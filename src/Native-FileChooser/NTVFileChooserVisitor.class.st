Class {
	#name : #NTVFileChooserVisitor,
	#superclass : #OSPlatformVisitor,
	#instVars : [
		'notification'
	],
	#category : #'Native-FileChooser'
}

{ #category : #api }
NTVFileChooserVisitor class >> choose [

	^ self new
		  visit;
		  yourself
]

{ #category : #visiting }
NTVFileChooserVisitor >> buildWindowsNotificationCommand [

	^ String streamContents: [ :stream | 
		  stream
			  << 'Add-Type -AssemblyName System.Windows.Forms;';
			  <<
				  ' $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath(''Desktop'') };';
			  << '$null = $FileBrowser.ShowDialog()' ]
]

{ #category : #visiting }
NTVFileChooserVisitor >> configWin [

	| directory |
	directory := (FileLocator temp / 'PharoNativeFileChooser')
		             ensureCreateDirectory.
	directory / 'ps-run.vbs' writeStreamDo: [ :stream | 
		stream << 'Set objShell = CreateObject("Wscript.Shell")
Set args = Wscript.Arguments
For Each arg In args
    objShell.Run("powershell -windowstyle hidden -executionpolicy bypass -noninteractive ""&"" ""''" & arg & "''"""),0
Next
' ].
	directory / 'file-chooser-script.ps1' writeStreamDo: [ :stream | 
		stream << self buildWindowsNotificationCommand ]
]

{ #category : #visiting }
NTVFileChooserVisitor >> visitUnix: aPlatform [

	| args |
	args := OrderedCollection new.
	args add: notification title.
	notification text ifNotNil: [ :text | args add: text ].
	OSSUnixSubprocess new
		command: 'notify-send';
		arguments: args;
		run
]

{ #category : #visiting }
NTVFileChooserVisitor >> visitWindows: aPlatform [

	| directory |
	directory := (FileLocator temp / 'PharoNativeFileChooser')
		             ensureDeleteAll; ensureCreateDirectory.
	self configWin.
	OSWSWinProcess new
		shellCommand: (String streamContents: [ :stream | 
					 stream
						 << 'wscript "';
						 << (directory / 'ps-run.vbs') pathString;
						 << '" "';
						 << (directory / 'file-chooser-script.ps1') pathString;
						 << '"' ]);
		run
]

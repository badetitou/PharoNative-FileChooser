Class {
	#name : #NTVFileChooserVisitor,
	#superclass : #OSPlatformVisitor,
	#instVars : [
		'locationWinProcessOutFile'
	],
	#category : #'Native-FileChooser'
}

{ #category : #api }
NTVFileChooserVisitor class >> choose [

	^ self new
		  visit
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> buildWindowsNotificationCommand [

	^ String streamContents: [ :stream | 
		  stream
			  << 'Add-Type -AssemblyName System.Windows.Forms;';
			  <<
				  ' $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath(''Desktop'') };';
			  << '$null = $FileBrowser.ShowDialog();';
			  << '$FileBrowser.FileName > "';
			  << self winTmpOutLocationString;
			  << '"' ]
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> configWin [

	| directory |
	directory := (FileLocator temp / 'PharoNativeFileChooser')
		             ensureCreateDirectory.
	directory / 'ps-run.vbs' writeStreamDo: [ :stream | 
		stream << 'Set objShell = CreateObject("Wscript.Shell")
Set args = Wscript.Arguments
For Each arg In args
    objShell.Run("powershell -windowstyle hidden -executionpolicy bypass -noninteractive ""&"" ""''" & arg & "''"""),0,True
Next
' ].
	directory / 'file-chooser-script.ps1' writeStreamDo: [ :stream | 
		stream << self buildWindowsNotificationCommand ]
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> locationWinProcessOutFile [

	^ locationWinProcessOutFile
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> locationWinProcessOutFile: anObject [

	locationWinProcessOutFile := anObject
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> visitWindows: aPlatform [

	| directory process |
	locationWinProcessOutFile := UUIDGenerator next.
	directory := (FileLocator temp / 'PharoNativeFileChooser')
		             ensureDeleteAll;
		             ensureCreateDirectory.
	self configWin.
	process := OSWSWinProcess new
		           shellCommand: (String streamContents: [ :stream | 
					            stream
						            << 'wscript "';
						            << (directory / 'ps-run.vbs') pathString;
						            << '" "';
						            <<
							            (directory / 'file-chooser-script.ps1') pathString;
						            << '"' ]);
		           runAndWait.
	^ (self winTmpOutLocation readStreamEncoded: #'utf-16' do: [:stream | stream upToEnd ]) asFileReference
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> winTmpOutLocation [

	^ self winTmpOutLocationString asFileReference
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> winTmpOutLocationString [
	^ (FileLocator temp / 'PharoNativeFileChooser'
				   / locationWinProcessOutFile asString , '.txt') pathString
]

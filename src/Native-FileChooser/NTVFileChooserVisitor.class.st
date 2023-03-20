"
I am a OS Visitor that aims to open the file choose of the native system.

I comply the FileChooser API of Pharo to be use easily 
"
Class {
	#name : #NTVFileChooserVisitor,
	#superclass : #OSPlatformVisitor,
	#instVars : [
		'locationWinProcessOutFile',
		'options'
	],
	#category : #'Native-FileChooser'
}

{ #category : #api }
NTVFileChooserVisitor class >> choose [

	^ self new
		  visit
]

{ #category : #api }
NTVFileChooserVisitor class >> chooseExistingFileReference: title extensions: exts path: path preview: preview [

	| fileChooser |
	fileChooser := self new.
	exts ifNotNil: [ :e | fileChooser options extensions: e ].
	path ifNotNil: [ :e | fileChooser options path: e ].
	preview ifNotNil: [ :e | fileChooser options preview: e ].
	title ifNotNil: [ :e | fileChooser options title: e ].
	^ fileChooser visit
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> buildWindowsFileChooserCommand [

	^ String streamContents: [ :stream | 
		  stream
			  << 'Add-Type -AssemblyName System.Windows.Forms;';
			  <<
				  ' $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = '.
		  self options path
			  ifNil: [ stream << '[Environment]::GetFolderPath(''Desktop'')' ]
			  ifNotNil: [ :p | 
				  stream
					  << '''';
					  << ((p isKindOf: AbstractFileReference)
							   ifTrue: [ p ]
							   ifFalse: [ p asFileReference ]) pathString;
					  << '''' ].
		  self options extensions ifNotNil: [ :extensions | 
			  stream << String crlf.
			  stream << 'Filter = ''Files ('.
			  extensions
				  do: [ :extension | 
					  stream
						  << '*.';
						  << extension ]
				  separatedBy: [ stream << ';' ].
			  stream << ')|'.
			  extensions
				  do: [ :extension | 
					  stream
						  << '*.';
						  << extension ]
				  separatedBy: [ stream << ';' ].
			  stream << '''' ].
		  self options title ifNotNil: [ :title | 
			  stream << String crlf.
			  stream
				  << 'Title = ''';
				  << title;
				  << '''' ].
		  stream
			  << ' };';
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
		stream << self buildWindowsFileChooserCommand ]
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> initialize [

	super initialize.
	options := NTVFileChooserOptions new
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> locationWinProcessOutFile [

	^ locationWinProcessOutFile
]

{ #category : #'visiting - windows' }
NTVFileChooserVisitor >> locationWinProcessOutFile: anObject [

	locationWinProcessOutFile := anObject
]

{ #category : #accessing }
NTVFileChooserVisitor >> options [

	^ options
]

{ #category : #accessing }
NTVFileChooserVisitor >> options: anObject [

	options := anObject
]

{ #category : #'visiting - unix' }
NTVFileChooserVisitor >> visitUnix: aPlatform [

	| args |
	args := OrderedCollection new.
	args add: '--file-selection'.
	self options extensions ifNotNil: [ :extensions | 
		args add: (String streamContents: [ :stream | 
				 stream << '--file-filter=Files | '.
				 extensions
					 do: [ :extension | 
						 stream
							 << '*.';
							 << extension ]
					 separatedBy: [ stream << ' ' ] ]) ].
	self options title ifNotNil: [ :title | 
		args add: (String streamContents: [ :stream | 
				 stream
					 << '--title=';
					 << title ]) ].
	OSSUnixSubprocess new
		command: 'zenity';
		arguments: args;
		redirectStdout;
		runAndWaitOnExitDo: [ :arg :resultString :resultError | 
			^ resultString trim asFileReference ]
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
	^ (self winTmpOutLocation readStreamEncoded: #'utf-16' do: [:stream | stream upToEnd ]) trim asFileReference
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

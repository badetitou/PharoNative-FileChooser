Extension { #name : #TEasilyThemed }

{ #category : #'*Native-FileChooser' }
TEasilyThemed >> chooseExistingFileReference: title extensions: exts path: path preview: preview [

	"Answer the result of a file name chooser dialog with the given title, extensions
	to show, path and preview type."

	NTVFileChooserSetting nativeFileChooser ifTrue: [ 
		^ NTVFileChooserVisitor
			  chooseExistingFileReference: title
			  extensions: exts
			  path: path
			  preview: preview ].
	^ self theme
		  chooseExistingFileReferenceIn: self
		  title: title
		  extensions: exts
		  path: path
		  preview: preview
]

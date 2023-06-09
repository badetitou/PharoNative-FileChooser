Class {
	#name : #NTVFileChooserOptions,
	#superclass : #Object,
	#instVars : [
		'extensions',
		'path',
		'preview',
		'title'
	],
	#category : #'Native-FileChooser'
}

{ #category : #accessing }
NTVFileChooserOptions >> extensions [

	^ extensions
]

{ #category : #accessing }
NTVFileChooserOptions >> extensions: anObject [

	extensions := anObject
]

{ #category : #accessing }
NTVFileChooserOptions >> path [

	^ path
]

{ #category : #accessing }
NTVFileChooserOptions >> path: anObject [

	path := anObject
]

{ #category : #accessing }
NTVFileChooserOptions >> preview [

	^ preview
]

{ #category : #accessing }
NTVFileChooserOptions >> preview: anObject [

	preview := anObject
]

{ #category : #accessing }
NTVFileChooserOptions >> title [

	^ title
]

{ #category : #accessing }
NTVFileChooserOptions >> title: anObject [

	title := anObject
]

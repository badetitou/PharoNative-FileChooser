Class {
	#name : #NTVFileChooserSetting,
	#superclass : #Object,
	#classInstVars : [
		'nativeFileChooser'
	],
	#category : #'Native-FileChooser'
}

{ #category : #settings }
NTVFileChooserSetting class >> browsingSettingsOn: aBuilder [

	"create empty #codeBrowsing and #qualityAssistant settings groups so the tools can use it"

	<systemsettings>
	(aBuilder pickOne: #nativeFileChooser)
				label: 'Use the native file chooser if possible';
				default: NTVFileChooserVisitor;
				parent: #NativeSettings;
				target: self;
				domainValues: { nil. NTVFileChooserVisitor }
]

{ #category : #accessing }
NTVFileChooserSetting class >> nativeFileChooser [

	^ nativeFileChooser
]

{ #category : #accessing }
NTVFileChooserSetting class >> nativeFileChooser: anObject [

	nativeFileChooser := anObject
]

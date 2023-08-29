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
	(aBuilder setting: #nativeFileChooser)
				label: 'Use the native file chooser if possible';
				default: true;
				parent: #NativeSettings;
				target: self
]

{ #category : #settings }
NTVFileChooserSetting class >> initialize [

	self nativeFileChooser: true
]

{ #category : #accessing }
NTVFileChooserSetting class >> nativeFileChooser [

	^ nativeFileChooser
]

{ #category : #accessing }
NTVFileChooserSetting class >> nativeFileChooser: anObject [

	nativeFileChooser := anObject
]

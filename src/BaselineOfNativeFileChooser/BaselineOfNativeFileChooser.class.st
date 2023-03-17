Class {
	#name : #BaselineOfNativeFileChooser,
	#superclass : #BaselineOf,
	#category : #BaselineOfNativeFileChooser
}

{ #category : #baselines }
BaselineOfNativeFileChooser >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfNativeFileChooser >> defineDependencies: spec [

	spec baseline: 'OSSubprocess' with: [ 
		spec repository:
			'github://pharo-contributions/OSSubprocess:master/repository' ].
	spec baseline: 'OSWinSubprocess' with: [ 
		spec repository:
			'github://pharo-contributions/OSWinSubprocess:v1' ]
]

{ #category : #baselines }
BaselineOfNativeFileChooser >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfNativeFileChooser >> definePackages: spec [

	spec
		package: 'Native-FileChooser'
		with: [ spec requires: #( 'OSSubprocess' 'OSWinSubprocess' ) ]
]

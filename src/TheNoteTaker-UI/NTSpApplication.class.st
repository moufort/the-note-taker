"
This is the main Notes Taker Spec2 application class which:

- Handles the notes container: A class which acts as a repository of notes.
- Provides convenience methods to retrieve notes and its metadata.
- Handles the application initialization: See the `NtSpApplication>>start` method.
- Creates a new entry for this application in the World menu.


"
Class {
	#name : 'NTSpApplication',
	#superclass : 'SpApplication',
	#instVars : [
		'noteTakerContainer',
		'log',
		'settings',
		'noteTakerMain'
	],
	#classVars : [
		'Default',
		'IsDeployed'
	],
	#category : 'TheNoteTaker-UI-Core',
	#package : 'TheNoteTaker-UI',
	#tag : 'Core'
}

{ #category : 'private' }
NTSpApplication class >> applicationTitle [

	^ 'The Note Taker'
]

{ #category : 'private' }
NTSpApplication class >> beDeployed [
	IsDeployed := true
]

{ #category : 'private' }
NTSpApplication class >> beUndeployed [
	IsDeployed := false
]

{ #category : 'private' }
NTSpApplication class >> default [
	^ Default ifNil: [ Default := self new ]
]

{ #category : 'private' }
NTSpApplication class >> default: aPharoLauncherApplication [
	Default := aPharoLauncherApplication
]

{ #category : 'private' }
NTSpApplication class >> isDeployed [
	^ IsDeployed ifNil: [ IsDeployed := false ]
]

{ #category : 'private' }
NTSpApplication class >> menuNoteTakersOn: aBuilder [
	<worldMenu>

	(aBuilder item: #NoteTaker)
		parent: #Tools;
		label: self applicationTitle;
		icon: (self iconNamed: #catalog);
		action: [ NTSpApplication new run ];
		help: 'The Note Taker';
		order: 630
]

{ #category : 'private' }
NTSpApplication class >> openFull [ 
	<script>
	
	^ self new startFullScreen 
]

{ #category : 'private' }
NTSpApplication class >> openIt [

	<script>
	self new run
]

{ #category : 'testing' }
NTSpApplication >> addNoteNamed: aString [ 
	"Add a new empty note with title aString to the receiver's notes. Answer the receiver"
	
	^ self noteTakerContainer addNoteNamed: aString trimBoth
]

{ #category : 'private' }
NTSpApplication >> applicationTitle [ 

	^ self class applicationTitle 
]

{ #category : 'initialization' }
NTSpApplication >> initialize [

	super initialize.
	noteTakerContainer := NTContainer new.
	settings := NTSettings.
	log := NTLog newWithFolder: settings noteLocation
]

{ #category : 'testing' }
NTSpApplication >> isValidNoteName: aString [ 
	"Answer <true> if aString is a valid note title"
	
	^ self noteTakerContainer isValidNoteName: aString
]

{ #category : 'accessing' }
NTSpApplication >> log [

	^ log
]

{ #category : 'accessing' }
NTSpApplication >> log: aNTLog [

	log := aNTLog
]

{ #category : 'accessig' }
NTSpApplication >> noteInformation: aNtNodeModel [

	self shouldBeImplemented.
	^ aNtNodeModel 
]

{ #category : 'callbacks' }
NTSpApplication >> noteNamed: aString [ 

	^ self noteTakerContainer noteNamed: aString
]

{ #category : 'accessing' }
NTSpApplication >> noteTakerContainer [

	^ noteTakerContainer
]

{ #category : 'running' }
NTSpApplication >> noteTakerMain [

	^ noteTakerMain
]

{ #category : 'accessing' }
NTSpApplication >> notes [
	"Answer the application's <Collection> of <NTNoteObject>"

	^ self noteTakerContainer notes
]

{ #category : 'running' }
NTSpApplication >> settings [

	^ settings
]

{ #category : 'running' }
NTSpApplication >> start [

	noteTakerMain := (NTSpNoteTakerMainUI newApplication: self) open
]

{ #category : 'running' }
NTSpApplication >> startFullScreen [
	" Private - Open the main application window in full screen, intended for the release version "

	(NTSpNoteTakerMainUI newApplication: self) asWorldWindow open
]

"
Represents a singleton pattern implementation for managing a centralized instance of `NTNoteObject` notes container.

The singleton ensures that there is only one instance of the container throughout the application's lifecycle, providing global access to the collection of notes. It is useful for scenarios where a single instance of a class needs to be shared and accessed globally across multiple parts of the application.

## Usage

To access the unique instance of the Notes container, use the class method 'uniqueInstance'. For example:

```
| notesContainer |
notesContainer := NTSingleton uniqueInstance.
```

### Responsibilities

- Providing a centralized and globally accessible instance of Notes.
- Ensuring that only one instance of the notes container exists within the application.

Note: It is recommended to use the `uniqueInstance` method to access the singleton rather than instantiating it directly.

"
Class {
	#name : 'NTSingleton',
	#superclass : 'Object',
	#instVars : [
		'notes',
		'tags'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'TheNoteTaker-Core',
	#package : 'TheNoteTaker',
	#tag : 'Core'
}

{ #category : 'instance creation' }
NTSingleton class >> new [

	self error: 'Use #uniqueInstance'
]

{ #category : 'class initialization' }
NTSingleton class >> reset [
	<script>
	
	UniqueInstance := nil
]

{ #category : 'instance creation' }
NTSingleton class >> safeDo: aBlock [

	| current res |
	[
		current := self uniqueInstance.
		self reset.
		res := aBlock value: self uniqueInstance.
		res ] ensure: [ UniqueInstance := current. res ]
]

{ #category : 'instance creation' }
NTSingleton class >> uniqueInstance [

	^ UniqueInstance
		ifNil: [ UniqueInstance := self basicNew initialize ]
]

{ #category : 'adding - notes' }
NTSingleton >> addNoteFromFileReference: aFileReference [
	"Add a new note with title aString to the receiver's notes. Answer the receiver"
	
	^ self notes add: (
		NTNoteObject 
			newFromFileReference: aFileReference )
]

{ #category : 'adding - notes' }
NTSingleton >> addNoteNamed: aString [
	"Add a new empty note with title aString to the receiver's notes. Answer the receiver"
	
	^ self notes add: ( NTNoteObject named: aString)
]

{ #category : 'adding - tags' }
NTSingleton >> addTagNamed: aString [
	"Add a new empty note with title aString to the receiver's notes. Answer the receiver"

	^ self tags add: (NTTag newNamed: aString)
]

{ #category : 'testing' }
NTSingleton >> hasNoteNamed: aString [
	"Answer <true> if the receiver includes a note with title aString"

	^ self notes anySatisfy: [ : note | note fileName = aString ]
]

{ #category : 'testing' }
NTSingleton >> hasNotes [
	"Answer <true> if the receiver includes any note"
	
	^ self notes isNotEmpty
]

{ #category : 'initialization' }
NTSingleton >> initialize [

	super initialize.
	self notes: OrderedCollection new.
	self tags: OrderedCollection new
]

{ #category : 'testing' }
NTSingleton >> isValidNoteName: aString [ 
	"Answer <true> if aString is a valid note title, i.e. 
		Non-empty, and not already present"

	(aString notNil and: [ aString notEmpty ])
		ifTrue: [ ^ (self hasNoteNamed: aString trimBoth) not ].
	self inform: 'Invalid note title'.
	^ false
]

{ #category : 'accessing - notes' }
NTSingleton >> noteNameMatching: aString [
	"Answer the first <NTNoteObject> matching aString in its name"

	| pattern |
	pattern := '*', aString, '*'.
	^ self notes detect: [ :n | pattern match: n fileName ]
]

{ #category : 'accessing - notes' }
NTSingleton >> noteNamed: aString [
	"Answer the first <NTNoteObject> matching aString in its name"
	
	^ self notes detect: [ : n | n fileName = aString ]
]

{ #category : 'accessing - notes' }
NTSingleton >> notes [
	"Answer the receiver's <Collection> of <NTNoteObject>"

	^ notes
]

{ #category : 'accessing - notes' }
NTSingleton >> notes: aCollection [ 
	notes := aCollection
]

{ #category : 'accessing - notes' }
NTSingleton >> notesCount [
	"Answer an <Integer> representing how many notes the receiver includes"
	
	^ self notes size
]

{ #category : 'accessing - notes' }
NTSingleton >> notesNameMatching: aString [
	"Answer a <Collection> with <NoteObject> objects whose title matched named aString"

	| pattern |
	pattern := '*' , aString , '*'.
	^ self notes select: [ :n | pattern match: n title ]
]

{ #category : 'accessing - notes' }
NTSingleton >> notesNamed: aString [
	"Answer a <Collection> with <NTNoteObject> objects named aString"
	
	^ self notes select: [ : n | n fileName = aString ]
]

{ #category : 'removing - notes' }
NTSingleton >> removeNote: aNTNoteObject [
	"Remove the note aNTNoteObject from the receiver's notes. Answer the receiver"
	
	self notes remove: aNTNoteObject
]

{ #category : 'removing - notes' }
NTSingleton >> removeNoteNamed: aString [
	"Remove the note with title aString in the receiver's notes. Answer the receiver"
	
	self removeNote: (self noteNamed: aString)
]

{ #category : 'removing - notes' }
NTSingleton >> removeNotes: aCollectionOfNTNoteObject [
	"Remove the note aNTNoteObject from the receiver's notes. Answer the receiver"
	
	self notes removeAll: aCollectionOfNTNoteObject
]

{ #category : 'removing - notes' }
NTSingleton >> removeNotesSuchThat: aBlock [

	self notes copy do: [:each | 
		(aBlock value: each) 
			ifTrue: [ self removeNoteNamed: each title ] ]
]

{ #category : 'removing - tags' }
NTSingleton >> removeTag: aNTTag [
	"Remove the note aNTNoteObject from the receiver's notes. Answer the receiver"

	self tags remove: aNTTag
]

{ #category : 'removing - tags' }
NTSingleton >> removeTagNamed: aString [

	self removeTag: (self tagNamed: aString)
]

{ #category : 'accessing - tags' }
NTSingleton >> tagNameMatching: aString [
	"Answer the first <NTNoteObject> matching aString in its name"

	| pattern |
	pattern := '*' , aString , '*'.
	^ self tags detect: [ :n | pattern match: n tagName ]
]

{ #category : 'accessing - tags' }
NTSingleton >> tagNamed: aString [
	"Answer the first <NTNoteObject> matching aString in its name"

	^ self tags detect: [ :n | n tagName = aString ] ifNone: [ self addTagNamed: aString ]
]

{ #category : 'accessing - tags' }
NTSingleton >> tags [
	"Answer the receiver's <Collection> of <NTNoteObject>"

	^ tags
]

{ #category : 'accessing - tags' }
NTSingleton >> tags: aCollection [

	tags := aCollection
]

{ #category : 'accessing - tags' }
NTSingleton >> tagsNameMatching: aString [
	"Answer a <Collection> with <NoteObject> objects whose title matched named aString"

	| pattern |
	pattern := '*' , aString , '*'.
	^ self tags select: [ :n | pattern match: n tagName ]
]

"
A note tag object contains the necessary attributes and methods to represent a tag associated with notes.

## Attributes

- tagName: A string representing the name or label of the tag.
- tagId: A unique identifier for the tag.
- notes: A collection (list, set, or other data structure) of notes associated with the tag.

## Main methods

- Add Note: To associate a note with the tag.
- Remove Note: To disassociate a note from the tag.
- Rename Tag: To change the name of the tag.
- Delete Tag: To remove the tag entirely.
- Get Notes: To retrieve all notes associated with the tag.
- Accesss tag name: To retrieve the name of the tag.
- Access the tag ID/UUID: To retrieve the unique identifier of the tag.

"
Class {
	#name : 'NTTag',
	#superclass : 'Object',
	#instVars : [
		'tagId',
		'notes',
		'tagName'
	],
	#category : 'TheNoteTaker-Core',
	#package : 'TheNoteTaker',
	#tag : 'Core'
}

{ #category : 'instance creation' }
NTTag class >> newNamed: aString [
	"Answer a new tag named aString"
	
	^ self new 
		tagName: aString;
		yourself
]

{ #category : 'adding' }
NTTag >> addNote: aNTNoteObject [ 

	self notes add: aNTNoteObject.
	aNTNoteObject addTag: self
]

{ #category : 'initialization' }
NTTag >> initialize [

	super initialize.
	self tagId: UUID new asString36.
	self notes: Set new
]

{ #category : 'accessing' }
NTTag >> notes [

	^ notes
]

{ #category : 'accessing' }
NTTag >> notes: anObject [

	notes := anObject
]

{ #category : 'removing' }
NTTag >> removeNote: aNTNoteObject [ 

	self notes
		remove: aNTNoteObject 
		ifAbsent: [ ]
]

{ #category : 'accessing' }
NTTag >> tagId [

	^ tagId
]

{ #category : 'accessing' }
NTTag >> tagId: anObject [

	tagId := anObject
]

{ #category : 'accessing' }
NTTag >> tagName [
	"Answer a <String> representing the receiver's name"
	
	^ tagName
]

{ #category : 'accessing' }
NTTag >> tagName: anObject [

	tagName := anObject
]

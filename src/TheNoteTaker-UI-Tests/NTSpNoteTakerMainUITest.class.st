Class {
	#name : 'NTSpNoteTakerMainUITest',
	#superclass : 'NTSpTestCase',
	#instVars : [
		'presenter',
		'editorPresenter',
		'indexPresenter',
		'toolbarPresenter'
	],
	#category : 'TheNoteTaker-UI-Tests',
	#package : 'TheNoteTaker-UI-Tests'
}

{ #category : 'running' }
NTSpNoteTakerMainUITest >> setUp [

	super setUp.

	presenter := NTSpNoteTakerMainUI newApplication: app.
	indexPresenter := presenter notesIndexPresenter.
	editorPresenter := presenter notesEditorPresenter.
	toolbarPresenter := presenter notesToolbarPresenter.

	ressources generateNoteAndTagsTo: noteContainer.
	indexPresenter updatePresenter
]

{ #category : 'running' }
NTSpNoteTakerMainUITest >> tearDown [

	presenter ifNotNil: [ presenter delete ].
	super tearDown 
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testAddContent [

	| tempNote note |
	note := ressources getNote1.
	editorPresenter setModel: note.

	editorPresenter textInputText: 'It''s just a test'.

	tempNote := editorPresenter model.
	tempNote folderReference: memoryFS workingDirectory.
	editorPresenter saveFile.

	self assert: note contents equals: 'It''s just a test'
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testAddNoteByItsContents [

	| tempNote |
	editorPresenter newEmptyNote.
	editorPresenter textInputText: 'just a new note'.

	tempNote := editorPresenter model.
	tempNote folderReference: memoryFS workingDirectory.

	editorPresenter saveFile.

	self assert: editorPresenter model exists.
	self assert:
		(editorPresenter model fileReference basename includesSubstring:
			 'justanew')
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testAddNoteByItsName [

	| sizeNotesBeforeAddNote |
	sizeNotesBeforeAddNote := indexPresenter items size.
	noteContainer addNoteNamed: 'note1'.
	indexPresenter updatePresenter.
	self
		assert: indexPresenter items size
		equals: sizeNotesBeforeAddNote + 1
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testAddTagSaveNote [

	| tag newNote note |
	note := ressources getNote3.
	note folderReference: memoryFS workingDirectory.
	tag := ressources getTag1.
	indexPresenter selectNote: note.

	SpWindowSimulateOpenModal
		value: [ :aDialogPresenter |
				aDialogPresenter presenter selectedItems: #( tag1 ).
				aDialogPresenter presenter accept ]
		during: [
				NTSpAddTagCommand new
					context: indexPresenter;
					execute ].
	newNote := NTNoteObject newFromFileReference: note fileReference.
	self assert: newNote tagsString equals: tag tagName
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testAddTagToMultipleNotes [

	| tag note3 note2 |
	note2 := ressources getNote2.
	note3 := ressources getNote3.
	tag := ressources getTag1.
	indexPresenter selectNote: note3.
	indexPresenter selectNote: note2.

	SpWindowSimulateOpenModal
		value: [ :aDialogPresenter |
				aDialogPresenter presenter selectedItems: #( tag1 ).
				aDialogPresenter presenter accept ]
		during: [
				NTSpAddTagCommand new
					context: indexPresenter;
					execute ].

	self assert: tag notes size equals: 2.
	self assert: (note3 tags includes: tag).
	self assert: (note2 tags includes: tag)
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testAddTagToSingleNote [

	| tag note |
	note := ressources getNote3.
	tag := ressources getTag1.
	indexPresenter selectNote: note.

	SpWindowSimulateOpenModal
		value: [ :aDialogPresenter |
				aDialogPresenter presenter selectedItems: #( tag1 ).
				aDialogPresenter presenter accept ]
		during: [
				NTSpAddTagCommand new
					context: indexPresenter;
					execute ].

	self assert: note tags size equals: 1.
	self assert: (note tags includes: tag)
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testCreateANoteSelectIt [

	self skip.
	indexPresenter searchBar type: 'createNote'.
	indexPresenter searchBar typeByChar: String cr.

	self
		assert: indexPresenter selectedNote
		equals: (noteContainer noteNamed: 'createNote')
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testFilterNotesWithToolbarSetIndexItems [

	self assert: indexPresenter items size equals: 3.

	indexPresenter searchBar type: 'note1'.
	self assert: indexPresenter items size equals: 1
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testIndexSelectNoteSendItToEditor [

	| note |
	note := ressources getNote1.
	indexPresenter selectNote: note.

	self assert: editorPresenter model equals: note
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testNameNoteIsInISOFormat [

	| date tempNote note |
	note := ressources getNote1.
	editorPresenter setModel: note.

	date := DateAndTime now asDate yyyymmdd.

	tempNote := editorPresenter model.
	tempNote folderReference: memoryFS workingDirectory.

	editorPresenter saveFile.

	self assert: (note fileName beginsWith: date)
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testRemoveTagSaveNote [

	| tag newNote note |
	note := ressources getNote2.
	note folderReference: memoryFS workingDirectory.
	tag := ressources getTag2.
	indexPresenter selectNote: note.

	SpWindowSimulateOpenModal
		value: [ :aDialogPresenter |
				aDialogPresenter presenter selectedItems: #( tag2 ).
				aDialogPresenter presenter accept ]
		during: [
				NTSpRemoveTagCommand new
					context: indexPresenter;
					execute ].
	newNote := NTNoteObject newFromFileReference: note fileReference.
	self assert: newNote tagsString isNil
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testRemoveTagToMultipleNotes [

	| tag note3 note2 |
	note3 := ressources getNote3.
	note2 := ressources getNote2.
	tag := ressources getTag2.
	note3 addTag: tag.
	indexPresenter selectNote: note3.
	indexPresenter selectNote: note2.

	SpWindowSimulateOpenModal
		value: [ :aDialogPresenter |
				aDialogPresenter presenter selectedItems: #( tag ).
				aDialogPresenter presenter accept ]
		during: [
				NTSpRemoveTagCommand new
					context: indexPresenter;
					execute ].

	self assert: tag notes size equals: 0
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testRemoveTagToSingleNote [

	| tag note |
	note := ressources getNote2.
	tag := ressources getTag2.
	indexPresenter selectNote: note.

	SpWindowSimulateOpenModal
		value: [ :aDialogPresenter |
				aDialogPresenter presenter selectedItems: #( tag2 ).
				aDialogPresenter presenter accept ]
		during: [
				NTSpRemoveTagCommand new
					context: indexPresenter;
					execute ].

	self assert: note tags size equals: 0
]

{ #category : 'tests' }
NTSpNoteTakerMainUITest >> testSelectANote [

	indexPresenter selectNote: ressources getNote1.

	self
		assert: editorPresenter textInputText
		equals: ressources getNote1 contents
]

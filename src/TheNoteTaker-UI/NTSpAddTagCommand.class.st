"
Implements logic to add a tag to selected note taking application.
"
Class {
	#name : 'NTSpAddTagCommand',
	#superclass : 'NTSpAbstractCommand',
	#category : 'TheNoteTaker-UI-Commands',
	#package : 'TheNoteTaker-UI',
	#tag : 'Commands'
}

{ #category : 'default' }
NTSpAddTagCommand class >> defaultDescription [

	^ 'Add a tag to a note'
]

{ #category : 'default' }
NTSpAddTagCommand class >> defaultName [

	^ 'Add Tag'
]

{ #category : 'executing' }
NTSpAddTagCommand >> execute [
	"execute"

	(NTSpTagSelectionDialog newApplication: self application)
		allowTagCreation;
		title: 'tag name';
		items:
			(self noteTakerContainer tags asArray collect: [ :each |
					 each tagName ]);
		display: #asString;
		onAccept: [ :dialog |
				| selectedTags |
				selectedTags := dialog presenter selectedItems collect: [ :each |
						                self noteTakerContainer tagNamed: each ].
				selectedTags do: [ :tag |
							self selectedNotes do: [ :note |
										tag addNote: note.
										note save.
										self context owner statusBar pushMessage: (self application log add: note tag: tag) ] ] ];
		openModalWithParent: context window.

	self context modelChanged
]

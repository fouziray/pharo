Class {
	#name : #RBStaticMessageNode,
	#superclass : #RBMessageNode,
	#instVars : [
		'staticClass'
	],
	#category : #'AST-Core-Nodes'
}

{ #category : #accessing }
RBStaticMessageNode >> acceptVisitor: aProgramNodeVisitor [

	^ aProgramNodeVisitor visitStaticMessageNode: self
]

{ #category : #accessing }
RBStaticMessageNode >> selector: aSelector [

	staticClass := nil.
	keywordsPositions := nil.
	selector := aSelector isString
		            ifTrue: [ RBSelectorNode value: aSelector allButFirst ]
		            ifFalse: [ aSelector value: aSelector value allButFirst ].
	selector parent: self
]

{ #category : #accessing }
RBStaticMessageNode >> staticClass [

	^ staticClass
]

{ #category : #accessing }
RBStaticMessageNode >> staticClass: anObject [

	staticClass := anObject
]

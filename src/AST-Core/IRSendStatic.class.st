Class {
	#name : #IRSendStatic,
	#superclass : #IRInstruction,
	#instVars : [
		'calledMethod'
	],
	#category : #'AST-Core-Nodes'
}

{ #category : #'as yet unclassified' }
IRSendStatic class >> sendStatic: aMethod [

	^ self new calledMethod: aMethod
]

{ #category : #visiting }
IRSendStatic >> accept: visitor [

	visitor visitStaticSend: self
]

{ #category : #accessing }
IRSendStatic >> calledMethod [

	^ calledMethod
]

{ #category : #accessing }
IRSendStatic >> calledMethod: anObject [

	calledMethod := anObject
]

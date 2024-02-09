Class {
	#name : 'OptRectangleSuite',
	#superclass : 'SMarkSuite',
	#instVars : [
		'savedOriginalRectangleClass'
	],
	#category : 'System-Benchmark',
	#package : 'System-Benchmark'
}

{ #category : 'benchmarking' }
OptRectangleSuite >> benchFootballAnimation [
		self problemSize timesRepeat: [ HGSimulator bouncingBalls ].
]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchHGSplashRefraction [
	
		self problemSize timesRepeat: [ HGSimulator splashRefraction ]
]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSShapeWithOptRectangle [
	
	self problemSize timesRepeat: [
		RSShapeExamples new example01BasicShape
	]
]

{ #category : 'script entry' }
OptRectangleSuite >> defaultNumberOfIterations [
	
	^ 50
]

{ #category : 'script entry' }
OptRectangleSuite >> defaultNumberOfProcesses [
    ^ 8
]

{ #category : 'defaults' }
OptRectangleSuite >> defaultProblemSize [

	^ 30
]

{ #category : 'running' }
OptRectangleSuite >> setUp [ 
	
	savedOriginalRectangleClass := Rectangle.
	
	Smalltalk globals at: #Rectangle put: OptRectangle .
	
]

{ #category : 'running' }
OptRectangleSuite >> tearDown [ 
	
	Smalltalk globals at: #Rectangle put: savedOriginalRectangleClass .
	

]

Class {
	#name : 'OptRectangleSuite',
	#superclass : 'SMarkSuite',
	#instVars : [
		'savedOriginalRectangleClass',
		'savedEmptyWindows'
	],
	#category : 'System-Benchmark',
	#package : 'System-Benchmark'
}

{ #category : 'benchmarking' }
OptRectangleSuite >> benchEmptyWindowCreation [
"Create multiple windows simultaneously"

|window|

	self defaultProblemSize 	timesRepeat: [  
		window := SpPresenter new.
		window application: SpApplication new.
		window layout: SpPanedLayout newTopToBottom.
		window open .
		savedEmptyWindows add: window.
		]


]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchHGFootballAnimation [

		self problemSize timesRepeat: [ HGSimulator bouncingBalls ].
]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchHGSplashRefraction [
	
		self problemSize timesRepeat: [ HGSimulator splashRefraction ]
]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSAttachedRectangles [

	self defaultProblemSize timesRepeat: [ RSBasicShapeExamples new example43ShortestAttachPoint ]

]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSBasicExample40 [

	self defaultProblemSize timesRepeat: [ RSBasicShapeExamples new example40ColorScale  ]


]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSHighlightableRectangles [

self defaultProblemSize timesRepeat: [ RSHighlightableExamples new example01Basic ]
]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSInspectableRectangles [

self defaultProblemSize timesRepeat: [ RSInspectableExample new example01SimpleExample ]
]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSLayout [

	self defaultProblemSize timesRepeat: [ RSLayoutExamples new example01LayoutBasic ]

]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSPackagesViz [

	self defaultProblemSize timesRepeat: [ RSShapeExamples new example39RoassalPackages  ]

]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRSShapeWithOptRectangle [
	
	self problemSize timesRepeat: [
		RSShapeExamples new example01BasicShape
	]
]

{ #category : 'benchmarking' }
OptRectangleSuite >> benchRectangleAnimated [

	self defaultProblemSize timesRepeat: [ RSShapeExamples new example30EdgesToChildren  ]

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

	^ 10
]

{ #category : 'running' }
OptRectangleSuite >> setUp [ 
	
	savedOriginalRectangleClass := Rectangle.
	savedEmptyWindows:=Set new.
	Smalltalk globals at: #Rectangle put: OptRectangle .
	
]

{ #category : 'running' }
OptRectangleSuite >> tearDown [ 
	
	Smalltalk globals at: #Rectangle put: savedOriginalRectangleClass .
	savedEmptyWindows do: [ :each | each window close ] .
	savedEmptyWindows := nil.

]

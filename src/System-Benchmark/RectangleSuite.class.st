Class {
	#name : 'RectangleSuite',
	#superclass : 'SMarkSuite',
	#instVars : [
		'savedEmptyWindows'
	],
	#category : 'System-Benchmark',
	#package : 'System-Benchmark'
}

{ #category : 'benchmarking' }
RectangleSuite >> benchEmptyWindowCreation [
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
RectangleSuite >> benchHGFootballAnimation [
	
	self problemSize timesRepeat: [ HGSimulator bouncingBalls ] 
]

{ #category : 'benchmarking' }
RectangleSuite >> benchHGSplashRefraction [
	
		self problemSize timesRepeat: [ HGSimulator splashRefraction ]
]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSAttachedRectangles [

	self defaultProblemSize timesRepeat: [ RSBasicShapeExamples new  example43ShortestAttachPoint ]

]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSBasicExample40 [

	self defaultProblemSize timesRepeat: [ RSBasicShapeExamples new example40ColorScale  ]


]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSHighlightableRectangles [

self defaultProblemSize timesRepeat: [ RSHighlightableExamples new example01Basic ]
]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSInspectableRectangles [

self defaultProblemSize timesRepeat: [ RSInspectableExample new example01SimpleExample ]

]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSLayout [

	self defaultProblemSize timesRepeat: [ RSLayoutExamples new example01LayoutBasic ]
]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSPackagesViz [

	self defaultProblemSize timesRepeat: [ RSShapeExamples new example39RoassalPackages  ]

]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSShapeWithRectangle [
	
	self problemSize timesRepeat: [
		RSShapeExamples new example01BasicShape
	]
]

{ #category : 'benchmarking' }
RectangleSuite >> benchRectangleAnimated [

	self defaultProblemSize timesRepeat: [ RSShapeExamples new example30EdgesToChildren  ]

]

{ #category : 'script entry' }
RectangleSuite >> defaultNumberOfIterations [
	
	^ 50
]

{ #category : 'script entry' }
RectangleSuite >> defaultNumberOfProcesses [
    ^ 8
]

{ #category : 'defaults' }
RectangleSuite >> defaultProblemSize [

	^ 30
]

{ #category : 'running' }
RectangleSuite >> setUp [ 

		savedEmptyWindows := Set new.
]

{ #category : 'running' }
RectangleSuite >> tearDown [ 

	savedEmptyWindows do: [ :each | each window close ] .
	savedEmptyWindows := nil.
]

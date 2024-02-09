Class {
	#name : 'RectangleSuite',
	#superclass : 'SMarkSuite',
	#category : 'System-Benchmark',
	#package : 'System-Benchmark'
}

{ #category : 'benchmarking' }
RectangleSuite >> benchFootballAnimation [
	
	self problemSize timesRepeat: [ HGSimulator bouncingBalls ] 
]

{ #category : 'benchmarking' }
RectangleSuite >> benchHGSplashRefraction [
	
		self problemSize timesRepeat: [ HGSimulator splashRefraction ]
]

{ #category : 'benchmarking' }
RectangleSuite >> benchRSShapeWithRectangle [
	
	self problemSize timesRepeat: [
		RSShapeExamples new example01BasicShape
	]
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

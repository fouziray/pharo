Extension { #name : 'OptRectangle' }

{ #category : '*Rubric' }
OptRectangle >> privateSetCorner: bottomRight [
	cornerX := bottomRight x.
	cornerY := bottomRight y.
]

{ #category : '*Rubric' }
OptRectangle >> privateSetOrigin: topLeft [
	originX := topLeft x.
	originY := topLeft y.
]

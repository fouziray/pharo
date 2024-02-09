Extension { #name : 'OptRectangle' }

{ #category : '*Athens-Core' }
OptRectangle >> asPolygonTransformedBy: aTransform [
	"answer a clock-wise oriented polygon, representing receiver,
	transformed by transform"

	^ {
		aTransform transform: (originX @ originY) .
		aTransform transformX: cornerX Y: originY.
		aTransform transform: (cornerX @ cornerY).
		aTransform transformX: originX Y: cornerY.
	}
]

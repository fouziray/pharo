Extension { #name : 'OptRectangle' }

{ #category : '*Fuel-Core' }
OptRectangle >> fuelAccept: aGeneralMapper [
	"Since we can have subclasses of Rectangle, like CharacterBlock that adds new instVars, we cannot use the visitRectangle: for it."
	^ (self class == OptRectangle) 
		ifTrue: [ aGeneralMapper visitRectangle: self ]
		ifFalse: [ super fuelAccept: aGeneralMapper   ]
]

{ #category : '*Fuel-Core' }
OptRectangle >> fuelSetOrigin: originPoint corner: cornerPoint [
	originX := originPoint x .
	originY := originPoint y .
	cornerX := cornerPoint x.
	cornerY := cornerPoint y.
]

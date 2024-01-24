"
I represent a rectangular area of the screen. Arithmetic functions take points as arguments and carry out scaling and translating operations to create new instances of me. Rectangle functions create new instances by determining intersections of rectangles with rectangles.

Note 1: only rectangles parallel to reference frame (Screen) can be represented by this class.

Note 2: the Rectangle is represented by two extremities of one diagonal. By convention, it must be the diagonal:
	from rectangle origin (the point having smallest coordinates in reference frame),
	to rectangle corner (the point having largest coordinates in reference frame).

Note 3: Screen coordinates conventions are:
	x is horizontal axis, zero at left border, oriented toward right;
	y is vertical axis, zero at top border, oriented toward bottom.
This corresponds to the latin convention for writing text from left to right and top to bottom.

Note 4: the Rectangle extent is obtained by subtracting rectangle origin to rectangle corner coordinates.
If this leads to a negative width (extent x coordinate) and/or a negative height (extent y coordinate), then the Rectangle is degenerated and considered empty.

Instance variables:
	origin	<Point> the coordinates of corner having smallest coordinates (top left in Screen coordinates)
	corner	<Point> the coordinates of corner having largest coordinates (bottom right in Screen coordinates)

"
Class {
	#name : 'OptRectangle',
	#superclass : 'Object',
	#instVars : [
		'cornerX',
		'cornerY',
		'originX',
		'originY'
	],
	#category : 'Kernel-BasicObjects',
	#package : 'Kernel',
	#tag : 'BasicObjects'
}

{ #category : 'instance creation' }
OptRectangle class >> center: centerPoint extent: extentPoint [
	"Answer an instance of me whose center is centerPoint asInteger  "

	^self origin: centerPoint - (extentPoint//2) extent: extentPoint
]

{ #category : 'instance creation' }
OptRectangle class >> encompassing: listOfPoints [
	"A number of callers of encompass: should use this method."
	| topLeft bottomRight |
	topLeft := bottomRight := listOfPoints first.
	listOfPoints allButFirstDo: [ :p |
		topLeft := topLeft min: p.
		bottomRight := bottomRight max: p ].
	^ topLeft corner: bottomRight
]

{ #category : 'instance creation' }
OptRectangle class >> floatCenter: centerPoint extent: extentPoint [
	"Answer an instance of me whose center is centerPoint and width
	by height is extentPoint."
	^self origin: centerPoint - (extentPoint/2.0) extent: extentPoint
]

{ #category : 'instance creation' }
OptRectangle class >> left: left right: right top: top bottom: bottom [
	"Answer an instance of me whose left, right, top, and bottom coordinates
	are determined by the arguments."

	^ self basicNew setLeft: left right: right top: top bottom: bottom
]

{ #category : 'instance creation' }
OptRectangle class >> merging: listOfRects [
	"A number of callers of merge: should use this method."
	| minX minY maxX maxY |
	listOfRects do:
		[ :r |
		minX
			ifNil:
				[ minX := r topLeft x.
				minY := r topLeft y.
				maxX := r bottomRight x.
				maxY := r bottomRight y ]
			ifNotNil:
				[ minX := minX min: r topLeft x.
				minY := minY min: r topLeft y.
				maxX := maxX max: r bottomRight x.
				maxY := maxY max: r bottomRight y ] ].
	^ self origin: minX @ minY corner: maxX @ maxY
]

{ #category : 'instance creation' }
OptRectangle class >> origin: originPoint corner: cornerPoint [
	"Answer an instance of me whose corners (top left and bottom right) are
	determined by the arguments."

	^self basicNew setPoint: originPoint point: cornerPoint
]

{ #category : 'instance creation' }
OptRectangle class >> origin: originPoint extent: extentPoint [
	"Answer an instance of me whose top left corner is originPoint and width by height is extentPoint. Note that extentPoint should be non negative since it represents the size of the rectangle"


	^self basicNew
		setPoint: originPoint
		point: (originPoint x+ (extentPoint x max: 0)) @ (originPoint y + (extentPoint y max: 0))
]

{ #category : 'instance creation' }
OptRectangle class >> point: pt1 point: pt2 [
	"Answer an instance of me constructed from two points."

	^self basicNew setPoint: pt1 point: pt2
]

{ #category : 'comparing' }
OptRectangle >> = aRectangle [
	"Answer true if the receiver's species, origin and corner match aRectangle's."

	^ self species = aRectangle species and: [
		  originX@originY = aRectangle origin and: [ cornerX@cornerY = aRectangle corner ] ]
]

{ #category : 'accessing' }
OptRectangle >> aboveCenter [
	"Answer the point slightly above the center of the receiver."

	^self topLeft + self bottomRight // (2@3)
]

{ #category : 'rectangle functions' }
OptRectangle >> adjustTo: newRect along: side [
	"Return a copy adjusted to fit a neighbor that has changed size."
	side = #left ifTrue: [^ self withRight: newRect left].
	side = #right ifTrue: [^ self withLeft: newRect right].
	side = #top ifTrue: [^ self withBottom: newRect top].
	side = #bottom ifTrue: [^ self withTop: newRect bottom]
]

{ #category : 'transforming' }
OptRectangle >> align: aPoint1 with: aPoint2 [
	"Answer a Rectangle that is a translated by aPoint2 - aPoint1."

	^self translateBy: aPoint2 - aPoint1
]

{ #category : 'rectangle functions' }
OptRectangle >> allAreasOutsideList: aCollection do: aBlock [
	"Enumerate aBlock with all areas of the receiver not overlapping
	any rectangle in the given collection"
	^self allAreasOutsideList: aCollection startingAt: 1 do: aBlock
]

{ #category : 'rectangle functions' }
OptRectangle >> allAreasOutsideList: aCollection startingAt: startIndex do: aBlock [
	"Enumerate aBlock with all areas of the receiver not overlapping
	any rectangle in the given collection"
	| yOrigin yCorner aRectangle index rr |
	index := startIndex.

	"Find the next intersecting rectangle from aCollection"

	[ index <= aCollection size ifFalse: [ ^ aBlock value: self ].
	aRectangle := aCollection at: index.
	originX@originY <= aRectangle corner and: [ aRectangle origin <= cornerX@cornerY ] ] whileFalse: [ index := index + 1 ].

	"aRectangle is intersecting; process it"
	aRectangle origin y > originY
		ifTrue:
			[ rr := OptRectangle origin: self origin corner: cornerX @ (yOrigin := aRectangle origin y).
			rr
				allAreasOutsideList: aCollection
				startingAt: index + 1
				do: aBlock ]
		ifFalse: [ yOrigin := originY ].
	aRectangle corner y < cornerY
		ifTrue:
			[ rr := OptRectangle origin: originX @ (yCorner := aRectangle corner y) corner: cornerX.
			rr
				allAreasOutsideList: aCollection
				startingAt: index + 1
				do: aBlock ]
		ifFalse: [ yCorner := cornerY ].
	aRectangle origin x > originX ifTrue:
		[ rr := OptRectangle origin: originX @ yOrigin corner: aRectangle origin x @ yCorner.
		rr
			allAreasOutsideList: aCollection
			startingAt: index + 1
			do: aBlock ].
	aRectangle corner x < cornerX ifTrue:
		[ rr := OptRectangle origin: aRectangle corner x @ yOrigin corner: cornerX @ yCorner.
		rr
			allAreasOutsideList: aCollection
			startingAt: index + 1
			do: aBlock ]
]

{ #category : 'rectangle functions' }
OptRectangle >> amountToTranslateWithin: aRectangle [
	"Answer a Point, delta, such that self + delta is forced within aRectangle.
	Keep self topLeft inside when all of self cannot be made to fit"
	| dx dy |
	dx := 0.
	dy := 0.
	cornerX > aRectangle right ifTrue: [ dx := aRectangle right - cornerX ].
	cornerY > aRectangle bottom ifTrue: [ dy := aRectangle bottom - cornerY ].
	originX + dx < aRectangle left ifTrue: [ dx := aRectangle left - originX ].
	originY + dy < aRectangle top ifTrue: [ dy := aRectangle top - originY ].
	^ dx @ dy
]

{ #category : 'accessing' }
OptRectangle >> area [
	"Answer the receiver's area, the product of width and height."
	| w |
	(w := self width) <= 0 ifTrue: [ ^ 0 ].
	^ w * self height max: 0
]

{ #category : 'rectangle functions' }
OptRectangle >> areasOutside: aRectangle [
	"Answer an Array of Rectangles comprising the parts of the receiver not
	intersecting aRectangle."
	"Make sure the intersection is non-empty"

	(self intersects: aRectangle) ifFalse: [ ^ Array with: self ].
	^ Array new: 4 streamContents: [ :aStream |
		| yOrigin yCorner |
		aRectangle origin y > originY
			ifTrue:
				[ aStream nextPut: ( OptRectangle origin: self origin corner: cornerX @ (yOrigin := aRectangle origin y)) ]
			ifFalse: [ yOrigin := originY ].
		aRectangle corner y < cornerY
			ifTrue:
				[ aStream nextPut: ( OptRectangle origin: originX @ (yCorner := aRectangle corner y) corner: self corner) ]
			ifFalse: [ yCorner := cornerY ].
		aRectangle origin x > originX ifTrue:
			[ aStream nextPut: ( OptRectangle origin: originX @ yOrigin corner: aRectangle origin x @ yCorner) ].
		aRectangle corner x < cornerX ifTrue:
			[ aStream nextPut: ( OptRectangle origin: aRectangle corner x @ yOrigin corner: cornerX @ yCorner) ] ]
]

{ #category : 'rectangle functions' }
OptRectangle >> bordersOn: her along: herSide [
	((herSide = #right and: [originX = her right])
	or: [herSide = #left and: [cornerX = her left]])
		ifTrue:
		[^ (originY max: her top) < (cornerY min: her bottom)].
	((herSide = #bottom and: [originY = her bottom])
	or: [herSide = #top and: [cornerY = her top]])
		ifTrue:
		[^ (originX max: her left) < (cornerX min: her right)].
	^ false
]

{ #category : 'accessing' }
OptRectangle >> bottom [
	"Answer the position of the receiver's bottom horizontal line."

	^cornerY
]

{ #category : 'accessing' }
OptRectangle >> bottom: aNumber [

	cornerY:=aNumber .
	^ self
]

{ #category : 'accessing' }
OptRectangle >> bottomCenter [
	"Answer the point at the center of the bottom horizontal line of the
	receiver."

	^self center x @ cornerY
]

{ #category : 'accessing' }
OptRectangle >> bottomLeft [
	"Answer the point at the left edge of the bottom horizontal line of the
	receiver."

	^originX @ cornerY
]

{ #category : 'accessing' }
OptRectangle >> bottomRight [
	"Answer the point at the right edge of the bottom horizontal line of the
	receiver."

	^cornerX@cornerY 
]

{ #category : 'accessing' }
OptRectangle >> boundingBox [
	^ self
]

{ #category : 'truncation and round off' }
OptRectangle >> ceiling [
	"Answer the integer rectangle to the bottom right of receiver.
	Return receiver if it is already an integerRectangle."

	self isIntegerRectangle ifTrue: [ ^ self ].
	^ OptRectangle origin: self origin ceiling corner: self corner ceiling
]

{ #category : 'accessing' }
OptRectangle >> center [
	"Answer the point at the center of the receiver."

	^self topLeft + self bottomRight // 2
]

{ #category : 'transforming' }
OptRectangle >> centeredBeneath: aRectangle [
	 "Move the receiver so that its top center point coincides with the bottom center point of aRectangle."

	^ self align: self topCenter with: aRectangle bottomCenter
]

{ #category : 'comparing' }
OptRectangle >> closeTo: aRectangle [
 	^ (self origin closeTo: aRectangle origin) and: [ self corner closeTo: aRectangle corner ]
]

{ #category : 'comparing' }
OptRectangle >> closeTo: aRectangle precision: aPrecision [
 	^ (self origin closeTo: aRectangle origin precision: aPrecision) and: [
		self corner closeTo: aRectangle corner precision: aPrecision ]
]

{ #category : 'truncation and round off' }
OptRectangle >> compressTo: grid [
	"Answer a Rectangle whose origin and corner are rounded to grid x and grid y.
	Rounding is done by upper value on origin and lower value on corner so that
	rounded rectangle is inside self."

	^ OptRectangle
		  origin: (self origin roundUpTo: grid)
		  corner: (self corner roundDownTo: grid)
]

{ #category : 'truncation and round off' }
OptRectangle >> compressed [
	"Answer a Rectangle whose origin and corner are rounded to integers.
	Rounding is done by upper value on origin and lower value on corner so that
	rounded rectangle is inside self."

	^ OptRectangle origin: self origin ceiling corner: self corner floor
]

{ #category : 'testing' }
OptRectangle >> containsPoint: aPoint [
	"Answer whether aPoint is within the receiver. Pay attention the self origin is considered less than but the corner is strict"

	"((0@0 corner: 100@100) containsPoint: 50@50) >>> true"
	"((0@0 corner: 100@100) containsPoint: 0@0) >>> true"
	"((0@0 corner: 100@100) containsPoint: 100@50) >>> false"
	"((0@0 corner: 100@100) containsPoint: 100@100) >>> false"

	^((originX@originY) <= aPoint )and: [aPoint < (cornerX@cornerY)]
]

{ #category : 'testing' }
OptRectangle >> containsRect: aRect [
	"Answer whether aRect is within the receiver (OK to coincide)."

	^ aRect origin >= self origin and: [aRect corner <= self corner]
]

{ #category : 'accessing' }
OptRectangle >> corner [
	"Answer the point at the bottom right corner of the receiver."

	^cornerX@cornerY 
]

{ #category : 'accessing' }
OptRectangle >> corners [
	"Return an array of corner points in the order of a quadrilateral spec for WarpBlt."

	^ Array
		with: self topLeft
		with: self bottomLeft
		with: self bottomRight
		with: self topRight
]

{ #category : 'fmp' }
OptRectangle >> deltaToEnsureInOrCentered: r extra: aNumber [
	| dX dY halfXDiff halfYDiff |
	dX := dY := 0.
	halfXDiff := ((r width - self width) * aNumber) truncated.
	halfYDiff := ((r height - self height) * aNumber) truncated.
	originX < r left
		ifTrue: [ dX := originX - r left - halfXDiff ]
		ifFalse:
			[ cornerX > r right ifTrue: [ dX := cornerX - r right + halfXDiff ] ].
	originY < r top
		ifTrue: [ dY := originY - r top - halfYDiff ]
		ifFalse:
			[ cornerY > r bottom ifTrue: [ dY := cornerY - r bottom + halfYDiff ] ].
	^ dX @ dY
]

{ #category : 'rectangle functions' }
OptRectangle >> encompass: aPoint [
	"Answer a Rectangle that contains both the receiver and aPoint."

	^ OptRectangle
		  origin: (self origin min: aPoint)
		  corner: (self corner max: aPoint)
]

{ #category : 'rectangle functions' }
OptRectangle >> expandBy: delta [
	"Answer a Rectangle that is outset from the receiver by delta. delta is a
	Rectangle, Point, or scalar."

	^ delta asMargin expandRectangle: self
]

{ #category : 'truncation and round off' }
OptRectangle >> expandTo: grid [
	"Answer a Rectangle whose origin and corner are rounded to grid x and grid y.
	Rounding is done by upper value on origin and lower value on corner so that
	self is inside rounded rectangle."

	^ OptRectangle
		  origin: (self origin roundDownTo: grid)
		  corner: (self corner roundUpTo: grid)
]

{ #category : 'truncation and round off' }
OptRectangle >> expanded [
	"Answer a Rectangle whose origin and corner are rounded to integers.
	Rounding is done by upper value on origin and lower value on corner so that
	self is inside rounded rectangle."

	^ OptRectangle origin: self origin floor corner: self corner ceiling
]

{ #category : 'rectangle functions' }
OptRectangle >> extendBy: deltaMargin [
	"Answer a Rectangle with the same origin as the receiver, but whose corner is offset by deltaMargin."

	^ deltaMargin asMargin extendRectangle: self
]

{ #category : 'accessing' }
OptRectangle >> extent [
	"Answer a point with the receiver's width @ the receiver's height."

	^self corner - self origin
]

{ #category : 'transforming' }
OptRectangle >> flipBy: direction centerAt: aPoint [
	"Return a copy flipped #vertical or #horizontal, about aPoint."
	^ self class origin: (originX@originY flipBy: direction centerAt: aPoint)
		corner: (cornerX@cornerY flipBy: direction centerAt: aPoint)
]

{ #category : 'accessing' }
OptRectangle >> floatCenter [
	"Answer the float point at the center of the receiver."
	^ self topLeft + self bottomRight / 2.0
]

{ #category : 'truncation and round off' }
OptRectangle >> floor [
	"Answer the integer rectangle to the topLeft of receiver.
	Return receiver if it is already an integerRectangle."

	self isIntegerRectangle ifTrue: [ ^ self ] .

	^ self origin floor corner: self corner floor
]

{ #category : 'rectangle functions' }
OptRectangle >> forPoint: aPoint closestSideDistLen: sideDistLenBlock [
	"Evaluate the block with my side (symbol) closest to aPoint,
		the approx distance of aPoint from that side, and
		the length of the side (or 0 if aPoint is beyond the side)"
	| side |
	side := self sideNearestTo: aPoint.
	side == #right ifTrue:
		[ ^ sideDistLenBlock
			value: side
			value: (cornerX - aPoint x) abs
			value: ((aPoint y
					between: originY
					and: cornerY)
					ifTrue: [ self height ]
					ifFalse: [ 0 ]) ].
	side == #left ifTrue:
		[ ^ sideDistLenBlock
			value: side
			value: (originX - aPoint x) abs
			value: ((aPoint y
					between: originY
					and: cornerY)
					ifTrue: [ self height ]
					ifFalse: [ 0 ]) ].
	side == #bottom ifTrue:
		[ ^ sideDistLenBlock
			value: side
			value: (cornerY - aPoint y) abs
			value: ((aPoint x
					between: originX
					and: cornerX)
					ifTrue: [ self width ]
					ifFalse: [ 0 ]) ].
	side == #top ifTrue:
		[ ^ sideDistLenBlock
			value: side
			value: (originY - aPoint y) abs
			value: ((aPoint x
					between: originX
					and: cornerX)
					ifTrue: [ self width ]
					ifFalse: [ 0 ]) ]
]

{ #category : 'testing' }
OptRectangle >> hasPositiveExtent [
	^ (cornerX > originX) and: [cornerY> originY]
]

{ #category : 'comparing' }
OptRectangle >> hash [
	"Hash is reimplemented because = is implemented."

	^ self origin hash bitXor: self corner hash
]

{ #category : 'accessing' }
OptRectangle >> height [
	"Answer the height of the receiver."

	^cornerY - originY
]

{ #category : 'accessing' }
OptRectangle >> innerCorners [
	"Return an array of inner corner points,
	ie, the most extreme pixels included,
	in the order of a quadrilateral spec for WarpBlt"
	| r1 |
	r1 := self topLeft corner: self bottomRight - (1 @ 1).
	^ Array
		with: r1 topLeft
		with: r1 bottomLeft
		with: r1 bottomRight
		with: r1 topRight
]

{ #category : 'rectangle functions' }
OptRectangle >> insetBy: delta [
	"Answer a Rectangle that is inset from the receiver by delta. delta is a
	Rectangle, Point, or scalar."

	^ delta asMargin insetRectangle: self
]

{ #category : 'rectangle functions' }
OptRectangle >> insetOriginBy: originDeltaPoint cornerBy: cornerDeltaPoint [
	"Answer a Rectangle that is inset from the receiver by a given amount in
	the origin and corner."

	^ OptRectangle
		  origin: self origin + originDeltaPoint
		  corner: self corner - cornerDeltaPoint
]

{ #category : 'transforming' }
OptRectangle >> interpolateTo: end at: amountDone [
	"Interpolate between the instance and end after the specified amount has been done (0 - 1)."

	^(self origin interpolateTo: end origin at: amountDone)
		corner: (self corner interpolateTo: end corner at: amountDone)
]

{ #category : 'rectangle functions' }
OptRectangle >> intersect: aRectangle [
	"Answer a Rectangle that is the area in which the receiver overlaps with
	aRectangle."
	^ self intersect: aRectangle ifNone:[0@0 extent:0@0]
]

{ #category : 'rectangle functions' }
OptRectangle >> intersect: aRectangle ifNone: aBlock [
	"Answer a Rectangle that is the area in which the receiver overlaps with
	aRectangle.
	If there's no overlap, evaluate the block instead
	"

	| aPoint left right top bottom |
	(self intersects: aRectangle)
		ifFalse: [ ^ aBlock value ].
	aPoint := aRectangle origin.
	left := aPoint x max: originX.
	top := aPoint y max: originY.
	aPoint := aRectangle corner.
	right := aPoint x min: cornerX.
	bottom := aPoint y min: cornerY.
	^ OptRectangle origin: left @ top corner: right @ bottom
]

{ #category : 'testing' }
OptRectangle >> intersects: aRectangle [
	"Answer whether aRectangle intersects the receiver anywhere."
	"Optimized; old code answered:
		(origin max: aRectangle origin) < (corner min: aRectangle corner)"
	| rOrigin rCorner |
	rOrigin := aRectangle origin.
	rCorner := aRectangle corner.
	rCorner x <= originX ifTrue: [ ^ false ].
	rCorner y <= originY ifTrue: [ ^ false ].
	rOrigin x >= cornerX ifTrue: [ ^ false ].
	rOrigin y >= cornerY ifTrue: [ ^ false ].
	^ true
]

{ #category : 'truncation and round off' }
OptRectangle >> isIntegerRectangle [
	"Answer true if all component of receiver are integral."

	^ self origin isIntegerPoint and: [ self corner isIntegerPoint ]
]

{ #category : 'testing' }
OptRectangle >> isRectangle [
	^true
]

{ #category : 'self evaluating' }
OptRectangle >> isSelfEvaluating [
	^ self class == OptRectangle
]

{ #category : 'testing' }
OptRectangle >> isTall [
	^ self height > self width
]

{ #category : 'testing' }
OptRectangle >> isWide [
	^ self width > self height
]

{ #category : 'testing' }
OptRectangle >> isZero [
	^ self origin isZero and:[ self corner isZero ]
]

{ #category : 'accessing' }
OptRectangle >> left [
	"Answer the position of the receiver's left vertical line."

	^originX
]

{ #category : 'accessing' }
OptRectangle >> left: aNumber [

	^ OptRectangle origin: aNumber @ originY corner: cornerX@cornerY
]

{ #category : 'accessing' }
OptRectangle >> leftCenter [
	"Answer the point at the center of the receiver's left vertical line."

	^originX @ self center y
]

{ #category : 'rectangle functions' }
OptRectangle >> merge: aRectangle [
	"Answer a Rectangle that contains both the receiver and aRectangle."

	^ OptRectangle
		  origin: (self origin min: aRectangle origin)
		  corner: (self corner max: aRectangle corner)
]

{ #category : 'accessing' }
OptRectangle >> origin [
	"Answer the point at the top left corner of the receiver."

	^originX@originY 
]

{ #category : 'accessing' }
OptRectangle >> pointAtSideOrCorner: loc [
	"Answer the point represented by the given location."

	^ self
		perform: (#(topLeft topCenter topRight rightCenter
					bottomRight bottomCenter bottomLeft leftCenter)
						at: (#(topLeft top topRight right
					bottomRight bottom bottomLeft left) indexOf: loc))
]

{ #category : 'rectangle functions' }
OptRectangle >> pointNearestTo: aPoint [
	"Return the point on my border closest to aPoint"
	| side |
	(self containsPoint: aPoint)
		ifTrue:
			[ side := self sideNearestTo: aPoint.
			side == #right ifTrue: [ ^ cornerX @ aPoint y ].
			side == #left ifTrue: [ ^ originX @ aPoint y ].
			side == #bottom ifTrue: [ ^ aPoint x @ cornerY ].
			side == #top ifTrue: [ ^ aPoint x @ originY ] ]
		ifFalse: [ ^ aPoint adhereTo: self ]
]

{ #category : 'printing' }
OptRectangle >> printOn: aStream [
	"Refer to the comment in Object|printOn:."
	aStream nextPutAll: ' OptRectangle origin: '.
	originX@originY printOn: aStream.
	aStream nextPutAll: ' corner: '.
	cornerX@cornerY printOn: aStream
]

{ #category : 'rectangle functions' }
OptRectangle >> quickMerge: aRectangle [
	"Answer the receiver if it encloses the given rectangle or the merge of the two rectangles if it doesn't. This method is an optimization to reduce extra rectangle creations."
	| useRcvr rOrigin rCorner minX maxX minY maxY |

	aRectangle ifNil: [ ^self ].

	useRcvr := true.
	rOrigin := aRectangle topLeft.
	rCorner := aRectangle bottomRight.
	minX := rOrigin x < originX
		ifTrue:
			[ useRcvr := false.
			rOrigin x ]
		ifFalse: [ originX ].
	maxX := rCorner x > cornerX
		ifTrue:
			[ useRcvr := false.
			rCorner x ]
		ifFalse: [ cornerX ].
	minY := rOrigin y < originY
		ifTrue:
			[ useRcvr := false.
			rOrigin y ]
		ifFalse: [ originY ].
	maxY := rCorner y > cornerY
		ifTrue:
			[ useRcvr := false.
			rCorner y ]
		ifFalse: [ cornerY ].
	^ useRcvr
		ifTrue: [ self ]
		ifFalse:
			[ OptRectangle
				origin: minX @ minY
				corner: maxX @ maxY ]
]

{ #category : 'transforming' }
OptRectangle >> quickMergePoint: aPoint [
	"Answer the receiver if it encloses the given point or the expansion of the
	receiver to do so if it doesn't. "

	| useRcvr minX maxX minY maxY |
	useRcvr := true.
	minX := aPoint x < originX ifTrue: [useRcvr := false. aPoint x] ifFalse: [originX].
	maxX := aPoint x >= cornerX ifTrue: [useRcvr := false. aPoint x + 1] ifFalse: [cornerX].
	minY := aPoint y < originY ifTrue: [useRcvr := false. aPoint y] ifFalse: [originY].
	maxY := aPoint y >= cornerY ifTrue: [useRcvr := false. aPoint y + 1] ifFalse: [cornerY].
	^useRcvr
		ifTrue: [self]
		ifFalse: [minX@minY corner: maxX@maxY]
]

{ #category : 'rectangle functions' }
OptRectangle >> rectanglesAt: y height: ht [

	^ y + ht > cornerY
		  ifTrue: [ #(  ) ]
		  ifFalse: [ { (originX @ y corner: cornerX @ (y + ht)) } ]
]

{ #category : 'accessing' }
OptRectangle >> right [
	"Answer the position of the receiver's right vertical line."

	^cornerX
]

{ #category : 'accessing' }
OptRectangle >> right: aNumber [

	^ OptRectangle origin: self origin corner: aNumber @ cornerY
]

{ #category : 'accessing' }
OptRectangle >> rightCenter [
	"Answer the point at the center of the receiver's right vertical line."

	^cornerX @ self center y
]

{ #category : 'transforming' }
OptRectangle >> rotateBy: direction centerAt: aPoint [
	"Return a copy rotated #right, #left, or #pi about aPoint"
	^ (originX@originY rotateBy: direction centerAt: aPoint)
		rectangle: (cornerX@cornerY rotateBy: direction centerAt: aPoint)
]

{ #category : 'truncation and round off' }
OptRectangle >> roundTo: grid [
	"Answer a Rectangle whose origin and corner are rounded to grid x and grid y."

	^ OptRectangle
		  origin: (self origin roundTo: grid)
		  corner: (self corner roundTo: grid)
]

{ #category : 'truncation and round off' }
OptRectangle >> rounded [
	"Answer a Rectangle whose origin and corner are rounded."

	^ OptRectangle
		  origin: self origin rounded
		  corner: self corner rounded
]

{ #category : 'transforming' }
OptRectangle >> scaleBy: scale [
	"Answer a Rectangle scaled by scale, a Point or a scalar."

	^ OptRectangle
		  origin: self origin * scale
		  corner: self corner * scale
]

{ #category : 'transforming' }
OptRectangle >> scaleFrom: rect1 to: rect2 [
	"Produce a rectangle stretched according to the stretch from rect1 to rect2"
	^ (self origin scaleFrom: rect1 to: rect2)
		corner: (self corner scaleFrom: rect1 to: rect2)
]

{ #category : 'transforming' }
OptRectangle >> scaledAndCenteredIn: aRect [
	"Answer a new rectangle that fits into aRectangle and is centered
	but with the same aspect ratio as the receiver."

	^self width / aRect width > (self height / aRect height)
		ifTrue: [aRect left @ (aRect leftCenter y - (self height * (aRect width / self width) / 2))
					corner: aRect right @ (aRect rightCenter y + (self height * (aRect width / self width) / 2))]
		ifFalse: [aRect topCenter x - (self width * (aRect height / self height) / 2) @ aRect top
					corner: (aRect topCenter x + (self width * (aRect height / self height) / 2)) @ aRect bottom]
]

{ #category : 'private' }
OptRectangle >> setLeft: left right: right top: top bottom: bottom [

	(originX:=left min: right) .
	 (originY:=top min: bottom).
	 (cornerX:= left max: right).
	(cornerY:= top max: bottom).
^self
]

{ #category : 'private' }
OptRectangle >> setPoint: pt1 point: pt2 [

	originX :=(pt1 x min: pt2 x).
	originY:=pt1 y min: pt2 y.
	cornerX:=pt1 x max: pt2 x.
	cornerY:=pt1 y max: pt2 y.

]

{ #category : 'rectangle functions' }
OptRectangle >> sideNearestTo: aPoint [
	| distToLeft distToRight distToTop distToBottom closest side |
	distToLeft := aPoint x - originX.
	distToRight := cornerX - aPoint x.
	distToTop := aPoint y - originY.
	distToBottom := cornerY - aPoint y.
	closest := distToLeft.
	side := #left.
	distToRight < closest ifTrue:
		[ closest := distToRight.
		side := #right ].
	distToTop < closest ifTrue:
		[ closest := distToTop.
		side := #top ].
	distToBottom < closest ifTrue:
		[ closest := distToBottom.
		side := #bottom ].
	^ side
	"
 | r | r := Rectangle fromUser.
Display border: r width: 1.
[Sensor anyButtonPressed] whileFalse:
	[(r sideNearestTo: Sensor cursorPoint) , '      ' displayAt: 0@0]
"
]

{ #category : 'transforming' }
OptRectangle >> squishedWithin: aRectangle [
	"Return an adjustment of the receiver that fits within aRectangle by reducing its size, not by changing its origin.  "

	^ self origin corner: ( self corner min: aRectangle bottomRight)

"(50 @ 50 corner: 160 @ 100) squishedWithin:  (20 @ 10 corner: 90 @ 85)"
]

{ #category : 'printing' }
OptRectangle >> storeOn: aStream [
	"printed form is good for storing too"

	aStream nextPut: $(.
	self printOn: aStream.
	aStream nextPut: $)
]

{ #category : 'accessing' }
OptRectangle >> top [
	"Answer the position of the receiver's top horizontal line."

	^originY
]

{ #category : 'accessing' }
OptRectangle >> top: aNumber [

	^ OptRectangle origin: originX @ aNumber corner: (cornerX@cornerY )
]

{ #category : 'accessing' }
OptRectangle >> topCenter [
	"Answer the point at the center of the receiver's top horizontal line."

	^self center x @ originY
]

{ #category : 'accessing' }
OptRectangle >> topLeft [
	"Answer the point at the top left corner of the receiver's top horizontal line."

	^originX@originY
]

{ #category : 'accessing' }
OptRectangle >> topRight [
	"Answer the point at the top right corner of the receiver's top horizontal
	line."

	^cornerX @ originY
]

{ #category : 'transforming' }
OptRectangle >> translateBy: factor [
	"Answer a Rectangle translated by factor, a Point or a scalar."

	^ OptRectangle
		  origin: self origin + factor
		  corner: self corner + factor
]

{ #category : 'transforming' }
OptRectangle >> translatedAndSquishedToBeWithin: aRectangle [
	"Return an adjustment of the receiver that fits within aRectangle by
		- translating it to be within aRectangle if necessary, then
		- reducing its size, if necessary"

	^ (self translatedToBeWithin: aRectangle) squishedWithin: aRectangle
]

{ #category : 'rectangle functions' }
OptRectangle >> translatedToBeWithin: aRectangle [
	"Answer a copy of the receiver that does not extend beyond aRectangle."

	^ self translateBy: (self amountToTranslateWithin: aRectangle)
]

{ #category : 'truncation and round off' }
OptRectangle >> truncateTo: grid [
	"Answer a Rectangle whose origin and corner are truncated to grid x and grid y."

	^ OptRectangle
		  origin: (self origin truncateTo: grid)
		  corner: (self corner truncateTo: grid)
]

{ #category : 'truncation and round off' }
OptRectangle >> truncated [
	"Answer a Rectangle whose origin and corner have any fractional parts removed. Answer the receiver if its coordinates are already integral."

	(originX isInteger and: [
		 originY isInteger and: [
			 cornerX isInteger and: [ cornerY isInteger ] ] ]) ifTrue: [
		^ self ].

	^ OptRectangle
		  origin: self origin truncated
		  corner: self corner truncated
]

{ #category : 'accessing' }
OptRectangle >> width [
	"Answer the width of the receiver."

	^cornerX - originX
]

{ #category : 'rectangle functions' }
OptRectangle >> withBottom: y [
	"Return a copy of me with a different bottom y"
	^ self class origin: originX @ originY corner: cornerX @ (y max: originY)
]

{ #category : 'rectangle functions' }
OptRectangle >> withHeight: height [
	"Return a copy of me with a different height"
	^ self setPoint: self origin point: cornerX @ (originY + height)
]

{ #category : 'rectangle functions' }
OptRectangle >> withLeft: x [
	"Return a copy of me with a different left x (but not going over right side)"
	^ self setPoint: (x min: cornerX) @ originY  point: cornerX @ cornerY
]

{ #category : 'rectangle functions' }
OptRectangle >> withRight: x [
	"Return a copy of me with a different right x"
	^  self setPoint: originX @ originY point: (x max: originX) @ cornerY  
]

{ #category : 'rectangle functions' }
OptRectangle >> withSide: side setTo: value [  "return a copy with side set to value"
	^ self perform: (#(withLeft: withRight: withTop: withBottom: )
							at: (#(left right top bottom) indexOf: side))
		with: value
]

{ #category : 'rectangle functions' }
OptRectangle >> withSideOrCorner: side setToPoint: newPoint [
	"Return a copy with side set to newPoint"

	^ self withSideOrCorner: side setToPoint: newPoint minExtent: 0@0
]

{ #category : 'rectangle functions' }
OptRectangle >> withSideOrCorner: side setToPoint: newPoint minExtent: minExtent [
	"Return a copy with side set to newPoint"
	^self withSideOrCorner: side setToPoint: newPoint minExtent: minExtent
		limit: ((#(left top) includes: side) ifTrue: [SmallInteger minVal] ifFalse: [SmallInteger maxVal])
]

{ #category : 'rectangle functions' }
OptRectangle >> withSideOrCorner: side setToPoint: newPoint minExtent: minExtent limit: limit [
	"Return a copy with side set to newPoint"
	side = #top ifTrue: [^ self withTop: (newPoint y min: cornerY - minExtent y max: limit + minExtent y)].
	side = #bottom ifTrue: [^ self withBottom: (newPoint y min: limit - minExtent y max: originY + minExtent y)].
	side = #left ifTrue: [^ self withLeft: (newPoint x min: cornerX - minExtent x max: limit + minExtent x)].
	side = #right ifTrue: [^ self withRight: (newPoint x min: limit - minExtent x max: originX + minExtent x)].
	side = #topLeft ifTrue: [^ (newPoint min: self corner - minExtent) corner: self bottomRight].
	side = #bottomRight ifTrue: [^ self topLeft corner: (newPoint max: self origin + minExtent)].
	side = #bottomLeft ifTrue: [^ self topRight rectangle: ((newPoint x min: cornerX - minExtent x) @ (newPoint y max: originY + minExtent y))].
	side = #topRight ifTrue: [^ self bottomLeft rectangle: ((newPoint x max: originX + minExtent x) @ (newPoint y min: cornerY - minExtent y))]
]

{ #category : 'rectangle functions' }
OptRectangle >> withTop: y [
	"Return a copy of me with a different top y"
	^ self class origin: originX @ (y min: cornerY) corner: cornerX @ cornerY
]

{ #category : 'rectangle functions' }
OptRectangle >> withWidth: width [
	"Return a copy of me with a different width"
	^ self setPoint: self origin  point: (originX + width) @ cornerY
]

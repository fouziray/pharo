"
SUnit tests for class Rectangle
"
Class {
	#name : 'RectangleParametrizedTest',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'emptyRectangle',
		'rectangle1',
		'rectangleClass'
	],
	#category : 'Graphics-Tests-Primitives',
	#package : 'Graphics-Tests',
	#tag : 'Primitives'
}

{ #category : 'building suites' }
RectangleParametrizedTest class >> testParameters [
	^ ParametrizedTestMatrix new
	addCase: {  (#rectangleClass -> Rectangle) };
	addCase: { (#rectangleClass -> OptRectangle) };
	yourself.
]

{ #category : 'accessing' }
RectangleParametrizedTest >> rectangleClass [
	^rectangleClass
]

{ #category : 'accessing' }
RectangleParametrizedTest >> rectangleClass: aRectangleClass [
	^ rectangleClass:= aRectangleClass 
]

{ #category : 'running' }
RectangleParametrizedTest >> setUp [
	super setUp.
	emptyRectangle := rectangleClass origin: 0 @ 0 corner: 0 @ 0.
	rectangle1:= rectangleClass origin: 10@10  corner: 20@20
]

{ #category : 'tests' }
RectangleParametrizedTest >> testARectangleContainsItsOrigin [

	self
		assert: (rectangle1 containsPoint: rectangle1 origin)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testARectangleDoesNotContainItsCorner [

	self
		deny: (rectangle1 containsPoint: rectangle1 corner)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testARectangleIntersectsWithItself [

	self
		assert: (rectangle1 intersects: rectangle1)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testAnEmptyRectangleHasNoArea [

	self assert: emptyRectangle area equals: 0
]

{ #category : 'tests - accessing' }
RectangleParametrizedTest >> testArea [

	self assert: (rectangleClass origin: 0 @ 0 corner: 5 @ 5) area equals: 25.
	self assert: (rectangleClass origin: 2 @ 3 corner: 10 @ 8) area equals: 40.
	self assert: (rectangleClass origin: 5 @ 5 corner: 6 @ 6) area equals: 1.
	self assert: (rectangleClass origin: -1 @ -2 corner: 2 @ 1) area equals: 9
]

{ #category : 'tests' }
RectangleParametrizedTest >> testAreasOutside1 [

    | frame rects visibleArea  |
    frame := rectangleClass origin: 0@0 corner: 300@300.
    rects := OrderedCollection new: 80.
    0 to: 3 do: [:i |
      					0 to: 2 do: [ :j |
            			rects add: (rectangleClass origin: i@j * 20 extent: 10@10)
   						]  
	 ].

   visibleArea := Array with: frame.
   rects do: [:aRectangle |  | remnants |
      remnants := OrderedCollection new.
      visibleArea do: [ :a | remnants addAll: (a areasOutside: aRectangle) ].
      visibleArea := remnants.
  ].
  visibleArea := visibleArea asArray.
  self assert: (visibleArea allSatisfy: [:r | r area ~= 0]).
   1 to: visibleArea size do: [:index |
     index + 1 to: visibleArea size do: [:index2 |
        self deny: ((visibleArea at: index) intersects: (visibleArea at: index2)).
  		]  
	].

  1 to: rects size do: [:index |
     1 to: visibleArea size do: [:index2 |
        self deny: ((rects at: index) intersects: (visibleArea at: index2)).
  		]  
   ]
]

{ #category : 'tests' }
RectangleParametrizedTest >> testAreasOutside2 [

    | frame rects visibleArea  |
    frame := rectangleClass origin: 0@0 extent: 300@300.
    rects := OrderedCollection new: 80.
    rects add: (rectangleClass origin: 50@50 corner: 200 @ 200);
          add: (rectangleClass origin: 100@100 corner: 250@250).

   visibleArea := Array with: frame.
   rects do: [:rect |  | remnants |
      remnants := OrderedCollection new.
      visibleArea do: [:a | remnants addAll: (a areasOutside: rect)].
      visibleArea := remnants.
  ].
  visibleArea := visibleArea asArray.
  self assert: (visibleArea allSatisfy: [:r | r area ~= 0]).

   1 to: visibleArea size do: [:idx |
     idx + 1 to: visibleArea size do: [:idx2 |
        self deny: ((visibleArea at: idx) intersects: (visibleArea at: idx2)).
  ]  ].

  1 to: rects size do: [:idx |
     1 to: visibleArea size do: [:idx2 |
        self deny: ((rects at: idx) intersects: (visibleArea at: idx2)).
  ]  ]
]

{ #category : 'tests - accessing' }
RectangleParametrizedTest >> testBottom [

	| rect |
	rect := (rectangleClass origin: 0 @ 0 corner: 20 @ 20) bottom: 10.
	self assert: rect bottom equals: 10
]

{ #category : 'tests' }
RectangleParametrizedTest >> testCenter [

	| r1 c |
	r1 := rectangleClass origin:0 @ 0 extent: 10 @ 20.
	c := r1 center.
	self assert: (r1 containsPoint: c) description: 'the center is inside the rectangle'.
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomRight distanceTo: c).
	self assert: (r1 bottomLeft distanceTo: c) equals: (r1 topRight distanceTo: c).
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomLeft distanceTo: c).
	self assert: (r1 translateBy: -20 @ 10) center = (c translateBy: -20 @ 10) description: 'the center is translated with the rectangle'
]

{ #category : 'tests' }
RectangleParametrizedTest >> testCenterEmpty [

	| r1 c |
	r1 := rectangleClass origin: 30 @ 10 corner: 10 @ 20.
	"does not create an empty rectangle"
	c := r1 center.
	self assert: (r1 containsPoint: c) description: 'A rectangle contain its center.'.
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomRight distanceTo: c).
	self assert: (r1 bottomLeft distanceTo: c) equals: (r1 topRight distanceTo: c).
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomLeft distanceTo: c).
	self assert: (r1 translateBy: -20 @ 10) center = (c translateBy: -20 @ 10) description: 'the center is translated with the rectangle'
]

{ #category : 'tests' }
RectangleParametrizedTest >> testCenterEmpty2 [

	| r1 c |
	r1 :=rectangleClass origin: 0 @ 0 corner: 0 @ 0.
	"does not create an empty rectangle"
	c := r1 center.
	self deny: (r1 containsPoint: c) description: 'An empty rectangle does not contain its center.'.
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomRight distanceTo: c).
	self assert: (r1 bottomLeft distanceTo: c) equals: (r1 topRight distanceTo: c).
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomLeft distanceTo: c).
	self assert: (r1 translateBy: -20 @ 10) center = (c translateBy: -20 @ 10) description: 'the center is translated with the rectangle'
]

{ #category : 'tests' }
RectangleParametrizedTest >> testCenterEmptyBasedOnPointPoint [

	| r1 c |
	r1 := rectangleClass origin: 30 @ 10 corner: 10 @ 20.
	"does not create an empty rectangle"
	c := r1 center.
	self assert: (r1 containsPoint: c) description: 'A rectangle contain its center.'.
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomRight distanceTo: c).
	self assert: (r1 bottomLeft distanceTo: c) equals: (r1 topRight distanceTo: c).
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomLeft distanceTo: c).
	self assert: (r1 translateBy: -20 @ 10) center = (c translateBy: -20 @ 10) description: 'the center is translated with the rectangle'
]

{ #category : 'tests' }
RectangleParametrizedTest >> testCloseTo [

	| aOrigin aCorner bOrigin bCorner|
	aOrigin := 0.00001000001 @ 0.00001000011.
	aCorner := 2.00001000001 @ 2.00001000011.

	bOrigin := 0.0000100000001 @ 0.0000100001001.
	bCorner := 2.0000100000001 @ 2.0000100001001.

	self assert: (aOrigin x closeTo: 0.00001).
	self assert: (aOrigin y closeTo: 0.00001).
	self assert: (aCorner x closeTo: 2.00001).
	self assert: (aCorner y closeTo: 2.00001).

	self assert: (bOrigin x closeTo: 0.00001).
	self assert: (bOrigin y closeTo: 0.00001).
	self assert: (bCorner x closeTo: 2.00001).
	self assert: (bCorner y closeTo: 2.00001).

	self assert: ((rectangleClass origin: aOrigin corner: aCorner) closeTo: (rectangleClass origin: bOrigin corner: bCorner))
]

{ #category : 'tests' }
RectangleParametrizedTest >> testCloseToWithPrecision [

	| aOrigin aCorner bOrigin bCorner|
	aOrigin := 0.105 @ 0.1051.
	aCorner := 2.105 @ 2.1051.

	bOrigin := 0.11 @ 0.1055.
	bCorner := 2.11 @ 2.1055.

	self assert: (aOrigin x closeTo: 0.1 precision: 0.1).
	self assert: (aOrigin y closeTo: 0.1 precision: 0.1).
	self assert: (aCorner x closeTo: 2.1 precision: 0.1).
	self assert: (aCorner y closeTo: 2.1 precision: 0.1).

	self assert: (bOrigin x closeTo: 0.1 precision: 0.1).
	self assert: (bOrigin y closeTo: 0.1 precision: 0.1).
	self assert: (bCorner x closeTo: 2.1 precision: 0.1).
	self assert: (bCorner y closeTo: 2.1 precision: 0.1).

	self assert: ((rectangleClass origin: aOrigin corner: aCorner) closeTo: (rectangleClass origin: bOrigin corner: bCorner) precision: 0.1)
]

{ #category : 'tests - comparing' }
RectangleParametrizedTest >> testEquals [

	self deny: nil equals: (rectangleClass origin: 10 @ 10 corner: 20 @ 20).
	self deny: Object new equals: (rectangleClass origin: 10 @ 10 corner: 20 @ 20).
	self 
		deny: (rectangleClass origin: 10 @ 8 corner: 20 @ 20) 
		equals: (rectangleClass origin: 10 @ 10 corner: 20 @ 20).
	self
		deny: (rectangleClass origin: 10 @ 10 corner: 20 @ 8)
		equals: (rectangleClass origin: 10 @ 10 corner: 20 @ 20).
	self
		assert: (rectangleClass origin: 10 @ 10 corner: 20 @ 20)
		equals: (rectangleClass origin: 10 @ 10 corner: 20 @ 20)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testFlip [

	| r1 c r1Horiz r1Vert |
	
	r1 := rectangleClass origin: 30 @ 10 corner: 10 @ 20.
	c := 5 @ 5.
	r1Horiz := r1 flipBy: #horizontal centerAt: c.
	r1Vert := r1 flipBy: #vertical centerAt: c.

	self assert: r1 area = r1Horiz area description: 'flip preserves area'.
	self assert: r1 area = r1Vert area description: 'flip preserves area'.

	self assert: r1 extent = r1Horiz extent description: 'flip preserves extent'.
	self assert: r1 extent = r1Vert extent description: 'flip preserves extent'.
	self assert: (r1 flipBy: #horizontal centerAt: r1 center) equals: r1.
	self assert: (r1 flipBy: #vertical centerAt: r1 center) equals: r1
]

{ #category : 'tests - transforming' }
RectangleParametrizedTest >> testFlipByCenterAt [

	| rectangle |

	rectangle := rectangleClass origin: 10 @ 10 corner: 20 @ 20.
	self assert: (rectangleClass origin: 10 @ 0 corner: 20 @ 10) equals: (rectangle flipBy: #vertical centerAt: 10 @ 10).
	self assert: (rectangleClass origin: 0 @ 10 corner: 10 @ 20) equals: (rectangle flipBy: #horizontal centerAt: 10 @ 10)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testFloatCenter [

	| r1 c |
	
	r1 := rectangleClass origin: 0@0 corner: 11@21.
	c := r1 floatCenter.
	self assert: (r1 containsPoint: c) description: 'the center is inside the rectangle'.
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomRight distanceTo: c).
	self assert: (r1 bottomLeft distanceTo: c) equals: (r1 topRight distanceTo: c).
	self assert: (r1 topLeft distanceTo: c) equals: (r1 bottomLeft distanceTo: c).
	self assert: (r1 translateBy: -20@10) floatCenter = (c translateBy: -20@10) description: 'the center is translated with the rectangle'
]

{ #category : 'tests' }
RectangleParametrizedTest >> testFloatCenterExtent [

	| r1 c |
	r1 := rectangleClass 
		floatCenter: 1.3@1.3 extent: 4.4 asPoint.
	c := r1 floatCenter.
	self
		assert: (c closeTo: 1.3@1.3);
		assert: (r1 topLeft distanceTo: c)
			equals: (r1 bottomRight distanceTo: c);
		assert: (r1 bottomLeft distanceTo: c)
			equals: (r1 topRight distanceTo: c);
		assert: (r1 topLeft distanceTo: c)
			equals: (r1 bottomLeft distanceTo: c);
		assert: ((r1 translateBy: -20@10) floatCenter closeTo: (c translateBy: -20@10))
			description: 'the center is translated with the rectangle'
]

{ #category : 'tests' }
RectangleParametrizedTest >> testInsettingByNumberShouldWork [

	| rec1 rec2 |
	rec1 := rectangleClass origin: 0 @ 0 corner: 100 @ 200.
	rec2 := rec1 insetBy: 30.

	self assert: rec2 height equals: 140.
	self assert: rec2 width equals: 40.

	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 200.
	rec2 := rec1 insetBy: 50.

	self assert: rec2 height equals: 100.
	self assert: rec2 width equals: 0
]

{ #category : 'tests' }
RectangleParametrizedTest >> testInsettingByRectangleShouldNotProduceNegativeRectangle [

	| rec1 rec2 |
	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 200.
	rec2 := rec1 insetBy: (1 @ 2 rectangle: 5 @ 10).

	self assert: rec2 left equals: 1.
	self assert: rec2 right equals: 95.
	self assert: rec2 top equals: 2.
	self assert: rec2 bottom equals: 190.


	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 200.
	rec2 := rec1 insetBy: (46 @ 2 rectangle: 55 @ 10).

	self assert: rec2 left equals: 46.
	self assert: rec2 right equals: 46.
	self assert: rec2 top equals: 2.
	self assert: rec2 bottom equals: 190.

	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 200.
	rec2 := rec1 insetBy: (46 @ 2 rectangle: 55 @ 10).

	self assert: rec2 left equals: 46.
	self assert: rec2 right equals: 46.
	self assert: rec2 top equals: 2.
	self assert: rec2 bottom equals: 190.

	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 200.
	rec2 := rec1 insetBy: (1 @ 102 rectangle: 5 @ 105).

	self assert: rec2 left equals: 1.
	self assert: rec2 right equals: 95.
	self assert: rec2 top equals: 102.
	self assert: rec2 bottom equals: 102
]

{ #category : 'tests' }
RectangleParametrizedTest >> testInsettingLargerThanRectangleExtentShouldNotProduceNegativeExtent [

	| rec1 rec2 |
	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 100.
	rec2 := rec1 insetBy: 200 @ 200.

	self assert: rec2 height >= 0.
	self assert: rec2 width >= 0.

	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 100.
	rec2 := rec1 insetBy: 50 @ 50.
	"because insetBy: reduces from both sides"
	self assert: rec2 height equals: 0.
	self assert: rec2 width equals: 0
]

{ #category : 'tests' }
RectangleParametrizedTest >> testInsettingSmallerThanRectangleExtentShouldProduceCorrectExtent [

	| rec1 rec2 |
	rec1 := rectangleClass origin: 0 @ 0 extent: 100 @ 100.
	rec2 := rec1 insetBy: 40 @ 40.

	self assert: rec2 height equals: 20.
	self assert: rec2 width equals: 20
]

{ #category : 'tests - accessing' }
RectangleParametrizedTest >> testLeft [

	| rect |
	rect := (rectangleClass origin: 0 @ 0 corner: 20 @ 20) left: 10.
	self assert: rect left equals: 10
]

{ #category : 'tests' }
RectangleParametrizedTest >> testMergingDisjointRectangles [

	| aCollection merge |
	aCollection := OrderedCollection new.
	aCollection
		add:
			(rectangleClass
				left: -10
				right: 0
				top: -10
				bottom: 0).
	aCollection
		add:
			(rectangleClass 
				left: 0
				right: 10
				top: 0
				bottom: 10).
	merge := rectangleClass merging: aCollection.
	self
		assert: merge
		equals:
			( rectangleClass 
				left: -10
				right: 10
				top: -10
				bottom: 10)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testMergingNestedRectanglesReturnTheContainer [

	| aCollection merge |
	aCollection := OrderedCollection new.
	aCollection
		add:
			(rectangleClass 
				left: 1
				right: 10
				top: 1
				bottom: 10).
	aCollection
		add:
			(rectangleClass 
				left: 4
				right: 5
				top: 4
				bottom: 5).
	merge := rectangleClass merging: aCollection.
	self assert: merge equals: aCollection first
]

{ #category : 'tests' }
RectangleParametrizedTest >> testMergingOneRectangleReturnsThisRectangle [

	| aCollection mergingRectangle |
	aCollection := OrderedCollection new.
	aCollection add: rectangle1.
	mergingRectangle := rectangleClass merging: aCollection.
	self assert: mergingRectangle equals: aCollection first
]

{ #category : 'tests' }
RectangleParametrizedTest >> testMergingOverlappingRectangles [

	| aCollection merge |
	aCollection := OrderedCollection new.
	aCollection
		add:
			(rectangleClass 
				left: 5
				right: 10
				top: 0
				bottom: 15);
		add:
			(rectangleClass 
				left: 0
				right: 15
				top: 5
				bottom: 10).
	merge := rectangleClass merging: aCollection.
	self
		assert: merge
		equals:
			(rectangleClass 
				left: 0
				right: 15
				top: 0
				bottom: 15)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testMergingOverlappingRects [

	| coll merge |
	coll := OrderedCollection new.
	coll
		add:
			(rectangleClass 
				left: 5
				right: 10
				top: 0
				bottom: 15).
	coll
		add:
			(rectangleClass
				left: 0
				right: 15
				top: 5
				bottom: 10).
	merge := rectangleClass merging: coll.
	self
		assert: merge
		equals:
			(rectangleClass
				left: 0
				right: 15
				top: 0
				bottom: 15)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testMergingTwoRectangles [

	| coll merge |
	coll := OrderedCollection new.
	coll
		add:
			(rectangleClass
				left: 1
				right: 1
				top: 1
				bottom: 1).
	coll
		add:
			(rectangleClass
				left: 10
				right: 10
				top: 10
				bottom: 10).

	merge := rectangleClass merging: coll.
	self
		assert: merge
		equals:
			(rectangleClass
				left: 1
				right: 10
				top: 1
				bottom: 10)
]

{ #category : 'tests - rectangle functions' }
RectangleParametrizedTest >> testPointNearestTo [

	| rectangle negativeRectangle |
	rectangle := rectangleClass origin: 10 @ 10 corner: 20 @ 20.
	self assert: 10 @ 10 equals: (rectangle pointNearestTo: 9 @ 9).
	self assert: 20 @ 20 equals: (rectangle pointNearestTo: 21 @ 21).
	self assert: 10 @ 20 equals: (rectangle pointNearestTo: 9 @ 21).
	self assert: 20 @ 10 equals: (rectangle pointNearestTo: 21 @ 10).
	self assert: 10 @ 15 equals: (rectangle pointNearestTo: 11 @ 15).
	self assert: 15 @ 10 equals: (rectangle pointNearestTo: 15 @ 13).
	self assert: 20 @ 15 equals: (rectangle pointNearestTo: 17 @ 15).
	self assert: 15 @ 20 equals: (rectangle pointNearestTo: 15 @ 18).
	negativeRectangle := rectangleClass origin:-10 @ -10 corner: -20 @ -20.
	self assert: -10 @ -10 equals: (negativeRectangle pointNearestTo: 0@0)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testPointPointConstructorIsSymmetrical [

	| pt1 pt2 rect1 rect2 |

	pt1:= 0@0.
	pt2 := 10@10.

	rect1 := rectangleClass origin: pt1 corner: pt2.
	rect2 := rectangleClass origin: pt2 corner: pt1.

	self assert: rect1 equals: rect2
]

{ #category : 'tests' }
RectangleParametrizedTest >> testRectangleWithNegativeExtentShouldHaveZeroExtent [

	self assert: (rectangleClass origin: 10 @ 10 extent: -5 @ -5) extent equals: 0 @ 0.
	self assert: (rectangleClass origin: 10 @ 10 extent: -5 @ -5) origin equals: 10 @ 10.
	self assert: (rectangleClass origin: 10 @ 10 extent: 50 @ 60) extent equals: 50 @ 60
]

{ #category : 'tests' }
RectangleParametrizedTest >> testRectanglesWithSameOriginIntersect [

   | rect1 rect2 |

   rect1 := rectangleClass origin: 10@10 corner: 20@30.
   rect2 := rect1 corner extent: 20@40.
   self deny: (rect1 intersects: rect2)
]

{ #category : 'tests - accessing' }
RectangleParametrizedTest >> testRight [

	| rect |
	
	rect := (rectangleClass origin: 0 @ 0 corner: 20 @ 20) right: 10.
	self assert: rect right equals: 10
]

{ #category : 'tests' }
RectangleParametrizedTest >> testRotateBy [

	| rect |

	rect := rectangleClass
		left: 0
		right: 6
		top: 4
		bottom: 2.

	self assert: (rect rotateBy: #left centerAt: 0 @ 0) left equals: 2.
	self assert: (rect rotateBy: #left centerAt: 0 @ 0) right equals: 4.
	self assert: (rect rotateBy: #left centerAt: 0 @ 0) top equals: -6.
	self assert: (rect rotateBy: #left centerAt: 0 @ 0) bottom equals: 0.

	self assert: (rect rotateBy: #right centerAt: 0 @ 0) left equals: -4.
	self assert: (rect rotateBy: #right centerAt: 0 @ 0) right equals: -2.
	self assert: (rect rotateBy: #right centerAt: 0 @ 0) top equals: 0.
	self assert: (rect rotateBy: #right centerAt: 0 @ 0) bottom equals: 6.

	self assert: (rect rotateBy: #pi centerAt: 0 @ 0) left equals: -6.
	self assert: (rect rotateBy: #pi centerAt: 0 @ 0) right equals: 0.
	self assert: (rect rotateBy: #pi centerAt: 0 @ 0) top equals: -4.
	self assert: (rect rotateBy: #pi centerAt: 0 @ 0) bottom equals: -2
]

{ #category : 'tests' }
RectangleParametrizedTest >> testScaleBy [

	| rect |
	rect := rectangleClass origin: 2 @ 2 corner: 6 @ 4.

	self assert: (rect scaleBy: 2) left equals: 4.
	self assert: (rect scaleBy: 2) right equals: 12.
	self assert: (rect scaleBy: 2) top equals: 4.
	self assert: (rect scaleBy: 2) bottom equals: 8.

	self assert: (rect scaleBy: 1 / 2) left equals: 1.
	self assert: (rect scaleBy: 1 / 2) right equals: 3.
	self assert: (rect scaleBy: 1 / 2) top equals: 1.
	self assert: (rect scaleBy: 1 / 2) bottom equals: 2.

	self assert: (rect scaleBy: 0) left equals: 0.
	self assert: (rect scaleBy: 0) right equals: 0.
	self assert: (rect scaleBy: 0) top equals: 0.
	self assert: (rect scaleBy: 0) bottom equals: 0
]

{ #category : 'tests' }
RectangleParametrizedTest >> testSettingLeftDoesNotProduceInvalidRectangle [

	| rect1 rect2 |

	rect1 := rectangleClass origin: 0@0 corner: 40@40.

	"the left side of new rectangle wants to be beyond the right side of it"
	rect2 := rect1 left: 50.

	self assert: rect2 left equals: 40.
	self assert: rect2 right equals: 50
]

{ #category : 'tests - rectangle functions' }
RectangleParametrizedTest >> testSideNearestTo [
	"rectangular area of screen implies that negalive coordinates not allowed"
	
	| rectangle |
	
	rectangle := rectangleClass origin: 5 @ 5 corner: 45 @ 45.
	self assert: #left equals: (rectangle sideNearestTo: 4 @ 34).
	self assert: #right equals: (rectangle sideNearestTo: 60 @ 21).
	self assert: #top equals: (rectangle sideNearestTo: 25 @ 1).
	self assert: #bottom equals: (rectangle sideNearestTo: 23 @ 65)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testStoreOn [

	| assoc assoc2 |
	
	assoc := (rectangleClass origin: 0 @ 0 corner: 1 @ 1) -> 0.
	assoc2 := self class compiler evaluate: assoc storeString.
	self assert: assoc key equals: assoc2 key.
	self assert: assoc value equals: assoc2 value
]

{ #category : 'tests - accessing' }
RectangleParametrizedTest >> testTop [

	| rect |
	rect := (rectangleClass origin: 0 @ 0 corner: 20 @ 20) top: 10.
	self assert: rect top equals: 10
]

{ #category : 'tests' }
RectangleParametrizedTest >> testTranslateBy [

	| rect |
	rect := rectangleClass origin: 2 @ 2 corner: 6 @ 4.

	self assert: (rect translateBy: 2) left equals: 4.
	self assert: (rect translateBy: 2) right equals: 8.
	self assert: (rect translateBy: 2) top equals: 4.
	self assert: (rect translateBy: 2) bottom equals: 6.

	self assert: (rect translateBy: 2 negated) left equals: 0.
	self assert: (rect translateBy: 2 negated) right equals: 4.
	self assert: (rect translateBy: 2 negated) top equals: 0.
	self assert: (rect translateBy: 2 negated) bottom equals: 2
]

{ #category : 'tests' }
RectangleParametrizedTest >> testTwoRectanglesWithAnAdjascentBorderDoNotIntersect [

   | rect1 rect2 |

   rect1 := rectangleClass origin: 0@0 corner: 40@40.
   rect2 := rectangleClass origin: 40@0 extent:40@40.
   self deny: (rect1 intersects: rect2);
        deny: (rect2 intersects: rect1)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testTwoRectanglesWithAnAdjascentCornerDoNotIntersect [

   | rect1 rect2 |

   rect1 := rectangleClass origin: 0@0 corner: 40@40.
   rect2 := rectangleClass origin: 40@40 corner: 50@50.
   self deny: (rect1 intersects: rect2);
        deny: (rect2 intersects: rect1)
]

{ #category : 'tests - rectangle functions' }
RectangleParametrizedTest >> testWithBottom [

	| r |
	
	r := rectangleClass new.
	r := rectangleClass origin: 0 @ 0 corner: 5 @ 5.
	self assert: (r withBottom: 7) equals: (rectangleClass origin: 0 @ 0 corner: 5 @ 7).
	self assert: (r withBottom: 3) equals: (rectangleClass  origin: 0 @ 0 corner: 5 @ 3).

	r := rectangleClass new.
	r := rectangleClass origin: -5 @ -10 corner: -2 @ -3.
	self assert: (r withBottom: -2) equals: (rectangleClass origin: -5 @ -10 corner: -2 @ -2).
	self assert: (r withBottom: 5) equals: (rectangleClass origin: -5 @ -10 corner: -2 @ 5)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testWithBottomDoesNotProduceInvalidRectangle [

	| rect1 rect2 |
	
	rect1 := rectangleClass origin: 0@10 corner: 50@60.

	"it is possible to adjust the bottom below the current bottom side"
	rect2 := rect1 withBottom: 100.
	self assert: rect2 bottom equals: 100.

	"it is possible to adjust the bottom above the current bottom side"
	rect2 := rect1 withBottom: 40.
	self assert: rect2 bottom equals: 40.

	"it is possible to adjust the bottom above the current bottom side but not above the top"
	rect2 := rect1 withBottom: -10.
	self assert: rect2 bottom equals: 10.
	self assert: rect2 height isZero
]

{ #category : 'tests - rectangle functions' }
RectangleParametrizedTest >> testWithHeight [

	| r |

	r := rectangleClass new.
	r := rectangleClass origin: 1 @ 2 corner: 5 @ 5.
	self assert: (r withHeight: 7) equals: (rectangleClass origin: 1 @ 2 corner: 5 @ 9).
	self assert: (r withHeight: 3) equals: (rectangleClass origin: 1 @ 2 corner: 5 @ 5)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testWithLeftDoesNotProduceInvalidRectangle [

	| rect1 rect2 |
	
	rect1 := rectangleClass origin: 0@10 corner: 50@60.

	"it is possible to adjust the left to the left of the current left side"
	rect2 := rect1 withLeft: -10.
	self assert: rect2 left equals: -10.

	"it is possible to adjust the left to the right of the current left side but not over the righ side!!!!"
	rect2 := rect1 withLeft: 40.
	self assert: rect2 left equals: 40.

	"it is possible to adjust the left to be to the right of the current left side but not over the righ side, at the maximum
	you will a zero width rectangle!!!!"
	rect2 := rect1 withLeft: 80.
	self assert: rect2 left equals: 50.
	self assert: rect2 width isZero
]

{ #category : 'tests' }
RectangleParametrizedTest >> testWithRightDoesNotProduceInvalidRectangle [

	| rect1 rect2 |
	
	rect1 := rectangleClass origin: 0@10 corner: 50@60.

	"it is possible to adjust the right to the right of the current right side"
	rect2 := rect1 withRight: 100.
	self assert: rect2 right equals: 100.

	"it is possible to adjust the right to the left of the current right side but not over the left side!!!!"
	rect2 := rect1 withRight: 40.
	self assert: rect2 right equals: 40.

	"it is possible to adjust the right to be to the left of the current right side but not over the left side itself, at the maximum
	you will a zero width rectangle!!!!"
	rect2 := rect1 withRight: -10.
	self assert: rect2 right equals: 0.
	self assert: rect2 width isZero
]

{ #category : 'tests - rectangle functions' }
RectangleParametrizedTest >> testWithTop [

	| r |
	
	r := rectangleClass new.
	r := rectangleClass origin: 0 @ 0 corner: 5 @ 5.
	self assert: (r withTop: -2) equals: (rectangleClass origin: 0 @ -2 corner: 5 @ 5).
	self assert: (r withTop: 3) equals: (rectangleClass origin: 0 @ 3 corner: 5 @ 5)
]

{ #category : 'tests' }
RectangleParametrizedTest >> testWithTopDoesNotProduceInvalidRectangle [

	| rect1 rect2 |
	
	rect1 := rectangleClass origin: 0@10 corner: 50@60.

	"it is possible to adjust the top above of the current top side"
	rect2 := rect1 withTop: -10.
	self assert: rect2 top equals: -10.

	"it is possible to adjust the top below of the current top side"
	rect2 := rect1 withTop: 40.
	self assert: rect2 top equals: 40.

	"it is possible to adjust the top below of the current top side but not below the bottom"
	rect2 := rect1 withTop: 70.
	self assert: rect2 top equals: 60.
	self assert: rect2 height isZero
]

{ #category : 'tests - rectangle functions' }
RectangleParametrizedTest >> testWithWidth [

	| r |

	r := rectangleClass new.
	r := rectangleClass origin: 1 @ 2 corner: 5 @ 5.
	self assert: (r withWidth: 7) equals: ( rectangleClass origin: 1 @ 2 corner: 8 @ 5).
	self assert: (r withWidth: 3) equals: ( rectangleClass origin: 1 @ 2 corner: 4 @ 5)
]

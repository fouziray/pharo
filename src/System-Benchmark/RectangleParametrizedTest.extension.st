Extension { #name : 'RectangleParametrizedTest' }

{ #category : '*System-Benchmark' }
RectangleParametrizedTest >> testRectangleBecomeOptRectangle [
	| c b t1 t2|
	c := RSCanvas new.
	b := RSBox new
		     extent: 100 @ 100;
		     border: (RSBorder new color: 'black').
	c addShape: b.

	c newAnimation
		easing: RSEasingInterpolator bounce;
		from: -100 @ -100;
		to: 100 @ 100;
		on: b set: #position:.
	c newAnimation
		from: Color red;
		to: Color blue;
		on: b set: #color:.
	c newAnimation
		from: 0;
		to: 10;
		on: b border set: 'width:'.
	c
		when: RSMouseClick do: [ c animations do: #pause ] for: self;
		when: RSMouseDoubleClick
		do: [ c animations do: #continue ]
		for: self.
	c shouldClearBackground: false.
	
	t1:= [c] benchFor: 100 milliSeconds .
	Rectangle allInstancesDo: [ :inst | inst become: (OptRectangle origin: inst origin corner: inst corner)  ].
	t2:= [c] benchFor: 100 milliSeconds .
	self assert: ((t1 compareTo: t2) frequencyFactor > 1).

]

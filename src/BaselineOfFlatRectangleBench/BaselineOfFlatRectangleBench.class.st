Class {
	#name : 'BaselineOfFlatRectangleBench',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFlatRectangleBench',
	#package : 'BaselineOfFlatRectangleBench'
}

{ #category : 'baselines' }
BaselineOfFlatRectangleBench >> baseline: spec [

<baseline>
	spec
		for: #common
		do: [
			spec
				package: 'Kernel';
				
				baseline: 'SMark'
				with: [ spec repository: 'github://smarr/SMark'];
				
				baseline: 'HoneyGinger'
				with: [ spec repository: 'github://tomooda/HoneyGinger:main/repository' ];
				
				package: 'System-Benchmark' with: [ spec requires: #('SMark' 'HoneyGinger') ];
				package: 'Graphics-Tests';
				package: 'Tool-Profilers';
				package: 'Tool-Profilers-Tests';
				package: 'OSWindow-SDL2';
				package:'Fuel-Core';
				package: 'Athens-Core'
		]
]

{ #category : 'accessing' }
BaselineOfFlatRectangleBench >> projectClass [
	^ MetacelloCypressBaselineProject
]

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
				package: 'Kernel' with: [ spec requires: #('Fuel-Core' 'Athens-Core' 'OSWindow-SDL2' 'Rubric')];
				baseline: 'SMark'
				with: [ spec repository: 'github://smarr/SMark:smarr/SMark'];
				package: 'System-Benchmark';
				package: 'Graphics-Tests';
				package: 'Tool-Profilers';
				package: 'Tool-Profilers-Tests';
				package: 'OSWindow-SDL2';
				package:'Fuel-Core';
				package: 'Athens-Core';
				baseline: 'HoneyGinger'
				with: [ spec repository: 'github://tomooda/HoneyGinger/repository:tomooda/HoneyGinger' ]
		]
]

{ #category : 'accessing' }
BaselineOfFlatRectangleBench >> projectClass [
	^ MetacelloCypressBaselineProject
]

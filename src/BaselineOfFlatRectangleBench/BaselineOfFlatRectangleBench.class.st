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
				with: [ spec repository: 'github://smarr/SMark:smarr/SMark'];
				package: 'System-Benchmark';
				package: 'Graphics-Tests';
				package: 'Tool-Profilers';
				package: 'Tool-Profilers-Tests';
				baseline: 'HoneyGinger'
				with: [ spec repository: 'github://tomooda/HoneyGinger/repository:tomooda/HoneyGinger' ]
		]
]

{ #category : 'accessing' }
BaselineOfFlatRectangleBench >> projectClass [
	^ MetacelloCypressBaselineProject
]

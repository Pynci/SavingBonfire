Class {
	#name : 'BaselineOfSavingBonfire',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSavingBonfire',
	#package : 'BaselineOfSavingBonfire'
}

{ #category : 'baselines' }
BaselineOfSavingBonfire >> baseline: spec [

	<baseline>
	spec for: #common do: [ spec package: 'SavingBonfire' ]
]

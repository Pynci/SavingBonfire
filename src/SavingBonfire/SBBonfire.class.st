Class {
	#name : 'SBBonfire',
	#superclass : 'Morph',
	#instVars : [
		'label',
		'ticks',
		'state'
	],
	#category : 'SavingBonfire',
	#package : 'SavingBonfire'
}

{ #category : 'class initialization' }
SBBonfire class >> initialize [

	SessionManager default registerUserClassNamed: #SBBonfireHook
]

{ #category : 'accessing' }
SBBonfire class >> show [

	| morph |
	morph := self new.
	morph openInWorld.
	morph startStepping.
	^ morph
]

{ #category : 'initialization' }
SBBonfire >> initialize [

	super initialize.
	self color: (Color black alpha: 0).
	self bounds: self currentWorld bounds.
	label := TextMorph new
		contents: 'BONFIRE LIT';
		font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 48);
		color: (Color orange alpha: 0);
		yourself.
	self addMorph: label.
	label position: self center - (label extent // 2).
	ticks := 0.
	state := #fadeIn
]

{ #category : 'stepping and presenter' }
SBBonfire >> setAlpha: aNumber [

	| clamped |
	clamped := (aNumber max: 0) min: 1.
	self color: (Color black alpha: clamped * 0.85).
	label color: (Color orange alpha: clamped)
]

{ #category : 'stepping and presenter' }
SBBonfire >> step [

	ticks := ticks + 1.
	state = #fadeIn
		ifTrue: [
			self setAlpha: ticks / 30.0.
			ticks >= 30 ifTrue: [ ticks := 0. state := #hold ] ]
		ifFalse: [
			state = #hold
				ifTrue: [ ticks >= 90 ifTrue: [ ticks := 0. state := #fadeOut ] ]
				ifFalse: [
					self setAlpha: 1 - (ticks / 40.0).
					ticks >= 40 ifTrue: [ self stopStepping. self delete ] ] ]
]

{ #category : 'stepping and presenter' }
SBBonfire >> stepTime [

	^ 30
]

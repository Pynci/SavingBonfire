Class {
	#name : 'SBBonfireMorph',
	#superclass : 'Morph',
	#instVars : [
		'label',
		'ticks',
		'state',
		'band'
	],
	#category : 'SavingBonfire',
	#package : 'SavingBonfire'
}

{ #category : 'class initialization' }
SBBonfireMorph class >> initialize [

	SessionManager default registerUserClassNamed: #SBBonfireHook
]

{ #category : 'accessing' }
SBBonfireMorph class >> show [

	| morph |
	morph := self new.
	[ morph playBonfireSound ] fork.
	morph openInWorld.
	morph startStepping.
	^ morph
]

{ #category : 'sound' }
SBBonfireMorph >> bonfireSoundPath [

	| repo |
	repo := IceRepository registry
		detect: [ :r | r name = 'SavingBonfire' ]
		ifNone: [ ^ nil ].
	^ (repo location / 'darksouls-bonfire.wav') fullName
]

{ #category : 'initialization' }
SBBonfireMorph >> initialize [

	super initialize.
	self color: Color transparent.
	self bounds: self currentWorld bounds.
	self lock.
	label := LabelMorph new
		contents: 'BONFIRE LIT';
		font: (LogicalFont familyName: 'Source Sans Pro' pointSize: 48);
		color: (Color orange alpha: 0);
		yourself.
	band := Morph new
		color: (Color black alpha: 0);
		yourself.
	self addMorph: band.
	self addMorph: label.
	label position: self center - (label extent // 2).
	band bounds: ((self bounds left @ (label top - 20)) corner: (self bounds right @ (label bottom + 20))).
	ticks := 0.
	state := #fadeIn
]

{ #category : 'sound' }
SBBonfireMorph >> playBonfireSound [

	| soundPath |
	soundPath := self bonfireSoundPath.
	
	OSPlatform current isMacOS ifTrue: [ 
		LibC runCommand: 'afplay "', soundPath, '" &' ].
	OSPlatform current isWindows ifTrue: [ 
		LibC runCommand: 'powershell -c "(New-Object Media.SoundPlayer ''', soundPath, ''').Play()"' ].
	OSPlatform current isUnix ifTrue: [ 
		LibC runCommand: 'aplay -q "', soundPath, '" &' ]
]

{ #category : 'stepping and presenter' }
SBBonfireMorph >> step [

	ticks := ticks + 1.
	state = #fadeIn ifTrue: [ self stepFadeIn ].
	state = #hold ifTrue: [ self stepHold ].
	state = #fadeOut ifTrue: [ self stepFadeOut ]
]

{ #category : 'stepping and presenter' }
SBBonfireMorph >> stepFadeIn [

	| progress |
	progress := ticks / 20.0 min: 1.
	band color: (Color black alpha: progress * 0.75).
	label color: (Color orange alpha: progress).
	progress >= 1 ifFalse: [ ^ self ].
	ticks := 0.
	state := #hold
]

{ #category : 'stepping and presenter' }
SBBonfireMorph >> stepFadeOut [

	| progress |
	progress := ticks / 35.0 min: 1.
	band color: (Color black alpha: 1 - (progress * 0.75)).
	label color: (Color orange alpha: 1 - progress).
	progress >= 1 ifFalse: [ ^ self ].
	self stopStepping.
	self delete
]

{ #category : 'stepping and presenter' }
SBBonfireMorph >> stepHold [

	ticks >= 110 ifFalse: [ ^ self ].
	ticks := 0.
	state := #fadeOut
]

{ #category : 'stepping and presenter' }
SBBonfireMorph >> stepTime [

	^ 20
]

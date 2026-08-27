Class {
	#name : 'SBBonfireHook',
	#superclass : 'Object',
	#category : 'SavingBonfire',
	#package : 'SavingBonfire'
}

{ #category : 'system startup' }
SBBonfireHook class >> shutDown: quitting [

	quitting ifFalse: [ SBBonfireMorph show ]
]

{ #category : 'system startup' }
SBBonfireHook class >> startUp: resuming [

	"required by SessionManager's protocol, nothing to do here"
]

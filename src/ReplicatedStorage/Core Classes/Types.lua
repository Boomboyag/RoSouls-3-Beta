
-- || CHARACTER ||

-- The character type
export type Character = {

    objectType: table,
    characterType: table,

    onClient: boolean,
    onServer: boolean,

    humanoid: Humanoid,
    humanoidRootPart: BasePart,
    head: BasePart,
    torso: BasePart,
    rootJoint: Motor6D,
    rootC0: CFrame,
    rootAttachment: Attachment,
    rollAttatchment: Attachment,
    rootOrientationAttachment: AlignOrientation,

    characterState: table,
    controlType: table,

    characterStats: CharacterStats,
    defaultCharacterStats: CharacterStats,

    fallTime: number,
    fallDistance: number,
    fallAnimationSpeed: number,
    groundCheckInterval: number,
    groundCounter: number,

    actionPrefabs: {[string]: Action},

    lastTransform: CFrame,
    XZPlane: Vector3,

    characterModelTilt: number,
    animator: Animator?,
    animations: Animations,
    coreAnimations: {
        [string]: Animations,
        Strafing: {
            Left: Animations,
            Right: Animations
        }
    },
    trackedAnimations: {Animations},
    savedAnimationEvents: {any},
    tilt: CFrame,

    alive: boolean,

    validEffectTables: {any},
    defaultValues: {any},
    effects: {Effect},
    effectTick: number,
    previousEffectTick: number,
    effectPrefabs: {[string]: EffectTable},

    modules: {any},

    isMoving: boolean,
    lockedMovementDirection: Vector3,
    movementDirection: Vector3,
    path: Path,

    GetStat: BindableFunction,
    FinishedPathfinding: BindableEvent,
    StaminaDrained: BindableEvent,
    CharacterDied: BindableEvent,
    CharacterStateChanged: BindableEvent,
    CharacterHumanoidStateChanged: BindableEvent,
    CharacterStatChanged: BindableEvent,
    HealthChanged: BindableEvent,
    StaminaChanged: BindableEvent,
    EffectAdded: BindableEvent,
    EffectRemoved: BindableEvent,
    NewAction: BindableEvent,
    ActionAnimationStopped: BindableEvent,

    DiedConnection: RBXScriptConnection,
    RunningConnection: RBXScriptConnection,
    JumpingConnection: RBXScriptConnection,
    ClimbingConnection: RBXScriptConnection,
    GettingUpConnection: RBXScriptConnection,
    FreeFallingConnection: RBXScriptConnection,
    FallingDownConnection: RBXScriptConnection,
    SeatedConnection: RBXScriptConnection,
    PlatformStandingConnection: RBXScriptConnection,
    SwimmingConnection: RBXScriptConnection,
    HumanoidStateChangedConnection: RBXScriptConnection,
	
    renderSteppedConnection: RBXScriptConnection,
    heartbeatConnection: RBXScriptConnection,

    ChangeControlType: (self: Character, newType: table, direction: Vector3) -> (),
    GetWorldMoveDirection: (self: Character) -> Vector3,
    WalkTo: (self: Character, position: Vector3) -> (),
    Move: (self: Character) -> (),

    AddEffect: (self: Character, effect: EffectTable) -> (),
    RemoveEffect: (self: Character, effectName: string) -> (),
    FindEffect: (self: Character, effectName: string, returnBoolean: boolean) -> Effect?,
    FindEffectAmount: (self: Character, effectName: string) -> number,
    SortEffects: (self: Character, effectsToSort: table) -> table,
    ApplyEffects: (self: Character, modifiedData: string, forceApply: boolean, effectsToIgnore: table?) -> (),
    
    ApplyRootMotion: (self: Character, deltaTime: number) -> (),
    ChangeCoreAnimation: (self: Character, newAnimation: AnimationTrack, oldValue: AnimationTrack, transitionTime: number) -> (),
    CoreAnimationSpeedReflectMovementSpeed: (self: Character, characterSpeed: number, reset: boolean) -> (),
    ChangeActionAnimation: (self: Character, newAnimation: AnimationTrack, transitionTime: number, animationPriority: Enum.AnimationPriority, loop: boolean) -> (),
    ChangeActionAnimationSpeed: (self: Character, characterSpeed: number) -> (),
    TrackAnimation: (self: Character, anim: AnimationTrack) -> (),
    GetFunctionFromAnimationEvent: (self: Character, paramString: string) -> (string, table),
    TiltBody: (self: Character, deltaTime: number) -> (),

    CheckCurrentAction: (self: Character) -> (),
    AddModule: (self: Character, name: string, module: ModuleScript) -> (),

    TakeDamage: (self: Character, damageAmount: number, ignoreForceField: boolean) -> (),
    DamageReaction: (self: Character, damageAmount: number) -> (),
    OnDeath: (self: Character) -> (),

    SpawnSound: (self: Character, id: string, volume: number, attachment: string, attachmentParent: Instance) -> (),
    SpawnVFX: (self: Character, name: string, timesToEmit: number, timeBetweenEmits: number, attachment: string, color: ColorSequence?, parent: Instance?) -> (),
    VFX: (self: Character, name: string, color: ColorSequence?, attachment: string, attachmentParent: Instance?) -> (),

    ApplyImpulse: (self: Character, objectToPush: BasePart, amount: number, direction: Vector3?) -> (),
    ApplyAngularImpulse: (self: Character, objectToPush: BasePart, direction: Vector3?) -> (),

    CheckFall: (self: Character, newTick: number) -> (),
    CheckGround: (self: Character, origin: Vector3) -> (boolean, Enum.Material, Instance),
    CheckSight: (self: Character, newModel: Model, excluded: Instance?, angle: number?, distance: number?) -> boolean,
    HumanoidStateChanged: (self: Character, oldState: Enum.HumanoidStateType, newState: Enum.HumanoidStateType?) -> (),

    Talk: (self: Character, text: string, color: Enum.ChatColor?, talkPoint: BasePart?) -> (),
    
    Destroy: (self: Character) -> (),
}

-- The character stats sheet
export type CharacterStats = {

    canChangeState: boolean,
    movementType: any, 
    characterStateRef: any,
    
    currentAction: any?,
    actionsEnabled: boolean,
    
    currentHealth: number,
    maxHealth: number,
    immuneToDamage: boolean,
    
    minStamina: number,
    maxStamina: number,
    currentStamina: number,
    
    staminaRegenRate: number,
    staminaRegenDelay: number,
    
    isMovingRef: boolean,
    currentWalkSpeed: number,
    
    actionAnimationSpeed: number,
    currentActionAnimation: any?,
    
    coreAnimationSpeed: number,
    coreAnimationInfluencedByCharacterMovement: boolean,
    currentCoreAnimation: any?,
    
    maxTiltAngle: number,
    rootMotionEnabled: boolean,
    
    viewAngle: number,
    viewDistance: number,
    
    autoRotate: boolean,
    canJump: boolean,
    canClimb: boolean,
    canStrafe: boolean,
    canAddEffects: boolean,
    canTilt: boolean,
    footstepsEnabled: boolean,
    
    currentGroundMaterial: string
}

-- The animations
export type Animations = {
	idleAnimation: AnimationTrack,
	walkAnimation: AnimationTrack,
	fallAnimation: AnimationTrack,
  
	strafeLeft: AnimationTrack,
	strafeRight: AnimationTrack,
  
	jumpAnimation: AnimationTrack,
	landAnimation: AnimationTrack,
	sprintAnimation: AnimationTrack,
	rollAnimation: AnimationTrack,
	backstepAnimation: AnimationTrack,
	climbAnimation: AnimationTrack,
	deathAnimation: AnimationTrack,
  
	stunAnimations: {
		
		Light: {
			[number]: AnimationTrack
	  	},

	  	Heavy: {
			[number]: AnimationTrack
	  	}
	}
}
 
-- || ACTIONS ||

-- The action table
export type ActionTable = {
	
	Name : string,
	Type : Enum.ActionType,

	CanQueue : boolean,
	MaxQueueTime : number,
	QueueWhenOveridden : boolean,

	CanCancel : boolean,

	Prerequisites : table,

	ActionBeginFunction : (character : table) -> (),
	ActionEndFunction : (character : table) -> (),

	ActionBeginFunction_PLAYER : (player : table) -> (),
	ActionEndFunction_PLAYER : (character : table) -> (),
}

-- The action prefab
export type Action = {
	
	name : string,
	actionType : Enum.ActionType,

	canQueue : boolean,
	maxQueueTime : number,
	queueWhenOveridden : boolean,

	prerequisites : table,

	actionBeginFunction : (character : table) -> (),
	actionEndFunction : (character : table) -> (),

	actionBeginFunction_PLAYER : (player : table) -> (),
	actionEndFunction_PLAYER : (character : table) -> (),

	CheckPrerequisites : (characterStats : table) -> (boolean),
	GetPrerequisites : () -> (table),

	BeginAction : (character : table) -> (),
	EndAction : (character : table) -> (),

	BeginActionPlayer : (player : table) -> (),
	EndActionPlayer : (player : table) -> (),

	GetType : () -> (Enum.ActionType)
}

-- || EFFECTS ||

-- The table passed when creating a new effect
export type EffectTable = {

	Name : string,
	Priority : number,
	DataToModify : string,

	EffectTickAmount : number,
	TimeBetweenEffectTick : number,

	EffectFunction : (input : any) -> (),

	CanStack : boolean,
	ResetDataWhenDone : boolean,
}

-- The effect itself
export type Effect = {

	name : string,
	priority : number,
	dataToModify : string,

	effectTickAmount : number,
	timeBetweenEffectTick : number,

	effectFunction : (input : any) -> (),

	canStack : boolean,
	resetDataWhenDone : boolean,

	canTerminate : boolean,
	metTickAmount : boolean,
	stopWhenTickAmountReached : boolean,
	
	previousTick : number,

	ApplyEffect : (dataToChange : string, forceApply : boolean) -> (),
	Clone : () -> (),
}

return {}
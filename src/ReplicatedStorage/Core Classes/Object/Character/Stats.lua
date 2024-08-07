-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local movementTypes = require(coreFolder:WaitForChild("Enum").MovementType)
local characterStates = require(coreFolder:WaitForChild("Enum").CharacterStates) 
local types = require(coreFolder:WaitForChild("Types"))

-- Class creation
local characterStats = {}
characterStats.__index = characterStats

-- Class constructor
function characterStats.new(newCharacter) : types.CharacterStats
	local self = {}
	
	-- CHARACTER STATES
	self.canChangeState = true
	self.movementType = movementTypes.Default
	self.characterStateRef = characterStates.Default
	
	-- || ACTIONS ||
	self.currentAction = nil
	self.actionsEnabled = true
	
	-- || HEALTH ||
	self.currentHealth = newCharacter.health or 100
	self.maxHealth = newCharacter.health or 100

	self.immuneToDamage = false
	
	-- || STAMINA ||
	self.minStamina = -50
	self.maxStamina = newCharacter.maxStamina or 100
	self.currentStamina = self.maxStamina
	
	self.staminaRegenRate = 1
	self.staminaRegenDelay = 0.5
	
	-- || WALK SPEED & MOVEMENT ||
	self.isMovingRef = false
	self.currentWalkSpeed = newCharacter.walkSpeed or 9
	
	-- || ANIMATION ||
	self.actionAnimationSpeed = 1
	self.currentActionAnimation = nil

	self.coreAnimationSpeed = 1
	self.coreAnimationInfluencedByCharacterMovement = false
	self.currentCoreAnimation = nil

	self.maxTiltAngle = newCharacter.maxTiltAngle or 10
	self.rootMotionEnabled = false
	
	-- || VIEWCONE ||
	self.viewAngle = newCharacter.viewAngle or -20
	self.viewDistance = newCharacter.viewDistance or 30
	
	-- || BOOLEANS ||
	self.autoRotate = true
	self.canJump = true
	self.canClimb = true
	self.canStrafe = true
	self.canAddEffects = true
	self.canTilt = true
	self.footstepsEnabled = (newCharacter.footstepsEnabled == false) or true

	-- || MISC ||
	self.currentGroundMaterial = "None"

	-- Set the metatable and return
	setmetatable(self, characterStats)
	return self
end

return characterStats

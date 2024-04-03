-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local Enum = require(coreFolder:WaitForChild("Enum")) 

-- Class creation
local characterStats = {}
characterStats.__index = characterStats

-- Class constructor
function characterStats.new(newCharacter)
	local self = {}
	
	-- CHARACTER STATES
	self.canChangeState = true
	self.movementType = Enum.MovementType.Default
	
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
	
	-- || ROLL AND BACKSTEP ||
	self.rollVelocity = 40
	self.backStepVelocity = 30
	
	-- || WALK SPEED ||
	self.currentWalkSpeed = newCharacter.walkSpeed or 11
	
	-- || ANIMATION ||
	self.actionAnimationInfluencedByCharacterMovement = false
	self.currentActionAnimation = nil
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
	self.canSprint = true
	self.canRoll = true
	self.canStrafe = true
	self.canAddEffects = true
	self.canTilt = true

	-- Set the metatable and return
	setmetatable(self, characterStats)
	return self
end

return characterStats

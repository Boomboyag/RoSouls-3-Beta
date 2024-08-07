-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Class creation
local animations = {}
animations.__index = animations

-- Required folders
local defaultAnims = replicatedStorage:WaitForChild("Default_Animations")
local idleAnims = defaultAnims:WaitForChild("Idle")
local movementAnims = defaultAnims:WaitForChild("Movement")
local strafeAnimations = movementAnims:WaitForChild("Strafe")
local actionAnimations = defaultAnims:WaitForChild("Actions")
local stunAnimations = actionAnimations:WaitForChild("Stun")

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

-- Class constructor
function animations.new(humanoid, animationList)
	local self = {}
	
	animationList = animationList or {}

	-- || BASIC ANIMATIONS ||
	self.idleAnimation = humanoid:LoadAnimation(animationList['Idle'] or idleAnims.Standing_Idle)
	self.walkAnimation = humanoid:LoadAnimation(animationList['Walk'] or movementAnims.Standing_Walk)
	self.fallAnimation = humanoid:LoadAnimation(animationList['Fall'] or actionAnimations.Fall_Animation)
	
	-- || STRAFING ANIMATIONS
	self.strafeLeft = humanoid:LoadAnimation(animationList["StrafeLeft"] or strafeAnimations.Strafe_Left)
	self.strafeRight = humanoid:LoadAnimation(animationList["StrafeRight"] or strafeAnimations.Strafe_Right)

	-- || ACTION ANIMATIONS ||
	self.jumpAnimation = humanoid:LoadAnimation(animationList['Jump'] or actionAnimations.Jump_Animation)
	self.landAnimation = humanoid:LoadAnimation(animationList["Land"] or actionAnimations.Land_Animation)
	self.sprintAnimation = humanoid:LoadAnimation(animationList['Sprint'] or actionAnimations.Sprint_Animation)
	self.rollAnimation = humanoid:LoadAnimation(animationList['Roll'] or actionAnimations.Roll_Animation)
	self.backstepAnimation = humanoid:LoadAnimation(animationList["Backstep"] or actionAnimations.Backstep_Animation)
	self.climbAnimation = humanoid:LoadAnimation(animationList['Climb'] or actionAnimations.Climb_Animation)
	self.deathAnimation = humanoid:LoadAnimation(animationList['Death'] or actionAnimations.Death_Animation)

	-- || STUN ANIMATIONS ||
	self.stunAnimations = {

		-- Light stun
		["Light"] = {
			[1] = humanoid:LoadAnimation(animationList['Stun_Light_2'] or stunAnimations.Stun_B),
			[2] = humanoid:LoadAnimation(animationList['Stun_Light_3'] or stunAnimations.Stun_C),
			
		},
		["Heavy"] = {
			[1] = humanoid:LoadAnimation(animationList['Stun_Light_4'] or stunAnimations.Stun_D),
			[2] = humanoid:LoadAnimation(animationList['Stun_Light_1'] or stunAnimations.Stun_A),
		}
	}

	-- Set the metatable and return
	setmetatable(self, animations)
	return self
end

return animations

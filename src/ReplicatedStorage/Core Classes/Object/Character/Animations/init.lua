-- Class creation
local animations = {}
animations.__index = animations

-- Required folders
local defaultAnims = script:WaitForChild("Default_Animations")
local idleAnims = defaultAnims:WaitForChild("Idle")
local movementAnims = defaultAnims:WaitForChild("Movement")
local strafeAnimations = movementAnims:WaitForChild("Strafe")
local actionAnimations = defaultAnims:WaitForChild("Actions")

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

	-- Set the metatable and return
	setmetatable(self, animations)
	return self
end

return animations

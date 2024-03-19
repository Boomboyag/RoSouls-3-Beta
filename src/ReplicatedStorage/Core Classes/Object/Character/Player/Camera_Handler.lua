-- Required scripts
local cameraShaker = require(script:WaitForChild("CameraShaker"))

local cameraHandler = {}
cameraHandler.__index = cameraHandler

-- Class constructor
function cameraHandler.new(player)
	
	local self = setmetatable({}, cameraHandler)

	-- || CAMERA SETUP ||
	self.camera = player.camera
	
	-- || CAMERA SETTINGS ||

	-- Whether or not the camera will follow it's current target
	self.cameraFollowsTarget = player.playerStats.cameraFollowsTarget

	-- How fast the camera follow's it's target and it's offset from said target
	self.cameraStiffness = player.playerStats.cameraStiffness
	self.cameraOffset = player.playerStats.cameraOffset

	self.appliedCameraOffset = self.cameraOffset
	
	-- || CAMERA FOLLOW ||
	
	-- The camera block
	self.cameraBlock = player.cameraBlock
	
	-- The body position
	self.cameraBodyPosition = Instance.new("BodyPosition", self.cameraBlock)
	self.cameraBodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	
	-- What the camera is 'following'
	self.cameraFollow = player.playerStats.cameraFollow

	-- || CAMERA SWAY ||

	-- The amount and speed of the camera sway on both axes
	self.cameraSwayAmount = Vector2.new(0.35, 0.35)
	self.cameraSwaySpeed = Vector2.new(10, 10)

	-- || CAMERA SHAKE ||

	-- The shake module
	self.shakeModule = cameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
		self.camera.CFrame = self.camera.CFrame * shakeCf
	end)
	
	return self
end

-- || CAMERA SMOOTHING ||

-- The camera block creation function
function cameraHandler:CreateCameraBlock(player)

	local CameraBlock = Instance.new("Part")
	CameraBlock.Name = 'CameraBlock'
	CameraBlock.Position = player.humanoidRootPart.CFrame.Position
	CameraBlock.Size = Vector3.new(1, 1, 1)
	CameraBlock.Name = "CameraBlock"
	CameraBlock.CastShadow = false
	CameraBlock.CanQuery = false
	CameraBlock.CanTouch = false
	CameraBlock.CanCollide = false
	CameraBlock.Transparency = 1
	CameraBlock.Massless = true
	CameraBlock.Parent = player.model

	return CameraBlock
end

-- The function to update to camera block's position
function cameraHandler:SmoothCamera()
	
	-- Make sure the camera block exists
	if self.cameraBlock == nil then
		
		warn("Camera block not found!")
		return
	end

	-- Assign the position of the camera part
	self.cameraBodyPosition.Position = (self.cameraFollow.CFrame.Position + self.appliedCameraOffset)

	-- Tween the camera part over time
	self.cameraBodyPosition.P = 1000 * self.cameraStiffness
end

-- || CAMERA SHAKE & SWAY ||

-- Update the camera's idle sway
function cameraHandler:CameraSway()
	
	-- The current time
	local currentTime = tick()

	-- The sway on the x and y axis
	local swayX = math.cos(currentTime * self.cameraSwaySpeed.X) * self.cameraSwayAmount.X
    local swayY = math.abs(math.sin(currentTime * self.cameraSwaySpeed.Y)) * self.cameraSwayAmount.Y
        
	-- The completed sway
    local sway = Vector3.new(swayX, swayY, 0)

	-- Calculate the applied camera offset
    self.appliedCameraOffset = self.cameraOffset + self.cameraOffset:lerp(sway, .25)
end

-- Shake the camera
function cameraHandler:ShakeCamera(magnitude, roughness, fadeInTime, fadeOutTime)
	
	-- Shake the camera via the shake module
	self.shakeModule:ShakeOnce(magnitude, roughness, fadeInTime, fadeOutTime)
end

-- || UPDATE ||

function cameraHandler:Update(deltaTime)

	-- Update the sway
	self:CameraSway()
	
	-- Check if we want the camera to be delayed
	if self.cameraFollowsTarget then
		
		-- Smooth the camera movement
		self:SmoothCamera()
	end
end

return cameraHandler

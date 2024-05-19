-- Required scripts
local cameraShaker = require(script:WaitForChild("CameraShaker"))

local cameraHandler = {}
cameraHandler.__index = cameraHandler

-- Class constructor
function cameraHandler.new(player)
	
	local self = setmetatable({}, cameraHandler)

	-- || PLAYER VARIABLES

	-- The humanoid root part and relative attachments
	self.humanoidRootPart = player.humanoidRootPart
	self.rootOrientation = player.rootOrientationAttachment

	-- || CAMERA SETUP ||

	-- The camera
	self.camera = player.camera

	-- || MOUSE SETUP ||

	-- The mouse
	self.mouse = player.mouse
	self.lastMousePosition = Vector2.new(self.mouse.X, self.mouse.Y)

	-- The camera's mouse sensitivity
	self.mouseSensitivity = player.playerStats.mouseSensitivity

	-- Whether or not the mouse moves the camera
	self.mouseMovesCamera = player.playerStats.mouseMovesCamera
	
	-- || CAMERA SETTINGS ||

	-- Movement relative to camera
	self.movementRelativeToCamera = false

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
	self.cameraBlockFollow = player.playerStats.cameraBlockFollow

	-- || CAMERA SWAY ||

	-- The amount and speed of the camera sway on both axes
	self.cameraSwayAmount = Vector2.new(0.35, 0.35)
	self.cameraSwaySpeed = Vector2.new(10, 10)

	-- || CAMERA SHAKE ||

	-- The shake module
	self.shakeModule = cameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
		self.camera.CFrame = self.camera.CFrame * shakeCf
	end)
	
	self.shakeModule:Start()

	return self
end

-- || CAMERA CONTROL ||

-- Move the camera via the mouse
function cameraHandler:MoveCameraWithMouse()

	-- Make sure we can move the camera
	if not self.mouseMovesCamera then return end
	
	-- Retrieves the current mouse position.
	local currentMousePosition = Vector2.new(self.mouse.X, self.mouse.Y)
	
	-- Calculates the change in mouse position multiplied by the sensitivity.
	local cameraDelta = (currentMousePosition - self.lastMousePosition) * self.mouseSensitivity
	
	-- Updates the last mouse position for the next frame.
	self.lastMousePosition = currentMousePosition
	
	-- Creates a rotation vector based on the mouse movement.
	local cameraRotation = Vector3.new(-cameraDelta.Y, -cameraDelta.X, 0)
	
	-- Updates the camera's CFrame (position and rotation) by applying the rotation calculated from mouse movement.
	self.camera.CFrame = self.camera.CFrame * CFrame.Angles(math.rad(cameraRotation.X), math.rad(cameraRotation.Y), 0)
end

-- Make character look in camera direction
function cameraHandler:LookInCameraDirection()
	
	-- The CFrame
	local camFrame = Vector3.new(self.camera.CFrame.LookVector.X, 0, self.camera.CFrame.LookVector.Z).Unit
	local newCFrame = CFrame.new(self.humanoidRootPart.CFrame.Position, self.humanoidRootPart.CFrame.Position + camFrame) 

	-- Make the humanoid look in the direction via the orientation attachment
	self.rootOrientation.CFrame = newCFrame
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
	self.cameraBodyPosition.Position = self.cameraBlockFollow.CFrame:ToWorldSpace(CFrame.new(self.appliedCameraOffset)).Position

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

		-- Check if we want to turn in the camera's direction
		if self.movementRelativeToCamera then self:LookInCameraDirection() end
	end
end

return cameraHandler

local cameraHandler = {}
cameraHandler.__index = cameraHandler

-- Class constructor
function cameraHandler.new(player)
	
	local self = setmetatable({}, cameraHandler)

	-- || CAMERA SETUP ||
	self.camera = player.camera
	
	-- || CAMERA SETTINGS ||

	self.cameraFollowsTarget = player.playerStats.cameraFollowsTarget

	self.cameraStiffness = player.playerStats.cameraStiffness
	self.cameraOffset = player.playerStats.cameraOffset
	
	-- || CAMERA FOLLOW ||
	
	-- The camera block
	self.cameraBlock = player.cameraBlock
	
	-- The body position
	self.cameraBodyPosition = Instance.new("BodyPosition", self.cameraBlock)
	self.cameraBodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	
	-- What the camera is 'following'
	self.cameraFollow = player.playerStats.cameraFollow
	
	return self
end

-- || CAMERA SMOOTHING ||

-- The camera block function
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

function cameraHandler:SmoothCamera()
	
	-- Make sure the camera block exists
	if self.cameraBlock == nil then
		
		warn("Camera block not found!")
		return
	end

	-- Assign the position of the camera part
	self.cameraBodyPosition.Position = (self.cameraFollow.CFrame.Position + self.cameraOffset)

	-- Tween the camera part over time
	self.cameraBodyPosition.P = 1000 * self.cameraStiffness
end

-- || UPDATE ||

function cameraHandler:Update(deltaTime)
	
	-- Check if we want the camera to be delayed
	if self.cameraFollowsTarget then
		
		-- Smooth the camera movement
		self:SmoothCamera()
	end
end

return cameraHandler

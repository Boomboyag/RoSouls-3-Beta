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

	-- What the camera is looking at
	self.cameraTarget = player.playerStats.cameraTarget
	self.cameraTween = nil

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

-- Make character look in camera direction
function cameraHandler:LookInCameraDirection()
	
	-- The CFrame
	local camFrame = Vector3.new(self.camera.CFrame.LookVector.X, 0, self.camera.CFrame.LookVector.Z).Unit
	local newCFrame = CFrame.new(self.humanoidRootPart.CFrame.Position, self.humanoidRootPart.CFrame.Position + camFrame) 
	
	if self.cameraTarget then
		
		newCFrame = CFrame.lookAt(self.humanoidRootPart.CFrame.Position * Vector3.new(1, 0, 1), self.cameraTarget.CFrame.Position * Vector3.new(1, 0, 1))
	end

	-- Make the humanoid look in the direction via the orientation attachment
	self.rootOrientation.CFrame = newCFrame
end

-- Apply the given camera offset
function cameraHandler:ApplyOffset(deltaTime)
    
    -- Initialize or update the blending factor
    if not self.blendingFactor then
        self.blendingFactor = 0
    end

    -- Target blending factor when a cameraTarget is assigned
    local targetBlendingFactor = self.cameraTarget and 1 or 0

    -- Smoothly increase or decrease the blending factor over time
    local blendSpeed = 5
    self.blendingFactor = self.blendingFactor + (targetBlendingFactor - self.blendingFactor) * blendSpeed * deltaTime
	--self.blendingFactor = (self.cameraTarget and distance < 7) and 1 or 0

    -- Apply an easing function for smoother transitions
    local function easeInOutQuad(t)
        return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
    end

    local smoothedBlendingFactor = easeInOutQuad(self.blendingFactor)

    -- Calculate the blended offset
    local offset = self.cameraOffset * Vector3.new(1, 0, 1)
    local yOffsetOnly = Vector3.new(0, offset.Y, 0)
    local blendedOffset = offset:Lerp(yOffsetOnly, smoothedBlendingFactor)

    -- Apply the blended offset
    local newFrame = self:UpdateCollision(self.camera.CFrame * CFrame.new(blendedOffset))
    self.camera.CFrame = newFrame
end

-- || CAMERA COLLISION ||

-- Find the best camera position while factoring in collisions
function cameraHandler:UpdateCollision(targetFrame, ignoreList)

    local originalTargetFrame = targetFrame
    ignoreList = ignoreList or {}

    -- Create the Raycast parameters
    local raycastParams = RaycastParams.new()
    table.insert(ignoreList, self.humanoidRootPart.Parent)
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true

    -- Define the starting position and the direction of the ray
    local startPosition = self.cameraBlock and self.cameraBlock.CFrame.Position or self.humanoidRootPart.CFrame.Position
    local direction = (targetFrame.Position - startPosition)

    -- Perform the Raycast
    local raycastResult = workspace:Raycast(startPosition, direction, raycastParams)
    
    -- Check if there is anything in the way
    if raycastResult then

		-- Get the instance and the position of the result
        local hitInstance = raycastResult.Instance
        local hitPosition = raycastResult.Position
		local hitNormal = raycastResult.Normal
        
        -- Adjust the targetFrame based on the collision
        local offset = (startPosition - self.camera.CFrame.Position).Unit
        targetFrame = (self.camera.CFrame - (self.camera.CFrame.Position - hitPosition)) + offset

        -- Make sure the object is not a humanoid
        if hitInstance.Parent:FindFirstChild("Humanoid") and hitInstance.Parent ~= game.Workspace then
            table.insert(ignoreList, hitInstance.Parent)
            targetFrame = self:UpdateCollision(originalTargetFrame, ignoreList)
        end
	end
    
    return targetFrame
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
	self.cameraBodyPosition.Position = self.cameraBlockFollow.CFrame:ToWorldSpace(CFrame.new(self.cameraOffset * Vector3.new(0, 1, 0))).Position

	-- Tween the camera part over time
	self.cameraBodyPosition.P = 1000 * self.cameraStiffness
end

-- || CAMERA LOOK AT ||

function cameraHandler:LookAt(deltaTime)
	
	-- Make sure the target exists
	if not self.cameraTarget then
		return
	end

	-- Base variables
	local rootPart : Part = self.humanoidRootPart
	local rootPos = rootPart.CFrame.Position

	local camera : Camera = self.camera
	local cameraPos = camera.CFrame.Position

	local target : Part = self.cameraTarget
	local targetPos = target.CFrame.Position

	-- Calculate the distance between the camera and target
	local baseDistance = (rootPos - targetPos)
	local distance = baseDistance.Magnitude

	-- Let the player know to stop locking on if too far from target
	if distance >= 60 then
		return true
	end

	-- Calculate the Y distance
	local yDist = -baseDistance.Y
	yDist = (-0.05 * math.pow(0.75, -21 + (yDist / 2.8))) + 15.5
	yDist = math.max(yDist, -1)

	-- Calculate the target CFrame
	local basePos = cameraPos + Vector3.new(0, yDist, 0)
	local targetCFrame : CFrame = CFrame.lookAt(basePos, targetPos)

	-- Interpolate between the current and target CFrame
	local lerpFactor = 8.0 * deltaTime -- Further reduced lerp factor for smoother movement
	local currentCFrame = camera.CFrame
	local newCFrame = currentCFrame:Lerp(targetCFrame, lerpFactor)

	-- Extract orientation and clamp X axis rotation
	local RX, RY, RZ = newCFrame:ToOrientation()
	local clampedRX = math.clamp(RX, math.rad(-80), math.rad(80))

	-- Reconstruct the new CFrame with the clamped X axis rotation
	newCFrame = CFrame.new(newCFrame.Position) * CFrame.fromOrientation(clampedRX, RY, RZ)

	-- Set the new camera CFrame
	self.camera.CFrame = newCFrame
	return false
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
    self.camera.CFrame *= CFrame.new(Vector3.new(0, 0, 0):Lerp(sway, 0.1))
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

	-- Apply the offset
	self:ApplyOffset(deltaTime)

	-- Update the look at (now done in heartbeat)
	--self:LookAt(deltaTime)
	
	-- Check if we want the camera to be delayed
	if self.cameraFollowsTarget then
		
		-- Smooth the camera movement
		self:SmoothCamera()

		-- Check if we want to turn in the camera's direction
		if self.movementRelativeToCamera then self:LookInCameraDirection() end
	end
end

return cameraHandler

-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = replicatedStorage["Core Classes"].Object.Character

-- Required scripts
local characterStates = require(coreFolder.Enum.CharacterStates)

local module = {}

module.Name = "Lock On Module"

-- The function to find a target
function module.FindTarget(self, targetTag, minAngle, maxAngle, minDist, maxDist, excluded, angleMoreImportant, targetAngle, respectLineOfSight) : Part
    
    -- Set the default values
    local rootPos = self.humanoidRootPart.CFrame
	local currentDistance = maxDist
	local currentAngle = math.huge
	local currentTarget = nil

	-- The list of targets
	local targetList = collectionService:GetTagged(targetTag)

	angleMoreImportant = angleMoreImportant or false

	-- Loop through the desired folder
	for _, enemy in targetList do
		
		-- Check for a primary part
		if not enemy:IsA("Model") or not enemy.PrimaryPart then continue end

		-- Make sure it isn't excluded
		if enemy.PrimaryPart == excluded then continue end

		-- Make sure the target is still alive
		if enemy:FindFirstChild("Humanoid") then
				
			if enemy:FindFirstChild("Humanoid").Health <= 0 then
				
				continue
			end
		end

		-- Get the angle between the target and the player
		local targetPosition = rootPos:ToObjectSpace(enemy.PrimaryPart.CFrame)
		local angle = module.findDirection(Vector3.zero, targetPosition)	

		-- Check if the angle is within bounds
		if not (angle > minAngle and angle < maxAngle) then continue end

		-- Find the distance between the charater and enemy
		local distance = (self.humanoidRootPart.CFrame.Position - enemy.PrimaryPart.CFrame.Position).Magnitude

		-- Check if we the target is visible (if allowed)
		if respectLineOfSight and self:CheckSight(enemy, targetList) then continue end

		-- Check if we want to find the angle more than the distance
		if angleMoreImportant and targetAngle ~= nil then
			
			-- Find the distance between the new angle and the target angle
			local newAngle = math.abs(angle - targetAngle)
			
			-- If this angle is closer, assign it
			if newAngle < currentAngle and distance < maxDist then
				currentAngle = newAngle
				currentTarget = enemy.PrimaryPart
			end
		else
			
			-- If the enem is closer, assign it
			if distance < currentDistance and distance > minDist then
				currentDistance = distance
				currentTarget = enemy.PrimaryPart
			end
		end
	end

	return currentTarget
end


-- The function to find a new target while locked on
function module.SwitchTarget(direction : Vector2, distanceFromCurrent : number) : Part
	
end

-- The function to check if the player can lock on
function module.CheckPrerequisites(self)
	
	local passed = true

	-- Make sure we are in the default state
	if self.characterState ~= characterStates.Default then passed = false end

	return passed
end

-- Find the direction between two parts
function module.findDirection(b, a) : number

	local angles = Vector2.new(b.z - a.z, b.x - a.x)
	local angle =  math.deg(math.atan2(angles.X, angles.Y))

	return angle
end

-- The function to be called
function module:CallFunction(player, tag : string, targetDirection : Vector2)

	-- Check the prerequisites
	if not module.CheckPrerequisites(self) then return end
    
	-- Check if we are locked on
	local lockedOn = self.playerStats.cameraTarget ~= nil

	-- Assign the default tag if one is not included
	if not tag then
		
		warn("Lock-on tag not provided, using default tag instead")
		tag = "Enemy"
	end

	-- Lock on
	if not lockedOn then
		
		-- Find the nearest target 
		local target = module.FindTarget(self, tag, -180, 360, 0, 50, nil, true, 90, false)

		-- Make sure the target was found
		if not target then return end

		-- Assign the camera target
		self.playerStats.cameraTarget = target
		
		return
	end

	-- Change the lock on
	if targetDirection and targetDirection ~= Vector2.zero then

		-- A local variable for the current target
		local currentTarget = self.playerStats.cameraTarget
		
		-- Get the distance from the current target
		local distance = (self.humanoidRootPart.CFrame.Position - currentTarget.CFrame.Position).Magnitude
	else

		-- Reset the camera target & stop locking on
		self.playerStats.cameraTarget = nil

		return
	end
end

return module
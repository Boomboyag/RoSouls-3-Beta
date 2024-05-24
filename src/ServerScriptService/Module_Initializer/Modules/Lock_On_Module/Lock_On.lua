-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = replicatedStorage["Core Classes"].Object.Character

-- Required scripts
local characterStates = require(coreFolder.Enum.CharacterStates)

-- Stats
local boolean canChange = true

local module = {}

module.Name = "Lock On Module"

-- The function to find a target
function module.FindTarget(self, targetTag, minAngle, maxAngle, minDist, maxDist, excluded, targetAngle, respectLineOfSight, weights) : Part
    
    -- Set the default values
    local cameraFrame = self.camera.CFrame
    local currentTarget = nil
    local bestScore = math.huge

    -- The list of targets
    local targetList = collectionService:GetTagged(targetTag)

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
        local targetPosition = cameraFrame:ToObjectSpace(enemy.PrimaryPart.CFrame)
        local angle = module.findDirection(Vector3.zero, targetPosition)    

        -- Check if the angle is within bounds
        if not (angle > minAngle and angle < maxAngle) then continue end

        -- Find the distance between the character and enemy
        local distance = (self.humanoidRootPart.CFrame.Position - enemy.PrimaryPart.CFrame.Position).Magnitude

        -- Make sure the enemy is within range
        if distance > maxDist or distance < minDist then continue end

        -- Check if the target is visible (if allowed)
        if respectLineOfSight and self:CheckSight(enemy, targetList) then continue end

        -- Find the distance between the new angle and the target angle
        local newAngle = math.abs(angle - targetAngle)

        -- Calculate the combined weight score for both distance and angle
        local weightAngle = weights and weights.X or 1.8 
        local weightDistance = weights and weights.Y or 1.5
        local score = (newAngle * weightAngle) + (distance * weightDistance)
        --print(enemy, score)

        -- Check if this target has the best score
        if score < bestScore then
            bestScore = score
            currentTarget = enemy.PrimaryPart
        end
    end

    return currentTarget
end

-- The function to find a new target while locked on
function module.SwitchTarget(self, direction : Vector3, distanceFromCurrent : number, tag : string) : Part
	
	-- Find the desired angle
	local angle = Vector2.new(90, 90)
	local weights = Vector2.new(1.8, 1.5)

	if direction.X ~= 0 then
		
		-- Get the direction
		if direction.X > 0.5 then
			
			angle = Vector2.new(90, 180)

		elseif direction.X < -0.5 then
			angle = Vector2.new(0, 90)
		end
	end

	-- Find the desired distance
	local distance = Vector2.new(0, 50)

	if direction.Y ~= 0 then
		
		-- Get the direction
		if direction.Y > 0.5 then
			
			distance = Vector2.new(distanceFromCurrent, 50)
			angle = Vector2.new(-90, 270)
			weights = Vector2.new(1, 0)

		elseif direction.Y < -0.5 then
			
			distance = Vector2.new(0, distanceFromCurrent)
			angle = Vector2.new(-90, 270)
		end
	end

	-- Find the nearest target 
	local excluded = self.playerStats.cameraTarget
	local target = module.FindTarget(self, tag, angle.X, angle.Y, distance.X, distance.Y, excluded, 90, true, weights)
	return target
end

-- The function to check if the player can lock on
function module.CheckPrerequisites(self) : boolean
	
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
function module:CallFunction(player, tag : string, targetDirection : Vector3)

	-- Check the prerequisites
	if not module.CheckPrerequisites(self) then return end
    
	-- Check if we are locked on
	local lockedOn = self.playerStats.cameraTarget ~= nil

	-- Assign the default tag if one is not included
	if not tag then
		
		--warn("Lock-on tag not provided, using default tag instead")
		tag = "Enemy"
	end

	-- Lock on
	if not lockedOn and not targetDirection then
		
		-- Find the nearest target 
		local target = module.FindTarget(self, tag, -180, 360, 0, 50, nil, 90, true)

		-- Make sure the target was found
		if not target then return end

		-- Assign the camera target
		self.playerStats.cameraTarget = target
		
		return
	end

	-- Change the lock on
	if targetDirection and targetDirection ~= Vector3.zero and canChange and lockedOn then

		-- A local variable for the current target
		local currentTarget = self.playerStats.cameraTarget
		
		-- Get the distance from the current target
		local distance = (self.humanoidRootPart.CFrame.Position - currentTarget.CFrame.Position).Magnitude

		-- Find the target
		local newTarget = module.SwitchTarget(self, targetDirection, distance, tag)

		-- Make sure the target exists
		if not newTarget then return end

		-- Assign the camera target
		self.playerStats.cameraTarget = newTarget

		canChange = false
		task.wait(0.6)
		canChange = true
	elseif not targetDirection or targetDirection == Vector3.zero then

		-- Reset the camera target & stop locking on
		self.playerStats.cameraTarget = nil

		return
	end
end

return module
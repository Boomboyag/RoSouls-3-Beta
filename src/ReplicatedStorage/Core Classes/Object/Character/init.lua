-- Required services
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local vfxFolder = replicatedStorage:WaitForChild("VFX")

-- Required scripts
local object = require(script.Parent)
local Enum = require(coreFolder:WaitForChild("Enum"))
local characterStatsSheet = require(script:WaitForChild("Stats"))
local animationModule = require(script:WaitForChild("Animations"))
local rootMotionModule = require(script:WaitForChild("Animations"):WaitForChild("RootMotion"))
local effectModule = require(script:WaitForChild("Character_Effects"))
local actionModule = require(script:WaitForChild("Character_Actions"))
local actionPrefabs = require(script:WaitForChild("Character_Actions"):WaitForChild("Action_Prefabs"))

-- Humanoid state changed table
local humanoidStateChangedFunctions = require(script:WaitForChild("Humanoid_State_Changed_Functions"))

-- Stats changed table
local statsChangedFunctions = require(script:WaitForChild("Variable_Changed_Functions"))
local afterStatChangedFunctions = require(script:WaitForChild("After_Variable_Change_Functions"))

-- Class creation
local character = {}
character.__index = function(_, key)
	return character[key]
end
character.__tostring = function(character)

	-- Return the name of the object
	return tostring(character.name or "Character")
end
setmetatable(character, object)

-- Class constructor
function character.new(newCharacter)

	-- Inherit the object class
	newCharacter.objectType = Enum.ObjectType.Humanoid
	local newChar = object.new(newCharacter)
	setmetatable(newChar, character)

	-- Create the proxy table to track changes made to variables
	local self = setmetatable({}, {

		__index = newChar,

		__newindex = function(_, key, value)

			local old_value = newChar[key]

			-- Check if there are any functions to call when changing the variable
			if statsChangedFunctions[tostring(key)] then

				-- Call said function
				value = statsChangedFunctions[tostring(key)](newChar, newChar[key], value) or value
			end

			newChar[key] = value

			-- Check if there are any functions to call after changing the variable
			if afterStatChangedFunctions[tostring(key)] then

				-- Call said function
				afterStatChangedFunctions[tostring(key)](newChar, old_value, value)
			end
		end,

		--__tostring = function(_) return newCharacter.name end,

		__pairs = function(_) return pairs(newChar) end,

		__len = function(_) return #newChar end,
	})

	-- || REQUIRED FUNCTIONS ||
	
	-- Function to clone a table
	local function CloneTable(original)

		local copy = {}

		for k, v in pairs(original) do

			if type(v) == "table" then

				v = CloneTable(v)

			end

			copy[k] = v

		end

		return copy
	end

	-- Function to track the changes made to a table
	local function TrackStats(tableToTrack, characterTable)

		-- Create the proxy table
		local proxy = {}

		-- Create the metatable for the proxy
		local metatable = {
			
			-- Table has been printed
			__tostring = function(character)
				
				local returnString = "\n"
				
				for i, v in pairs(tableToTrack) do
					
					returnString = returnString .. i
					returnString = returnString .. ", "
					returnString = returnString .. tostring(v)
					returnString = returnString .. "\n"
				end
				
				return returnString
			end,

			-- Element has been accessed
			__index = function(_, key)

				return tableToTrack[key]
			end,

			-- Element has been changed
			__newindex = function(character, key, value)
				

				local old_value = tableToTrack[key]

				-- Check if there are any functions to call when changing the variable
				if statsChangedFunctions[tostring(key)] then

					-- Call said function
					value = statsChangedFunctions[tostring(key)](characterTable, character[key], value) or value
				end
				
				-- Check if the player is currently in an action
				if character.currentAction and character.currentAction.prerequisites[tostring(key)] then

					-- Check if the action is still compatible
					self:CheckCurrentAction()
				end

				tableToTrack[key] = value

				-- Check if there are any functions to call after changing the variable
				if afterStatChangedFunctions[tostring(key)] then

					-- Call said function
					afterStatChangedFunctions[tostring(key)](characterTable, old_value, value)
				end
			end,

			-- Elements are being iterated over
			__pairs = function()
				return function(_, k)

					-- Get the next key and value
					local nextKey, nextValue = next(tableToTrack, k)

					-- Return the next key and value
					return nextKey, nextValue
				end
			end,

			-- Length of the table
			__len = function() return #tableToTrack end
		}

		-- Set the metatable and return
		setmetatable(proxy, metatable)
		return proxy
	end

	-- || CHARACTER MODEL ||

	-- The type of character this is
	self.characterType = Enum.CharacterType.Default
	
	-- Where the character is located on the client / server boundary
	self.onClient = game:GetService("RunService"):IsClient()
	self.onServer = game:GetService("RunService"):IsServer()

	-- Get the character
	self.humanoid = self.model:WaitForChild("Humanoid")
	self.humanoidRootPart = self.model:WaitForChild("HumanoidRootPart")
	self.head = self.model:WaitForChild("Head")
	self.torso = self.model:WaitForChild("Torso")
	self.model:WaitForChild("Animate"):Destroy()
	self.model:WaitForChild("Health"):Destroy()
	
	-- Character joints
	self.rootJoint = self.humanoidRootPart:WaitForChild('RootJoint')
	self.rootC0 = self.rootJoint.C0
	
	-- Character attachments
	self.rootAttachment = self.humanoidRootPart:WaitForChild("RootAttachment")
	
	-- Character roll and backstep attachments
	self.rollAttatchment = Instance.new("Attachment", self.humanoidRootPart)
	self.rollAttatchment.WorldPosition = self.humanoidRootPart.AssemblyCenterOfMass - Vector3.new(0, 2, 0)
	self.rollAttatchment.Name = 'VelocityPart'
	self.rollAttatchment.Orientation = Vector3.new(0, 90, 0)

	-- Character orientation attachments
	self.rootOrientationAttachment = Instance.new("AlignOrientation", self.humanoidRootPart)
	self.rootOrientationAttachment.Name = "Root Orientation"
	self.rootOrientationAttachment.Mode = Enum.OrientationAlignmentMode.OneAttachment
	self.rootOrientationAttachment.Attachment0 = self.rootAttachment
	self.rootOrientationAttachment.Responsiveness = 60

	-- || STATS ||

	-- Get the character's state
	self.characterState = Enum.CharacterState.Default
	self.controlType = Enum.ControlType.Full

	-- Create the character stats
	self.characterStats = TrackStats(characterStatsSheet.new(newCharacter), self)
	self.defaultCharacterStats = characterStatsSheet.new(newCharacter)
	
	-- The character's fall time
	self.fallTime = 0
	self.fallDistance = 0
	self.fallAnimationSpeed = 1

	-- Ground variables
	self.groundCheckInterval = 0.1
	self.groundCounter = 0
	
	-- || ACTIONS ||
	
	self.actionPrefabs = {
		
		-- Default
		["Blank"] = actionModule.new(actionPrefabs.Blank),

		-- Falling
		["Landed"] = actionModule.new(actionPrefabs.Land),

		-- Stun
		["Light Stun"] = actionModule.new(actionPrefabs.Light_Damage_Impact),
		["Heavy Stun"] = actionModule.new(actionPrefabs.Heavy_Damage_Impact),
	}

	-- || ANIMATIONS ||
	
	-- Root motion
	self.lastTransform = self.rootJoint.Transform
	self.XZPlane = Vector3.new(1, 1, 0)

	-- The character's animations
	self.characterModelTilt = 0
	self.animator = self.humanoid:FindFirstChildOfClass("Animator")
	self.animations = animationModule.new(self.humanoid, newCharacter.animationList)
	self.coreAnimations = {

		["Idle"] = self.animations.idleAnimation,
		["Walking"] = self.animations.walkAnimation,
		["Falling"] = self.animations.fallAnimation,
		["Jumping"] = self.animations.jumpAnimation,
		["Climbing"] = self.animations.climbAnimation,
		["Death"] = self.animations.deathAnimation,

		["Strafing"] = {
			
			["Left"] = self.animations.strafeLeft,
			["Right"] = self.animations.strafeRight
		},
	}

	-- Tracked animations
	self.trackedAnimations = {}

	-- Stop all current animations 
	if self.animator then
		local animTracks = self.animator:GetPlayingAnimationTracks()
		for i,track in ipairs(animTracks) do
			track:Stop(0)
			track:Destroy()
		end
	end

	-- Character tilt
	self.tilt = CFrame.new()

	-- || HEALTH ||

	-- Set the character's health
	self.alive = true
	self.humanoid.MaxHealth = self.characterStats.maxHealth
	self.humanoid.Health = self.characterStats.maxHealth
	
	-- || EFFECTS ||
	
	-- Which tables the effects can change
	self.validEffectTables = {
		self.characterStats
	}
	
	self.defaultValues = {
		self.defaultCharacterStats
	}

	-- The table of all current effects
	self.effects = {}
	self.effectTick = newCharacter.effectTick or 0.1
	self.previousEffectTick = 0
	
	-- Effect prefabs specific to the character
	self.effectPrefabs = require(script:WaitForChild("Character_Effects"):WaitForChild("Effect_Prefabs"))

	-- || MOVEMENT ||

	-- Set the character's walkspeed
	self.isMoving = false
	self.humanoid.WalkSpeed = self.characterStats.currentWalkSpeed
	self.lockedMovementDirection = Vector3.zero
	self.movementDirection = Vector3.zero

	-- || HUMANOID SETTINGS ||
	
	-- Disable some humanoid states
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)

	-- Turn off the breaking of joints on death
	self.humanoid.BreakJointsOnDeath = false

	-- || PATHFINDING ||

	-- Set the character's pathfinding
	self.path = pathfindingService:CreatePath({

		-- The pathfinding settings
		AgentRadius = newCharacter.radius or 3,
		AgentHeight = newCharacter.height or 6,
		AgentCanJump = newCharacter.canAutoJump or false,

		-- Pathfinding costs
		Costs = newCharacter.pathfindingCosts or {

			Water = 20

		}
	})

	-- || EVENTS & FUNCTIONS ||
	
	-- Retrieve stats
	self.GetStat = Instance.new("BindableFunction")
	self.GetStat.OnInvoke = function(statName : string)
		
		local stat = nil
		
		-- Find the stat
		if self[statName] then stat = self[statName] 
		else

			-- Loop through all effect tables
			for i, v in self.validEffectTables do
				
				-- Check if the given table has the value
				if v[statName] then 
					stat = v[statName] 
					break
				end
			end
		end
		
		-- Return the stat
		return stat
	end

	-- Character events
	self.FinishedPathfinding = Instance.new("BindableEvent")
	self.StaminaDrained = Instance.new("BindableEvent")
	self.CharacterDied = Instance.new("BindableEvent")
	
	-- States and stats
	self.CharacterStateChanged = Instance.new("BindableEvent")
	self.CharacterHumanoidStateChanged = Instance.new("BindableEvent")
	self.CharacterStatChanged = Instance.new("BindableEvent")

	-- Health & Stamina
	self.HealthChanged = Instance.new("BindableEvent")
	self.StaminaChanged = Instance.new("BindableEvent")
	
	-- Effects and actions
	self.EffectAdded = Instance.new("BindableEvent")
	self.EffectRemoved = Instance.new("BindableEvent")
	self.NewAction = Instance.new("BindableEvent")
	
	-- Animation events
	self.ActionAnimationStopped = Instance.new("BindableEvent")

	-- || CONNECTIONS ||

	-- Humanoid connections
	self.DiedConnection = self.humanoid.Died:connect(function()
		self:HumanoidStateChanged()
	end)
	self.RunningConnection = self.humanoid.Running:connect(function()
		self:HumanoidStateChanged()
	end)
	self.JumpingConnection = self.humanoid.Jumping:connect(function()
		self:HumanoidStateChanged()
	end)
	self.ClimbingConnection = self.humanoid.Climbing:connect(function()
		self:HumanoidStateChanged()
	end)
	self.GettingUpConnection = self.humanoid.GettingUp:connect(function()
		self:HumanoidStateChanged()
	end)
	self.FreeFallingConnection = self.humanoid.FreeFalling:connect(function()
		self:HumanoidStateChanged()
	end)
	self.FallingDownConnection = self.humanoid.FallingDown:connect(function()
		self:HumanoidStateChanged()
	end)
	self.SeatedConnection = self.humanoid.Seated:connect(function()
		self:HumanoidStateChanged()
	end)
	self.PlatformStandingConnection = self.humanoid.PlatformStanding:connect(function()
		self:HumanoidStateChanged()
	end)
	self.SwimmingConnection = self.humanoid.Swimming:connect(function()
		self:HumanoidStateChanged()
	end)
	self.HumanoidStateChangedConnection = self.humanoid.StateChanged:Connect(function(oldState, newState)

		self:HumanoidStateChanged(oldState, newState)
	end)
	self.humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
		
		-- Apply any other effects
		self.movementDirection = self.humanoid.MoveDirection
		
		-- Make sure the character is currently moving
		if self.humanoid:GetState() ~= Enum.HumanoidStateType.Running then return end

		-- Check if the character is moving
		if self.humanoid.MoveDirection.Magnitude > 0 then

			if not self.isMoving then self.isMoving = true end
		else

			if self.isMoving then self.isMoving = false end
		end
	end)

	-- Humanoid health connection
	self.humanoid.HealthChanged:Connect(function(newHealth)
		self.characterStats.currentHealth = newHealth
	end)

	-- || UPDATES ||
	
	-- Update every frame
	self.renderSteppedConnection = runService.RenderStepped:Connect(function(deltaTime)
		
		-- Apply root motion if possible
		if self.characterStats.rootMotionEnabled then
			self:ApplyRootMotion(deltaTime)
		end
	end)
	
	-- Update every heartbeat
	self.heartbeatConnection = runService.Heartbeat:Connect(function(deltaTime)
		
		local currentTick = tick()

		-- Applies current effects
		coroutine.wrap(function()
		
			-- Make sure the character is alive and enough time has passed to apply the effects
			if self.alive and (currentTick - self.previousEffectTick >= self.effectTick) then
			
				-- Update the effect tick
				self.previousEffectTick = currentTick
			
				-- Apply all effects
				self:ApplyEffects(nil, false)
			end
		end)()

		-- Applies effects based on ground material
		coroutine.wrap(function()

			-- Check if enough time has elapsed
			if (currentTick - self.groundCounter) >= self.groundCheckInterval then

				-- Reset the counter
	    		self.groundCounter = currentTick
	    		
				-- Get the ground material
				local grounded, material = self:CheckGround()

				-- Change the variable if the material is different
				local materialName = not grounded and "None" or material.Name
				if materialName ~= self.characterStats.currentGroundMaterial then self.characterStats.currentGroundMaterial = materialName end
    		end
		end)()
	end)
	
	-- The final update
	runService:BindToRenderStep("Final Update", Enum.RenderPriority.Last.Value, function(deltaTime)

		-- Tilt the charatcer
		self:TiltBody(deltaTime)
	end)
	
	-- || STARTUP ||
	
	-- Check if there needs to be any default effects applied
	for key, value in pairs(newChar) do
		
		-- Check if there are any functions to call when changing the variable
		if statsChangedFunctions[tostring(key)] then

			-- Call said function
			statsChangedFunctions[tostring(key)](newChar, nil, value, true)
		end

		-- Check if there are any functions to call after changing the variable
		if afterStatChangedFunctions[tostring(key)] then

			-- Call said function
			afterStatChangedFunctions[tostring(key)](newChar, nil, value)
		end
	end
	for key, value in pairs(newChar.defaultCharacterStats) do

		-- Check if there are any functions to call when changing the variable
		if statsChangedFunctions[tostring(key)] then

			-- Call said function
			statsChangedFunctions[tostring(key)](newChar, nil, value, true)
		end

		-- Check if there are any functions to call after changing the variable
		if afterStatChangedFunctions[tostring(key)] then

			-- Call said function
			afterStatChangedFunctions[tostring(key)](newChar, nil, value)
		end
	end
	
	-- || STARTING EFFECTS ||

	self:AddEffect(self.effectPrefabs.Disable_Jumping)
	
	-- Return the table
	return newChar
end

-- || MOVEMENT ||

-- Change the character's control type
function character:ChangeControlType(newType, direction : Vector3)

	-- Change the type
	self.controlType = newType;

	-- Set the new movement direction if locked
	if (newType == Enum.ControlType.None) then
		self.lockedMovementDirection = direction;
	end
end

-- Get the character's movement direction
function character:GetWorldMoveDirection()

	-- Check if we are locked on able to move
	if (self.controlType == Enum.ControlType.Full) then

		return self.humanoid.MoveDirection;

	elseif (self.controlType == Enum.ControlType.None) then

		return self.lockedMovementDirection;
	end
end

-- Make the character walk to something
function character:WalkTo(position : Vector3)

	local waypoints
	local nextWaypointIndex
	local reachedConnection
	local blockedConnection

	-- Compute the path
	local success, errorMessage = pcall(function()

		self.path:ComputeAsync(self.humanoidRootPart.Position, position)
	end)

	if success and self.path.Status == Enum.PathStatus.Success then

		-- Get the path waypoints
		waypoints = self.path:GetWaypoints()

		-- Detect if path becomes blocked
		blockedConnection = self.path.Blocked:Connect(function(blockedWaypointIndex)

			-- Check if the obstacle is further down the path
			if blockedWaypointIndex >= nextWaypointIndex then

				-- Stop detecting path blockage until path is re-computed
				blockedConnection:Disconnect()

				-- Call function to re-compute new path
				self:WalkTo(position)
			end
		end)

		-- Detect when movement to next waypoint is complete
		if not reachedConnection then

			reachedConnection = self.humanoid.MoveToFinished:Connect(function(reached)

				if reached and nextWaypointIndex < #waypoints then

					-- Increase waypoint index and move to next waypoint
					nextWaypointIndex += 1

					self.humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
				else

					self.FinishedPathfinding:Fire()
					reachedConnection:Disconnect()
					blockedConnection:Disconnect()
				end
			end)
		end

		-- Initially move to second waypoint (first waypoint is path start; skip it)
		nextWaypointIndex = 2
		self.humanoid:MoveTo(waypoints[nextWaypointIndex].Position)
	else

		warn("Path not computed!", errorMessage)
	end
end

-- Make the character move in a given direction
function character:Move()

	-- Move the humanoid
	self.humanoid:Move(self:GetWorldMoveDirection(), false);
end

-- || EFFECTS ||

-- Add an effect to the character's effect table
function character:AddEffect(effect)

	-- Make sure we are allowed to add effects
	if not self.characterStats.canAddEffects then return end

	-- 'Clone' the effect
	local effectClone = effectModule.new(effect)
	
	-- Check if the effect can stack
	if effectClone.canStack then
		
		-- Check for duplicates and change their name if so
		while self.effects[effectClone.name] ~= nil do

			effectClone.name = effectClone.name .. "$"
		end
	end
	
	-- Add the clone to the list of effects
	self.effects[effectClone.name] = effectClone

	-- Apply all associated effects
	self:ApplyEffects(effectClone.dataToModify, true, effectClone.timeBetweenEffectTick > 0 and {effectClone.name} or nil)
	
	-- Fire the event
	self.EffectAdded:Fire(effectClone)
end

-- Remove an effect from the character's effect table
function character:RemoveEffect(effectName : string)

	-- Loop through all current effects
	for i, v in self.effects do

		-- Check if the names are the same
		if string.match(i, effectName) then

			-- Check if the effect's name is longer than the desired effect
			if string.len(i) > string.len(effectName) then

				-- See if the effect is just a clone of the desired effect
				local s, e = string.find(i, effectName)

				if string.sub(i, e + 1, e + 1) ~= "$" then

					continue
				end
			end

			-- The effect to remove and it's effected data
			local effectToRemove = self.effects[i]
			local resetData = effectToRemove.resetDataWhenDone
			local changedData = effectToRemove.dataToModify

			-- Destroy the effect
			self.effects[i] = nil

			-- Check if the effect should reset the data when finished
			if resetData then
				
				local defaultValue = nil

				for index, defaultTable in self.defaultValues do
					
					if defaultTable[changedData] ~= nil then
						defaultValue = defaultTable[changedData]
						break
					end
				end

				-- Loop through all tables effects can be applied to
				for index, validTable in self.validEffectTables do

					-- Check if the table contains the data
					if validTable[changedData] ~= nil then

						-- Reset the effect to it's original value
						validTable[changedData] = defaultValue
					end
				end

				-- Apply all associated effects
				self:ApplyEffects(changedData, true)
			end

			-- Fire the event
			self.EffectRemoved:Fire(effectToRemove)

			break
		end
	end
end

-- Find a specific effect
function character:FindEffect(effectName : string, returnBoolean : boolean)
	
	-- Loop through the current effects
	for i, v in pairs(self.effects) do
		
		-- Check if the names are the same
		if string.match(i, effectName) then

			-- Check if the effect's name is longer than the desired effect
			if string.len(i) > string.len(effectName) then

				-- See if the effect is just a clone of the desired effect
				local s, e = string.find(i, effectName)

				if string.sub(i, e + 1, e + 1) ~= "$" then

					continue
				end
			end
			

			-- Check if we want to return the effect or boolean
			return not returnBoolean and v or true
		end
	end
	
	-- Return nothing if not found
	return nil
end

-- Find the amount of a specific effect the character has
function character:FindEffectAmount(effectName : string)
	
	local count = 0

	-- Loop through the current effects
	for i, v in pairs(self.effects) do
		
		-- Check if the names are the same
		if string.match(i, effectName) then
			
			-- Check if the effect's name is longer than the desired effect
			if string.len(i) > string.len(effectName) then
				
				-- See if the effect is just a clone of the desired effect
				local s, e = string.find(i, effectName)
				
				if string.sub(i, e + 1, e + 1) ~= "$" then
					
					continue
				end
			end

			-- Update the count
			count += 1
		end
	end

	-- Return the count
	return count
end

-- Sort the effects by priority
function character:SortEffects(effectsToSort)

	local array = {}
	
	-- Add the effects to the array
	for key, value in pairs(effectsToSort) do
		array[#array+1] = {key = key, value = value}
	end
	
	-- Return the sorted array
	table.sort(array, function(a, b)
		return a.value < b.value
	end)

	local weakTable = {__mode = "kv"}
	return setmetatable(array, weakTable)
end

-- Apply all effects (or ones modifying a certain piece of data)
function character:ApplyEffects(modifiedData : string, forceApply : boolean, effectsToIgnore)

	local priorityList = {}
	
	-- Sort effects by priority
	priorityList = self:SortEffects(self.effects)

	-- Loop through the sorted effects
	for i, v in pairs(priorityList) do

		-- Check if we only want to apply specific effects
		if modifiedData and v.value.dataToModify ~= modifiedData then continue end
		
		-- Check if we want to ignore this effect
		if effectsToIgnore then 
			local skip = false
			for ii, vv in effectsToIgnore do
				if vv == v.key then
					skip = true
				end
			end

			if skip then continue end
		end

		-- Apply the effect
		coroutine.wrap(function()

			-- Check if the effect can be removed
			if v.value.canTerminate then

				self:RemoveEffect(v.key)
				return
			end

			-- Loop through all tables effects can be applied to
			for index, validTable in self.validEffectTables do
				
				-- Check if the table contains the data
				if validTable[v.value.dataToModify] ~= nil then
					
					-- Apply the effect
					validTable[v.value.dataToModify] = v.value:ApplyEffect(validTable[v.value.dataToModify], forceApply)
				end
			end

			-- Check if the effect can be removed
			if v.value.canTerminate then

				self:RemoveEffect(v.key)
				return
			end

		end)()
	end
end

-- || ANIMATIONS ||

-- Apply root motion to the character
function character:ApplyRootMotion(deltaTime)
	
	local transform = self.rootJoint.Transform

	-- Get the delta (difference) between the transform this frame and last frame.
	-- Delta is relative to LastTransform.
	local RelativeDelta = rootMotionModule:GetTransform(self.lastTransform):ToObjectSpace(rootMotionModule:GetTransform(transform))

	self.lastTransform = true

	-- Move the character by the delta (But make it move relative to current root part orientation).
	local moveMotion = self.humanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(RelativeDelta.Position.Z, 0, RelativeDelta.Position.Y))
	rootMotionModule:MoveHumanoid(self.humanoid, moveMotion, deltaTime)

	-- Rotate the character by the delta.
	local rx, ry, rz = RelativeDelta:ToOrientation()
	self.humanoidRootPart.CFrame *= CFrame.Angles(rx, rz, ry)

	-- Code below removes root transform from the animation.
	-- In a final implementation you need to preprocess the animation so you don't use the two lines below.

	-- Remove joint translation. (Keep Y axis translation.)
	self.rootJoint.Transform -= self.rootJoint.Transform.Position * self.XZPlane

	-- Remove Y axis rotation from animation.
	self.rootJoint.Transform = rootMotionModule:GetTransform(transform).Rotation:Inverse() * self.rootJoint.Transform
end

-- Change the current core animation being played
function character:ChangeCoreAnimation(newAnimation : AnimationTrack, oldValue : AnimationTrack, transitionTime : number)

	-- Switch animation
	if (newAnimation ~= oldValue) then

		if (oldValue) then
			oldValue:Stop(transitionTime or 0.1)
		end

		-- Assign the track and set priority
		newAnimation.Priority = Enum.AnimationPriority.Core

		-- Track the animation
		self:TrackAnimation(newAnimation)

		-- Play the animation
		newAnimation:Play(transitionTime or 0.1, 1, self.characterStats.coreAnimationSpeed)
	end
end

-- Change the speed of the current core animation
function character:CoreAnimationSpeedReflectMovementSpeed(characterSpeed, reset)
	
	-- Make sure the animation exists
	if not self.characterStats.currentCoreAnimation then return end
	
	-- Check if we want to reset the speed
	if reset then
		
		-- Change speed to default
		self.characterStats.currentCoreAnimation:AdjustSpeed(1)
		return
	end
	
	-- Create the speed
	local newSpeed = (self.characterStats.currentWalkSpeed / self.defaultCharacterStats.currentWalkSpeed) * characterSpeed

	-- Adjust the speed
	characterSpeed = newSpeed * self.characterStats.coreAnimationSpeed
	
	-- Make sure the speed is different from the current speed
	if characterSpeed ~= self.characterStats.currentCoreAnimation.Speed then
		
		-- Change the speed to reflect the change
		self.characterStats.currentCoreAnimation:AdjustSpeed(characterSpeed)
	end
end

-- Change the current action animation (if any) being played
function character:ChangeActionAnimation(newAnimation : AnimationTrack, transitionTime : number, animationPriority : Enum.AnimationPriority, loop : boolean)

	-- A short simplification
	local characterStats = self.characterStats

	-- Check if we can change the animation
	local canChange = false
	if newAnimation == characterStats.currentActionAnimation then
		
		if newAnimation == nil then return end
		canChange = not characterStats.currentActionAnimation.IsPlaying
	else
		canChange = true
	end

	-- Switch animation		
	if canChange then

		if (characterStats.currentActionAnimation ~= nil) then
			
			-- Stop the current animation
			characterStats.currentActionAnimation:Stop(transitionTime)
			characterStats.currentActionAnimation = nil
			
			-- Unbind the current stopped event
			self.ActionAnimationStoppedSignal:Disconnect()
		end

		-- Make sure there is a new animation
		if not newAnimation then return end

		-- Assign the track and set priority
		characterStats.currentActionAnimation = newAnimation
		characterStats.currentActionAnimation.Looped = loop or false
		characterStats.currentActionAnimation.Priority = animationPriority or Enum.AnimationPriority.Action

		-- Track the animation
		self:TrackAnimation(characterStats.currentActionAnimation)

		-- Play the animation
		characterStats.currentActionAnimation:Play(transitionTime)
		characterStats.currentActionAnimation:AdjustSpeed(self.characterStats.actionAnimationSpeed)
		
		-- Bind the stopped event
		self.ActionAnimationStoppedSignal = characterStats.currentActionAnimation.Stopped:Connect(function()
			self.ActionAnimationStopped:Fire()
		end)
	end
end

-- Change the speed of the current core animation
function character:ChangeActionAnimationSpeed(characterSpeed)
	
	-- Make sure the animation exists
	if not self.characterStats.currentActionAnimation then return end
	
	-- Make sure the speed is different from the current speed
	if characterSpeed ~= self.characterStats.currentActionAnimation.Speed then

		-- Change the speed to reflect the change
		self.characterStats.currentActionAnimation:AdjustSpeed(characterSpeed)
	end
end

-- Track a given animation
function character:TrackAnimation(anim : AnimationTrack)
	
	-- Make sure we were provided an animation
	if not anim or not anim:IsA("AnimationTrack") then
		print("Not a valid animation track: ", anim)
		return
	end

	-- Check if the animation is already being tracked
	if self.trackedAnimations[anim.Animation.AnimationId] then return end

	-- Put it in the tracking table
	self.trackedAnimations[anim.Animation.AnimationId] = anim

	-- Wait for the animation to call any functions
	anim:GetMarkerReachedSignal("Call_Function"):Connect(function(paramString)

		-- Wrap in a pcall
		local _, errorMessage = pcall(function()
			
			local func, parameters = self:GetFunctionFromAnimationEvent(paramString)

			-- Wrap in a pcall to avoid errors
			local success, errorMessage = pcall(function()

				-- Check if the provided function is valid and call it with the provided parameters
				if self[func] then self[func](self, table.unpack(parameters)) end
			end)

			-- Let the user know there was an error
			if not success and errorMessage then

				warn("\n")
				warn("Error calling function " .. func .. " in animation: " .. anim.Name .. " (" .. anim.Animation.AnimationId .. ")")
				warn(errorMessage)
			end	
		end)

		-- Let the user know there was an error
		if errorMessage then warn(errorMessage) end	
	end)
end

-- Get function name and parameters from animation event
function character:GetFunctionFromAnimationEvent(paramString : string) : (string, table)
	
	-- Make sure the provided parameter was valid
	if not paramString or string.len(paramString) <= 1 then return end

	-- Decrypt the provided parameter
	local splitString: table = string.split(string.gsub(paramString, " ", ""), ",")

	-- Get the desired function and parameters
	local func = tostring(splitString[1])
	table.remove(splitString, 1)

	-- Turn all strings into numbers
	for _, v in pairs(splitString) do
		if tonumber(v) then v = tonumber(v) end
	end

	return func, splitString
end

-- Change the tilt of the character
function character:TiltBody(deltaTime)

	-- Get the chracter's movement direction
	local moveDirection = self.humanoidRootPart.CFrame:VectorToObjectSpace(self:GetWorldMoveDirection())
	
	-- Create the CFrame and angle
	local tiltCFrame
	local tiltAngleX = math.rad(-moveDirection.X) * (self.characterStats.canTilt == true and self.characterStats.maxTiltAngle or 0)
	local tiltAngleY = math.rad(-moveDirection.Y) * (self.characterStats.canTilt == true and self.characterStats.maxTiltAngle or 0)
	
	-- Apply the tilt on the x and y axis
	tiltCFrame = CFrame.Angles(0, tiltAngleX, tiltAngleY)
	
	-- Lerp and apply the tilt
	self.tilt = self.tilt:Lerp(tiltCFrame, 0.2 ^ (1 / (deltaTime * 60)))
	self.rootJoint.C0 = self.rootC0 * self.tilt
end

-- || ACTIONS ||

-- Check if the current action's prerequisites are met
function character:CheckCurrentAction()
	
	-- Make sure an action exists
	if not self.characterStats.currentAction then return end

	-- Check if the prerequisites are met
	if not self.characterStats.currentAction:CheckPrerequisites(self.characterStats) then

		-- Make sure the action can be canceled
		if not self.characterStats.currentAction.canCancel then return end
		
		-- Remove the action if not
		self.characterStats.currentAction = nil
	end
end

-- Add a new action to the character
function character:AddModule(name, action)

	-- Get the action table
	action = require(action)

	-- Add the action stats
	if action.stats then

		-- Add the action stats to the effect table
		table.insert(self.validEffectTables, action.stats)
		table.insert(self.defaultValues, action.stats)
	end
	
	-- Call the init function
	if action.Init then
		action:Init()
	end

	-- Add the given action
	if action.CallFunction then self:AddFunction(name, action.CallFunction) end
	print("Injected the " .. action.Name)
	action = nil
end

-- || HEALTH ||

-- Make the humanoid take damage
function character:TakeDamage(damageAmount, ignoreForceField)
	
	-- Check if we want to ignore forcefields
	if not ignoreForceField then
		
		-- Use the :TakeDamage() function
		self.humanoid:TakeDamage(math.abs(damageAmount))
	else

		-- Subtract the damage amount from the health
		self.humanoid.Health -= math.abs(damageAmount)
	end
end

-- Reaction animation to damage
function character:DamageReaction(damageAmount)

	-- Make sure the character has taken enough damage to warrent a reaction
	if damageAmount < 5 then return end

	-- Play a light stun
	self.characterStats.currentAction = self.actionPrefabs["Light Stun"]
end

-- || SFX ||

-- Play a sound
function character:SpawnSound(id : string, volume : number, attachment : string, attachmentParent : Instance)

	-- Make sure the volume is a number
	if type(volume) == "string" then
		volume = tonumber(volume) or 1
	end
	
	-- Set default values if not provided
	volume = volume or 1
	attachment = attachment or "HumanoidRootPart"
	attachmentParent = attachmentParent or self.model
	
	-- Find the attachment
	attachment = attachment and attachmentParent:FindFirstChild(attachment, true) or attachmentParent

	-- Make sure the ID was provided
	if not id then return end

	-- Spawn the sound object
	local sound = Instance.new("Sound")
	sound.Volume = volume
	sound.Parent = attachment
	sound.SoundId = id

	-- Play the sound
	sound:Play()

	-- Destory the sound after it stops
	debris:AddItem(sound, sound.TimeLength == 0 and 1 or sound.TimeLength)
end

-- Spawn a VFX element
function character:SpawnVFX(name : string, attachment : string, attachmentParent : Instance, color : ColorSequence, ...)

	-- Get any additional arguments
	local args = {...}
	
	-- Find the attachment
	attachmentParent = attachmentParent or self.model
	attachment = attachment and attachmentParent:FindFirstChild(attachment, true) or attachmentParent:FindFirstChild("RootAttachment", true)

	-- Find the particle in the VFX folder
	local particle : ParticleEmitter = vfxFolder:FindFirstChild(name, true)
	if not particle then return end
	particle = particle:Clone()
	particle.Parent = attachment

	-- Set the default length if not provided
	local length = args[1] or 0
	local tickLength = args[2] or 0.1

	-- Change the color (if desired)
	particle.Color = color or particle.Color
	
	-- Emit the particle
	if length > 0 then

		local ticks = 0
		
		-- Fire the particle a certain amount of times
		while ticks <= length do
				
			-- Emit the particles
			particle:Emit()
			task.wait(tickLength)
			ticks += 1
		end
	else

		-- Emit once
		particle:Emit()
	end

	debris:AddItem(particle, particle.Lifetime.Max)
end

-- || MISCELLANEOUS ||

-- Fired when the humanoid state changes
function character:HumanoidStateChanged(oldState, newState)

	newState = newState or self.humanoid:GetState()
	
	self.CharacterHumanoidStateChanged:Fire(oldState, newState)

	-- Check if this state has a function attached to it
	if humanoidStateChangedFunctions[newState] then

		-- Call said function
		humanoidStateChangedFunctions[newState](self)
	end
end

-- See if anything needs to be done after a fall
function character:CheckFall(newTick)
	
	-- Get the time spent falling and the distance
	local timeFalling = newTick - self.fallTime
	self.fallDistance = self.fallDistance - self.humanoidRootPart.CFrame.Position.Y
	
	-- Make sure the time is valid
	if timeFalling > 1000 then return end
	
	-- Check if the player has spent the minimum time falling
	if timeFalling >= 0.3 and self.fallDistance > 0 then
		
		-- Play the animation
		self.fallAnimationSpeed = math.clamp(1 / timeFalling, 0.3, 1.25)
		self.characterStats.currentAction = self.actionPrefabs["Landed"]

		-- Calculate the damage
		local damage = (timeFalling / 2) * self.humanoid.maxHealth

		-- Take damage
		self:TakeDamage(damage)
	end
end

-- Check if the character is grounded
function character:CheckGround(origin : Vector3) : (boolean, Enum.Material, Instance)
	
	-- The raycast origin and direction
	local origin = origin or self.humanoidRootPart.CFrame.Position
	local direction = Vector3.new(0, -4, 0)

	-- The raycast parameters
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {self.model}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	-- The raycast
	local raycastResult = workspace:Raycast(origin, direction, raycastParams)

	-- Check if the raycast hit anything
	if raycastResult then
		
		-- Return trua and provide the material
		return true, raycastResult.Material, raycastResult.Instance
	else

		-- Return false
		return false
	end
end

-- See if the character can see an object
function character:CheckSight(newModel, excluded, angle, distance) : boolean

	-- Find the required angles
	local distanceToObject = (self.head.Position - newModel.PrimaryPart.Position)
	local lookAngle = self.head.CFrame.LookVector

	-- Get the dot product
	local angleToTarget = math.deg(distanceToObject.Unit:Dot(lookAngle))

	-- Check if it is within the view angle
	if angleToTarget < (self.viewAngle or angle or 180) and distanceToObject.Magnitude < (self.viewDistance or distance or 50) then 

		-- Create the raycast
		local rayOrigin = self.head.Position
		local rayDirection = newModel.PrimaryPart.Position - rayOrigin

		-- Create the raycast parameters
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = excluded and {self.model, excluded} or {self.model}
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.IgnoreWater = true

		-- Fire the raycast
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

		-- Check if we hit something
		if raycastResult then

			-- Make sure it is part of the model
			if raycastResult.Instance:IsDescendantOf(newModel) then

				return true
			end
		end
	end

	return false
end

-- Make the character speak
function character:Talk(text : string, color : Enum.ChatColor, talkPoint)

	-- Set the talk part
	local talkPart = talkPoint or self.head

	if talkPart then

		-- Speak
		chatService:Chat(talkPart, text, color or Enum.ChatColor.White)
	end
end

-- Destroy the character
function character:Destroy()
	
	-- Disconnect all connections
	self.renderSteppedConnection:Disconnect()
	self.heartbeatConnection:Disconnect()
	runService:UnbindFromRenderStep("Final Update")
	
	-- Call the parent class method
	object.Destroy(self)
end

return character
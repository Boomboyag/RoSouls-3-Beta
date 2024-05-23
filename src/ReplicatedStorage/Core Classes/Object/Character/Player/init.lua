-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")

-- Required folders and directories
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterPath = coreFolder:WaitForChild("Object"):WaitForChild("Character")

-- Required scripts
local character = require(characterPath)
local Enum = require(coreFolder:WaitForChild("Enum"))
local playerStatsSheet = require(script:WaitForChild("Player_Stats"))
local effectPrefabs = require(script:WaitForChild("Player_Effect_Prefabs"))
local characterEffectPrefabs = require(characterPath.Character_Effects.Effect_Prefabs)
local cameraHandler = require(script:WaitForChild("Camera_Handler"))

-- Required actions
local requiredActions = script:WaitForChild("Required_Action_Modules")

-- Humanoid state changed table
local humanoidStateChangedFunctions = require(script:WaitForChild("Player_Humanoid_State_Changed_Functions"))

-- Stats changed table
local statsChangedFunctions = require(script:WaitForChild("Player_Variable_Changed_Functions"))

-- Iris Debug
local iris = require(script:WaitForChild("Iris")).Init()

-- Class creation
local player = {}
player.__index = player
player.__tostring = function(player)

	-- Return the name of the object
	return player.name
end
setmetatable(player, character)

-- Class constructor
function player.new(newPlayerTable)

	-- Inherit the character class
	local newPlayer = character.new(newPlayerTable)
	setmetatable(newPlayer, player)

	-- Create the proxy table to track changes made to variables
	local self = setmetatable({}, {

		__index = newPlayer,

		__newindex = function(_, key, value)

			local old_value = newPlayer[key]

			-- Check if there are any functions to call when changing the variable
			if statsChangedFunctions[tostring(key)] then

				-- Call said function
				value = statsChangedFunctions[tostring(key)](newPlayer, newPlayer[key], value) or value
			end

			newPlayer[key] = value
		end,

		--__tostring = function(_) return newCharacter.name end,

		__pairs = function(_) return pairs(newPlayer) end,

		__len = function(_) return #newPlayer end,
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
	local function TrackStats(tableToTrack, playerTable)

		-- Create the proxy table
		local proxy = {}

		-- Create the metatable for the proxy
		local metatable = {

			-- Element has been accessed
			__index = function(_, key)

				return tableToTrack[key]
			end,

			-- Element has been changed
			__newindex = function(player, key, value)

				-- Check if there are any functions to call when changing the variable
				if statsChangedFunctions[tostring(key)] then

					-- Call said function
					value = statsChangedFunctions[tostring(key)](playerTable, player[key], value) or value

				end

				rawset(tableToTrack, key, value)
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
		proxy.tableToTrack = tableToTrack
		setmetatable(proxy, metatable)
		return proxy
	end

	-- || STATS ||

	-- The player
	self.player = game:GetService("Players").LocalPlayer

	-- The player stats
	self.playerStats = TrackStats(playerStatsSheet.new(newPlayer, self), self)
	self.defaultPlayerStats = playerStatsSheet.new(newPlayer, self)

	-- Add the player stats to the effect table
	table.insert(self.validEffectTables, self.playerStats)
	table.insert(self.defaultValues, self.defaultPlayerStats)

	-- || ACTIONS ||

	-- Get all the required action modules
	for i, v in ipairs(requiredActions:GetChildren()) do
		
		-- Add said modules to the player
		self:AddAction(v.Name, v)
	end

	-- || CAMERA ||

	-- The camera and camera block
	self.camera = newPlayerTable.camera or game.Workspace.CurrentCamera
	self.cameraBlock = cameraHandler:CreateCameraBlock(self)

	-- The mouse
	self.mouse = self.player:GetMouse()

	-- Camera & camera block settings
	self.playerStats.cameraBlockFollow = self.humanoidRootPart
	self.defaultPlayerStats.cameraBlockFollow = self.humanoidRootPart
	self.playerStats.cameraSubject = self.cameraBlock
	self.defaultPlayerStats.cameraSubject = self.cameraBlock

	-- What the camera is looking at
	self.playerStats.cameraTarget = nil
	self.defaultPlayerStats.cameraTarget = nil
	
	-- Camera handler
	self.cameraHandler = cameraHandler.new(self)

	-- || DEBUG MENU ||

	-- Whether or not the debug menu is enabled
	self.debugEnabled = false

	-- Make sure the user is in studio
	if runService:IsStudio() then
		
		-- Let the script know the debug menu is enabled
		self.debugEnabled = true

		self:DebugMenu()
	end
	
	-- || UPDATES ||
	
	-- The input update
	runService:BindToRenderStep("Input Update", Enum.RenderPriority.Input.Value, function(deltaTime)

		-- Move the player
		self:Move()
	end)
	
	-- The graphics update
	runService:BindToRenderStep("Camera Update", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
		
		-- Update the camera
		self.cameraHandler:Update(deltaTime)
	end)

	-- The final update
	runService:BindToRenderStep("After Final Update", Enum.RenderPriority.Last.Value + 1, function(deltaTime)

		-- Apply the current mouse setting
		userInputService.MouseBehavior = self.playerStats.cursorType.MouseBehavior
	end)

	-- || CONNECTIONS ||

	-- The player's current action was changed
	self.NewAction.Event:Connect(function(oldValue, newValue)
		
		-- Call any related functions
		statsChangedFunctions["currentAction"](newPlayer, oldValue, newValue, false)
	end)
	
	-- The player's current state was changed
	self.CharacterStateChanged.Event:Connect(function(oldValue, newValue)
		
		-- Call any related functions
		statsChangedFunctions["characterState"](newPlayer, oldValue, newValue, false)
	end)

	-- || STARTUP ||

	-- Check if there needs to be any default effects applied
	for key, value in pairs(newPlayer) do

		-- Check if there are any functions to call when changing the variable
		if statsChangedFunctions[tostring(key)] then

			-- Call said function
			statsChangedFunctions[tostring(key)](newPlayer, nil, value, true)
		end
	end
	for key, value in pairs(newPlayer.defaultPlayerStats) do

		-- Check if there are any functions to call when changing the variable
		if statsChangedFunctions[tostring(key)] then
			
			-- Call said function
			statsChangedFunctions[tostring(key)](newPlayer, nil, value, true)
		end
	end

	-- Return the table
	return newPlayer
end

-- Unlock or lock the mouse
function player:ChangeMouseLock()
	
	-- Change the mouse lock to the opposite of the current version
	if self.playerStats.cursorType == Enum.CustomCursorType.Locked then
			
		self.playerStats.cursorType = Enum.CustomCursorType.Unlocked
		self.playerStats.mouseMovesCamera = false
	else

		self.playerStats.cursorType = Enum.CustomCursorType.Locked
		self.playerStats.mouseMovesCamera = true
	end
end

function player:DebugMenu()
	
	-- Start iris
	iris:Connect(function()

		if not self.debugEnabled then return end

		-- Create a window
		local windowSize = iris.State(Vector2.new(400, 500))
		local windowPosition = iris.State(Vector2.new(0, 0))
		iris.Window({"DEBUG WINDOW"}, {position = windowPosition, size = windowSize, isUncollapsed = false})

			-- Character stats
			iris.CollapsingHeader({"Character Stats"}, {isUncollapsed = true})

					-- CHARACTER HEALTH
					iris.SameLine()

						iris.Text({"Current Health: "})
						iris.Text({self.characterStats.currentHealth .. "/" .. self.characterStats.maxHealth, true, Color3.new(1, 0.592156, 0.592156)})
					iris.End()

					-- CHARACTER STAMINA
					iris.SameLine()

						iris.Text({"Current Stamina: "})
						iris.Text({self.characterStats.currentStamina .. "/" .. self.characterStats.maxStamina, true, Color3.new(0.627450, 1, 0.592156)})
					iris.End()

					iris.Separator()

					-- CHARACTER STATES
					iris.Tree({"Character States"})

						if iris.Text({"Current State: " .. self.characterState.Name}).hovered() then
							iris.Tooltip("The player's current state \n[Enum.CharacterState]")
						end

						if iris.Text({"Control Type: " .. self.controlType.Name}).hovered() then
							iris.Tooltip("The player's current control type. Dictates whether or not the humanoid can move. \n[Enum.Enum.ControlType]")
						end

						if iris.Text({"Movement Type: " .. self.characterStats.movementType.Name}).hovered() then
							iris.Tooltip("The player's current movement type \n[Enum.MovementType]")
						end
						
					iris.End()

					-- CHARACTER BOOLEANS
					iris.Tree({"Character Booleans"})

						-- Can jump
						iris.SameLine()
							iris.Text({"Can Jump: "})
							iris.Text({
								tostring(self.characterStats.canJump),
								false,
								self.characterStats.canJump and Color3.new(0, 0.184313, 1) or Color3.new(1, 0, 0)
							})
						iris.End()

						-- Can Climb
						iris.SameLine()
							iris.Text({"Can climb: "})
							iris.Text({
								tostring(self.characterStats.canClimb),
								false,
								self.characterStats.canClimb and Color3.new(0, 0.184313, 1) or Color3.new(1, 0, 0)
							})
						iris.End()
						
					iris.End()

					-- CHARACTER ACTIONS
					iris.Tree({"Current Character Action"})

						-- Check if there is a current action
						if self.characterStats.currentAction then

							local action = self.characterStats.currentAction
							iris.Text({"Current Action: " .. action.name})
						else

							-- The current action is nil
							iris.Text({"Current Action: " .. "nil"})
						end
						
					iris.End()

					-- CHARACTER EFFECTS
					iris.Tree({"Current Character Effects"})

						-- Can add effects
						iris.SameLine()
							iris.Text({"Can add effects: "})
							iris.Text({
								tostring(self.characterStats.canAddEffects),
								false,
								self.characterStats.canAddEffects and Color3.new(0, 0.184313, 1) or Color3.new(1, 0, 0)
							})
						iris.End()

						-- Add all current effects
						for index, value in self.effects do

							-- Effect tree
							iris.Tree({value.name})

								iris.Text({"Effect Name: " .. value.name})
								iris.Text({"Effect Priority: " .. value.priority})
								iris.Text({"Data to modify: " .. value.dataToModify})
							iris.End()
						end
					iris.End()
				iris.End()
		
			-- Character functions
			iris.CollapsingHeader({"Character Functions"})

					-- STRAFING
					local strafing = iris.Checkbox({"Strafing"})
					if strafing.checked() then
						
						self:AddEffect(characterEffectPrefabs.Enable_Strafing)
					end
					if strafing.unchecked() then
					
						self:RemoveEffect(characterEffectPrefabs.Enable_Strafing.Name)
					end

					-- DAMAGE SIM
					iris.SameLine()

						local damageButton = iris.Button({"Simulate Damage"})
						local damageAmount = iris.InputNum({""})

						if damageButton.hovered() or damageAmount.hovered() then
							
							iris.Tooltip({"Will simulate damage being taken. \nThe player's actual health will NOT be drained"})
						end

						if damageButton.clicked() then
							
							self:DamageReaction(damageAmount.state.number.value)
						end
					iris.End()

				iris.End()
			
			-- Camera
			iris.CollapsingHeader({"Camera Functions"})

					-- FIRST PERSON CAMERA
					local firstPersonEnabled = iris.Checkbox({"First Person"})
					if firstPersonEnabled.checked() then
						self:AddEffect(effectPrefabs.First_Person_Camera)
					end
					if firstPersonEnabled.unchecked() then
						self:RemoveEffect(effectPrefabs.First_Person_Camera.Name)
					end
					if firstPersonEnabled.hovered() then
						iris.Tooltip("Whether or not the player is in first person")
					end

					-- LOCK PLAYER TO CAMERA
					local movementRelativeToCamera = iris.Checkbox({"Movement Relative to Camera"})
					if movementRelativeToCamera.checked() then
						self:AddEffect(effectPrefabs.Enable_Movement_Relative_To_Camera)
					end
					if movementRelativeToCamera.unchecked() then
						self:RemoveEffect(effectPrefabs.Enable_Movement_Relative_To_Camera.Name)
					end
					if movementRelativeToCamera.hovered() then
						iris.Tooltip("Whether or not the player looks in the camera's forward direction")
					end

					-- CAMERA FOV
					local fovSlider = iris.SliderNum({"Camera FOV"}, {number = self.playerStats.fieldOfView})
					if fovSlider.numberChanged() then
						self.playerStats.fieldOfView = fovSlider.number.value
					end
					if fovSlider.hovered() then
						iris.Tooltip("The player's field of view")
					end

					-- CAMERA ZOOM
					local zoomSlider = iris.SliderNum({"Camera Zoom", 1, 1, 200}, {number = self.playerStats.cameraZoomDistance})
					if zoomSlider.numberChanged() then
						self.playerStats.cameraZoomDistance = zoomSlider.number.value
					end
					if fovSlider.hovered() then
						iris.Tooltip("The camera's zoom distance")
					end

					-- CAMERA STIFFNESS
					local stiffnessSlider = iris.SliderNum({"Camera Stiffness"}, {number = 30})
					if stiffnessSlider.numberChanged() then
						self.playerStats.cameraStiffness = stiffnessSlider.number.value
					end
					if stiffnessSlider.hovered() then
						iris.Tooltip("How quickly the camera block follows the player")
					end
					
					-- CAMERA FOLLOWS TARGET
					local cameraFollowsTarget = iris.Checkbox({"Camera block Follows Target"}, {isChecked = true})
					if cameraFollowsTarget.checked() then
						self:RemoveEffect(effectPrefabs.Disable_Camera_Block_Follow.Name)
					end
					if cameraFollowsTarget.unchecked() then
						self:AddEffect(effectPrefabs.Disable_Camera_Block_Follow)
					end
					if cameraFollowsTarget.hovered() then
						iris.Tooltip("Whether or not the camera block will follow the current target")
					end

					-- CAMERA OFFSET
					local cameraOffset = iris.InputVector3({"Camera Offset", 0.01}, {number = self.playerStats.cameraOffset})
					if cameraOffset.numberChanged() then
						self.playerStats.cameraOffset = cameraOffset.number.value
					end
					if cameraOffset.hovered() then
						iris.Tooltip("The camera's offset from it's current target")
					end
				iris.End()
		iris.End()
	end)
end

-- Destroy the player
function player:Destroy()

	-- Stop the debug
	self.debugEnabled = false

	-- Disable the camera shake
	self.cameraHandler.shakeModule:Stop()
	
	-- Disconnect all connections
	self.renderSteppedConnection:Disconnect()
	self.heartbeatConnection:Disconnect()
	runService:UnbindFromRenderStep("Final Update")
	runService:UnbindFromRenderStep("After Final Update")
	runService:UnbindFromRenderStep("Input Update")
	runService:UnbindFromRenderStep("Camera Update")

	-- Remove the metatable
	setmetatable(self, nil)
end

return player

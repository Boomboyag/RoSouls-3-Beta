-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders and directories
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterPath = coreFolder:WaitForChild("Object"):WaitForChild("Character")

-- Required scripts
local character = require(characterPath)
local Enum = require(coreFolder:WaitForChild("Enum"))
local playerStatsSheet = require(script:WaitForChild("Player_Stats"))
local effectPrefabs = require(script:WaitForChild("Player_Effect_Prefabs"))
local cameraHandler = require(script:WaitForChild("Camera_Handler"))

-- Humanoid state changed table
local humanoidStateChangedFunctions = require(script:WaitForChild("Player_Humanoid_State_Changed_Functions"))

-- Stats changed table
local statsChangedFunctions = require(script:WaitForChild("Player_Variable_Changed_Functions"))

-- Class creation
local player = {}
player.__index = player
player.__tostring = function(player)

	-- Return the name of the object
	return player.name
end
setmetatable(player, character)

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
		setmetatable(proxy, metatable)
		return proxy
	end
	
	-- || STATS ||
	
	-- The player stats
	self.playerStats = TrackStats(playerStatsSheet.new(newPlayer, self), self)
	self.defaultPlayerStats = playerStatsSheet.new(newPlayer, self)
	
	-- Add the player stats to the effect table
	table.insert(self.validEffectTables, self.playerStats)
	table.insert(self.defaultValues, self.defaultPlayerStats)
	
	-- || CAMERA ||
	
	-- The camera and camera block
	self.camera = newPlayerTable.camera or game.Workspace.CurrentCamera
	self.cameraBlock = cameraHandler:CreateCameraBlock(self)
	
	-- Camera handler
	self.cameraHandler = cameraHandler.new(self)
	
	-- Camera and mouse states
	self.cameraType = Enum.CustomCameraType.Default
	self.cursorType = Enum.CustomCursorType.Locked
	
	-- || UPDATES ||
	
	-- The input update
	runService:BindToRenderStep("Input Update", Enum.RenderPriority.Input.Value, function(deltaTime)

		-- Move the player
		self:Move()
	end)
	
	-- The graphics update
	runService:BindToRenderStep("Camera Update", Enum.RenderPriority.Camera.Value, function(deltaTime)
		
		-- Update the camera
		self.cameraHandler:SmoothCamera()
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
	for key, value in pairs(newPlayer.playerStats) do

		-- Check if there are any functions to call when changing the variable
		if statsChangedFunctions[tostring(key)] then

			-- Call said function
			statsChangedFunctions[tostring(key)](newPlayer, nil, value, true)
		end
	end

	-- Return the table
	return newPlayer
end

-- Destroy the player
function player:Destroy()
	
	-- Disconnect all connections
	self.renderSteppedConnection:Disconnect()
	self.heartbeatConnection:Disconnect()
	runService:UnbindFromRenderStep("Final Update")
	runService:UnbindFromRenderStep("Input Update")
	runService:UnbindFromRenderStep("Camera Update")

	-- Remove the metatable
	setmetatable(self, nil)
end

return player

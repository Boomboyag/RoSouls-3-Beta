-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = coreFolder:WaitForChild("Object"):WaitForChild("Character")

-- Required scripts
local object = require(coreFolder:WaitForChild("Object"))
local Enum = require(coreFolder:WaitForChild("Enum"))
local characterStatsSheet = require(characterFolder:WaitForChild("Stats"))
local animationModule = require(characterFolder:WaitForChild("Animations"))
local rootMotionModule = require(characterFolder:WaitForChild("Animations"):WaitForChild("RootMotion"))
local effectModule = require(characterFolder:WaitForChild("Character_Effects"))
local effectPrefabs = require(characterFolder:WaitForChild("Character_Effects"):WaitForChild("Effect_Prefabs"))
local actionModule = require(characterFolder:WaitForChild("Character_Actions"))
local actionPrefabs = require(characterFolder:WaitForChild("Character_Actions"):WaitForChild("Action_Prefabs"))

local statsChangedFunctions = {
	
	-- || ACTIONS ||

	-- The character's state has been changed
	["currentAction"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if startup or (newValue == oldValue) then return end

			-- Wrap in coroutine
			coroutine.wrap(function()

				-- End the current action
				if oldValue then oldValue:EndAction(character) end

				-- Begin the new action
				if newValue then newValue:BeginAction(character) end
			end)()
		end) 

		if not success then
			warn(response)
		end
		
		return newValue	
	end,
}

return statsChangedFunctions

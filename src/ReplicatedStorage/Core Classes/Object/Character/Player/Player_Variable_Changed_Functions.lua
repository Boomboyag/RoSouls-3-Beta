-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = coreFolder:WaitForChild("Object"):WaitForChild("Character")
local playerFolder = characterFolder:WaitForChild("Player")

-- Required scripts
local Enum = require(coreFolder:WaitForChild("Enum"))
local playerStatsSheet = require(playerFolder:WaitForChild("Player_Stats"))
local effectPrefabs = require(playerFolder:WaitForChild("Player_Effect_Prefabs"))

local statsChangedFunctions = {

}

return statsChangedFunctions

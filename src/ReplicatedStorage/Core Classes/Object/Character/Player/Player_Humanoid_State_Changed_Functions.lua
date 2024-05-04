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
local playerStatsSheet = require(playerFolder:WaitForChild("Player_Stats"))
local effectPrefabs = require(playerFolder:WaitForChild("Player_Effect_Prefabs"))

local humanoidStateChangedFunctions = {

	-- The character is walking or idle
	[Enum.HumanoidStateType.Running] = function(player)

	end,

	-- The chracter is falling
	[Enum.HumanoidStateType.Freefall] = function(player)

	end,

	-- The character has landed
	[Enum.HumanoidStateType.Landed] = function(player)

	end,

	-- The character is jumping
	[Enum.HumanoidStateType.Jumping] = function(player)

	end,

	-- The character is sitting
	[Enum.HumanoidStateType.Seated] = function(player)

	end,

	-- The character is climbing
	[Enum.HumanoidStateType.Climbing] = function(player)

	end,

	-- The character is dead
	[Enum.HumanoidStateType.Dead] = function(player)

	end,
}

return humanoidStateChangedFunctions

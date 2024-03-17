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

    -- || CAMERA SETTINGS ||

    ["fieldOfView"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (not oldValue and not startup) or (oldValue == newValue) or not newValue then return end

            -- Change the player's maximum camera zoom distance
            player.camera.FieldOfView = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    ["maximumZoom"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (not oldValue and not startup) or (oldValue == newValue) or not newValue then return end

            -- Change the player's maximum camera zoom distance
            player.player.CameraMaxZoomDistance = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    ["minimumZoom"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (not oldValue and not startup) or (oldValue == newValue) or not newValue then return end

            -- Change the player's maximum camera zoom distance
            player.player.CameraMinZoomDistance = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,
}

return statsChangedFunctions

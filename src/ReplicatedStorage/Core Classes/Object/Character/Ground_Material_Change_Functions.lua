-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = coreFolder:WaitForChild("Object"):WaitForChild("Character")

local groundMaterialChangedFunctions = {

    ["Grass"] = {

        ["Default"] = {

            -- Character began stepping on the material
            ["MaterialEntered"] = function(character)
                
                
            end,

            -- Character began stepping on the material
            ["MaterialLeft"] = function(character)
                
                
            end,
        }
    }
}

return groundMaterialChangedFunctions

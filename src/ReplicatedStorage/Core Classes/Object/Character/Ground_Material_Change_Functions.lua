-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = coreFolder:WaitForChild("Object"):WaitForChild("Character")

-- Required scripts
local characterEffectPrefabs = require(characterFolder:WaitForChild("Character_Effects"):WaitForChild("Effect_Prefabs"))

local groundMaterialChangedFunctions = {

    ["Ice"] = {

        ["Default"] = {

            -- Character began stepping on the material
            ["MaterialEntered"] = function(character)
                
                character:AddEffect(characterEffectPrefabs.Slow_Walkspeed)
            end,

            -- Character began stepping on the material
            ["MaterialLeft"] = function(character)
                
                character:RemoveEffect(characterEffectPrefabs.Slow_Walkspeed.Name)
            end,
        }
    }
}

return groundMaterialChangedFunctions

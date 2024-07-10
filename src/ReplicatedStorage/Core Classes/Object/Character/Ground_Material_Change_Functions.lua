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

    -- Ice
    [Enum.Material.Ice.Name] = {

        ["Default"] = {

            -- Character began stepping on the material
            ["MaterialEntered"] = function(character)
                
                -- Slow the character
                character:AddEffect(characterEffectPrefabs.Slow_Walkspeed)
                character:AddEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed)
            end,

            -- Character began stepping on the material
            ["MaterialLeft"] = function(character)
                
                -- Reset the character speed
                character:RemoveEffect(characterEffectPrefabs.Slow_Walkspeed.Name)
                character:RemoveEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed.Name)
            end,
        }
    },

    -- Cracked Lava
    [Enum.Material.CrackedLava.Name] = {

        ["Default"] = {

            -- Character began stepping on the material
            ["MaterialEntered"] = function(character)

                -- Drain the character health
                character:AddEffect(characterEffectPrefabs.Lava_Health_Drain)
                
                -- Slow the character
                character:AddEffect(characterEffectPrefabs.Slow_Walkspeed)
                character:AddEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed)
            end,

            -- Character began stepping on the material
            ["MaterialLeft"] = function(character)

                -- Stop draining the character health
                character:RemoveEffect(characterEffectPrefabs.Lava_Health_Drain.Name)
                
                -- Reset the character speed
                character:RemoveEffect(characterEffectPrefabs.Slow_Walkspeed.Name)
                character:RemoveEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed.Name)
            end,
        }
    },
}

return groundMaterialChangedFunctions

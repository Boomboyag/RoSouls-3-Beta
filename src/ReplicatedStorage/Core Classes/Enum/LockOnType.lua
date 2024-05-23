-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local characterModule = coreFolder:WaitForChild("Object"):WaitForChild("Character")
local playerModule = characterModule:WaitForChild("Player")
local characterEffectPrefabs = require(characterModule:WaitForChild("Character_Effects").Effect_Prefabs)
local playerEffectPrefabs = require(playerModule:WaitForChild("Player_Effect_Prefabs"))

local lockOnType = {}

-- Full lock on
lockOnType.Full = {

    -- The index
    1,

    -- The name
    Name = "Full",

    -- Called when changed to
    StateBeganFunction = function(player)
        
        -- Lock the player to it's camera and enable strafing
        player:AddEffect(characterEffectPrefabs.Enable_Strafing)
        player:AddEffect(playerEffectPrefabs.Enable_Movement_Relative_To_Camera)

        -- Stop the cursor from moving the camera
        player:AddEffect(playerEffectPrefabs.Disable_Cursor_Camera_Movement)
    end,

    -- Called when changed from
    StateEndedFunction = function(player)
        
        player:RemoveEffect(characterEffectPrefabs.Enable_Strafing.Name)
        player:RemoveEffect(playerEffectPrefabs.Enable_Movement_Relative_To_Camera.Name)

        player:RemoveEffect(playerEffectPrefabs.Disable_Cursor_Camera_Movement.Name)
    end
}

-- Limited lock on
lockOnType.Limited = {
    
     -- The index
     2,

     -- The name
     Name = "Limited",
 
     -- Called when changed to
     StateBeganFunction = function(player)
         
        -- Stop the cursor from moving the camera
        player:AddEffect(playerEffectPrefabs.Disable_Cursor_Camera_Movement)
     end,
 
     -- Called when changed from
     StateEndedFunction = function(player)
         
        player:RemoveEffect(playerEffectPrefabs.Disable_Cursor_Camera_Movement.Name)
     end
}

-- No lock on
lockOnType.None = {
    
     -- The index
     3,

     -- The name
     Name = "None",
 
     -- Called when changed to
     StateBeganFunction = function(player)
         
        player.playerStats.cameraTarget = nil
     end,
 
     -- Called when changed from
     StateEndedFunction = function(player)
         
     end
}

return lockOnType
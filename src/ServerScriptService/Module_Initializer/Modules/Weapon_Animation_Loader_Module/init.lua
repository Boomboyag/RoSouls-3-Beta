-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Modules
local playerFolder = moduleFolder.Parent.Player.Required_Modules

-- The action module
local actionModule = script:WaitForChild("Weapon_Animation_Loader")

local module = {}

-- The function to initialize the module
function module:Init()

    -- Put the VFX in the correct folder
    --particle.Parent = replicatedStorage:WaitForChild("VFX")
    
    -- Clone the module for other scripts to use
    local module_ = actionModule:Clone()
    module_.Parent = moduleFolder

    -- Add the module to the character
    local playerMod = actionModule:Clone()
    playerMod.Parent = playerFolder
end

return module
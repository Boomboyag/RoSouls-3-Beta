-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Action_Modules
local playerFolder = moduleFolder.Parent.Player.Required_Action_Modules

-- The action module
local actionModule = script:WaitForChild("Footstep")

-- The footstep particle
--local particle = script:WaitForChild("Footstep_Particle")

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
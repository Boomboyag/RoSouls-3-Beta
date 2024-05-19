-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Action_Modules
local playerFolder = moduleFolder.Parent.Player.Required_Action_Modules

-- The action module
local actionModule = script:WaitForChild("Lock_On")

local module = {}

-- The function to initialize the module
function module:Init()
    
    -- Clone the module for other scripts to use
    local module_ = actionModule:Clone()
    module_.Parent = moduleFolder

    -- Add the module to the character
    --local playerMod = actionModule:Clone()
    --playerMod.Parent = playerFolder
end

return module
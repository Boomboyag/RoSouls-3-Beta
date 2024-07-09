-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local remoteFolder = replicatedStorage:WaitForChild("Remote")

-- Required events
local remoteEvent = remoteFolder:WaitForChild("Take_Damage_Remote")

local module = {}

module.Name = "Damage Module"

-- The function to be called
function module:CallFunction(damageAmount, ignoreForceField)

    -- Call the remote or bindable event
    if self.onClient then remoteEvent:FireServer(damageAmount, ignoreForceField or true) end

    return 0
end

return module
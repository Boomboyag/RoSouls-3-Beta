-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local remoteFolder = replicatedStorage:WaitForChild("Remote")
local bindableFolder = replicatedStorage:WaitForChild("Bindable")

-- Required events
local remoteEvent = remoteFolder:WaitForChild("Add_Character_Tag_Remote")
local bindableEvent = bindableFolder:WaitForChild("Add_Character_Tag_Bindable")

local module = {}

module.Name = "Character Tag Module"

-- The init function
function module:Init()

    -- Add the forcefield
    if self.onServer then
        bindableEvent:Fire(self.model)
    else
        remoteEvent:FireServer()
    end
end

-- The function to be called
function module:CallFunction()

    warn("Internal function, not meant to be called")
    return 0
end

return module
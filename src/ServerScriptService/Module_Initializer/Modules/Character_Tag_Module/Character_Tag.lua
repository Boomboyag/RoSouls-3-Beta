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

    -- Add the tag
    if self.onServer then
        bindableEvent:Fire(self.model)
    else
        remoteEvent:FireServer()
    end
end

return module
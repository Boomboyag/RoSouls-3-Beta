-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")
local debrisService = game:GetService("Debris")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Action_Modules
local playerFolder = moduleFolder.Parent.Player.Required_Action_Modules

-- The action module
local actionModule = script:WaitForChild("Roll")

-- Variables
local iFrameDelay = 0.1
local iFrameTime = 0.75

local module = {}

-- The function to initialize the module
function module:Init()
    
    -- Clone the module for other scripts to use
    local module_ = actionModule:Clone()
    module_.Parent = moduleFolder

    -- Add the module to the character
    local playerMod = actionModule:Clone()
    playerMod.Parent = playerFolder

    -- Add in the remote & bindable events
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = "Roll_Remote"
    local bindableEvent = Instance.new("BindableEvent")
    bindableEvent.Name = "Roll_Bindable"

    -- The function to add the forcefield to the character
    local function RollForceField(character)
        
        -- Make sure the character exists
        if not character then return end

        task.wait(iFrameDelay)

        -- Add the force field
        local forceField = Instance.new("ForceField")
        forceField.Visible = false
        forceField.Parent = character

        -- Destroy the force field
        debrisService:AddItem(forceField, iFrameTime)
    end

    -- Fired when the remote event is called
    remoteEvent.OnServerEvent:Connect(function(player)
        
        -- Get the character
        local character = player.Character

        RollForceField(character)
    end)

    -- Fired when the bindable event is fired
    bindableEvent.Event:Connect(function(character)
        
        RollForceField(character)
    end)

    -- Get the remote folder
    local remoteFolder = replicatedStorage:FindFirstChild("Remote")
    if not remoteFolder then
        
        remoteFolder = Instance.new("Folder")
        remoteFolder.Name = "Remote"
        remoteFolder.Parent = replicatedStorage
    end
    remoteEvent.Parent = remoteFolder

    -- Get the bindable folder
    local bindableFolder = replicatedStorage:FindFirstChild("Bindable")
    if not bindableFolder then
        
        bindableFolder = Instance.new("Folder")
        bindableFolder.Name = "Bindable"
        bindableFolder.Parent = replicatedStorage
    end
    bindableEvent.Parent = bindableFolder
end

return module
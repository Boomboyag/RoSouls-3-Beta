-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Action_Modules
local playerFolder = moduleFolder.Parent.Player.Required_Action_Modules

-- The action module
local actionModule = script:WaitForChild("Character_Tag")

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
    remoteEvent.Name = "Add_Character_Tag_Remote"
    local bindableEvent = Instance.new("BindableEvent")
    bindableEvent.Name = "Add_Character_Tag_Bindable"

    -- Fired when the remote event is called
    remoteEvent.OnServerEvent:Connect(function(player)
        
        -- Get the character
        local character = player.Character
        collectionService:AddTag(character, "Charater")
    end)

    -- Fired when the bindable event is fired
    bindableEvent.Event:Connect(function(character)
        collectionService:AddTag(character, "Charater")
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
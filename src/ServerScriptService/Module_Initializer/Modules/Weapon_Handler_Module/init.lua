-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Modules
local playerFolder = moduleFolder.Parent.Player.Required_Modules

-- The action module
local actionModule = script:WaitForChild("Weapon_Handler")

local module = {}

-- The function to create the events that load weapons
function LoadWeaponEvents()
    
    -- The events
    local remoteFunction = Instance.new("RemoteFunction")
    remoteFunction.Name = "Load_Weapons_Remote"
    local bindableFunction = Instance.new("BindableFunction")
    bindableFunction.Name = "Load_Weapons_Bindable"

    -- Get the remote folder
    local remoteFolder = replicatedStorage:FindFirstChild("Remote")
    if not remoteFolder then
        
        remoteFolder = Instance.new("Folder")
        remoteFolder.Name = "Remote"
        remoteFolder.Parent = replicatedStorage
    end
    remoteFunction.Parent = remoteFolder

    -- Get the bindable folder
    local bindableFolder = replicatedStorage:FindFirstChild("Bindable")
    if not bindableFolder then
        
        bindableFolder = Instance.new("Folder")
        bindableFolder.Name = "Bindable"
        bindableFolder.Parent = replicatedStorage
    end
    bindableFunction.Parent = bindableFolder

    -- When the load function is called by a player
    remoteFunction.OnServerInvoke = function(player : Player)
    
        -- Get the player's profile
        local profile : table = bindableFolder:WaitForChild("Get_Player_Data_Bindable"):Invoke(player, "Weapons")
        if not profile then return end
        
        return profile["Left_Hand"]["Slot_A"], profile["Right_Hand"]["Slot_A"]
    end
end

-- The function to initialize the module
function module:Init()
    
    -- Clone the module for other scripts to use
    local module_ = actionModule:Clone()
    module_.Parent = moduleFolder

    -- Add the module to the character
    local playerMod = actionModule:Clone()
    playerMod.Parent = playerFolder

    -- Loading weapons
    LoadWeaponEvents()
end

return module
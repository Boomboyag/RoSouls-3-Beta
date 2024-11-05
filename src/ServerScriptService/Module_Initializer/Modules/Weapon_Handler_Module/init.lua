-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")
local insertServer = game:GetService("InsertService")
local players = game:GetService("Players")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Modules
local playerFolder = moduleFolder.Parent.Player.Required_Modules

-- Required scripts
local weaponPrefabs = require(coreFolder.Weapons)

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

-- The function to spawn weapon models
function LoadWeaponModelsRemote()
    
    -- Find the remove folder
    local remoteFolder = replicatedStorage:WaitForChild("Remote")

    -- Create the remote function
    local remoteFunction = Instance.new("RemoteFunction", remoteFolder)
    remoteFunction.Name = "Load_Weapon_Model"

    -- When the remote function is called
    remoteFunction.OnServerInvoke = function(player, weaponName, weaponHand)

        -- Get the character from the player
        local character = player.Character

        -- Make sure the character exists
        if not character then return end
        
        -- Load the model
        module:LoadWeaponModel(character, weaponName, weaponHand)
    end
end

-- The function to load a weapon onto a character
function module:LoadWeaponModel(character, weaponName, weaponHand)
    
    -- Find the weapon table
    local weaponTable = weaponPrefabs[weaponName]
    if not weaponTable then
            warn(weaponName .. " not found!")
            return
    end

    -- Create the weapon model
    local weaponID = weaponTable.Model
    local weaponType = weaponTable.Type
    local weaponModel = insertServer:LoadAsset(weaponID)

    -- Add the model to the character
    local weaponFolder = Instance.new("Folder")
	weaponFolder.Name = string.gsub(weaponName, " ", "_") .. "_" .. string.gsub(weaponHand, " ", "_")

    -- Rename the weapon model
	local handle = weaponModel:GetChildren()[1]
	handle.Name = "Handle"
	handle.Parent = weaponFolder

    -- Create the motor binding the weapon to the character
	local m6d = Instance.new("Motor6D")
	m6d.Name = "Motor6D_" .. string.gsub(weaponHand, " ", "_")
	m6d.Parent = weaponFolder
	m6d.Part0 = character:WaitForChild(weaponHand .. " Arm")
	m6d.Part1 = handle
    
    -- Check if the weapon offset needs to be inverted
	local multiplier = 1
	if weaponHand == "Left Arm" then multiplier = -1 end

	if weaponType == 'Ultra_Greatsword' then

		    m6d.C0 = CFrame.new(-0.25 * multiplier, -0.75, -0.125) * CFrame.Angles(0, 0, math.rad(-90))
		    m6d.C1 = CFrame.new(0,-3,0) * CFrame.Angles(math.rad(90),0,0)

	elseif weaponType == 'Greathammer' then
		
		    m6d.C0 = CFrame.new(0.25 * multiplier, -0.75, -0.125) * CFrame.Angles(0, math.rad(90), math.rad(-90))
		    --m6d.C1 = CFrame.new(0,-3,0) * CFrame.Angles(math.rad(90),0,0)

	elseif weaponType == 'Straight_Sword' then

		    m6d.C0 = CFrame.new(-0.25, -0.75, -0.125) * CFrame.Angles(0, 0, math.rad(-90))
		    m6d.C1 = CFrame.new(0,-0.258,1.963) * CFrame.Angles(0,0,0)

	elseif weaponType == 'Greatsword' then

		    m6d.C0 = CFrame.new(-0.25, -0.75, -0.125) * CFrame.Angles(0, 0, math.rad(-90))
		    m6d.C1 = CFrame.new(0,-3,0) * CFrame.Angles(math.rad(90),0,0)

	elseif weaponType == 'Fist' or weaponType == "Default" then

		    m6d.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(-90))
		    m6d.C1 = CFrame.new(-0.5,0,0) * CFrame.Angles(math.rad(90),0,0)

	elseif weaponType == "Spear" then

		    m6d.C0 = CFrame.new(0, -0.75, -0.125) * CFrame.Angles(0, 0, math.rad(-90))
		    m6d.C1 = CFrame.new(-0.2,0,1) * CFrame.Angles(0,0,0)
	end

	-- Assign the folder to the character
	weaponFolder.Parent = character
    weaponModel:Destroy()
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
    LoadWeaponModelsRemote()
end

return module
-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Modules
local playerFolder = moduleFolder.Parent.Player.Required_Modules

-- The action module
local actionModule = script:WaitForChild("Player_Profile")

local module = {}

-- A default player profile
local defaultProfile = require(script.Default_Profile)

-- A collection of all player profiles within the game
local currentProfiles : table = {}

-- The function to return an entire character's profile
function GetPlayerProfile(player : Player) : table

    -- The table copy function
    local function DeepCopy(original)
        local copy = {}
        for k, v in pairs(original) do
            if type(v) == "table" then
                v = DeepCopy(v)
            end
            copy[k] = v
        end
        return copy
    end
	
	-- Return the default profile for now
	return DeepCopy(defaultProfile)
end

-- The function to get specific data from a player's profile
function GetPlayerProfileData(player : Player, data : string) : any
	
	-- Get the profile & make sure it exists
	local profile = currentProfiles[player]
	if not profile then return end
	
    -- The function to find data
	local function FindData(tableToSearch : table, data : string)
        
        for i, v in tableToSearch do

            -- Check if we found the desired data
            if i == data then return v end
            
            -- Check if the value was a table to loop through
            if type(v) == "table" then
                
                -- Check the table
                local foundData = FindData(v, data)
                if foundData then return foundData end
            end
        end

        -- Return nil if nothing is found
        return nil
    end

    local foundData = FindData(profile, data)
    if not foundData then  warn("Player data " .. data .. " was nout found in " .. player.Name .. "s profile!") end
    return foundData
end

-- Handling player connections
function PlayerConnections()
	
	-- Get all current players in the game
	for i, v in players:GetChildren() do
		
		-- Get the player's profile
		currentProfiles[v] = GetPlayerProfile(v)
	end
	
	-- Player connected
	players.PlayerAdded:Connect(function(player)
		
		-- Get the player's profile
		currentProfiles[player] = GetPlayerProfile(player)
	end)
	
	-- Player disconnected
	players.PlayerRemoving:Connect(function(player)

		-- Get the player's profile
		currentProfiles[player] = nil
	end)
end

-- The function to create the necessary events
function LoadEvents()
    
    -- Remote events
    local remoteFunction = Instance.new("RemoteFunction")
    remoteFunction.Name = "Get_Player_Data_Remote"

    -- Get the remote folder
    local remoteFolder = replicatedStorage:FindFirstChild("Remote")
    if not remoteFolder then
        
        remoteFolder = Instance.new("Folder")
        remoteFolder.Name = "Remote"
        remoteFolder.Parent = replicatedStorage
    end
    remoteFunction.Parent = remoteFolder

    -- Local events
    local bindableFunction = Instance.new("BindableFunction")
    bindableFunction.Name = "Get_Player_Data_Bindable"

    -- Get the bindable folder
    local bindableFolder = replicatedStorage:FindFirstChild("Bindable")
    if not bindableFolder then
        
        bindableFolder = Instance.new("Folder")
        bindableFolder.Name = "Bindable"
        bindableFolder.Parent = replicatedStorage
    end
    bindableFunction.Parent = bindableFolder

    -- Get a player's data
    bindableFunction.OnInvoke = GetPlayerProfileData
end

-- The function to initialize the module
function module:Init()
    
    -- Clone the module for other scripts to use
    local module_ = actionModule:Clone()
    module_.Parent = moduleFolder

    -- Add the module to the character
    local playerMod = actionModule:Clone()
	playerMod.Parent = playerFolder
	
    LoadEvents()
	PlayerConnections()
end

return module
-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Modules
local playerFolder = moduleFolder.Parent.Player.Required_Modules

-- The action module
local actionModule = script:WaitForChild("TakeDamage")

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
    remoteEvent.Name = "Take_Damage_Remote"

    -- The function to damage the character
    local function TakeDamage(character, damageAmount, ignoreForceField)
        
        -- Make sure the character exists
        if not character then return end

        -- Check if we want to ignore forcefields
	    if not ignoreForceField then
		
		    -- Use the :TakeDamage() function
		    character.Humanoid:TakeDamage(math.abs(damageAmount))
	    else

		    -- Subtract the damage amount from the health
		    character.Humanoid.Health -= math.abs(damageAmount)
	    end
    end

    -- Fired when the remote event is called
    remoteEvent.OnServerEvent:Connect(function(player, damageAmount, ignoreForceField)
        
        -- Get the character
        local character = player.Character

        TakeDamage(character, damageAmount, ignoreForceField)
    end)

    -- Get the remote folder
    local remoteFolder = replicatedStorage:FindFirstChild("Remote")
    if not remoteFolder then
        
        remoteFolder = Instance.new("Folder")
        remoteFolder.Name = "Remote"
        remoteFolder.Parent = replicatedStorage
    end
    remoteEvent.Parent = remoteFolder
end

return module
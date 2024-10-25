-- Required services
local contentProvider = game:GetService("ContentProvider")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local remoteFolder = replicatedStorage:WaitForChild("Remote")

-- Required scripts
local weapon = require(script:WaitForChild("Weapon"))

-- Required remote events
local loadWeapons : RemoteFunction = remoteFolder:WaitForChild("Load_Weapons_Remote")

local module = {}

-- The module name
module.Name = "Weapon Handler"

-- Required animations and models
module.WeaponAnimations = require(coreFolder.Weapons.Weapon_Animations)
module.WeaponPrefabs = require(coreFolder.Weapons)

-- The init function
function module:Init()

    -- Load the animation & model IDs
    module.PreloadAnimations(self)
    module.PreloadModels(self)

    -- Add the required functions to the character
    self.LoadWeaponAnimations = module.LoadWeaponAnimations

    -- Get the weapons from the server
    local leftHand, rightHand = loadWeapons:InvokeServer()

    -- Make sure the weapons were found properly
    if leftHand and rightHand then
        
        -- Load the right hand weapon
        self.rightHandWeapon = weapon.new(self, rightHand, "Right")
    end
end

-- || PRELOADING ||

-- Preload all animations
function module:PreloadAnimations()

    -- Check if the animations need to be preloaded
    if replicatedStorage:FindFirstChild("Weapon_Animations") then return end

    -- The recursive loadinf function
    local function LoadAnimationRecursive(tableName : string, tableToLoad : table, previousFolder : Folder)

        local folder = Instance.new("Folder", previousFolder)
        folder.Name = tableName
        
        -- Loop through the provided table
        for i, v in tableToLoad do
            
            -- Check if an animation ID was provided
            if type(v) == "number" then
                
                -- Create the animation
                local animation = Instance.new("Animation", folder)
                animation.Name = i
                animation.AnimationId = "rbxassetid://" .. v

                -- Preload the animation if on client
                if self.onClient then
                    contentProvider:PreloadAsync({animation}, function(assetId, assetFetchStatus)

                        -- Warn the user if the load failed
                        if assetFetchStatus == Enum.AssetFetchStatus.Failure and not game:GetService("RunService"):IsStudio() then
                            warn("Failed to load weapon animation ID(s): " .. assetId)
                        end
                    end)
                end
                
                tableToLoad[i] = animation

            elseif type(v) == "table" then

                LoadAnimationRecursive(i, v, folder)
            end
        end
    end

    -- Create the starting folder
    local startingFolder = Instance.new("Folder", replicatedStorage)
    startingFolder.Name = "Weapon_Animations"
    
    -- Preload all animations
    for i, v in module.WeaponAnimations do
       LoadAnimationRecursive(i, v, startingFolder)
    end
end

-- Preloading all models
function module:PreloadModels()

    -- Check if the animations need to be preloaded
    if replicatedStorage:FindFirstChild("Weapon_Models") then return end
    
    -- Loop through the weapon folder
    for index, weapon in module.WeaponPrefabs do

        -- Wrap in a coroutine
        coroutine.wrap(function()
            
            -- Get the model ID
            local modelID = "rbxassetid://" .. weapon.Model

            -- Preload the model if on client
            if self.onClient then

                print("Loading " .. index)

                contentProvider:PreloadAsync({modelID}, function(assetId, assetFetchStatus)

                    -- Warn the user if the load failed
                    if assetFetchStatus == Enum.AssetFetchStatus.Failure and not game:GetService("RunService"):IsStudio() then
                    warn("Failed to load weapon model ID(s): " .. assetId)
                    end
                end)
            end
        end)()
    end

    -- Create the foler to ensure the weapon's are not loaded twice
    if self.onClient then
        local f = Instance.new("Folder")
        f.Name = "Weapon_Models"
        f.Parent = replicatedStorage
    end
end

-- Load specific weapon animations
function module:LoadWeaponAnimations(weaponName : string) : table
    
    -- Make sure the given weapon was valid
    if not weaponName or not module.WeaponAnimations[weaponName] then
        warn(weaponName .. " is not a valid weapon")
        return
    end

    -- The function to create a copy of a table
    local function TableFromFolder(original : Folder) : table
        local copy = {}
        for k, v in pairs(original:GetChildren()) do

            local name = v.Name
            if v:IsA("Folder") then
                v = TableFromFolder(v)
            end
            copy[name] = v
        end
        return copy
    end

    -- The function to make a humanoid load a weapon's animations
    local function LoadAnimations(animator : Animator, tableToLoad : table) : table
        
        local copy = {}
        for k, v in pairs(tableToLoad) do

            -- Check if the value is a table
            if type(v) == "table" then
                v = LoadAnimations(animator, v)

            -- Check if the value is an animation
            elseif v:IsA("Animation") then

                -- Load the animation
                v = animator:LoadAnimation(v)
            end
            copy[k] = v
        end
        return copy
    end

    -- Copy the weapon animation table
    local weapon = TableFromFolder(replicatedStorage["Weapon_Animations"])[weaponName]
    local weaponAnimationTable = LoadAnimations(self.animator, weapon)
    
    return weaponAnimationTable
end

return module
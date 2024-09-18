-- Required services
local contentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {}

-- The module name
module.Name = "Weapon Animation Loader"

-- The module priority
module.Priority = 10

-- The weapon animations
module.WeaponAnimations = {

    -- The greatsword animations
    ["Greatsword"] = {

        -- Left hand animations
        ["Left"] = {

            -- || One handed animations
            ["1H_Idle"] = 14794876958,
            ["1H_Light_1"] = 15714345920,
            ["1H_Light_2"] = 15714531168,
            ["1H_Light_3"] = 15714577681,
        },

        -- Right hand animations
        ["Right"] = {

            -- || One handed animations
            ["1H_Idle"] = 14004079995,
            ["1H_Light_1"] = 14004083451,
            ["1H_Light_2"] = 14006530152,
            ["1H_Light_3"] = 14071419088,
        }
    }
}

-- The init function
function module:Init()

    -- Load the animation IDs
    module:PreloadAnimations()

    -- Add the required functions to the character
    self.LoadWeaponAnimations = module.LoadWeaponAnimations
end

-- Preload all animations
function module:PreloadAnimations()

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

                -- Preload the animation
                contentProvider:PreloadAsync({animation}, function(assetId, assetFetchStatus)

                    -- Warn the user if the load failed
                    if assetFetchStatus == Enum.AssetFetchStatus.Failure and not game:GetService("RunService"):IsStudio() then
                        warn("Failed to load weapon animation ID(s): " .. assetId)
                    end
                end)

                tableToLoad[i] = animation

            elseif type(v) == "table" then

                LoadAnimationRecursive(i, v, folder)
            end
        end
    end

    -- Create the starting folder
    local startingFolder = Instance.new("Folder", ReplicatedStorage)
    startingFolder.Name = "Weapon_Animations"
    
    -- Preload all animations
    for i, v in module.WeaponAnimations do

        -- Wrap in a coroutine
       LoadAnimationRecursive(i, v, startingFolder)
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
    local function CopyTable(original : table) : table
        local copy = {}
        for k, v in pairs(original) do
            if type(v) == "table" then
                v = CopyTable(v)
            end
            copy[k] = v
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
    local weapon = CopyTable(module.WeaponAnimations[weaponName])
    local weaponAnimationTable = LoadAnimations(self.animator, weapon)
    
    return weaponAnimationTable
end

return module
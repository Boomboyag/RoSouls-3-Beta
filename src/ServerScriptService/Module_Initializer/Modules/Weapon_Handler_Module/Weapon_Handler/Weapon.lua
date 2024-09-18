-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local remoteFolder = replicatedStorage:WaitForChild("Remote")

-- Required scripts
local weaponPrefabs = require(coreFolder:WaitForChild("Weapons"))

-- Create the class
local weapon = {}
weapon.__index = weapon

-- Class constructor
function weapon.new(character, weaponName : string, weaponHand : string)
    local self = setmetatable({}, weapon)

    -- Get the character
    self.character = character

    -- Assign the weapon variables
    self.weaponHand = weaponHand
    self:ChangeWeapon(weaponName, weaponHand)
	
    return self
end

-- Change the weapon into a new one
function weapon:ChangeWeapon(newWeapon : string)

    -- Get the weapon prefab
    local prefab = weaponPrefabs[newWeapon]
    if not prefab then
        warn("Weapon name " .. newWeapon .. " not found!")
        return
    end

    -- Get the weapon type
    self.weaponType = prefab.Type
    
    -- Load the animations
    self.animations1H = self.character:LoadWeaponAnimations(self.weaponType)[self.weaponHand]

    -- Equip the weapon
    self:Equip()
end

-- Equip the weapon
function weapon:Equip()
    
    -- Load the weapon model

    -- Play the idle animation
    local idle : AnimationTrack = self.animations1H["1H_Idle"]
    idle.Priority = Enum.AnimationPriority.Idle
    idle:Play(0.2)
end

return weapon
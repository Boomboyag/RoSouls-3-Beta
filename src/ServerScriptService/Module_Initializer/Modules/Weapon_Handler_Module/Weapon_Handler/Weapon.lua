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

    -- Get the weapon data table
    self.weaponData = weaponPrefabs[weaponName]
    if not self.weaponData then warn("Weapon data for " .. weaponName .. " not found") end

    -- Assign the weapon variables
    self.weaponName = weaponName
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
    self.character:LoadWeaponModel(self.weaponName, self.weaponHand)

    -- Play the idle animation
    local idle : AnimationTrack = self.animations1H["1H_Idle"]
    idle.Priority = self.weaponData.IdlePriority
    idle:Play(0.2)
end

return weapon
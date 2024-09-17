-- Create the class
local weapon = {}
weapon.__index = weapon

-- Class constructor
function weapon.new(character, weaponName : string, weaponHand : string)
    local self = setmetatable({}, weapon)
    self.character = character
    self.weaponHand = weaponHand
    self:ChangeWeapon(weaponName, weaponHand)
	return self
end

-- Change the weapon into a new one
function weapon:ChangeWeapon(newWeapon : string)
    
    -- Load the animations
    self.animations1H = self.character:LoadWeaponAnimations(newWeapon)[self.weaponHand]

    -- Equip the weapon
    self:Equip()
end

-- Equip the weapon
function weapon:Equip()
    
    -- Load the weapon model

    -- Play the idle animation
    self.animations1H["1H_Idle"]:Play()
end

return weapon
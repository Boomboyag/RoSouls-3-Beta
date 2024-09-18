-- Required services
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

-- The init function
function module:Init()

    -- Get the weapons from the server
    local leftHand, rightHand = loadWeapons:InvokeServer()

    -- Make sure the weapons were found properly
    if leftHand and rightHand then
        
        -- Load the right hand weapon
        self.rightHandWeapon = weapon.new(self, rightHand, "Right")
    end
end

return module
-- Required services
local contentProvider = game:GetService("ContentProvider")

local module = {}

module.Name = "Footstep Module"

-- The sound ID's
module.SoundIds = {
	["Bass"] = {
		"rbxassetid://9126748907",
		"rbxassetid://9126748813",
		"rbxassetid://9126748580",
	},
	
	["Carpet"] = {
		"rbxassetid://9126748130",
		"rbxassetid://9126747861",
		"rbxassetid://9126747720",
	},
	
	["Concrete"] = {
		"rbxassetid://9126746167",
		"rbxassetid://9126746098",
		"rbxassetid://9126745995",
	},
	
	["Dirt"] = {
		"rbxassetid://9126744390",
		"rbxassetid://9126744718",
		"rbxassetid://9126744263",
	},
	
	["Glass"] = {
		"rbxassetid://9126742971",
		"rbxassetid://9126742461",
		"rbxassetid://9126742875",
	},
	
	["Grass"] = {
		"rbxassetid://9126742396",
		"rbxassetid://9126741427",
		"rbxassetid://9126742333",
	},
	
	["Gravel"] = {
		"rbxassetid://9126741273",
		"rbxassetid://9126740393",
		"rbxassetid://9126741200",
	},
	
	["Ladder"] = {
		"rbxassetid://9126740217",
		"rbxassetid://9126739039",
		"rbxassetid://9126740133",
	},
	
	["Metal_Auto"] = {
		"rbxassetid://9126739090",
		"rbxassetid://9126738967",
		"rbxassetid://9126738896",
	},
	
	["Metal_Chainlink"] = {
		"rbxassetid://9126738423",
		"rbxassetid://9126737791",
		"rbxassetid://9126738338",
	},
	
	["Metal_Grate"] = {
		"rbxassetid://9126737728",
		"rbxassetid://9126736554",
		"rbxassetid://9126737597",
	},
	
	["Metal_Solid"] = {
		"rbxassetid://9126736470",
		"rbxassetid://9126734921",
		"rbxassetid://9126736274",
	},
	
	["Mud"] = {
		"rbxassetid://9126734842",
		"rbxassetid://9126734314",
		"rbxassetid://9126734778",
	},
	
	["Rubber"] = {
		"rbxassetid://9126734172",
		"rbxassetid://9126733896",
		"rbxassetid://9126734560",
	},
	
	["Sand"] = {
		"rbxassetid://9126733118",
		"rbxassetid://9126733408",
		"rbxassetid://9126733225",
	},
	
	["Snow"] = {
		"rbxassetid://9126732128",
		"rbxassetid://9126731099",
		"rbxassetid://9126732016",
	},
	
	["Tile"] = {
		"rbxassetid://9126730713",
		"rbxassetid://9126730782",
		"rbxassetid://9126731037",
		"rbxassetid://9126730980",
	},
	
	["Wood"] = {
		"rbxassetid://9126931624",
		"rbxassetid://9126931515",
		"rbxassetid://9126931417",
	},
}

-- The material maps
module.MaterialMap = {
	[Enum.Material.Slate] = 		"Concrete",
	[Enum.Material.Concrete] = 		"Concrete",
	[Enum.Material.Brick] = 		"Concrete",
	[Enum.Material.Cobblestone] = 	"Concrete",
	[Enum.Material.Sandstone] =		"Concrete",
	[Enum.Material.Rock] = 			"Concrete",
	[Enum.Material.Basalt] = 		"Concrete",
	[Enum.Material.CrackedLava] = 	"Concrete",
	[Enum.Material.Asphalt] = 		"Concrete",
	[Enum.Material.Limestone] = 	"Concrete",
	[Enum.Material.Pavement] = 		"Concrete",

	[Enum.Material.Plastic] = 		"Tile",
	[Enum.Material.Marble] = 		"Tile",
	[Enum.Material.Neon] = 			"Tile",
	[Enum.Material.Granite] = 		"Tile",
	
	[Enum.Material.Wood] = 			"Wood",
	[Enum.Material.WoodPlanks] = 	"Wood",
	
	[Enum.Material.CorrodedMetal] = "Metal_Auto",
	
	[Enum.Material.DiamondPlate] = 	"Metal_Solid",
	[Enum.Material.Metal] = 		"Metal_Solid",
	
	[Enum.Material.Ground] = 		"Dirt",
	
	[Enum.Material.Grass] = 		"Grass",
	[Enum.Material.LeafyGrass] = 	"Grass",
	
	[Enum.Material.Fabric] = 		"Carpet",
	
	[Enum.Material.Pebble] = 		"Gravel",
	
	[Enum.Material.Snow] = 			"Snow",
	[Enum.Material.Ice] = 			"Snow",
	[Enum.Material.Glacier] = 		"Snow",
	
	[Enum.Material.Sand] = 			"Sand",
	[Enum.Material.Salt] = 			"Sand",

	[Enum.Material.Glass] = 		"Glass",
	
	[Enum.Material.SmoothPlastic] = "Rubber",
	[Enum.Material.ForceField] = 	"Rubber",
	[Enum.Material.Foil] = 			"Rubber",
	
	[Enum.Material.Mud] = 			"Mud",
}

-- Footstep settings
module.stats = {
	volume = 0.1
}
local stats = module.stats
local materialMap = module.MaterialMap
local ids = module.SoundIds

-- The init function
function module:Init()

    -- Load the sound IDs
    module:LoadSounds()
end

-- Load all sounds
function module:LoadSounds()
    
    -- Preload all sounds
    for i, v in module.SoundIds do

        -- Wrap to minimize time spent
        task.spawn(function()
            
            -- Preload the ID's
            contentProvider:PreloadAsync(v, function(assetId, assetFetchStatus)

                -- Warn the user if the load failed
                if assetFetchStatus == Enum.AssetFetchStatus.Failure then
                    warn("Failed to load Footstep ID(s): " .. assetId)
                end
            end)
        end)
    end
end

-- This function returns a table from the MaterialMap given the material.
function module:GetTableFromMaterial(material) : table

    -- Check if the given material is a string
    if typeof(material) == "string" then
        material = Enum.Material[material]
    end

    -- Return the table
    return ids[materialMap[material]]
end

-- This function is a primitive "pick randomly from table" function.
function module:GetRandomSound(table) : string
	return table[math.random(#table)]
end

-- The function to be called
function module:CallFunction(foot : string)

    -- Make sure we can step
    if not self.characterStats.footstepsEnabled or not foot then
        return
    end

    local grounded, material = self:CheckGround()

    -- Make sure we are grounded
    if not grounded then return end

    -- Find and play the desired sound
    local soundID = module:GetRandomSound(module:GetTableFromMaterial(material))
    self:SpawnSound(soundID, stats.volume)

    return 0
end

return module
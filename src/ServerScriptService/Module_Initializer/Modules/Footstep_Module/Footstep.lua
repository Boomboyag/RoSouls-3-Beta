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
		"rbxassetid://9126748691",
		"rbxassetid://9126748431",
		"rbxassetid://9126748324",
		"rbxassetid://9126748239",
		"rbxassetid://9126748185",
		"rbxassetid://9126748045",
		"rbxassetid://9126747958"
	},
	
	["Carpet"] = {
		"rbxassetid://9126748130",
		"rbxassetid://9126747861",
		"rbxassetid://9126747720",
		"rbxassetid://9126747529",
		"rbxassetid://9126747412",
		"rbxassetid://9126747283",
		"rbxassetid://9126746732",
		"rbxassetid://9126746837",
		"rbxassetid://9126747132",
		"rbxassetid://9126746984",
		"rbxassetid://9126746598",
		"rbxassetid://9126746481",
		"rbxassetid://9126746371",
		"rbxassetid://9126746291"
	},
	
	["Concrete"] = {
		"rbxassetid://9126746167",
		"rbxassetid://9126746098",
		"rbxassetid://9126745995",
		"rbxassetid://9126745877",
		"rbxassetid://9126745774",
		"rbxassetid://9126745574",
		"rbxassetid://9126745336",
		"rbxassetid://9126745241",
		"rbxassetid://9126745445",
		"rbxassetid://9126745052",
		"rbxassetid://9126745141",
		"rbxassetid://9126745676",
		"rbxassetid://9126744969",
		"rbxassetid://9126744894",
		"rbxassetid://9126744639",
		"rbxassetid://9126744789",
		"rbxassetid://9126744481"
	},
	
	["Dirt"] = {
		"rbxassetid://9126744390",
		"rbxassetid://9126744718",
		"rbxassetid://9126744263",
		"rbxassetid://9126744157",
		"rbxassetid://9126744066",
		"rbxassetid://9126744009",
		"rbxassetid://9126743796",
		"rbxassetid://9126743938",
		"rbxassetid://9126743711",
		"rbxassetid://9126743879",
		"rbxassetid://9126743613",
		"rbxassetid://9126743481",
		"rbxassetid://9126743338",
		"rbxassetid://9126743086"
	},
	
	["Glass"] = {
		"rbxassetid://9126742971",
		"rbxassetid://9126742461",
		"rbxassetid://9126742875",
		"rbxassetid://9126742786",
		"rbxassetid://9126743193",
		"rbxassetid://9126742680",
		"rbxassetid://9126742582",
		"rbxassetid://9126742510"
	},
	
	["Grass"] = {
		"rbxassetid://9126742396",
		"rbxassetid://9126741427",
		"rbxassetid://9126742333",
		"rbxassetid://9126742215",
		"rbxassetid://9126742271",
		"rbxassetid://9126742031",
		"rbxassetid://9126741934",
		"rbxassetid://9126742105",
		"rbxassetid://9126741826",
		"rbxassetid://9126741594",
		"rbxassetid://9126741512",
		"rbxassetid://9126741741",
		"rbxassetid://9126741674"
	},
	
	["Gravel"] = {
		"rbxassetid://9126741273",
		"rbxassetid://9126740393",
		"rbxassetid://9126741200",
		"rbxassetid://9126741051",
		"rbxassetid://9126741128",
		"rbxassetid://9126740951",
		"rbxassetid://9126740802",
		"rbxassetid://9126740724",
		"rbxassetid://9126740524",
		"rbxassetid://9126740623"
	},
	
	["Ladder"] = {
		"rbxassetid://9126740217",
		"rbxassetid://9126739039",
		"rbxassetid://9126740133",
		"rbxassetid://9126739947",
		"rbxassetid://9126740044",
		"rbxassetid://9126740305",
		"rbxassetid://9126739834",
		"rbxassetid://9126739622",
		"rbxassetid://9126739505",
		"rbxassetid://9126739406",
		"rbxassetid://9126739332",
		"rbxassetid://9126739229"
	},
	
	["Metal_Auto"] = {
		"rbxassetid://9126739090",
		"rbxassetid://9126738967",
		"rbxassetid://9126738896",
		"rbxassetid://9126738732",
		"rbxassetid://9126738543",
		"rbxassetid://9126738634"
	},
	
	["Metal_Chainlink"] = {
		"rbxassetid://9126738423",
		"rbxassetid://9126737791",
		"rbxassetid://9126738338",
		"rbxassetid://9126738197",
		"rbxassetid://9126738113",
		"rbxassetid://9126738032",
		"rbxassetid://9126737943",
		"rbxassetid://9126737853"
	},
	
	["Metal_Grate"] = {
		"rbxassetid://9126737728",
		"rbxassetid://9126736554",
		"rbxassetid://9126737597",
		"rbxassetid://9126737668",
		"rbxassetid://9126737506",
		"rbxassetid://9126737412",
		"rbxassetid://9126737315",
		"rbxassetid://9126737212",
		"rbxassetid://9126736947",
		"rbxassetid://9126737081",
		"rbxassetid://9126736863",
		"rbxassetid://9126736806",
		"rbxassetid://9126736642",
		"rbxassetid://9126736721"
	},
	
	["Metal_Solid"] = {
		"rbxassetid://9126736470",
		"rbxassetid://9126734921",
		"rbxassetid://9126736274",
		"rbxassetid://9126736354",
		"rbxassetid://9126736186",
		"rbxassetid://9126736049",
		"rbxassetid://9126735913",
		"rbxassetid://9126735734",
		"rbxassetid://9126735546",
		"rbxassetid://9126735474",
		"rbxassetid://9126735265",
		"rbxassetid://9126735374",
		"rbxassetid://9126735161",
		"rbxassetid://9126735028",
		"rbxassetid://9126735089",
		"rbxassetid://9126734972"
	},
	
	["Mud"] = {
		"rbxassetid://9126734842",
		"rbxassetid://9126734314",
		"rbxassetid://9126734778",
		"rbxassetid://9126734710",
		"rbxassetid://9126734613",
		"rbxassetid://9126734499",
		"rbxassetid://9126734365",
		"rbxassetid://9126734432",
		"rbxassetid://9126734244"
	},
	
	["Rubber"] = {
		"rbxassetid://9126734172",
		"rbxassetid://9126733896",
		"rbxassetid://9126734560",
		"rbxassetid://9126734010",
		"rbxassetid://9126733324",
		"rbxassetid://9126733766",
		"rbxassetid://9126733614",
		"rbxassetid://9126733493"
	},
	
	["Sand"] = {
		"rbxassetid://9126733118",
		"rbxassetid://9126733408",
		"rbxassetid://9126733225",
		"rbxassetid://9126732675",
		"rbxassetid://9126732571",
		"rbxassetid://9126732962",
		"rbxassetid://9126732962",
		"rbxassetid://9126732457",
		"rbxassetid://9126732862",
		"rbxassetid://9126732776",
		"rbxassetid://9126732334",
		"rbxassetid://9126732253"
	},
	
	["Snow"] = {
		"rbxassetid://9126732128",
		"rbxassetid://9126731099",
		"rbxassetid://9126732016",
		"rbxassetid://9126731951",
		"rbxassetid://9126731877",
		"rbxassetid://9126731632",
		"rbxassetid://9126731493",
		"rbxassetid://9126731343",
		"rbxassetid://9126731790",
		"rbxassetid://9126731243",
		"rbxassetid://9126731169",
		"rbxassetid://9126730861"
	},
	
	["Tile"] = {
		"rbxassetid://9126730713",
		"rbxassetid://9126730782",
		"rbxassetid://9126731037",
		"rbxassetid://9126730980",
		"rbxassetid://9126730651",
		"rbxassetid://9126730563",
		"rbxassetid://9126730279",
		"rbxassetid://9126730403",
		"rbxassetid://9126730056",
		"rbxassetid://9126730172",
		"rbxassetid://9126729836",
		"rbxassetid://9126730472",
		"rbxassetid://9126729938",
		"rbxassetid://9126729706"
	},
	
	["Wood"] = {
		"rbxassetid://9126931624",
		"rbxassetid://9126931515",
		"rbxassetid://9126931417",
		"rbxassetid://9126931322",
		"rbxassetid://9126931699",
		"rbxassetid://9126931235",
		"rbxassetid://9126931169",
		"rbxassetid://9126931026",
		"rbxassetid://9126930953",
		"rbxassetid://9126930885",
		"rbxassetid://9126930789",
		"rbxassetid://9126930647",
		"rbxassetid://9126930516",
		"rbxassetid://9126930598",
		"rbxassetid://9126930718"
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
	volume = 0.05
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

    local grounded, material, instance = self:CheckGround()

    -- Make sure we are grounded
    if not grounded then return end

    -- Find and play the desired sound
    local soundID = module:GetRandomSound(module:GetTableFromMaterial(material))
    self:SpawnSound(soundID, stats.volume)

    -- A function to make a color darker
	local function MakeDarker(color)
		local H, S, V = color:ToHSV()
		
		V = math.clamp(V - 0.05, 0, 1)
		
		return Color3.fromHSV(H, S, V)
	end

    -- Get the color of the ground
	local particleColor = instance == workspace.Terrain and workspace.Terrain:GetMaterialColor(material) or instance.Color
    particleColor = ColorSequence.new(MakeDarker(particleColor or Color3.new(1, 1, 1)))

    -- Emit the particle
    self:SpawnVFX("Footstep_Particle", foot == "Left" and "LeftStep" or "RightStep", particleColor)

    return 0
end

return module
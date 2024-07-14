-- Class creation
local footstepHandler = {}
footstepHandler.__index = footstepHandler

-- The sound ID's
footstepHandler.SoundIds = {
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
footstepHandler.MaterialMap = {
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

-- Class constructor
function footstepHandler.new(humanoidRootPart)
	local self = setmetatable({}, footstepHandler)
	
    self.currentAnimation = nil
    self.humanoidRootPart = humanoidRootPart
    self.savedAnimations = {}

	-- || PARTICLES ||

	-- Check if the character has the required vfx
	self.particlesEnabled = true
	self.leftParticle = humanoidRootPart:FindFirstChild("LeftStep")
	self.rightParticle = humanoidRootPart:FindFirstChild("RightStep")
	if not self.leftParticle or not self.rightParticle then self.particlesEnabled = false end

	-- Get the particle emitter
	if self.particlesEnabled then

		self.leftParticle = self.leftParticle.ParticleEmitter
		self.rightParticle = self.rightParticle.ParticleEmitter

		-- Set the particle transparency
		local particleTransparency = NumberSequence.new(0.8, 1.1)
		
		self.leftParticle.Transparency = particleTransparency
		self.rightParticle.Transparency = particleTransparency
	end

    -- || SETTINGS ||

    self.enabled = true
    local volume = 0.1

    -- Create the sound folder if it doesn't already exist
    if not script:FindFirstChild("Footstep Sounds") then
        
        self.soundFolder = Instance.new("Folder", script)
        self.soundFolder.Name = "Footstep Sounds"
        for i, v in footstepHandler.SoundIds do

            local folder = Instance.new("Folder", self.soundFolder)
            folder.Name = i
            for ii, vv in v do
                local sound = Instance.new("Sound")
                sound.SoundId = vv
                sound.Volume = volume
                sound.Parent = folder
            end
        end
    else

        self.soundFolder = script:FindFirstChild("Footstep Sounds")
    end

	return self
end

-- Sync footsteps to an animation
function footstepHandler:SyncSteps(animation : AnimationTrack)
    
    self.currentAnimation = animation
    
    -- Check if we are already watching this animation
    if not table.find(self.savedAnimations, animation) then
        
        table.insert(self.savedAnimations, animation)
    else
        return
    end

    animation:GetMarkerReachedSignal("Footstep"):Connect(function(foot)

        if self.currentAnimation ~= animation then return end

        self:Step(foot)
    end)
end

-- The footstep function
function footstepHandler:Step(foot)
    
    -- Check if the character is grounded
    local grounded, instance, material = self:CheckGround()

    if grounded and self.enabled then
        
		-- Play the desired sound
        local sound = self:GetRandomSound(self:GetTableFromMaterial(material))
        sound:Play()

		-- Check if we want to emit the particle
		if foot and self.particlesEnabled then

			-- Emit the particle
			self:EmitParticle(foot, instance, material)
		end
    end
end

-- The particle function
function footstepHandler:EmitParticle(foot, instance, material)
	
	-- Get the color of the ground
	local particleColor = instance == workspace.Terrain and workspace.Terrain:GetMaterialColor(material) or instance.Color

	-- A function to make a color darker
	local function MakeDarker(color)
		local H, S, V = color:ToHSV()
		
		V = math.clamp(V - 0.05, 0, 1)
		
		return Color3.fromHSV(H, S, V)
	end

	particleColor = MakeDarker(particleColor)
	
	-- Set the particle color and emit
	if foot == "Left" then
		self.leftParticle.Color = ColorSequence.new(particleColor)
		self.leftParticle:Emit()
	else
		self.rightParticle.Color = ColorSequence.new(particleColor)
		self.rightParticle:Emit()
	end
end

-- Check if the character is grounded
function footstepHandler:CheckGround()
	
	-- The raycast origin and direction
	local origin = self.humanoidRootPart.CFrame.Position
	local direction = Vector3.new(0, -4, 0)

	-- The raycast parameters
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {self.humanoidRootPart.Parent}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	-- The raycast
	local raycastResult = workspace:Raycast(origin, direction, raycastParams)

	-- Check if the raycast hit anything
	if raycastResult then
		
		-- Return trua and provide the material
		return true, raycastResult.Instance, raycastResult.Material
	else

		-- Return false
		return false
	end
end

-- This function returns a table from the MaterialMap given the material.
function footstepHandler:GetTableFromMaterial(material)

    -- Check if the given material is a string
    if typeof(material) == "string" then
        material = Enum.Material[material]
    end

    -- Return the table
    return self.soundFolder[footstepHandler.MaterialMap[material]]:GetChildren()
end

-- This function is a primitive "pick randomly from table" function.
function footstepHandler:GetRandomSound(table)
	return table[math.random(#table)]
end

return footstepHandler
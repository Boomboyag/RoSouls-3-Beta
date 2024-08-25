-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")
local collectionService = game:GetService("CollectionService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local moduleFolder = coreFolder:WaitForChild("Object").Character.Modules
local playerFolder = moduleFolder.Parent.Player.Required_Modules

-- The action module
local actionModule = script:WaitForChild("Ragdoll")

-- Specific CFrame's made for the best looking Ragdoll
local attachmentCFrames = {
	["Neck"] = {CFrame.new(0, 1, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1), CFrame.new(0, -0.5, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1)},
	["Left Shoulder"] = {CFrame.new(-1.3, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1), CFrame.new(0.2, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1)},
	["Right Shoulder"] = {CFrame.new(1.3, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.2, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
	["Left Hip"] = {CFrame.new(-0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1)},
	["Right Hip"] = {CFrame.new(0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1)},
}

-- Names of ragdoll-related instances
local ragdollInstanceNames = {
	["RagdollAttachment"] = true,
	["RagdollConstraint"] = true,
	["ColliderPart"] = true,
}

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
    remoteEvent.Name = "Ragdoll_Remote"
    local bindableEvent = Instance.new("BindableEvent")
    bindableEvent.Name = "Ragdoll_Bindable"

    -- Change the network onwer of the character
    local function SetNetworkOwner(player : Player, character : Model)
    
        -- Get all the parts in the character
        for i, v in character:GetChildren() do
            
            -- Set the part's newtowk owner to the player
            if v:IsA("BasePart") then
                v:SetNetworkOwner(player)
            end
        end
    end

    -- Change the character's current ragdoll state
    local function ChangeRagdollState(character, value : boolean)

        -- Make sure the character exists
        if not character then return end

        -- Start the ragdoll
        if value then
            
            -- Check to make sure the character isn't already ragdolled
            if collectionService:HasTag(character, "Ragdoll") then return end

            -- Start the ragdoll
            module:ReplaceJoints(character)
           
            -- Add the ragdoll tag
            collectionService:AddTag(character, "Ragdoll")
            return
        end

        -- Stop the ragdoll
        if not value then
            
             -- Check to make sure the character is ragdolled
             if not collectionService:HasTag(character, "Ragdoll") then return end

             -- Stop the ragdoll
            module:ResetJoints(character)

            -- Remove the ragdoll tag
            collectionService:RemoveTag(character, "Ragdoll")
            return
        end
    end

    -- Fired when the remote event is called
    remoteEvent.OnServerEvent:Connect(function(player, value)
        
        -- Get the character
        local character = player.Character

        -- Change the character state and set it's network owner
        ChangeRagdollState(character, value)
        SetNetworkOwner(player, character)
    end)

    -- Fired when the bindable event is fired
    bindableEvent.Event:Connect(function(character, value)
        ChangeRagdollState(character, value)
    end)

    -- Get the remote folder
    local remoteFolder = replicatedStorage:FindFirstChild("Remote")
    if not remoteFolder then
        
        remoteFolder = Instance.new("Folder")
        remoteFolder.Name = "Remote"
        remoteFolder.Parent = replicatedStorage
    end
    remoteEvent.Parent = remoteFolder

    -- Get the bindable folder
    local bindableFolder = replicatedStorage:FindFirstChild("Bindable")
    if not bindableFolder then
        
        bindableFolder = Instance.new("Folder")
        bindableFolder.Name = "Bindable"
        bindableFolder.Parent = replicatedStorage
    end
    bindableEvent.Parent = bindableFolder
end

-- || RAGDOLL FUNCTIONS ||

-- Create proper collisions between parts in character
function module:CreateColliderPart(part: BasePart)
	if not part then return end
	local rp = Instance.new("Part")
	rp.Name = "ColliderPart"
	rp.Size = part.Size/1.7
	rp.Massless = true			
	rp.CFrame = part.CFrame
	rp.Transparency = 1

	local wc = Instance.new("WeldConstraint")
	wc.Part0 = rp
	wc.Part1 = part

	wc.Parent = rp
	rp.Parent = part
end

-- Converts Motor6D's into BallSocketConstraints
function module:ReplaceJoints(character)
	for _, motor: Motor6D in pairs(character:GetDescendants()) do
		if motor:IsA("Motor6D") then
			if not attachmentCFrames[motor.Name] then return end
			motor.Enabled = false;
			local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
			a0.CFrame = attachmentCFrames[motor.Name][1]
			a1.CFrame = attachmentCFrames[motor.Name][2]

			a0.Name = "RagdollAttachment"
			a1.Name = "RagdollAttachment"

			module:CreateColliderPart(motor.Part1)

			local b = Instance.new("BallSocketConstraint")
			b.Attachment0 = a0
			b.Attachment1 = a1
			b.Name = "RagdollConstraint"

			b.Radius = 0.15
			b.LimitsEnabled = true
			b.TwistLimitsEnabled = false
			b.MaxFrictionTorque = 0
			b.Restitution = 0
			b.UpperAngle = 90
			b.TwistLowerAngle = -45
			b.TwistUpperAngle = 45

			if motor.Name == "Neck" then
				b.TwistLimitsEnabled = true
				b.UpperAngle = 45
				b.TwistLowerAngle = -70
				b.TwistUpperAngle = 70
			end

			a0.Parent = motor.Part0
			a1.Parent = motor.Part1
			b.Parent = motor.Parent
		end
	end
end

-- Destroys all Ragdoll made instances and re-enables the Motor6D's
function module:ResetJoints(character)
	for _, instance in pairs(character:GetDescendants()) do
		if ragdollInstanceNames[instance.Name] then
			instance:Destroy()
		end

		if instance:IsA("Motor6D") then
			instance.Enabled = true;
		end
	end
end

return module
-- Required services
local collectionService = game:GetService("CollectionService")

local module = {}

module.Name = "Character Tracker Module"

-- Functions that are allowed to be called
local allowedFunctions = {

	-- The footstep function
	["Footstep"] = function(self, character, foot)
		self:Footstep(foot, character)
	end,

	-- The vfx function
	["SpawnVFX"] = function(self, character, name, timesToEmit, timeBetweenEmits, attachment)
		
		-- Emit the particle
		for i = 1, timesToEmit, 1 do

			self:VFX(name, nil, attachment, character)
			task.wait(timeBetweenEmits)
		end
	end,

	-- The sound function
	["SpawnSound"] = function(self, character, id : string, volume : number, attachment : string)
		self:SpawnSound(id, volume, attachment, character)
	end
}

local trackedCharacters = setmetatable({}, {__mode = "kv"})

-- The init function
function module:Init()

    -- Track all registered characters
    module.GetTaggedCharacters(self)
end

function module:GetTaggedCharacters()

	-- Get all tagged characters
	local characters : table = collectionService:GetTagged("Character")

	-- Track all found characters (excluding the local client)
	for _, character in pairs(characters) do

		-- Make sure the character is not our own
		if character ~= self.model then module.TrackCharacter(self, character) end
	end

	collectionService:GetInstanceAddedSignal("Character"):Connect(function(character)

		-- Make sure the character is not our own
		if character ~= self.model then module.TrackCharacter(self, character) end
	end)

	collectionService:GetInstanceRemovedSignal("Character"):Connect(function(character)
		module.StopTrackingCharacter(self, character)
	end)
end

function module:TrackCharacter(character : Instance)
	
	-- Add the character to the table
	trackedCharacters[character] = {}
	local charTable : table = trackedCharacters[character]

	-- Get the animator
	charTable.animator = character:FindFirstChild("Animator", true)
	local animator : Animator = charTable.animator

	-- Animation marker reached
	charTable.animationAddedConnection = animator.AnimationPlayed:Connect(function(animationTrack : AnimationTrack)

		-- Make sure the animation is new
		if not charTable[animationTrack.Animation.AnimationId] then
			
			-- Establish the connection
			charTable[animationTrack.Animation.AnimationId] = animationTrack:GetMarkerReachedSignal("Call_Function"):Connect(function(paramString)
			
				-- Find and call the function
				local func, parameters = self:GetFunctionFromAnimationEvent(paramString)
				if allowedFunctions[func] then
					allowedFunctions[func](self, character, table.unpack(parameters))
				end
			end)
		end
	end)
end

-- Stop tracking a character
function module:StopTrackingCharacter(character : Instance)
	
	-- Get the character table
	local charTable = trackedCharacters[character]
	if not charTable then return end

	-- Disconnect all connections
	for i, v in pairs(charTable) do
		
		if typeof(v) == "RBXScriptConnection" then
			v:Disconnect()
		end
		v = nil
	end

	trackedCharacters[character] = nil
end

return module
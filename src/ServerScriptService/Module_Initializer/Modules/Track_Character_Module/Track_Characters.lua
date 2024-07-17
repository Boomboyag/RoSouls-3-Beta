-- Required services
local collectionService = game:GetService("CollectionService")

local module = {}

module.Name = "Character Tracker Module"

-- The init function
function module:Init()

    -- Track all registered characters
    module:GetTaggedCharacters()
end

function module:GetTaggedCharacters()
	
	-- Get all tagged characters
	local characters : table = collectionService:GetTagged("Character")

	-- Track all found characters (excluding the local client)
	for _, character in pairs(characters) do
		
		-- Make sure the character is not our own
		if character ~= self.model then self:TrackCharacter(character) end
	end

	collectionService:GetInstanceAddedSignal("Character"):Connect(function(character)
		
		-- Make sure the character is not our own
		if character ~= self.model then self:TrackCharacter(character) end
	end)
end

function module:TrackCharacter(character : Instance)
	
end

return module
-- Class creation
local playerStats = {}
playerStats.__index = playerStats

-- Class constructor
function playerStats.new(newPlayerTable, player)
	local self = {}
	
	-- || CAMERA SETTINGS ||
	
	self.cameraStiffness = 40
	self.cameraOffset = Vector3.new(0, 2, 0)
	
	self.cameraFollow = player.torso
	self.cameraSubject = player.cameraBlock
	
	-- Set the metatable and return
	setmetatable(self, playerStats)
	return self
end

return playerStats

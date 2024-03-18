-- Class creation
local playerStats = {}
playerStats.__index = playerStats

-- Class constructor
function playerStats.new(newPlayerTable, player)
	local self = {}
	
	-- || CAMERA SETTINGS ||

	self.cameraFollowsTarget = true
	self.cameraStiffness = 40

	self.cameraOffset = Vector3.new(0, 2, 0)

	self.minimumZoom = 12
	self.maximumZoom = 12

	self.fieldOfView = 70
	
	self.cameraFollow = nil
	self.cameraSubject = nil

	-- || MOUSE SETTINGS ||

	self.mouseMovesCamera = true
	
	-- Set the metatable and return
	setmetatable(self, playerStats)
	return self
end

return playerStats

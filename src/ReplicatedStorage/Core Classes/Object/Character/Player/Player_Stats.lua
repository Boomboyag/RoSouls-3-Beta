-- Class creation
local playerStats = {}
playerStats.__index = playerStats

-- Class constructor
function playerStats.new(newPlayerTable, player)
	local self = {}
	
	-- || CAMERA SETTINGS ||

	-- Movement relative to camera
	self.movementRelativeToCamera = true

	-- Whether or not the camera follow's it's current target
	self.cameraFollowsTarget = true
	self.cameraStiffness = 40

	-- The camera's offset from it's current target
	self.cameraOffset = Vector3.new(0, 1.75, 0)

	-- Zoom distance
	self.minimumZoom = 12
	self.maximumZoom = 12

	-- The field of view
	self.fieldOfView = 70
	
	self.cameraFollow = nil
	self.cameraSubject = nil

	-- The amount and speed of the camera sway on both axes
	self.cameraSwayAmount = Vector2.new(0.35, 0.35)
	self.cameraSwaySpeed = Vector2.new(0.7, 0.7)

	-- || MOUSE SETTINGS ||

	-- The camera's mouse sensitivity
	self.mouseSensitivity = 0.3

	-- Whether or not the mouse moves the camera positon
	self.mouseMovesCamera = true
	
	-- Set the metatable and return
	setmetatable(self, playerStats)
	return self
end

return playerStats

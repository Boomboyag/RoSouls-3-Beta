-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = coreFolder:WaitForChild("Object"):WaitForChild("Character")

-- Required scripts
local cameraTypes = require(coreFolder:WaitForChild("Enum").CameraType)
local cursorTypes = require(coreFolder:WaitForChild("Enum").CursorType)
local lockOnTypes = require(coreFolder:WaitForChild("Enum").LockOnType)

-- Class creation
local playerStats = {}
playerStats.__index = playerStats

-- Class constructor
function playerStats.new(newPlayerTable, player)
	local self = {}
	
	-- || CAMERA SETTINGS ||

	-- The camera state
	self.cameraType = cameraTypes.Default
	self.cameraLockOnType = lockOnTypes.Full

	-- Whether or not the camera is in first person
	self.firstPersonCamera = false

	-- Movement relative to camera
	self.movementRelativeToCamera = false

	-- Whether or not the camera follow's it's current target
	self.cameraFollowsTarget = true
	self.cameraStiffness = 30

	-- The camera's offset from it's current target
	self.cameraOffset = Vector3.new(0, 1.75, 0)

	-- Zoom distance
	self.cameraZoomDistance = 12

	-- The field of view
	self.fieldOfView = 70
	self.fieldOfViewEffectsAllowed = true
	
	self.cameraBlockFollow = nil
	self.cameraSubject = nil

	self.cameraTarget = nil

	-- The amount and speed of the camera sway on both axes
	self.cameraSwayAmount = Vector2.new(0.35, 0.35)
	self.cameraSwaySpeed = Vector2.new(0.7, 0.7)

	-- || MOUSE SETTINGS ||

	-- The mouse states
	self.cursorType = cursorTypes.Locked

	-- The camera's mouse sensitivity
	self.mouseSensitivity = 0.3

	-- Whether or not the mouse moves the camera positon
	self.mouseMovesCamera = true
	
	-- Set the metatable and return
	setmetatable(self, playerStats)
	return self
end

return playerStats

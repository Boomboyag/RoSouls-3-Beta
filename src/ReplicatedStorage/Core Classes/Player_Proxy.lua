-- Required services
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")

-- Required scripts
local player = require(script.Parent:WaitForChild("Object").Character.Player)
local Enum = require(script.Parent:WaitForChild("Enum"))

-- Class creation
local playerProxy = {}
playerProxy.__index = playerProxy
playerProxy.__tostring = function(playerProxy)

	-- Return the name of the object
	return playerProxy.name
end
setmetatable(playerProxy, player)

-- Class constructor
function playerProxy.new(newPlayer)

	-- Inherit the object class
	local self = setmetatable({}, playerProxy)
	self = player.new(newPlayer)
	
	-- The crouch function
	local Crouch = function(newPlayer, wantToCrouch, oppositeOfCurrent)
		self:Crouch(wantToCrouch, oppositeOfCurrent)
	end
	
	-- The slow walk function
	local SlowWalk = function(newPlayer, wantToSprint, oppositeOfCurrent)
		self:SlowWalk(wantToSprint, oppositeOfCurrent)
	end
	
	-- The sprint function
	local Sprint = function(newPlayer, wantToSprint, oppositeOfCurrent)
		self:Sprint(wantToSprint, oppositeOfCurrent)
	end
	
	-- The roll function
	local Roll = function(newPlayer, forceRoll : Vector3)
		self:Roll(forceRoll)
	end
	
	-- THe destroy function
	local Destroy = function()
		self:Destroy()
	end

	-- Return the table
	return {
		
		-- || FUNCTIONS ||
		Crouch = Crouch,
		SlowWalk = SlowWalk,
		Sprint = Sprint,
		Roll = Roll,
		Destroy = Destroy,
		
		-- || EVENTS ||
		GetPlayerStat = self.GetStat,
		PlayerStatChanged = self.CharacterStatChanged,
		
		PlayerStateChanged = self.CharacterStateChanged,
		HumanoidStateChanged = self.HumanoidStateChanged,
		
		EffectAdded = self.EffectAdded,
		EffectRemoved = self.EffectRemoved
	}
end

return playerProxy
-- Required scripts
local player = require(script.Parent:WaitForChild("Object").Character.Player)

-- Class creation
local playerProxy = {}

-- Class constructor
function playerProxy.new(newPlayer)

	-- Inherit the object class
	local self = player.new(newPlayer)
	
	-- The crouch function
	local Crouch = function(newPlayer, wantToCrouch, oppositeOfCurrent)
		self:Crouch(wantToCrouch, oppositeOfCurrent)
	end
	
	-- The sprint function
	local Sprint = function(newPlayer, wantToSprint, oppositeOfCurrent)
		self:Sprint(wantToSprint, oppositeOfCurrent)
	end
	
	-- The roll function
	local Roll = function(newPlayer, forceRoll : Vector3)
		self:Roll(forceRoll)
	end

	-- The lock on function
	local Lock_On = function(newPlayer, targetDirection)
		self:Lock_On(nil, nil, targetDirection)
	end

	-- The unlock / lock mouse function
	local ChangeMouseLock = function(newPlayer)
		
		self:ChangeMouseLock()
	end
	
	-- THe destroy function
	local Destroy = function()
		self:Destroy()
	end

	-- Return the table
	return {
		
		-- || FUNCTIONS ||
		Crouch = Crouch,
		Sprint = Sprint,
		Roll = Roll,
		Lock_On = Lock_On,
		Destroy = Destroy,

		ChangeMouseLock = ChangeMouseLock,
		
		-- || EVENTS ||
		GetPlayerStat = self.GetStat,
		PlayerStatChanged = self.CharacterStatChanged,
		
		PlayerStateChanged = self.CharacterStateChanged,
		HumanoidStateChanged = self.HumanoidStateChanged,
		
		EffectAdded = self.EffectAdded,
		EffectRemoved = self.EffectRemoved,

		StaminaChanged = self.StaminaChanged,
		HealthChanged = self.HealthChanged
	}
end

return playerProxy
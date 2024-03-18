-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local characterModule = coreFolder:WaitForChild("Object"):WaitForChild("Character")
local characterEffectPrefabs = require(characterModule:WaitForChild("Character_Effects").Effect_Prefabs)

local enums = {}

-- || OBJECT ENUMS ||

-- The type of object
enums.ObjectType = {
	Humanoid = {1, Name = "Humanoid"},
	Tool = {2, Name = "Tool"},
	Interactable = {3, Name = "Interactable"},
	Clothing = {3, Name = "Clothing"}
}

-- || CHARACTER ENUMS ||

-- The character's control type
enums.ControlType = {
	Full = {1, Name = "Full"},
	None = {2, Name = "None"}
}

-- The character's state
enums.CharacterState = {
	
	-- The default state
	Default = {
		
		-- State index
		1, 
		
		-- The name of the state
		Name = "Default",
		
		-- Function called when the state begins
		StateBeganFunction = function(character)
			
		end,
		
		-- Function called when the state ends
		StateEndedFunction = function(character)

		end,
	},
	
	-- The sitting state
	Sitting = {
		
		-- State index
		4, 

		-- The name of the state
		Name = "Sitting",

		-- Function called when the state begins
		StateBeganFunction = function(character)

			-- Apply the effects to the character
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)

			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
		end,
	},
	
	-- The sprinting state
	Falling = {

		-- State index
		5, 

		-- The name of the state
		Name = "Falling",

		-- Function called when the state begins
		StateBeganFunction = function(character)
			
			character.fallTime = tick()
			character.fallDistance = character.humanoidRootPart.CFrame.Position.Y

			-- Apply the effects to the character
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			character:AddEffect(characterEffectPrefabs.Fall_Walkspeed)
			character:AddEffect(characterEffectPrefabs.Disable_Character_Tilt)
			character:AddEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed)
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)
		
			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
			character:RemoveEffect(characterEffectPrefabs.Fall_Walkspeed.Name)
			character:RemoveEffect(characterEffectPrefabs.Disable_Character_Tilt.Name)
			character:RemoveEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed.Name)
			
			-- Check if the character needs to play the fall animation
			character:CheckFall(tick())
			character.fallTime = 0
		end,
	},

	-- The climbing state
	Climbing = {
		
		-- State index
		6, 

		-- The name of the state
		Name = "Climbing",

		-- Function called when the state begins
		StateBeganFunction = function(character)

			-- Apply the effects to the character
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			character:AddEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed)
			character:AddEffect(characterEffectPrefabs.Disable_Character_Tilt)
			
			-- Change the walkspeed
			character:AddEffect(characterEffectPrefabs.Climb_Walkspeed)
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)

			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
			character:RemoveEffect(characterEffectPrefabs.Disable_Character_Tilt.Name)
			character:RemoveEffect(characterEffectPrefabs.Movement_Effects_Core_Animation_Speed.Name)
			
			-- Revert the walkspeed
			character:RemoveEffect(characterEffectPrefabs.Climb_Walkspeed.Name)
		end,
	},
	
	-- The death state
	Dead = {

		-- State index
		7, 

		-- The name of the state
		Name = "Dead",

		-- Function called when the state begins
		StateBeganFunction = function(character)

			-- Apply the effects to the character
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)

			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
		end,
	},

	-- The locked state
	Locked = {
		
		-- State index
		8, 

		-- The name of the state
		Name = "Locked",

		-- Function called when the state begins
		StateBeganFunction = function(character)
			
			-- Lock the player
			character:ChangeControlType(enums.ControlType.None, Vector3.zero)

			-- Apply the effects to the character
			character:AddEffect(characterEffectPrefabs.Walkspeed_0)
			
			-- Disable all other actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)
			
			-- Unlock the player
			character:ChangeControlType(enums.ControlType.Full)

			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Walkspeed_0.Name)
			
			-- Allow the player to use actions again
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
		end,
	}
}

-- The type of action
enums.ActionType = {
	
	Movement = {
		1,
		Name = "Movement"
	},
	
	Attack = {
		2,
		Name = "Attack"
	},
	
	Damage = {
		3,
		Name = "Damage"
	},	
}

-- What operator to use on an action prerequisite
enums.ActionPrerequisiteOperator = {
	
	Equals = {

		1, 

		Name = "Equals",

		Check = function(a, b)
			
			return a == b
		end,
	},
	
	LessThan = {

		1, 

		Name = "Less Than",

		Check = function(a, b)

			return a < b
		end,
	},
	
	GreaterThan = {

		1, 

		Name = "Greater Than",

		Check = function(a, b)

			return a > b
		end,
	},
	
	LessThanOrEqual = {

		1, 

		Name = "Less Than or Equal to",

		Check = function(a, b)

			return a <= b
		end,
	},

	GreaterThanOrEqual = {

		1, 

		Name = "Greater Than or Equal to",

		Check = function(a, b)

			return a >= b
		end,
	},	
}

-- || PLAYER ENUMS ||

enums.CustomCameraType = {
	
	Default = {
		
		1,
		
		Name = "Default",
	},
	
	Locked = {

		2,

		Name = "Locked",
	},
}

enums.CustomCursorType = {
	
	Unlocked = {

		1,

		Name = "Unlocked",

		StateBeganFunction = function(player)
			
			-- Unlock the cursor
			userInputService.MouseBehavior = Enum.MouseBehavior.Default

			-- Show the cursor
			userInputService.MouseIconEnabled = true
		end,
	},

	Locked = {

		2,

		Name = "Locked",

		StateBeganFunction = function(player)
			
			-- Lock the cursor
			userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter

			-- Hide the cursor
			userInputService.MouseIconEnabled = false
		end,
	},
}

return setmetatable(enums, {__index = Enum});
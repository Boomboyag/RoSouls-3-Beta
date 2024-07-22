-- Required services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local characterStates = require(coreFolder:WaitForChild("Enum").CharacterStates)

local humanoidStateChangedFunctions = {

	-- The character is walking or idle
	[Enum.HumanoidStateType.Running] = function(character)
		
		if character.characterState ~= characterStates.Locked then
			
			-- Change the current state
			character.characterState = characterStates.Default
		end

		-- Check if the character is moving
		if character.humanoid.MoveDirection.Magnitude > 0.01 then

			-- Change the animation to the walking track
			character.characterStats.currentCoreAnimation = character.coreAnimations["Walking"]

			-- Let the character know it's moving
			if not character.isMoving then character.isMoving = true end
		else

			-- Change the animation to the idle
			character.characterStats.currentCoreAnimation = character.coreAnimations["Idle"]

			-- Let the character know it's idle
			if character.isMoving then character.isMoving = false end
		end
	end,

	-- The character is ragdolled
	[Enum.HumanoidStateType.Ragdoll] = function(character)
		
		-- Change the current state
		character.characterState = characterStates.Ragdoll
	end,

	-- The character is getting up
	[Enum.HumanoidStateType.GettingUp] = function(character)
		
		-- Change the current state
		character.characterState = characterStates.Default
	end,

	-- The chracter is falling
	[Enum.HumanoidStateType.Freefall] = function(character)

		-- Change the animation to the falling track
		character.characterStats.currentCoreAnimation = character.coreAnimations["Falling"]

		-- Change the current state
		character.characterState = characterStates.Falling
	end,

	-- The character has landed
	[Enum.HumanoidStateType.Landed] = function(character)

		-- Change the current state back to default (if player was falling)
		character.characterState = (character.characterState == characterStates.Falling) and characterStates.Default or character.characterState
	end,

	-- The character is jumping
	[Enum.HumanoidStateType.Jumping] = function(character)

		-- Change the animation to the jump track
		character.characterStats.currentCoreAnimation = character.coreAnimations["Jumping"]
	end,

	-- The character is sitting
	[Enum.HumanoidStateType.Seated] = function(character)

		-- Change the current state
		character.characterState = characterStates.Sitting
	end,

	-- The character is climbing
	[Enum.HumanoidStateType.Climbing] = function(character)

		-- Change the current state
		character.characterState = characterStates.Climbing

		-- Change the animation to the falling track
		character.characterStats.currentCoreAnimation = character.coreAnimations["Climbing"]
	end,

	-- The character is dead
	[Enum.HumanoidStateType.Dead] = function(character)

		-- Change the current state
		character.characterState = characterStates.Dead
	end,
}

return humanoidStateChangedFunctions

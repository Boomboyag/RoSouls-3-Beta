-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = coreFolder:WaitForChild("Object"):WaitForChild("Character")

-- Required scripts
local object = require(coreFolder:WaitForChild("Object"))
local Enum = require(coreFolder:WaitForChild("Enum"))
local characterStatsSheet = require(characterFolder:WaitForChild("Stats"))
local animationModule = require(characterFolder:WaitForChild("Animations"))
local rootMotionModule = require(characterFolder:WaitForChild("Animations"):WaitForChild("RootMotion"))
local effectModule = require(characterFolder:WaitForChild("Character_Effects"))
local effectPrefabs = require(characterFolder:WaitForChild("Character_Effects"):WaitForChild("Effect_Prefabs"))
local actionModule = require(characterFolder:WaitForChild("Character_Actions"))
local actionPrefabs = require(characterFolder:WaitForChild("Character_Actions"):WaitForChild("Action_Prefabs"))

local humanoidStateChangedFunctions = {

	-- The character is walking or idle
	[Enum.HumanoidStateType.Running] = function(character)
		
		if character.characterState ~= Enum.CharacterState.Locked then
			
			-- Change the current state
			character.characterState = Enum.CharacterState.Default
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

	-- The chracter is falling
	[Enum.HumanoidStateType.Freefall] = function(character)

		-- Change the animation to the falling track
		character.characterStats.currentCoreAnimation = character.coreAnimations["Falling"]

		-- Change the current state
		character.characterState = Enum.CharacterState.Falling
	end,

	-- The character has landed
	[Enum.HumanoidStateType.Landed] = function(character)

		-- Change the current state back to default (if player was falling)
		character.characterState = (character.characterState == Enum.CharacterState.Falling) and Enum.CharacterState.Default or character.characterState
	end,

	-- The character is jumping
	[Enum.HumanoidStateType.Jumping] = function(character)

		-- Change the animation to the jump track
		character.characterStats.currentCoreAnimation = character.coreAnimations["Jumping"]
	end,

	-- The character is sitting
	[Enum.HumanoidStateType.Seated] = function(character)

		-- Change the current state
		character.characterState = Enum.CharacterState.Sitting
	end,

	-- The character is climbing
	[Enum.HumanoidStateType.Climbing] = function(character)

		-- Change the current state
		character.characterState = Enum.CharacterState.Climbing

		-- Change the animation to the falling track
		character.characterStats.currentCoreAnimation = character.coreAnimations["Climbing"]
	end,

	-- The character is dead
	[Enum.HumanoidStateType.Dead] = function(character)

		-- Let the character know it's dead
		character.alive = false

		-- Change the current state
		character.characterState = Enum.CharacterState.Dead
	end,
}

return humanoidStateChangedFunctions

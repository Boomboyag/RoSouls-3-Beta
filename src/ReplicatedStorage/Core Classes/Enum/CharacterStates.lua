-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local characterModule = coreFolder:WaitForChild("Object"):WaitForChild("Character")
local playerModule = characterModule:WaitForChild("Player")
local characterEffectPrefabs = require(characterModule:WaitForChild("Character_Effects").Effect_Prefabs)
local playerEffectPrefabs = require(playerModule:WaitForChild("Player_Effect_Prefabs"))

local movementType = require(script.Parent.MovementType)
local controlType = require(script.Parent.ControlType)
local cameraLockOnTypes = require(script.Parent.LockOnType)

local states = {

	Name = "CharacterState",

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

		-- Function called when the state begins on the client
		StateBeganFunctionPlayer = function(player)
			
			player.playerStats.cameraLockOnType = cameraLockOnTypes.Full
		end,
		
		-- Function called when the state ends on the client
		StateEndedFunctionPlayer = function(player)

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

		-- Function called when the state begins on the client
		StateBeganFunctionPlayer = function(player)
			
		end,
		
		-- Function called when the state ends on the client
		StateEndedFunctionPlayer = function(player)

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

		-- Function called when the state begins on the client
		StateBeganFunctionPlayer = function(player)
			
		end,
		
		-- Function called when the state ends on the client
		StateEndedFunctionPlayer = function(player)

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

		-- Function called when the state begins on the client
		StateBeganFunctionPlayer = function(player)
			
			-- Stop the player from moving to look in the camera's direction
			player:AddEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera)
		end,
		
		-- Function called when the state ends on the client
		StateEndedFunctionPlayer = function(player)

			-- Allow the player to look in the camera's direction
			player:RemoveEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera.Name)
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

			-- Let the character know it's dead
			character.alive = false

			-- Return to the default movement state
			character.movementType = movementType.Default

			-- Fire the event
			character.CharacterDied:Fire()

			-- Lock the character in place
			character:ChangeControlType(controlType.None, Vector3.zero)

			-- Stop the character from moving
			character:AddEffect(characterEffectPrefabs.Walkspeed_0)

			-- Disable all actions, states, & effects
			character:AddEffect(characterEffectPrefabs.Disable_State_Change)
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			character.characterStats.canAddEffects = false

			-- Play the death animation if grounded
			if character:CheckGround() then
				
				-- Anchor the character
				character.humanoidRootPart.Anchored = true

				-- Play the death animation
				local deathAnimation = character.coreAnimations.Death
				character:ChangeActionAnimation(deathAnimation, 0.1, Enum.AnimationPriority.Action4, false, 1)

				-- Unanchor the character after the animation playes
				coroutine.wrap(function()
					task.wait(deathAnimation.Length - 0.5)
					deathAnimation:AdjustSpeed(0)
					character.humanoidRootPart.Anchored = false
				end)()
			end
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)

			-- One does not come back from death
			warn("THE HEAVY IS NOT DEAD?")
		end,

		-- Function called when the state begins on the client
		StateBeganFunctionPlayer = function(player)

			-- Required line of code (do not remove)
			print("THE HEAVY IS DEAD")

			-- Stop the camera block from following the player
			player.playerStats.cameraFollowsTarget = false
			player.playerStats.cameraLockOnType = cameraLockOnTypes.None
		end,
		
		-- Function called when the state ends on the client
		StateEndedFunctionPlayer = function(player)

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
			
			-- Lock the character in place
			character:ChangeControlType(controlType.None, Vector3.zero)

			-- Apply the effects to the character
			character:AddEffect(characterEffectPrefabs.Walkspeed_0)
			
			-- Disable all other actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)
			
			-- Unlock the player
			character:ChangeControlType(controlType.Full)

			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Walkspeed_0.Name)
			
			-- Allow the player to use actions again
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
		end,

		-- Function called when the state begins on the client
		StateBeganFunctionPlayer = function(player)
			
		end,
		
		-- Function called when the state ends on the client
		StateEndedFunctionPlayer = function(player)

		end,
	}
}

return states
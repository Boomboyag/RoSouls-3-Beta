-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local characterEffectPrefabs = require(script.Parent.Parent:WaitForChild("Character_Effects").Effect_Prefabs)
local playerEffectPrefabs = require(script.Parent.Parent.Player:WaitForChild("Player_Effect_Prefabs"))
local Enum = require(coreFolder:WaitForChild("Enum"))

-- The table of effects
local effectTable = {

	-- || BLANK ||

	["Blank"] = {

		-- || REQUIRED VARIABLES ||

		-- The name of the effect
		["Name"] = "Blank",
		
		-- The type of action
		["Type"] = Enum.ActionType.None,
		
		-- If this action can be queued
		["CanQueue"] = false,
		["MaxQueueTime"] = 0,
		["QueueWhenOveridden"] = false,

		-- If the action can be canceled
		["CanCancel"] = true,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
			
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)

		end,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = function(character)

		end,
	
		-- The function performed on the PLAYER when the action begins
		["ActionBeginFunction_PLAYER"] = function(player)

		end,

		-- The function performed on the PLAYER when the action is finished
		["ActionEndFunction_PLAYER"] = function(player)

		end,
	},	
	
	-- || DAMAGE IMPACTS ||

	["Light_Damage_Impact"] = {

		-- || REQUIRED VARIABLES ||

		-- The name of the effect
		["Name"] = "Light_Damage_Impact",
		
		-- The type of action
		["Type"] = Enum.ActionType.None,
		
		-- If this action can be queued
		["CanQueue"] = false,
		["MaxQueueTime"] = 0,
		["QueueWhenOveridden"] = false,

		-- If the action can be canceled
		["CanCancel"] = false,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
			
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)

			-- Disable actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			
			-- Lock the character
			character.characterState = Enum.CharacterState.Locked
			character:AddEffect(characterEffectPrefabs.Disable_Auto_Rotate)

			-- Get the animation folder
			local stunAnims = character.animations.stunAnimations["Light"]

			-- Get a random stun animation
			local randomStun = stunAnims[math.random(#stunAnims)]
			character:ChangeActionAnimation(randomStun, 0.1, Enum.AnimationPriority.Action, false, 1)

			local animationEnded = false
			local connection
			connection = character.ActionAnimationStopped.Event:Connect(function()

				animationEnded = true
				connection:Disconnect()
			end)

			-- Wait for the animation to finish
			repeat
				task.wait()
			until animationEnded

			-- Unlock the character
			character.characterState = Enum.CharacterState.Default
			character:RemoveEffect(characterEffectPrefabs.Disable_Auto_Rotate.Name)

			task.wait(0.1)
			
			-- Allow the player to use actions again
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
			character.characterStats.currentAction = nil
		end,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = function(character)

		end,
	
		-- The function performed on the PLAYER when the action begins
		["ActionBeginFunction_PLAYER"] = function(player)

		end,

		-- The function performed on the PLAYER when the action is finished
		["ActionEndFunction_PLAYER"] = function(player)

		end,
	},

	["Heavy_Damage_Impact"] = {

		-- || REQUIRED VARIABLES ||

		-- The name of the effect
		["Name"] = "Heavy_Damage_Impact",
		
		-- The type of action
		["Type"] = Enum.ActionType.None,
		
		-- If this action can be queued
		["CanQueue"] = false,
		["MaxQueueTime"] = 0,
		["QueueWhenOveridden"] = false,

		-- If the action can be canceled
		["CanCancel"] = false,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
			
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)

			-- Disable actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			
			-- Lock the character
			character.characterState = Enum.CharacterState.Locked
			character:AddEffect(characterEffectPrefabs.Disable_Auto_Rotate)

			-- Get the animation folder
			local stunAnims = character.animations.stunAnimations["Heavy"]

			-- Get a random stun animation
			local randomStun = stunAnims[math.random(#stunAnims)]
			character:ChangeActionAnimation(randomStun, 0.1, Enum.AnimationPriority.Action, false, 1)

			local animationEnded = false
			local connection
			connection = character.ActionAnimationStopped.Event:Connect(function()

				animationEnded = true
				connection:Disconnect()
			end)

			-- Wait for the animation to finish
			repeat
				task.wait()
			until animationEnded

			-- Unlock the character
			character.characterState = Enum.CharacterState.Default
			character:RemoveEffect(characterEffectPrefabs.Disable_Auto_Rotate.Name)

			task.wait(0.1)
			
			-- Allow the player to use actions again
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
			character.characterStats.currentAction = nil
		end,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = function(character)

		end,
	
		-- The function performed on the PLAYER when the action begins
		["ActionBeginFunction_PLAYER"] = function(player)

		end,

		-- The function performed on the PLAYER when the action is finished
		["ActionEndFunction_PLAYER"] = function(player)

		end,
	},

	-- || MISC ||

	["Land"] = {

		-- || REQUIRED VARIABLES ||

		-- The name of the effect
		["Name"] = "Landed",

		-- The type of action
		["Type"] = Enum.ActionType.Damage,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)

			-- Disable all other actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			
			-- Apply the effect to the character
			character:AddEffect(characterEffectPrefabs.Slow_Walkspeed)

			-- Change the animation
			local landAnimation = character.animations.landAnimation
			character:ChangeActionAnimation(landAnimation, 0.1, Enum.AnimationPriority.Action, false, character.fallAnimationSpeed)

			local animationEnded = false
			local connection
			connection = character.ActionAnimationStopped.Event:Connect(function()

				animationEnded = true
				connection:Disconnect()
			end)

			-- Wait for the animation to finish
			repeat task.wait()
			until animationEnded

			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Slow_Walkspeed.Name)

			-- Allow the player to use actions again
			character.characterStats.currentAction = nil
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
		end,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = function(character)


		end,
	
		-- The function performed on the PLAYER when the action begins
		["ActionBeginFunction_PLAYER"] = function(player)

			-- Create the shake multiplier
			local shakeMultiplier = player.fallAnimationSpeed - 0.5

			-- Shake the camera
			player.cameraHandler:ShakeCamera(5 * shakeMultiplier, 10 * shakeMultiplier, 0, 1)
		end,

		-- The function performed on the PLAYER when the action is finished
		["ActionEndFunction_PLAYER"] = function(player)

		end,
	},
}

return effectTable

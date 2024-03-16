-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local characterEffectPrefabs = require(script.Parent.Parent:WaitForChild("Character_Effects").Effect_Prefabs)
local Enum = require(coreFolder:WaitForChild("Enum"))

-- The table of effects
local effectTable = {
	
	-- || PLAYER MOVEMENT ||
	
	["Sprint"] = {

		-- || REQUIRED VARIABLES ||

		-- The name of the effect
		["Name"] = "Sprint",
		
		-- The type of action
		["Type"] = Enum.ActionType.Movement,
		
		-- If this action can be queued
		["CanQueue"] = true,
		["MaxQueueTime"] = -1,
		["QueueWhenOveridden"] = true,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
			["canSprint"] = {true, Enum.ActionPrerequisiteOperator.Equals},
			["currentStamina"] = {0, Enum.ActionPrerequisiteOperator.GreaterThan},
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)

			-- Change the animation
			local sprintAnimation = character.animations.sprintAnimation
			character:ChangeActionAnimation(sprintAnimation, 0.2, Enum.AnimationPriority.Action, true, 0.8)
			
			-- Drain the stamina
			character:RemoveEffect(characterEffectPrefabs.Stamina_Regen.Name)
			character:AddEffect(characterEffectPrefabs.Sprint_Stamina_Drain)
			
			-- Apply the effect to the character
			character:AddEffect(characterEffectPrefabs.Sprint_Walkspeed)
			character:AddEffect(characterEffectPrefabs.Sprint_Character_Tilt)
			character:AddEffect(characterEffectPrefabs.Disable_Climbing)
		end,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = function(character)

			character:ChangeActionAnimation(nil, 0.1)
			
			-- Regen the stamina
			character:RemoveEffect(characterEffectPrefabs.Sprint_Stamina_Drain.Name)
			
			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Sprint_Walkspeed.Name)
			character:RemoveEffect(characterEffectPrefabs.Sprint_Character_Tilt.Name)
			character:RemoveEffect(characterEffectPrefabs.Disable_Climbing.Name)
		end,
	},
	
	-- || ROLLING ||
	
	["Roll"] = {

		-- || REQUIRED VARIABLES ||

		-- The name of the effect
		["Name"] = "Roll",

		-- The type of action
		["Type"] = Enum.ActionType.Movement,
		
		-- If this action can be queued
		["CanQueue"] = true,
		["MaxQueueTime"] = 1.5,
		["QueueWhenOveridden"] = false,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
			["canRoll"] = {true, Enum.ActionPrerequisiteOperator.Equals},
			["currentStamina"] = {0, Enum.ActionPrerequisiteOperator.GreaterThan},
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)
			
			-- Lock the character
			character.characterState = Enum.CharacterState.Locked
			character:AddEffect(characterEffectPrefabs.Disable_Auto_Rotate)
			
			-- Drain the stamina
			character:RemoveEffect(characterEffectPrefabs.Stamina_Regen.Name)
			character:AddEffect(characterEffectPrefabs.Roll_Stamina_Drain)
			
			-- Change the animation
			local rollAnimation = character.animations.rollAnimation
			character:ChangeActionAnimation(rollAnimation, 0.1, Enum.AnimationPriority.Action, false, 1)
			
			-- Create a new linear velocity to move the charatcer via physics
			local rollVelocity = Instance.new("LinearVelocity", character.rollAttatchment)
			rollVelocity.Attachment0 = character.rollAttatchment
			rollVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
			rollVelocity.MaxForce = 1300
			rollVelocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
			rollVelocity.LineDirection = character.humanoidRootPart.CFrame.LookVector
			rollVelocity.LineVelocity = character.characterStats.rollVelocity

			local animationEnded = false
			local connection
			connection = character.ActionAnimationStopped.Event:Connect(function()

				animationEnded = true
				connection:Disconnect()
			end)

			-- Wait for the animation to finish
			repeat
				task.wait(0.1)

				rollVelocity.LineVelocity *= 0.8

			until animationEnded
			
			-- Unlock the character
			character.characterState = Enum.CharacterState.Default
			character:RemoveEffect(characterEffectPrefabs.Disable_Auto_Rotate.Name)
			
			-- Allow the player to use actions again
			character.characterStats.currentAction = nil
			
			-- Destroy the roll velocity
			rollVelocity:Destroy()
		end,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = function(character)

		end,
	},	
	
	["Backstep"] = {

		-- || REQUIRED VARIABLES ||

		-- The name of the effect
		["Name"] = "Roll",

		-- The type of action
		["Type"] = Enum.ActionType.Movement,
		
		-- If this action can be queued
		["CanQueue"] = true,
		["MaxQueueTime"] = 1.5,
		["QueueWhenOveridden"] = false,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
			["canRoll"] = {true, Enum.ActionPrerequisiteOperator.Equals},
			["currentStamina"] = {0, Enum.ActionPrerequisiteOperator.GreaterThan},
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)

			-- Lock the character
			character.characterState = Enum.CharacterState.Locked
			character:AddEffect(characterEffectPrefabs.Disable_Auto_Rotate)

			-- Drain the stamina
			character:RemoveEffect(characterEffectPrefabs.Stamina_Regen.Name)
			character:AddEffect(characterEffectPrefabs.Roll_Stamina_Drain)

			-- Disable all other actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)

			-- Change the animation
			local rollAnimation = character.animations.backstepAnimation
			character:ChangeActionAnimation(rollAnimation, 0.1, Enum.AnimationPriority.Action, false, 1)

			-- Create a new linear velocity to move the charatcer via physics
			local rollVelocity = Instance.new("LinearVelocity", character.rollAttatchment)
			rollVelocity.Attachment0 = character.rollAttatchment
			rollVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
			rollVelocity.MaxForce = 1000
			rollVelocity.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
			rollVelocity.LineDirection = character.humanoidRootPart.CFrame.LookVector
			rollVelocity.LineVelocity = -character.characterStats.backStepVelocity

			local animationEnded = false
			local connection
			connection = character.ActionAnimationStopped.Event:Connect(function()

				animationEnded = true
				connection:Disconnect()
			end)

			-- Wait for the animation to finish
			repeat
				task.wait(0.1)

				rollVelocity.LineVelocity *= 0.8

			until animationEnded

			-- Unlock the character
			character.characterState = Enum.CharacterState.Default
			character:RemoveEffect(characterEffectPrefabs.Disable_Auto_Rotate.Name)
			
			-- Allow the player to use actions again
			character.characterStats.currentAction = nil
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)

			-- Destroy the roll velocity
			rollVelocity:Destroy()
		end,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = function(character)


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
	},
}

return effectTable

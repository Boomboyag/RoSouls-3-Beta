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

		-- If the action can be canceled
		["CanCancel"] = true,

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
			character.footstepHandler:SyncSteps(sprintAnimation)
			
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

			-- Check if we can smoothly fade out the animation (if still moving)
			if character:GetWorldMoveDirection() ~= Vector3.zero then
				
				-- Slowly stop the animation
				character:ChangeActionAnimation(nil, 0.3)
			else

				-- Quickly stop the animation
				character:ChangeActionAnimation(nil, 0.1)
			end
			character.footstepHandler:SyncSteps(character.coreAnimations.Walking)

			-- Regen the stamina
			character:RemoveEffect(characterEffectPrefabs.Sprint_Stamina_Drain.Name)
			
			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Sprint_Walkspeed.Name)
			character:RemoveEffect(characterEffectPrefabs.Sprint_Character_Tilt.Name)
			character:RemoveEffect(characterEffectPrefabs.Disable_Climbing.Name)
		end,
	
		-- The function performed on the PLAYER when the action begins
		["ActionBeginFunction_PLAYER"] = function(player)

			-- Increase the fov
			player:AddEffect(playerEffectPrefabs.Sprint_Camera_FOV)

			-- Change the camera sway
			player:AddEffect(playerEffectPrefabs.Sprint_Camera_Sway_Speed)
			player:AddEffect(playerEffectPrefabs.Sprint_Camera_Sway_Amount)

			-- Stop the movement being relative to the camera
			player:AddEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera)
		end,

		-- The function performed on the PLAYER when the action is finished
		["ActionEndFunction_PLAYER"] = function(player)

			-- Reset the FOV
			player:RemoveEffect(playerEffectPrefabs.Sprint_Camera_FOV.Name)

			-- Reset the camera sway
			player:RemoveEffect(playerEffectPrefabs.Sprint_Camera_Sway_Speed.Name)
			player:RemoveEffect(playerEffectPrefabs.Sprint_Camera_Sway_Amount.Name)

			-- Allow the movement being relative to the camera
			player:RemoveEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera.Name)
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

		-- If the action can be canceled
		["CanCancel"] = false,

		-- Variables that must be a certain value for the action to trigger
		["Prerequisites"] = {
			["canRoll"] = {true, Enum.ActionPrerequisiteOperator.Equals},
			["currentStamina"] = {0, Enum.ActionPrerequisiteOperator.GreaterThan},
		},

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = function(character)

			-- Get the character's movement vector
			local movementVector = character:GetWorldMoveDirection()
			local newCFrame = CFrame.new(character.humanoidRootPart.CFrame.Position, character.humanoidRootPart.CFrame.Position + movementVector) 

			-- Disable actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			
			-- Lock the character
			character.characterState = Enum.CharacterState.Locked
			character:AddEffect(characterEffectPrefabs.Disable_Auto_Rotate)
			
			-- Drain the stamina
			character:RemoveEffect(characterEffectPrefabs.Stamina_Regen.Name)
			character:AddEffect(characterEffectPrefabs.Roll_Stamina_Drain)
			
			-- Change the animation
			local rollAnimation = character.animations.rollAnimation
			character:ChangeActionAnimation(rollAnimation, 0.1, Enum.AnimationPriority.Action, false, 1)

			-- Create an align orientation to make the character look in their movement direction
			local rootOrientationAttachment = Instance.new("AlignOrientation", character.humanoidRootPart)
			rootOrientationAttachment.Name = "Roll Orientation"
			rootOrientationAttachment.Mode = Enum.OrientationAlignmentMode.OneAttachment
			rootOrientationAttachment.Attachment0 = character.rootAttachment
			rootOrientationAttachment.Responsiveness = 150
			
			-- Make the humanoid look in their movement direction via the orientation attachment
			rootOrientationAttachment.CFrame = newCFrame
			
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

			-- Destroy the roll velocity
			rootOrientationAttachment:Destroy()
			rollVelocity:Destroy()

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

			-- Stop the movement being relative to the camera
			player:AddEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera)

			-- Wait for the animation to finish
			task.wait(player.animations.rollAnimation.length)

			-- Allow the movement being relative to the camera
			player:RemoveEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera.Name)
		end,

		-- The function performed on the PLAYER when the action is finished
		["ActionEndFunction_PLAYER"] = function(player)

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

		-- If the action can be canceled
		["CanCancel"] = false,

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

		-- The function performed on the PLAYER when the action begins
		["ActionBeginFunction_PLAYER"] = function(player)

			-- Stop the movement being relative to the camera
			player:AddEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera)

			-- Wait for the animation to finish
			task.wait(player.animations.backstepAnimation.length)

			-- Allow the movement being relative to the camera
			player:RemoveEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera.Name)
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

-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

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

local statsChangedFunctions = {
	
	-- || CHARATCER STATE ||

	-- The character's state has been changed
	["characterState"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time or if the values are the same
			if (not oldValue and not startup) or (oldValue == newValue) then return end

			-- Check if tha character can change states (disregarded if dead)
			if not character.characterStats.canChangeState and newValue ~= Enum.CharacterState.Dead then

				-- Warn the console
				warn("Character cannot change state, it is disabled!")

				newValue = oldValue
				return
			end

			-- End the current state
			if oldValue then oldValue.StateEndedFunction(character) end

			-- Begin the new state
			newValue.StateBeganFunction(character)

			-- Fire the event
			character.CharacterStateChanged:Fire(oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
		
		return newValue
	end,

	-- || ACTIONS ||

	-- The character's current action has been changed
	["currentAction"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if startup or (newValue == oldValue) then return end

			-- Check if character ations are enabled
			if not character.characterStats.actionsEnabled then
				
				newValue = oldValue
				return
			else
				
				-- Make sure the values aren't the same
				if oldValue == newValue then return end
				
				-- Check if the prerequisites are met
				if newValue and not newValue:CheckPrerequisites(character.characterStats) then 
					
					newValue = oldValue
					return
				end
				
				-- Fire the event
				character.NewAction:Fire(oldValue, newValue)
			end
		end) 

		if not success then
			warn(response)
		end

		if newValue == nil then
			
			newValue = character.actionPrefabs.Blank
		end
		
		return newValue	
	end,

	-- The character's current action has been changed
	["actionsEnabled"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time or if the values are the same
			if startup then return end

			-- Check if character ations are disabled
			if newValue == false then

				-- Make sure the current action can be canceled
				if character.characterStats.currentAction and not character.characterStats.currentAction.canCancel then 
					--warn(character.characterStats.currentAction.name .. " cannot be canceled.")
					return 
				end

				-- Check if the current action needs to be removed
				character.characterStats.currentAction = nil
			end
		end) 

		if not success then
			warn(response)
		end

		return newValue	
	end,

	-- || MOVEMENT ||

	-- The type of movement the character is using
	["movementType"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time or if the values are the same
			if (not oldValue and not startup) or (oldValue == newValue) then return end

			-- End the current state
			if oldValue then oldValue.EndFunction(character) end

			-- Begin the new state
			newValue.StartFunction(character)

			-- Fire the event
			character.CharacterStatChanged:Fire("movementType", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
		
		return newValue
	end,

	-- The direction the character is moving in has changed
	["movementDirection"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time or if the values are the same
			if (not oldValue and not startup) or (oldValue == newValue) then return end

			-- Check if the speed of the current playing animation needs to be changed
			if character.characterStats.coreAnimationInfluencedByCharacterMovement then

				-- Change the speed of the character's current core animation
				character:ChangeCoreAnimationSpeed(newValue.Magnitude)
			end
		end) 

		if not success then
			warn(response)
		end
	end,

	-- The current speed has been changed
	["currentWalkSpeed"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if not oldValue and not startup then return end

			-- Make sure we can tween it
			if newValue ~= 0 then
				
				-- Tween to the new value
				local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine)
				local tween = tweenService:Create(character.humanoid, TweenInfo, {WalkSpeed = newValue})
				tween:Play() 
			else
			
				-- Set the speed of the character
				character.humanoid.WalkSpeed = newValue
			end

			-- Fire the event
			character.CharacterStatChanged:Fire("currentWalkSpeed", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,

	-- The character is moving (or not)
	["isMoving"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if oldValue == nil and not startup then return end

			-- Check what the new value is
			if newValue == true then

				-- Change the animation to the walking track
				character.characterStats.currentCoreAnimation = character.coreAnimations["Walking"]

				-- Remove the disable sprint effect
				character:RemoveEffect(effectPrefabs.Disable_Sprint.Name)
			else

				-- Change the animation to the idle
				character.characterStats.currentCoreAnimation = character.coreAnimations["Idle"]
				
				-- Add the disable sprint effect
				character:AddEffect(effectPrefabs.Disable_Sprint)
			end
		end) 

		if not success then
			warn(response)
		end
	end,

	-- || HEALTH ||

	-- The current stamina has been changed
	["currentHealth"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if not oldValue and not startup then return end

			-- Check if the character is dead
			if newValue <= 0 then

				-- Update the character's current state
				character.characterState = Enum.CharacterState.Dead
			end

			-- Check if the character needs to play a reaction
			if oldValue and newValue < oldValue then
				character:DamageReaction(oldValue - newValue)
			end

			-- Fire the event
			character.CharacterStatChanged:Fire("currentHealth", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,

	-- || STAMINA ||

	-- The current stamina has been changed
	["currentStamina"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if not oldValue and not startup then return end

			-- Check if stamina has just gone below zero
			if oldValue and oldValue > 0 and newValue <= 0 then

				-- Fire the event
				character.StaminaDrained:Fire(oldValue, newValue)
			end

			-- Check if the player has reached their maximum
			if newValue > character.characterStats.maxStamina then

				newValue = 100

				-- Remove any stamina regen
				character:RemoveEffect(effectPrefabs.Stamina_Regen.Name)
			end

			-- Check if we can regenerate stamina
			coroutine.wrap(function()

				if not oldValue then return end

				-- Check if the stamina is being drained
				if oldValue < newValue then return end

				task.wait(character.characterStats.staminaRegenDelay)

				if character.characterStats.currentStamina == newValue then

					-- Add the stamina regen
					character:AddEffect(character.effectPrefabs.Stamina_Regen)
				end
			end)()

			-- Fire the event
			character.CharacterStatChanged:Fire("currentStamina", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end

		return newValue	
	end,

	-- The amount of stamina being added per tick
	["staminaRegenRate"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if not oldValue and not startup then return end
			
			-- Make sure the value is different
			if newValue == oldValue then return end

			-- Change the chracter's stamina regen effect
			character.effectPrefabs.Stamina_Regen = {
				
				-- The name of the effect
				["Name"] = "Stamina_Regen",

				-- The priority of the effect (the lower the number the sooner it is called)
				["Priority"] = 10,

				-- The data the effect will modify (must be within the 'Stats' module script of character)
				["DataToModify"] = "currentStamina",

				-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
				["EffectTickAmount"] = 0,

				-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
				["TimeBetweenEffectTick"] = 0.1,

				-- The function performed on the DataToModify (takes the DataToModify as an argument)
				["EffectFunction"] = function(input)

					return input + newValue
				end,

				-- || OPTIONAL VARIABLES ||

				-- Whether or not the effects can stack
				["Can_Stack"] = false,

				-- Whether or not the effect resets the DataToModify value when finished (default is false)
				["ResetDataWhenDone"] = false,
			}

			-- Find all current regen effectsa
			local count = character:FindEffectAmount("Stamina_Regen")

			-- Check if the character needs to have it's regen effect re-applied
			if count > 0 then
				
				-- Replace all regen effects
				for i = 1, count, 1 do
					
					-- Remove the effect
					character:RemoveEffect("Stamina_Regen")
				end
				
				-- Replace all regen effects
				for i = 1, count, 1 do

					-- Add the updated version
					character:AddEffect(character.effectPrefabs.Stamina_Regen)
				end
			end

			-- Fire the event
			character.CharacterStatChanged:Fire("staminaRegenRate", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end

		return newValue	
	end,

	-- || BOOLEANS ||

	-- Whether or not the character can sprint
	["canSprint"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if oldValue == nil and not startup then return end

			-- Fire the event
			character.CharacterStatChanged:Fire("canSprint", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,

	-- Whether or not the character can jump
	["canJump"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if oldValue == nil and not startup then return end

			-- Check if the character can no longer jump
			if newValue == false then

				-- Disable the jump
				character.humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			else

				-- Enable the jump
				character.humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			end

			-- Fire the event
			character.CharacterStatChanged:Fire("canJump", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,

	-- Whether or not the character can climb
	["canClimb"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if oldValue == nil and not startup then return end

			-- Check if the character can no longer jump
			if newValue == false then

				-- Disable the jump
				character.humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
			else

				-- Enable the jump
				character.humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			end

			-- Fire the event
			character.CharacterStatChanged:Fire("canClimb", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,

	-- Whether or not the character will automatically rotate in the movement direction
	["autoRotate"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if oldValue == nil and not startup then return end

			-- Set the humanoid variable
			character.humanoid.AutoRotate = newValue

			-- Fire the event
			character.CharacterStatChanged:Fire("autoRotate", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,

	-- Whether or not the footstep sound plays
	["footstepsEnabled"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if oldValue == nil and not startup then return end

			-- Set the humanoid variable
			character.footstepHandler.enabled = newValue

			-- Fire the event
			character.CharacterStatChanged:Fire("footstepsEnabled", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,

	-- || ANIMATION ||

	-- The current core animation has been changed
	["currentCoreAnimation"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			if not oldValue and not startup then return end

			-- Call the corresponding function
			character:ChangeCoreAnimation(newValue, oldValue, 0.1)

			-- Fire the event
			character.CharacterStatChanged:Fire("currentCoreAnimation", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,	
	
	["coreAnimationInfluencedByCharacterMovement"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			if startup then return end

			-- Check if the animation is influenced
			if newValue == true then
				
				-- Change the speed
				character:ChangeCoreAnimationSpeed(character.movementDirection.Magnitude)
			else
				
				-- Reset the speed
				character:ChangeCoreAnimationSpeed(nil, true)
			end

			-- Fire the event
			character.CharacterStatChanged:Fire("coreAnimationInfluencedByCharacterMovement", oldValue, newValue)
		end) 

		if not success then
			warn(response)
		end
	end,	
}

return statsChangedFunctions

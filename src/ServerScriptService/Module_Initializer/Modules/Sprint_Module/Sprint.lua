-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = replicatedStorage["Core Classes"].Object.Character

-- Required scripts
local actionModule = require(characterFolder:WaitForChild("Character_Actions"))
local characterEffectPrefabs = require(characterFolder.Character_Effects.Effect_Prefabs)
local playerEffectPrefabs = require(characterFolder.Player.Player_Effect_Prefabs)
local Enum = require(coreFolder:WaitForChild("Enum"))

local module = {}

module.Name = "Sprint Module"

-- Sprint effects
local effects = {

    -- || CHARACTER EFFECTS ||

    ["Sprint_Walkspeed"] = {

		-- The name of the effect
		["Name"] = "Sprint_Walkspeed",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "currentWalkSpeed",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return 20
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	["Sprint_Character_Tilt"] = {

		-- The name of the effect
		["Name"] = "Sprint_Character_Tilt",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "maxTiltAngle",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return 30
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	["Sprint_Stamina_Drain"] = {

		-- The name of the effect
		["Name"] = "Sprint_Stamina_Drain",

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

			return input - 0.5
		end,

		-- || OPTIONAL VARIABLES ||
		
		-- Whether or not the effects can stack
		["Can_Stack"] = false,

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = false,
	},

	["Sprint_Animation_Speed"] = {
		
		-- The name of the effect
		["Name"] = "Sprint_Animation_Speed",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 9,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "actionAnimationSpeed",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return 0.8
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

    -- || PLAYER EFFECTS ||

	["Sprint_Camera_FOV"] = {

		-- The name of the effect
		["Name"] = "Sprint_Camera_FOV",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "fieldOfView",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return 65
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

    ["Sprint_Camera_Sway_Amount"] = {

		-- The name of the effect
		["Name"] = "Sprint_Camera_Sway",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "cameraSwayAmount",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return Vector2.new(1, 1.5)
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

    ["Sprint_Camera_Sway_Speed"] = {

		-- The name of the effect
		["Name"] = "Sprint_Camera_Sway_Speed",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "cameraSwaySpeed",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return Vector2.new(10, 10)
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
}

-- The sprint action
local sprintAction = actionModule.new({

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
        ["isMovingRef"] = {true, Enum.ActionPrerequisiteOperator.Equals},
        ["characterStateRef"] = {Enum.CharacterState.Default, Enum.ActionPrerequisiteOperator.Equals},
        ["currentStamina"] = {0, Enum.ActionPrerequisiteOperator.GreaterThan},
    },

    -- The function performed on the character when the action begins
    ["ActionBeginFunction"] = function(character)

		-- Stop the current core animation
		character:AddEffect(characterEffectPrefabs.Core_Animation_Speed_Zero)

        -- Change the animation
        local sprintAnimation = character.animations.sprintAnimation
		character:AddEffect(effects.Sprint_Animation_Speed)
        character:ChangeActionAnimation(sprintAnimation, 0.2, Enum.AnimationPriority.Action, true)
        
        -- Drain the stamina
        character:RemoveEffect(characterEffectPrefabs.Stamina_Regen.Name)
        character:AddEffect(effects.Sprint_Stamina_Drain)
        
        -- Apply the effect to the character
        character:AddEffect(effects.Sprint_Walkspeed)
        character:AddEffect(effects.Sprint_Character_Tilt)
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
		character:RemoveEffect(effects.Sprint_Animation_Speed.Name)

		-- Start the current core animation
		character:RemoveEffect(characterEffectPrefabs.Core_Animation_Speed_Zero.Name)

        -- Regen the stamina
        character:RemoveEffect(effects.Sprint_Stamina_Drain.Name)
        
        -- Remove the effect from the character
        character:RemoveEffect(effects.Sprint_Walkspeed.Name)
        character:RemoveEffect(effects.Sprint_Character_Tilt.Name)
        character:RemoveEffect(characterEffectPrefabs.Disable_Climbing.Name)
    end,

    -- The function performed on the PLAYER when the action begins
    ["ActionBeginFunction_PLAYER"] = function(player)

        -- Increase the fov
        player:AddEffect(effects.Sprint_Camera_FOV)

        -- Change the camera sway
        player:AddEffect(effects.Sprint_Camera_Sway_Speed)
        player:AddEffect(effects.Sprint_Camera_Sway_Amount)

        -- Stop the movement being relative to the camera
        player:AddEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera)
    end,

    -- The function performed on the PLAYER when the action is finished
    ["ActionEndFunction_PLAYER"] = function(player)

        -- Reset the FOV
        player:RemoveEffect(effects.Sprint_Camera_FOV.Name)

        -- Reset the camera sway
        player:RemoveEffect(effects.Sprint_Camera_Sway_Speed.Name)
        player:RemoveEffect(effects.Sprint_Camera_Sway_Amount.Name)

        -- Allow the movement being relative to the camera
        player:RemoveEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera.Name)
    end,
})

-- The function to be called
function module:CallFunction(wantToSprint, oppositeOfCurrent)
    
    -- Check if we want to do opposite of current
	if oppositeOfCurrent then

		wantToSprint =  self.characterStats.currentAction ~= sprintAction and true or false
	end

	-- Check if we want to sprint
	local check = wantToSprint
	if check and self.characterStats.currentAction ~= sprintAction then

		-- Make the character sprint
		self.characterStats.currentAction = sprintAction
		return

	elseif self.characterStats.currentAction == sprintAction then

		-- Stop the sprint
		self.characterStats.currentAction = nil
		return
	end
end

return module
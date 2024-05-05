-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local actionModule = require(script.Parent.Parent:WaitForChild("Character_Actions"))
local characterEffectPrefabs = require(replicatedStorage["Core Classes"].Object.Character.Character_Effects.Effect_Prefabs)
local playerEffectPrefabs = require(replicatedStorage["Core Classes"].Object.Character.Player.Player_Effect_Prefabs)
local Enum = require(coreFolder:WaitForChild("Enum"))

local module = {}

module.Name = "Roll Module"

-- Roll effects
local effects = {
	
	["Roll_Stamina_Drain"] = {

		-- The name of the effect
		["Name"] = "Roll_Stamina_Drain",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "currentStamina",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 1,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return input - 20
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effects can stack
		["Can_Stack"] = false,

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = false,
	},
}

-- Roll stats
module.stats = {
	rollVelocity = 40,
	backStepVelocity = 30
}
local stats = module.stats

-- The roll action
local rollAction = actionModule.new({

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
        ["characterStateRef"] = {Enum.CharacterState.Default, Enum.ActionPrerequisiteOperator.Equals},
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
        character:AddEffect(effects.Roll_Stamina_Drain)
        
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
        rollVelocity.LineVelocity = stats.rollVelocity

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
    end,

    -- The function performed on the PLAYER when the action is finished
    ["ActionEndFunction_PLAYER"] = function(player)

        -- Allow the movement being relative to the camera
        player:RemoveEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera.Name)
    end,
})

-- The backstep action
local backstepAction = actionModule.new({

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
        ["characterStateRef"] = {Enum.CharacterState.Default, Enum.ActionPrerequisiteOperator.Equals},
        ["currentStamina"] = {0, Enum.ActionPrerequisiteOperator.GreaterThan},
    },

    -- The function performed on the character when the action begins
    ["ActionBeginFunction"] = function(character)

         -- Disable actions
         character:AddEffect(characterEffectPrefabs.Disable_Actions)
        
         -- Lock the character
         character.characterState = Enum.CharacterState.Locked
         character:AddEffect(characterEffectPrefabs.Disable_Auto_Rotate)
         
         -- Drain the stamina
         character:RemoveEffect(characterEffectPrefabs.Stamina_Regen.Name)
         character:AddEffect(effects.Roll_Stamina_Drain)

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
        rollVelocity.LineVelocity = -stats.backStepVelocity

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
    end,

    -- The function performed on the PLAYER when the action is finished
    ["ActionEndFunction_PLAYER"] = function(player)

        -- Allow the movement being relative to the camera
        player:RemoveEffect(playerEffectPrefabs.Disable_Movement_Relative_To_Camera.Name)
    end,
})

-- The function to be called
function module:CallFunction(forceRollDirection : Vector3)
	
    -- Check if the character is moving
    if self:GetWorldMoveDirection() ~= Vector3.zero or forceRollDirection then
    
        -- Check if the character can roll
        if self.characterStats.currentAction ~= rollAction then

            -- Make the character roll
            self.characterStats.currentAction = rollAction
        end
    else
    
        -- Check if the character can backstep
        if self.characterStats.currentAction ~= backstepAction then

            -- Make the character backstep
            self.characterStats.currentAction = backstepAction
        end
    end

    return 0
end

return module
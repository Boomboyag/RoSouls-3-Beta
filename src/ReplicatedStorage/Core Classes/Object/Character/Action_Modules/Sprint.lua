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

module.Name = "Sprint Module"

-- The roll action
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
        ["characterStateRef"] = {Enum.CharacterState.Default, Enum.ActionPrerequisiteOperator.Equals},
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
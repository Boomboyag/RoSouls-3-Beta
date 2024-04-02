-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Required scripts
local characterModule = coreFolder:WaitForChild("Object"):WaitForChild("Character")
local characterEffectPrefabs = require(characterModule:WaitForChild("Character_Effects").Effect_Prefabs)

local enums = {}

-- || OBJECT ENUMS ||

-- The type of object
enums.ObjectType = {
	Humanoid = {1, Name = "Humanoid"},
	Tool = {2, Name = "Tool"},
	Interactable = {3, Name = "Interactable"},
	Clothing = {3, Name = "Clothing"}
}

-- || CHARACTER ENUMS ||

-- The character's control type
enums.ControlType = {
	Full = {1, Name = "Full"},
	None = {2, Name = "None"}
}

-- The character's movement type
enums.MovementType = {

	-- The default movement type
	Default = {

		1, 
		Name = "Default",

		-- Called when changed to
		StartFunction = function(character)

		end,

		-- Called when changed from
		EndFunction = function(character)
			
		end
	},

	-- The character is strafing
	Strafing = {

		2, 
		Name = "Strafing",

		-- Called when changed to
		StartFunction = function(character)

			-- The animations
			local strafeLeft = character.coreAnimations.Strafing["Left"]
			local strafeRight = character.coreAnimations.Strafing["Right"]

			-- Play the animations
			strafeLeft:Play()
			strafeRight:Play()

			-- Set the animation priority
			strafeLeft.Priority = Enum.AnimationPriority.Movement
			strafeRight.Priority = Enum.AnimationPriority.Movement

			-- Fade the animations to 0
			strafeLeft:AdjustWeight(0, 0)
			strafeRight:AdjustWeight(0, 0)

			-- Bind the strafe update to the render stepped
			runService:BindToRenderStep("Strafe Update", Enum.RenderPriority.Character.Value + 1, function()
				
				-- Get the current movement direction
				local moveDir = character.humanoidRootPart.CFrame:VectorToObjectSpace(character:GetWorldMoveDirection())

				-- Get the individual axis
				local x = moveDir.X
				local z = moveDir.Z

				-- Make sure the character can strafe
				if character.characterStats.canStrafe then

					-- Check what direction on the x-axis the character is moving
					if x >= 0.5 then

						-- Fade the animations back to 0
						strafeLeft:AdjustWeight(0.8 * x)
						strafeRight:AdjustWeight(0)

					elseif x <= -0.5 then
						
						-- Fade the animations back to 0
						strafeLeft:AdjustWeight(0)
						strafeRight:AdjustWeight(0.8 * math.abs(x))
					else
					
						-- Fade the animations back to 0
						strafeLeft:AdjustWeight(0, 0.1)
						strafeRight:AdjustWeight(0, 0.1)
					end
				end
			end)
		end,

		-- Called when changed from
		EndFunction = function(character)

			-- The animations
			local strafeLeft = character.coreAnimations.Strafing["Left"]
			local strafeRight = character.coreAnimations.Strafing["Right"]

			-- Stop the animations
			strafeLeft:Stop()
			strafeRight:Stop()
			
			-- Unbind the strafe
			runService:UnbindFromRenderStep("Strafe Update")
		end
	},
}

-- The character's state
enums.CharacterState = {
	
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
	},
	
	-- The death state
	Dead = {

		-- State index
		7, 

		-- The name of the state
		Name = "Dead",

		-- Function called when the state begins
		StateBeganFunction = function(character)

			-- Required line of code (do not remove)
			print("THE HEAVY IS DEAD")

			-- Let the character know it's dead
			character.alive = false

			-- Return to the default movement state
			character.movementType = enums.MovementType.Default

			-- Fire the event
			character.CharacterDied:Fire()

			-- Lock the character in place
			character:ChangeControlType(enums.ControlType.None, Vector3.zero)

			-- Stop the character from moving
			character:AddEffect(characterEffectPrefabs.Walkspeed_0)

			-- Disable all actions, states, & effects
			character:AddEffect(characterEffectPrefabs.Disable_State_Change)
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
			character.characterStats.canAddEffects = false
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)

			-- One does not come back from death
			warn("THE HEAVY IS NOT DEAD?")
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
			character:ChangeControlType(enums.ControlType.None, Vector3.zero)

			-- Apply the effects to the character
			character:AddEffect(characterEffectPrefabs.Walkspeed_0)
			
			-- Disable all other actions
			character:AddEffect(characterEffectPrefabs.Disable_Actions)
		end,

		-- Function called when the state ends
		StateEndedFunction = function(character)
			
			-- Unlock the player
			character:ChangeControlType(enums.ControlType.Full)

			-- Remove the effect from the character
			character:RemoveEffect(characterEffectPrefabs.Walkspeed_0.Name)
			
			-- Allow the player to use actions again
			character:RemoveEffect(characterEffectPrefabs.Disable_Actions.Name)
		end,
	}
}

-- The type of action
enums.ActionType = {
	
	Movement = {
		1,
		Name = "Movement"
	},
	
	Attack = {
		2,
		Name = "Attack"
	},
	
	Damage = {
		3,
		Name = "Damage"
	},	

	None = {
		4,
		Name = "None"
	}
}

-- What operator to use on an action prerequisite
enums.ActionPrerequisiteOperator = {
	
	Equals = {

		1, 

		Name = "Equals",

		Check = function(a, b)
			
			return a == b
		end,
	},
	
	LessThan = {

		1, 

		Name = "Less Than",

		Check = function(a, b)

			return a < b
		end,
	},
	
	GreaterThan = {

		1, 

		Name = "Greater Than",

		Check = function(a, b)

			return a > b
		end,
	},
	
	LessThanOrEqual = {

		1, 

		Name = "Less Than or Equal to",

		Check = function(a, b)

			return a <= b
		end,
	},

	GreaterThanOrEqual = {

		1, 

		Name = "Greater Than or Equal to",

		Check = function(a, b)

			return a >= b
		end,
	},	
}

-- || PLAYER ENUMS ||

enums.CustomCameraType = {
	
	Default = {
		
		1,
		
		Name = "Default",
	},
	
	Locked = {

		2,

		Name = "Locked",
	},
}

enums.CustomCursorType = {
	
	Unlocked = {

		1,

		Name = "Unlocked",

		MouseBehavior = Enum.MouseBehavior.Default,

		StateBeganFunction = function(player)

			-- Show the cursor
			userInputService.MouseIconEnabled = true
			
			-- Unlock the cursor
			userInputService.MouseBehavior = Enum.MouseBehavior.Default
		end,
	},

	Locked = {

		2,

		Name = "Locked",

		MouseBehavior = Enum.MouseBehavior.LockCenter,

		StateBeganFunction = function(player)

			-- Hide the cursor
			userInputService.MouseIconEnabled = false
			
			-- Lock the cursor
			userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		end,
	},
}

return setmetatable(enums, {__index = Enum});
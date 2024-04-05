-- The table of effects
local effectTable = {

	-- || STRAFING ||

	["Enable_Strafing"] = {

		-- The name of the effect
		["Name"] = "Enable_Strafing",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "movementType",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return {

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
					game:GetService("RunService"):BindToRenderStep("Strafe Update", Enum.RenderPriority.Character.Value + 1, function()
						
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
					game:GetService("RunService"):UnbindFromRenderStep("Strafe Update")
				end
			}
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effects can stack
		["Can_Stack"] = false,

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	-- || STAMINA ||
	
	["Stamina_Regen"] = {

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

			return input + 1
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effects can stack
		["Can_Stack"] = false,

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = false,
	},
	
	["Slow_Stamina_Regen_Rate"] = {

		-- The name of the effect
		["Name"] = "Slow_Stamina_Regen_Rate",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "staminaRegenRate",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return 0.5
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effects can stack (default is false)
		["Can_Stack"] = false,

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	-- || WALKSPEED ||
	
	["Slow_Walkspeed"] = {

		-- The name of the effect
		["Name"] = "Slow_Walkspeed",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 11,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "currentWalkSpeed",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return 3
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	["Walkspeed_0"] = {
		
		-- The name of the effect
		["Name"] = "Walkspeed_0",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 100,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "currentWalkSpeed",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return 0
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	-- || SPRINTING ||
	
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
	
	["Disable_Sprint"] = {

		-- The name of the effect
		["Name"] = "Disable_Sprint",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "canSprint",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	-- || ROLLING ||
	
	["Disable_Roll"] = {

		-- The name of the effect
		["Name"] = "Disable_Roll",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "canRoll",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
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
	
	-- || FALLING ||
	
	["Fall_Walkspeed"] = {

		-- The name of the effect
		["Name"] = "Fall_Walkspeed",

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

			return 4
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

	-- || JUMPING ||
	
	["Disable_Jumping"] = {

		-- The name of the effect
		["Name"] = "Disable_Jumping",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "canJump",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	-- || CLIMBING ||
	
	["Climb_Walkspeed"] = {

		-- The name of the effect
		["Name"] = "Climb_Walkspeed",

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

			return 6
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	["Disable_Climbing"] = {

		-- The name of the effect
		["Name"] = "Disable_Climbing",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "canClimb",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

	-- || ANIMATIONS ||
	
	["Movement_Effects_Core_Animation_Speed"] = {
		
		-- The name of the effect
		["Name"] = "Movement_Effects_Core_Animation_Speed",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "coreAnimationInfluencedByCharacterMovement",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return true
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	["Disable_Character_Tilt"] = {

		-- The name of the effect
		["Name"] = "Disable_Character_Tilt",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "canTilt",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
	
	["Disable_Auto_Rotate"] = {

		-- The name of the effect
		["Name"] = "Disable_Auto_Rotate",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "autoRotate",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},	
	
	-- || SOUNDS ||

	["Disable_Footsteps"] = {
		
		-- The name of the effect
		["Name"] = "Disable_Footsteps",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "footstepsEnabled",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

	-- || ACTIONS ||

	["Disable_Actions"] = {
		
		-- The name of the effect
		["Name"] = "Disable_Actions",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "actionsEnabled",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

	-- || STATES ||

	["Disable_State_Change"] = {
		
		-- The name of the effect
		["Name"] = "Disable_State_Change",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "canChangeState",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)

			return false
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},
}

return effectTable

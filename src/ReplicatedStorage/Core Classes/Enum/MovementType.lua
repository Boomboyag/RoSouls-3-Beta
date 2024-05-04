local movementType = {

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
			strafeLeft:AdjustWeight(0.01, 0)
			strafeRight:AdjustWeight(0.01, 0)

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
						strafeRight:AdjustWeight(0.01)

					elseif x <= -0.5 then
						
						-- Fade the animations back to 0
						strafeLeft:AdjustWeight(0.01)
						strafeRight:AdjustWeight(0.8 * math.abs(x))
					else
					
						-- Fade the animations back to 0
						strafeLeft:AdjustWeight(0.01, 0.1)
						strafeRight:AdjustWeight(0.01, 0.1)
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
	},
}

return movementType
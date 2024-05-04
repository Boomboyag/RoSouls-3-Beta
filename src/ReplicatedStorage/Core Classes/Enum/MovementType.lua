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

			-- Set the animation priority
			strafeLeft.Priority = Enum.AnimationPriority.Movement
			strafeRight.Priority = Enum.AnimationPriority.Movement

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

						-- Play the left animation
						if not strafeLeft.IsPlaying then
							strafeLeft:Play()
						end

						-- Fade the animations back to 0
						strafeLeft:AdjustWeight(0.8 * x)
						strafeRight:Stop()

					elseif x <= -0.5 then

						-- Play the right animation
						if not strafeRight.IsPlaying then
							strafeRight:Play()
						end
						
						-- Stop the left animation and play the right
						strafeLeft:Stop()
						strafeRight:AdjustWeight(0.8 * math.abs(x))
					else
					
						-- Stop the animations
						strafeLeft:Stop()
						strafeRight:Stop()
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
-- Get the required services
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Get the required folders
local core = replicatedStorage:WaitForChild("Core Classes")

-- Get the required scripts
local Enum = require(core:WaitForChild("Enum"))
local playerHandler = require(core:WaitForChild("Player_Proxy"))
local uiHandler = require(script.GUI_Handler)

-- The player
local characterHandler
local player = players.LocalPlayer

local ui = nil

-- Update the UI
local function UpdateUI(charHandler)
	
	if not ui then return end
	
	ui:ChangeHealth(charHandler.GetPlayerStat:Invoke("currentHealth"))
	ui:ChangeSpeed(charHandler.GetPlayerStat:Invoke("currentWalkSpeed"))
	ui:ChangeStamina(characterHandler.GetPlayerStat:Invoke("currentStamina"))
	ui:CoreAnimationChange(characterHandler.GetPlayerStat:Invoke("currentCoreAnimation"))
	ui:ChangeEffects(characterHandler.GetPlayerStat:Invoke("effects"))
end

player.CharacterAdded:Connect(function(character)
	
	-- The character's info
	local charTable = {
		['model'] = character,
		['position'] = Vector3.new(20, 10, 0),
	}
	
	-- Wait for the humanoid root part to appear
	character:WaitForChild("HumanoidRootPart")
	characterHandler = playerHandler.new(charTable)

	ui = uiHandler.new(player)
	UpdateUI(characterHandler)

	characterHandler.PlayerStatChanged.Event:Connect(function()
		task.wait(0.1)
		UpdateUI(characterHandler)
	end)
	
	characterHandler.EffectAdded.Event:Connect(function()
		task.wait(0.1)
		UpdateUI(characterHandler)
	end)
	
	characterHandler.EffectRemoved.Event:Connect(function()
		task.wait(0.1)
		UpdateUI(characterHandler)
	end)
end)

player.CharacterRemoving:Connect(function()
	
	-- Check if the character handler exists
	if characterHandler then
		
		-- Remove the character handler
		characterHandler:Destroy()
		ui:Destroy()
	end
end)

-- The beginning of an input
userInputService.InputBegan:Connect(function(input, gameProcessed)

	-- Return if it's part of something else
	if gameProcessed or not characterHandler then return end
	
	-- Check if we want to sprint
	if (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonB) then

		-- Crouch or uncrouch
		characterHandler:Sprint(true, false)
	end
end)

-- The end of an input
userInputService.InputEnded:Connect(function(input, gameProcessed)

	-- Return if it's part of something else
	if gameProcessed or not characterHandler then return end
	
	-- Check if we want to roll
	if (input.KeyCode == Enum.KeyCode.F or input.KeyCode == Enum.KeyCode.ButtonY) then

		-- Crouch or uncrouch
		characterHandler:Roll()
	end
	
	-- Check if we want to stop sprinting
	if (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonB) then

		-- Crouch or uncrouch
		characterHandler:Sprint(false, false)
	end
	
end)
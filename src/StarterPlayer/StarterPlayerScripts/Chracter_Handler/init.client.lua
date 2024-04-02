-- Get the required services
local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Get the required folders
local core = replicatedStorage:WaitForChild("Core Classes")

-- Get the required scripts
local playerHandler = core:WaitForChild("Player_Proxy")

-- The player
local characterHandler
local player = players.LocalPlayer

player.CharacterAdded:Connect(function(character)
	
	-- The character's info
	local charTable = {
		['model'] = character,
		['position'] = Vector3.new(20, 10, 0),
	}
	
	-- Wait for the humanoid root part to appear
	character:WaitForChild("HumanoidRootPart")
	characterHandler = require(playerHandler).new(charTable)
end)

player.CharacterRemoving:Connect(function()
	
	-- Check if the character handler exists
	if characterHandler then
		
		-- Remove the character handler
		characterHandler:Destroy()
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

	-- Check if we want to unlock the mouse
	if input.KeyCode == Enum.KeyCode.U then
		
		characterHandler:ChangeMouseLock()
	end
	
	-- Check if we want to stop sprinting
	if (input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonB) then

		-- Crouch or uncrouch
		characterHandler:Sprint(false, false)
	end
	
end)
-- Roblox services
local userInputService = game:GetService("UserInputService")

local customCursorType = {
	
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

return customCursorType
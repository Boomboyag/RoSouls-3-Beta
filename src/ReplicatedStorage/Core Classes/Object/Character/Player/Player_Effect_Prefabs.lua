-- Required services
local players = game:GetService("Players")

-- Required variables
local player = players.LocalPlayer

-- The table of effects
local effectTable = {

	-- || FIRST PERSON CAMERA

	["Humanoid_Camera_Subject"] = {

		-- The name of the effect
		["Name"] = "Humanoid_Camera_Subject",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "cameraSubject",

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = 0,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
		["TimeBetweenEffectTick"] = 0,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = function(input)
			
			-- Get the player's character
			local character = player.Character

			-- Return the humanoid
			return character.Humanoid
		end,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = true,
	},

	["Max_Camera_Zoom_0"] = {

		-- The name of the effect
		["Name"] = "Max_Camera_Zoom_0",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "maximumZoom",

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
	
	["Min_Camera_Zoom_0"] = {

		-- The name of the effect
		["Name"] = "Min_Camera_Zoom_0",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "minimumZoom",

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

	-- || CAMERA ||

	["Disable_Movement_Relative_To_Camera"] = {

		-- The name of the effect
		["Name"] = "Disable_Movement_Relative_To_Camera",

		-- The priority of the effect (the lower the number the sooner it is called)
		["Priority"] = 10,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = "movementRelativeToCamera",

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

    -- || SPRINTING ||

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

return effectTable

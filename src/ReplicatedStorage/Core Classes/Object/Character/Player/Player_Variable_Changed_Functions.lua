-- Required services
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")
local chatService = game:GetService("Chat")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")
local characterFolder = coreFolder:WaitForChild("Object"):WaitForChild("Character")
local playerFolder = characterFolder:WaitForChild("Player")

-- Required scripts
local Enum = require(coreFolder:WaitForChild("Enum"))
local playerStatsSheet = require(playerFolder:WaitForChild("Player_Stats"))
local effectPrefabs = require(playerFolder:WaitForChild("Player_Effect_Prefabs"))

local statsChangedFunctions = {

    -- || ACTIONS ||

    ["currentAction"] = function(player, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time or is the same action
			if startup or oldValue == newValue then return end

			-- End the current action
            if oldValue and oldValue.actionEndFunctionPlayer then oldValue.actionEndFunctionPlayer(player) end

            -- Begin the new action
            if newValue and newValue.actionBeginFunctionPlayer then newValue.actionBeginFunctionPlayer(player) end
		end) 

		if not success then
			warn(response)
		end
		
		return newValue	
	end,

    -- || CAMERA SETTINGS ||

    -- Movement relative to camera
    ["movementRelativeToCamera"] = function(player, oldValue, newValue, startup)
        
        -- Create the pcall
        local success, response = pcall(function()

            -- Change the game setting
            if newValue == nil then newValue = false end

            -- Enable or disable the orientation attachment
            player.rootOrientationAttachment.Enabled = newValue

            -- Change the camera setting
            player.cameraHandler.movementRelativeToCamera = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end

        return newValue
    end,

    -- The camera's current subject
    ["cameraSubject"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Make sure the camera exists
            if not player.camera then
                
                warn("Camera not found!")
                return
            end

            -- Change the camera setting
            player.camera.CameraSubject = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- Whether or not the camera follows the current target
    ["cameraFollowsTarget"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) or newValue == nil then return end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.cameraFollowsTarget = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- What the camera block is following
    ["cameraFollow"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) or newValue == nil then return end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.cameraFollow = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- The camera's offset from the current target
    ["cameraOffset"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) or newValue == nil then return end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.cameraOffset = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- The camera's stiffness (only applied when following the player)
    ["cameraStiffness"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) or newValue == nil then return end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.cameraStiffness = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- The camera's field of view
    ["fieldOfView"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (not oldValue and not startup) or (oldValue == newValue) or not newValue then return end
            
            -- Tween the FOV
            local tweenInfo = TweenInfo.new(0.5)
            local tween = tweenService:Create(player.camera, tweenInfo, {FieldOfView  = newValue})
            tween:Play()
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- The maximum zoom distance
    ["maximumZoom"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (not oldValue and not startup) or (oldValue == newValue) or not newValue then return end

            -- Change the player's maximum camera zoom distance
            player.player.CameraMaxZoomDistance = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- The minimum zoom distance
    ["minimumZoom"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (not oldValue and not startup) or (oldValue == newValue) or not newValue then return end

            -- Change the player's maximum camera zoom distance
            player.player.CameraMinZoomDistance = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- || CAMERA SWAY ||

    -- The amount of camera sway applied
    ["cameraSwayAmount"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) then return end

            -- Check if the new value is equal to nil
            if newValue == nil then
                newValue = Vector2.zero
                warn("Camera sway amount cannot be set to nil! Setting to Vector2.zero instead")
            end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.cameraSwayAmount = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end

        return newValue
    end,

    -- The speed of the camera sway
    ["cameraSwaySpeed"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) then return end

            -- Check if the new value is equal to nil
            if newValue == nil then
                newValue = Vector2.zero
                warn("Camera sway speed cannot be set to nil! Setting to Vector2.zero instead")
            end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.cameraSwaySpeed = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end

        return newValue
    end,

    -- || MOUSE SETTINGS ||

    -- The type of cursor being shown (if any)
    ["cursorType"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (not oldValue and not startup) or (oldValue == newValue) then return end

            -- Fire the related function
            if newValue then newValue:StateBeganFunction() end
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- Whether or not the mouse can move the camera
    ["mouseMovesCamera"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) or newValue == nil then return end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.mouseMovesCamera = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,

    -- The sensitivity of the mouse
    ["mouseSensitivity"] = function(player, oldValue, newValue, startup)

        -- Create the pcall
        local success, response = pcall(function()

            -- Check if this is being fired for the first time or if the values are the same
		    if (oldValue == nil and not startup) or (oldValue == newValue) or newValue == nil then return end

            -- Change the camera handler to reflect the new value
            player.cameraHandler.mouseSensitivity = newValue
        end)

        -- Check if not a success
        if not success then
            warn(response)
        end
    end,
}

return statsChangedFunctions

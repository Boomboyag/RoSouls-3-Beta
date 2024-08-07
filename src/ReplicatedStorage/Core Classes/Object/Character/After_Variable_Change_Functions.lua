local statsChangedFunctions = {
	
	-- || ACTIONS ||

	-- The character's state has been changed
	["currentAction"] = function(character, oldValue, newValue, startup)

		local success, response = pcall(function()

			-- Check if this is being fired for the first time
			if startup or (newValue == oldValue) then return end

			-- Wrap in coroutine
			coroutine.wrap(function()

				-- End the current action
				if oldValue then oldValue:EndAction(character) end

				-- Begin the new action
				if newValue then newValue:BeginAction(character) end
			end)()
		end) 

		if not success then
			warn(response)
		end
		
		return newValue	
	end,
}

return statsChangedFunctions

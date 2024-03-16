-- Class creation
local effect = {}
effect.__index = effect
effect.__le = function(effectA, effectB)
	
	-- Check if the effect has a higher priority
	if effectA.priority <= effectB.priority then return true end
	return false
end
effect.__lt = function(effectA, effectB)
	
	-- Check if the effect has a higher priority
	if effectA.priority < effectB.priority then return true end
	return false
end
effect.__eq = function(effectA, effectB)
	
	-- Check if the effects have an equal priority
	if effectA.priority == effectB.priority then return true end
	return false
end

-- Short hand if function
function ternary(cond)
	if cond then return true else return false end
end

-- This is what the table to create a new effect should look like
local effectTableExample = {
	
	-- || REQUIRED VARIABLES ||
	
	-- The name of the effect
	["Name"] = "Example",
	
	-- The priority of the effect (the lower the number the sooner it is called)
	["Priority"] = 1,
	
	-- The data the effect will modify (must be within the 'Stats' module script of character)
	["DataToModify"] = "Data I want to change",
	
	-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
	["EffectTickAmount"] = 1,
	
	-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
	["TimeBetweenEffectTick"] = 1,
	
	-- The function performed on the DataToModify (takes the DataToModify as an argument)
	["EffectFunction"] = function(input)
		
		return input + 1
	end,
	
	-- || OPTIONAL VARIABLES ||
	
	-- Whether or not the effects can stack
	["Can_Stack"] = true,
	
	-- Whether or not the effect resets the DataToModify value when finished (default is false)
	["ResetDataWhenDone"] = false,
}

-- Class constructor
function effect.new(newEffect)
	local self = {}
	
	-- || REQUIRED VARIABLES ||
	
	-- The name of the effect
	self.name = newEffect["Name"]
	
	-- Whether or not the effect can stack
	self.canStack = newEffect["Can_Stack"] or true
	
	-- The priority of the effect (the lower the number the sooner it is called)
	self.priority = newEffect["Priority"]

	-- The data the effect will modify (must be within the 'Stats' module script of character)
	self.dataToModify = newEffect["DataToModify"]

	-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
	self.effectTickAmount = newEffect["EffectTickAmount"]
	self.currentTickAmount = 0

	-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1), will call effect once when 0
	self.timeBetweenEffectTick = newEffect["TimeBetweenEffectTick"]

	-- The function performed on the DataToModify (takes the DataToModify as an argument)
	self.effectFunction = newEffect["EffectFunction"]

	-- || OPTIONAL VARIABLES ||

	-- Whether or not the effect resets the DataToModify value when finished (default is false)
	self.resetDataWhenDone = newEffect["ResetDataWhenDone"] or false

	-- The delay before the effect is first called (default is 0)
	--self.effectDelay = newEffect["EffectDelay"] or 0
	
	-- || INTERNAL VARIABLES ||
	
	-- Whether or not the effect can be terminated
	self.canTerminate = false
	
	-- Whether or not the effect has met it's tick amount
	self.metTickAmount = false
	
	-- If this effect should be stopped upon reaching it's tick amount
	self.stopWhenTickAmountReached = not ternary(self.effectTickAmount == 0)
	
	-- The previous tick
	self.previousTick = 0
	
	-- Create the effect coroutine
	self.apply = function(dataToChange, forceApply)

		-- Get the current tick
		local currentTick = tick()

		-- Check if we want to check for time passed
		if not forceApply and self.effectTickAmount ~= 0 or self.timeBetweenEffectTick ~= 0 then

			-- Check if enough time has passed
			if currentTick - self.previousTick < self.timeBetweenEffectTick then return end

			-- Check if the effect lasts forever
			if self.effectTickAmount ~= 0 then

				-- Check if this effect has been called as many times as it's meant to and should be stopped
				if self.currentTickAmount >= self.effectTickAmount and self.stopWhenTickAmountReached then

					-- Let the script know it has completed running
					self.metTickAmount = true
					self.canTerminate = true

				-- Check if this effect has been called as many times as it's meant to and should be stopped	
				elseif self.currentTickAmount >= self.effectTickAmount and not self.stopWhenTickAmountReached then

					-- Let the script know it has completed
					self.metTickAmount = true
					return
				end
			end
		elseif self.timeBetweenEffectTick == 0 or self.effectTickAmount == 1 then
				
			-- Check if we have met the tick amount
			if not self.metTickAmount and self.effectTickAmount ~= 1 then
				
				self.metTickAmount = true
			else
				
				if self.stopWhenTickAmountReached then
					
					-- Let the script know it has completed running
					self.canTerminate = true
				end
				
				if not forceApply then return end
			end
		end

		-- Apply the effect
		dataToChange = self.effectFunction(dataToChange)

		-- Make sure it wasn't forcibly called
		if not forceApply then
			
			-- Set the current tick
			self.currentTickAmount += 1
			self.previousTick = currentTick
		end
		
		return dataToChange
	end

	-- Set the metatable and return
	setmetatable(self, effect)
	return self
end

-- The function to apply the effect
function effect:ApplyEffect(dataToChange, forceApply)
	
	-- Resume the coroutine
	local newData = self.apply(dataToChange, forceApply)
	
	-- Check if we are returning a boolean value
	if typeof(newData) == "boolean" then
		
		-- Return the boolean
		return newData
	else
		
		-- Return the new data (if it exists)
		return newData and newData or dataToChange
	end
end

-- The function to return the effects data (used for cloning)
function effect:Clone()
	
	-- Return the data table
	return {
		
		-- The name of the effect
		["Name"] = self.name,

		-- The data the effect will modify (must be within the 'Stats' module script of character)
		["DataToModify"] = self.dataToModify,

		-- The amount of times the effect will be called (0 lasts forever until manually removed, 1 calls the effect once)
		["EffectTickAmount"] = self.effectTickAmount,

		-- The time in between the effect being called in seconds (will not be used if the EffectTickAmount is 1)
		["TimeBetweenEffectTick"] = self.timeBetweenEffectTick,

		-- The function performed on the DataToModify (takes the DataToModify as an argument)
		["EffectFunction"] = self.effectFunction,

		-- || OPTIONAL VARIABLES ||

		-- Whether or not the effect resets the DataToModify value when finished (default is false)
		["ResetDataWhenDone"] = self.resetDataWhenDone,
	}
end

return effect

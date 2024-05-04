-- Roblox services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Required folders
local coreFolder = replicatedStorage:WaitForChild("Core Classes")

-- Class creation
local action = {}
action.__index = action

--[[ This is what the table to create a new effect should look like
local actionTableExample = {
	
	-- || REQUIRED VARIABLES ||
	
	-- The name of the effect
	["Name"] = "Example",
	
	-- The type of action
	["Type"] = Enum.ActionType.Movement,
	
	-- If this action can be queued
	["CanQueue"] = true,
	["MaxQueueTime"] = 1, -- How long the effect can be queued for (-1 can queue forever)
	["QueueWhenOveridden"] = false, -- Whether or not this action will be queued when overidden
	
	-- Variables that must be a certain value for the action to trigger
	["Prerequisites"] = {
		["This_Must_Be_True"] = {true, Enum.ActionPrerequisiteOperator.Equals},
		["Must_Be_Greater_Than_This"] = {0, Enum.ActionPrerequisiteOperator.GreaterThan},
	},
	
	-- The function performed on the character when the action begins
	["ActionBeginFunction"] = function(character)
		
		-- Do something
	end,

	-- The function performed on the character when the action is finished
	["ActionEndFunction"] = function(character)

		-- Do something
	end,

	-- The function performed on the PLAYER when the action begins (optional)
	["ActionBeginFunction_PLAYER"] = function(player)
		
		-- Do something
	end,

	-- The function performed on the PLAYER when the action is finished (optional)
	["ActionEndFunction_PLAYER"] = function(player)

		-- Do something
	end,
} --]]

-- Class constructor
function action.new(newAction)
	local self = {}
	
	-- The name of the effect
	self.name = newAction["Name"]
	
	-- The type of action
	self.actionType = newAction["Type"]
	
	-- If the action can be queued
	self.canQueue = newAction["CanQueue"] or false
	self.maxQueueTime = newAction["MaxQueueTime"] or -1
	self.queueWhenOveridden = newAction["QueueWhenOveridden"] or false

	-- If the action can be canceled
	self.canCancel = newAction["CanCancel"]
	
	-- The action's prerequisites
	self.prerequisites = newAction["Prerequisites"]

	-- The function performed on the character when the action begins
	self.actionBeginFunction = newAction["ActionBeginFunction"]
	
	-- The function performed on the character when the action ends
	self.actionEndFunction = newAction["ActionEndFunction"]

	-- The function performed on the PLAYER when the action begins (optional)
	self.actionBeginFunctionPlayer = newAction["ActionBeginFunction_PLAYER"] or nil
	
	-- The function performed on the PLAYER when the action ends (optional)
	self.actionEndFunctionPlayer = newAction["ActionEndFunction_PLAYER"] or nil

	-- Set the metatable and return
	setmetatable(self, action)
	return self
end

-- || PREREQUISITES ||

-- The function to check the action prerequisites
function action:CheckPrerequisites(characterStats)
	
	-- Loop through the actions prerequisites
	for i, v in pairs(self.prerequisites) do
		
		-- Check is the index exists
		if characterStats[i] == nil then
			warn("Prerequisite " .. tostring(i) .. " does not exist!")
			continue
		end
		
		-- Check if the prerequisite is met
		if not v[2].Check(characterStats[i], v[1]) then
			return false
		end
	end
	
	return true
end

-- The function to get the action prerequisites
function action:GetPrerequisites()
	
	local prerequisites = {}

	-- Loop through the actions prerequisites
	for i, v in pairs(self.prerequisites) do

		prerequisites[#prerequisites + 1] = tostring(v[1])
	end

	return prerequisites
end

-- || CHARACTER FUNCTIONS ||

-- The function called when the action begins
function action:BeginAction(character)
	
	-- Call the function
	self.actionBeginFunction(character)
end

-- The function called when the action is ended
function action:EndAction(character)
	
	-- Call the function
	self.actionEndFunction(character)
end

-- || PLAYER FUNCTIONS ||

-- The function called when the action begins
function action:BeginActionPlayer(player)
	
	-- Call the function
	self.actionBeginFunctionPlayer(player)
end

-- The function called when the action is ended
function action:EndActionPlayer(player)
	
	-- Call the function
	self.actionEndFunctionPlayer(player)
end

-- || GETS ||

-- Return the type of action
function action:GetType()
	
	return self.actionType
end

-- || MISCELLANEOUS ||

-- The function to return the effects data (used for cloning)
function action:Clone()
	
	-- Return the data table
	return {
		
		-- The name of the effect
		["Name"] = self.name,

		-- The function performed on the character when the action begins
		["ActionBeginFunction"] = self.actionEndFunction,

		-- The function performed on the character when the action is finished
		["ActionEndFunction"] = self.actionEndFunction,
	}
end

return action

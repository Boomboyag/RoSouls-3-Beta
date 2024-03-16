-- Required scripts
local object = require(script.Parent:WaitForChild("Object"))
local Enum = require(script.Parent:WaitForChild("Enum"))

-- Create the class
local tool = {}
tool.__index = tool
tool.__tostring = function(tool)

	-- Return the name of the object
	return tool.name
end
setmetatable(tool, object)

-- Class constructor
function tool.new(newTool)
	
	-- Create the self
	newTool.objectType = Enum.ObjectType.Tool
	local self = object.new(newTool)
	
	-- Set the metatable an return
	setmetatable(self, tool)
	return self
end

return tool
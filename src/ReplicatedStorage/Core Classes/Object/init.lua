-- Required scripts
local objectsTypes = require(script.Parent:WaitForChild("Enum").ObjectType)
local types = require(script.Parent:WaitForChild("Types"))

-- Create the class
local object = {}
object.__index = function(_, key)
	return object[key]
end
object.__tostring = function(object)
	
	-- Return the name of the object
	return tostring(object.name or "Object")
end

-- Class constructor
function object.new(newObject) : types.Object
	
	-- Create the self
	local self : types.Object = {}
	
	-- Create the name
	self.name = newObject.name or newObject.model.Name
	
	-- Set the type
	self.objectType  = newObject.objectType or objectsTypes.Humanoid
	
	-- Create the model
	self.model = newObject.cloneObject and newObject.model:Clone() or newObject.model
	self.model.Parent = newObject.modelParent or workspace
	self.size = self.model:GetBoundingBox()
	
	-- Change the model name
	if self.model.Name ~= self.name then
		self.model.Name = self.name
	end
	
	-- Set the model's position
	if self.model:IsA("Model") then
		self.model.PrimaryPart.CFrame = CFrame.new(newObject.position or Vector3.new(0, 0, 0))
	else
		self.model.CFrame = CFrame.new(newObject.position or Vector3.new(0, 0, 0))
	end
	
	-- Set the metatable an return
	return setmetatable(self, object)
end

-- The function to change the parent of the object
function object:ChangeParent(newParent)
	local self : types.Object = self
	
	self.model.Parent = newParent
end

-- Add a function to the object
function object:AddFunction(name, func)
	local self : types.Object = self

	if self[name] ~= nil then
		warn("The function " .. name .. " was overwritten")
	end

	self[name] = func
end

-- The function to destroy the object
function object:Destroy()
	local self : types.Object = self
	
	-- Destroy the model and metatable
	self.model:Destroy()
	setmetatable(self, nil)
end

return object
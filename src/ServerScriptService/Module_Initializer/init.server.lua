-- The action modules to add
local actionModules = script:WaitForChild("Modules")

-- Loop through and add the modules
for i, module in ipairs(actionModules:GetChildren()) do
    
    -- Initialize the modules
    module = require(module)
    module:Init()
end

actionModules:Destroy()
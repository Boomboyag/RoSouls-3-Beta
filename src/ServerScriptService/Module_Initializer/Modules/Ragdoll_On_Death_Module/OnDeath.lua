local module = {}

module.Name = "Ragdoll on Death Module"

module.requiredModules = {"Ragdoll"}

-- The function to be called
function module:CallFunction()

    -- Make sure we can ragdoll
    if self.Ragdoll ~= nil then
        
        -- Make the character ragdoll
        self:Ragdoll()
    else
        warn("Ragdoll module not included!")
    end

    return 0
end

return module
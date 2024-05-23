local enums = {}

for _, v in ipairs(script:GetChildren()) do

    local newEnum = require(v)
    enums[newEnum.Name] = newEnum
end

return setmetatable(enums, {__index = Enum});
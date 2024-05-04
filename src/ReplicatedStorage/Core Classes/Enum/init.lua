-- Required enums
local movementTypeScript = require(script.MovementType)
local characterStates = require(script.CharacterStates)
local controlType = require(script.ControlType)
local objectType = require(script.ObjectType)
local actionType = require(script.ActionType)
local operators = require(script.Operators)
local customCameraType = require(script.CameraType)
local customCursorType = require(script.CursorType)

local enums = {}

-- || OBJECT ENUMS ||

-- The type of object
enums.ObjectType = objectType

-- || CHARACTER ENUMS ||

-- The character's control type
enums.ControlType = controlType

-- The character's movement type
enums.MovementType = movementTypeScript

-- The character's state
enums.CharacterState = characterStates

-- The type of action
enums.ActionType = actionType

-- What operator to use on an action prerequisite
enums.ActionPrerequisiteOperator = operators

-- || PLAYER ENUMS ||

enums.CustomCameraType = customCameraType

enums.CustomCursorType = customCursorType

return setmetatable(enums, {__index = Enum});
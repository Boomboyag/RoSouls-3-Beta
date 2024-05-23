local operators = {
	
	Name = "ActionPrerequisiteOperator",

	Equals = {

		1, 

		Name = "Equals",

		Check = function(a, b)
			
			return a == b
		end,
	},
	
	LessThan = {

		1, 

		Name = "Less Than",

		Check = function(a, b)

			return a < b
		end,
	},
	
	GreaterThan = {

		1, 

		Name = "Greater Than",

		Check = function(a, b)

			return a > b
		end,
	},
	
	LessThanOrEqual = {

		1, 

		Name = "Less Than or Equal to",

		Check = function(a, b)

			return a <= b
		end,
	},

	GreaterThanOrEqual = {

		1, 

		Name = "Greater Than or Equal to",

		Check = function(a, b)

			return a >= b
		end,
	},	
}

return operators
local defaultProfile : table = {

	["Name"] = "Blank_Name",

	["Player_Saved_Place"] = tostring(game.PlaceId),

	-- The player's level variables
	["Levels"] = {
		["Vigor"] = 10;
		["Attunement"] = 10;
		["Endurance"] = 10;
		["Vitality"] = 10;
		["Strength"] = 10;
		["Dexterity"] = 10;
		["Intelligence"] = 10;
		["Faith"] = 10;
		["Luck"] = 10;
	},

	["Area"] = "",

	-- The player's spawned point
	["Spawn Point"] = {
		['x'] = 0,
		['y'] = 0,
		['z'] = 0
	},

	-- The player's saved bonfires
	["Bonfires"] = {

	},

	-- The player's interacted items
	["Interacted"] = {

	},

	-- The player's inventory
	["Inventory"] = {

		["Weapons"] = {

			["Right_Hand"] = {
				["Slot_A"] = "Default",
				["Slot_B"] = "Default",
				["Slot_C"] = "Default",
				["Slot_D"] = "Default",
			},

			["Left_Hand"] = {
				["Slot_A"] = "Default",
				["Slot_B"] = "Default",
				["Slot_C"] = "Default",
				["Slot_D"] = "Default",
			},

			["Default"] = 7,
		},

		["Armor"] = {

			["Equipped"] = {
				["Helmet"] = "Default_Helmet",
				["Chestpiece"] = "Default_Chest",
				["Leggings"] = "Default_Leggings",
			},

			["Default_Helmet"] = 1,
			["Default_Chest"] = 1,
			["Default_Leggings"] = 1,

			["Elite_Knight_Helmet"] = 1,
			["Elite_Knight_Chest"] = 1,
			["Elite_Knight_Leggings"] = 1,
		},
	}
}

return defaultProfile

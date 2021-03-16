  
config = {
	timeToRob = 1, -- In seconds
	robberyCooldown = 1, -- In minutes
	robbingStr = "Ouverture du coffre",

	displayBlips = true, -- Makes it so when a robbery is started a blip is created and flashes.

	enableAmmunations = false, -- Enables all Ammunations to be robbed.
	enable247 = false, -- Enables all 24/7's to be robbed.
	enableGasStations = false, -- Enables all Gas Stations to be robbed.
	enableBanks = true, -- Enables all Banks to be robbed.
	enableLiquor = false, -- Enables all Liquor Stores to be robbed.

	robberySuccess = "Vous avez réussi le braquage.",
	robberyFailed = "Le braquage à échoué",

	bankcoords = {
		{name = "Paleto Bank Robbery", alarm = "^1^*A silent alarm has been triggered at the ^5Blaine County Savings Bank in Paleto Bay^1! All police units are required to assist!", 
		x = -104.42, y = 6476.56, z=32.51-1.7},

		{name = "Harmony Bank Robbery", alarm = "^1^*A silent alarm has been triggered at the ^5Fleeca Bank Harmony in Harmony^1! All police units are required to assist!", 
		x = 1177.32, y = 2711.79, z = 38.1 - 1},

		{name = "Banham Canyon Bank Robbery", alarm = "^1^*A silent alarm has been triggered at the ^5Bank in Banham Canyon^1! All police units are required to assist!", 
		x = -2957.5, y = 480.97, z = 15.71 - 1},

		{name = "Pillbox Hill Bank Robbery", alarm = "^1^*A silent alarm has been triggered at the ^5Bank in Pillbox Hill^1! All police units are required to assist!", 
		x = 146.46, y = -1044.67, z = 29.38 - 1},
	},
}
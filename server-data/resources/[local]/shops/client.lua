config = {}
config.DrawDistance = 100
config.Size         = {x = 1.5, y = 1.5, z = 1.5}
config.Color        = {r = 0, g = 128, b = 255}
config.Type         = 1
config.Locale       = 'en'

config.Zones = {

	TwentyFourSeven = {
		Items = {},
		Pos = {
			{x = 373.875,   y = 325.896,  z = 102.566},
			{x = 2557.458,  y = 382.282,  z = 107.622},
			{x = -3038.939, y = 585.954,  z = 6.908},
			{x = -3241.927, y = 1001.462, z = 11.830},
			{x = 547.431,   y = 2671.710, z = 41.156},
			{x = 1961.464,  y = 3740.672, z = 31.343},
			{x = 1729.216,  y = 6414.131, z = 34.037}
		}
	},

	LTDgasoline = {
		Items = {},
		Pos = {
			{x = -48.519,   y = -1757.514, z = 28.421},
			{x = 1163.373,  y = -323.801,  z = 68.205},
			{x = -707.501,  y = -914.260,  z = 18.215},
			{x = -1820.523, y = 792.518,   z = 137.118},
			{x = 1698.388,  y = 4924.404,  z = 41.063}
		}
    }
}

-- Create blips
Citizen.CreateThread(function()   
    for k,v in pairs(config.Zones) do
		for i = 1, #v.Pos, 1 do
			local blip = AddBlipForCoord(v.Pos[i].x, v.Pos[i].y, v.Pos[i].z)

			SetBlipSprite (blip, 52)
			SetBlipScale  (blip, 1.0)
			SetBlipColour (blip, 2)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName('Supérette')
			EndTextCommandSetBlipName(blip)
		end
	end
end)
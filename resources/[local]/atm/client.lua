liquid = 0
account = 0

-- main loop
Citizen.CreateThread(function()
	exports.bro_core:AddArea("ATM", {
		trigger = {
			weight = 2,
			enter = {
                callback = function()
					exports.bro_core:Key("E", "E", "Ouvrir ATM", function()
						TriggerServerEvent("atm:get", "atm:get")
                    end)
					exports.bro_core:HelpPromt("ATM : ~INPUT_PICKUP~")
				end
			},
			exit = {
                callback = function()
                    exports.bro_core:RemoveMenu("ATM")
                    exports.bro_core:Key("E", "E", "Interaction", function()
                    end)
            	end
			},
		},
		blip = {
			text = "ATM",
			colorId = 2,
			imageId = 431,
		},
		locations = {
			{ x = 381.2827,  y = 323.2518,  z = 103.270},
			{ x = 2558.051,  y = 389.4817,  z = 108.660},
			{ x = -3044.22,  y = 595.2429,  z = 7.595},
			{ x = -3241.10,  y = 996.6881,  z = 12.500},
			{ x = -3241.11,  y = 1009.152,  z = 12.877},
			{ x = 540.0420,  y = 2671.007,  z = 42.177},
			{ x = 1967.333,  y = 3744.293,  z = 32.272},
			{ x = 1703.138,  y = 6426.783,  z = 32.730},
			{ x = 1735.114,  y = 6411.035,  z = 35.164},
			{ x = -56.1935,  y = -1752.53,  z = 29.452},
			{ x = 1168.975,  y = -457.241,  z = 66.641},
			{ x = -717.614,  y = -915.880,  z = 19.268},
			{ x = -1827.04,  y = 785.5159,  z = 138.020},
			{ x = 1686.753,  y = 4815.809,  z = 42.008},
			{ x = 1153.75,  y = -326.8,  z = 69.21},
			{ x = 33.249336242676, y = -1348.1586914062, z= 29.497022628784},
			{ x=1702.8286132812, y = 4933.603515625,z=42.063678741455}
		}
	})

	exports.bro_core:AddArea("bank", {
		trigger = {
			weight = 2,
			enter = {
                callback = function()
					exports.bro_core:Key("E", "E", "Ouvrir ATM", function()
						TriggerServerEvent("atm:get", "bank:get")
                    end)
					exports.bro_core:HelpPromt("Banque : ~INPUT_PICKUP~")
				end
			},
			exit = {
                callback = function()
                    exports.bro_core:RemoveMenu("bank")
                    exports.bro_core:Key("E", "E", "Interaction", function()
                    end)
            	end
			},
		},
		blip = {
			text = "Banque",
			colorId = 2,
			imageId = 300,
		},
		locations = {
			{ 
				x =-2962.7800292969, y=482.77465820312, z= 15.703103065491
			},
			{
				x=-112.68618774414,y=6469.8583984375,z=31.626710891724
			},
			{
				x=1175.4284667969,y=2706.8161621094, z=38.094074249268
			},
			{
				x=149.11099243164,y=-1040.4370117188,z=29.374076843262
			}
		}
	})

end) 
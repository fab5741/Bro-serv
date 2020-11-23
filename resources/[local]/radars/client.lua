--===============================================--===============================================
--= stationary radars based on 	https://github.com/DreanorGTA5Mods/StationaryRadar	         =
--===============================================--===============================================

local radares = {
  {x=-77.788414001465, y= -542.80474853516,z=39.602699279785},
{x=388.11514282227, y= -1067.8217773438, z=29.248865127563}
}

Citizen.CreateThread(function()
  while true do
    Wait(0)
	for k,v in pairs(radares) do
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player, true)
      if Vdist2(radares[k].x, radares[k].y, radares[k].z, coords["x"], coords["y"], coords["z"]) < 20 then
        Citizen.Trace("estas pasando por un radar")
          checkSpeed()
        end
    end
 end
end)

  function checkSpeed()
  local pP = GetPlayerPed(-1)
  local speed = GetEntitySpeed(pP)
  local vehicle = GetVehiclePedIsIn(pP, false)
  local driver = GetPedInVehicleSeat(vehicle, -1)
  local maxspeed = 80
	local kmhspeed = math.ceil(speed*3.6)
		if kmhspeed > maxspeed and driver == pP then
			Citizen.Wait(250)z      
      exports.bf:Notification("Vous avez été flashé ~r~".. kmhspeed.. " km/h")
	end
end

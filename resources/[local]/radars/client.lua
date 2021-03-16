--===============================================--===============================================
--= stationary radars based on 	https://github.com/DreanorGTA5Mods/StationaryRadar	         =
--===============================================--===============================================

local radares = {
  {x=394.01586914062, y= -1051.7839355469, z=28.893375396729, speed = 80, location = "lspd"},
  {x=-277.26965332031, y= -1309.1405029297, z=30.939800262451, speed = 80, location = "bennys"},
  {x=-702.79852294922, y= -837.08538818359, z=23.164554595947, speed = 80, location = "Vespucci Boulevard"},
  {x=-395.23190307617, y= -1.468491435051, z=46.537395477295, speed = 80, location = "Hawick avenue | Burton"},
  {x=859.34936523438, y= 124.029296875, z=70.76798248291, speed = 130, location = "FreeWay"},
}

Citizen.CreateThread(function()
  while true do
    Wait(0)
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player, true)
    for k,v in pairs(radares) do
        if Vdist2(radares[k].x, radares[k].y, radares[k].z, coords["x"], coords["y"], coords["z"]) < 50 then
            checkSpeed(radares[k].speed, radares[k].location)
          end
      end
  end
end)

nbPoints = 1
fine = 200

function round(number, decimals)
  local power = 10^decimals
  return math.floor(number * power) / power
end

  function checkSpeed(maxspeed, location)
  local pP = GetPlayerPed(-1)
  local speed = GetEntitySpeed(pP)
  local vehicle = GetVehiclePedIsIn(pP, false)
  local driver = GetPedInVehicleSeat(vehicle, -1)
  local kmhspeed = math.ceil(speed*3.6)
    if kmhspeed > maxspeed and driver == pP then
      if GetVehicleClass(vehicle) == 18 then
        exports.bro_core:Notification("Vous avez été flashé. ~g~Véhicle authorisé")
      else
        fine = kmhspeed - maxspeed
        nbPoints = (fine/40)+1
        nbPoints = math.floor(nbPoints)
        fine = round(fine*5, 2)
        Citizen.Wait(math.random(1000,10000))
        TriggerServerEvent("vehicle:permis:withdraw", "", nbPoints)
        TriggerServerEvent("account:player:add", "", -fine)
        exports.bro_core:Notification("Vous avez été flashé ~r~".. kmhspeed.. " km/h~s~. Perte de ~r~"..nbPoints.."points ~s~. Amende de ~r~"..fine.."$")
        TriggerServerEvent("job:avert:all", "lspd", "Flash radars : "..location, true)
      end
	end
end

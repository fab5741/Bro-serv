local liquid = 0
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    if (IsControlJustPressed(1, 288)) then
      TriggerServerEvent("account:liquid", "bf:liquid")
    end
  end
end)

RegisterNetEvent('bf:liquid')

AddEventHandler("bf:liquid", function(liquide) 
  liquid = liquide
  TriggerServerEvent("items:get", "bf:items")
end)

RegisterNetEvent('bf:items')

AddEventHandler("bf:items", function(inventory) 
  items = {
    {name = "inventaire", label =  'Inventaire', items= inventory},
    {name = "wallet", label =  'Portefeuille', items= {
      {name = "liquid", label =  'Liquide :'..liquid.." $"},
    }},
    }
  TriggerEvent(
      "menu:create", "player", "Joueur", "list",
      "", items, "align-top-right", "", ""
  ) 
end)
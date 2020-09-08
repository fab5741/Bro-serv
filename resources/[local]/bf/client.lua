Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)

      if (IsControlJustPressed(1, 288)) then
        liquid = 50.0
        function cb(res)then
          print(res)
        end
        TriggerServerEvent("account:liquid")

        items = {
          {name = "inventaire", label =  'Inventaire', items= {
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'}
          }},
          {name = "wallet", label =  'Portefeuille', items= {
            {name = "liquid", label =  'Liquide :'..liquid.." $"},
          }},
          {name = "job",  label =  'Travail', items= {
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'}
          }},
          {name = "cards",  label =  'Permis', items= {
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'},
            {name = "inventaire", label =  'Inventaire'}
          }},
      }
        TriggerEvent(
            "menu:create", "player", "Joueur", "list",
            "", items, "align-top-right", "", ""
        ) 
      end
    end
  end)
  
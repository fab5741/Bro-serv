AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    if false then
      StartResource("account")
      print("loaded")
      StartResource("admin")
      print("loaded")
      StartResource("atm")
      print("loaded")
      StartResource("jobManager")
      print("loaded")
      StartResource("bromenu")
    end
end)
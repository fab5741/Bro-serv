AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' has been started.')
    if false then
      StartResource("bromenu")
      StartResource("atm")
      StartResource("admin")
      StartResource("jobmanager")
      StartResource("vehicles")
      StartResource("lsms")
    end
end)
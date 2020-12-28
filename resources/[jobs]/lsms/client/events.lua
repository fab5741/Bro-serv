AddEventHandler('player:dead', function(data)
    if(not isDead) then
        isDead = true
        StartDeathTimer()
        StartDistressSignal()

        StartScreenEffect('DeathFailOut', 0, false)
    end
end)

AddEventHandler('player:alive', function()
	isDead = false
end)
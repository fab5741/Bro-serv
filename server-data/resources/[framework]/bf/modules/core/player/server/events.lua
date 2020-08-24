M('events')

onClient('bf:player:join', function()
  local source = source
  Player.onJoin(source)
end)

AddEventHandler('playerDropped', function(reason)

  local source = source
	local player = Player.all[source]

  if player then

		emit('bf:player:drop', player, reason)

    if player.identity ~= nil then
      player.identity:save(function()
        Identity.all[player.identity.id] = nil
      end)
    end

    player:save(function()
			Player.all[source] = nil
    end)

  end

end)

onRequest('bf:cache:player:get', function(source, cb, id)

  local player = Player.all[source]

  if player then
    cb(true, player:serialize())
  else
    cb(false, nil)
  end

end)

on('bf:player:load', function(player)
  print('^2loaded ^7' .. player.name .. ' (' .. player.source .. '|' .. player.identifier .. ')')
end)

on('bf:player:load:error', function(source, name)
  print(name .. ' (' .. source .. ') ^1load error')
end)
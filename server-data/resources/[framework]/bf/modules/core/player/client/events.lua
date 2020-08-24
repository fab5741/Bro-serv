onServer('bf:player:load', function(sid)

    Cache.player:fetch(sid, function(exists, player)
  
      if exists then
  
        bf.Player = player
  
        emit('bf:player:load:done')
  
      else
        print('player not found')
      end
  
    end)
  
  end)

if IsDuplicityVersion() then

    onClient('BF:request', function(name, id, ...)
  
      local client = source
  
      if module.requestCallbacks[name] == nil then
        print('request callback ^4' .. name .. '^7 does not exist')
        return
      end
  
      module.requestCallbacks[name](client, function(...)
        emitClient('BF:response', client, id, ...)
      end, ...)
  
    end)
  
    onClient('BF:response', function(id, ...)
  
      local client = source
  
      if module.callbacks[id] ~= nil then
        module.callbacks[id](client, ...)
        module.callbacks[id] = nil
      end
  
    end)
  
  else
  
    onServer('BF:request', function(name, id, ...)
  
      if module.requestCallbacks[name] == nil then
        print('request callback ^4' .. name .. '^7 does not exist')
        return
      end
  
      module.requestCallbacks[name](client, function(...)
        emitServer('BF:response', id, ...)
      end, ...)
  
    end)
  
  
    onServer('BF:response', function(id, ...)
  
      if module.callbacks[id] ~= nil then
        module.callbacks[id](...)
        module.callbacks[id] = nil
      end
  
    end)
  
  end
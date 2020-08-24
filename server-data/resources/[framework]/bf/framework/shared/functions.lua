local __print = print

_print = function(...)

  local args = {...}
  local str  = '[^4BF^7'

  for i=1, #args, 1 do
    if i == 1 then
      str = str .. '' .. tostring(args[i])
    else
      str = str .. ' ' .. tostring(args[i])
    end
  end

  __print(str)

end

print = function(...)

  local args = {...}
  local str  = ']'

  for i=1, #args, 1 do
    str = str .. ' ' .. tostring(args[i])
  end

  _print(str)

end

local tableIndexOf = function(t, val)

  for i=1, #t, 1 do
    if t[i] == val then
      return i
    end
  end

  return -1

end

-- Main Variables
BF = {}
BF.loaded = false
BF.modules = {}

BF.config = function ()
    return config
end

-- Custom error logging
BF.printError = function(error, location)
    location = location or 'Location Non Défini'
    print(debug.traceback('^1[Erreur] l ^5' .. location .. '^7\n\n^5 : ^1' .. error .. '^7\n'))
end

BF.evalfile = function (resource, file, env)
    env           = env or {}
    env._G        = env
    local code    = LoadResourceFile(resource, file)
    local fn      = load(code, '@' .. resource .. ':' .. file, 't', env)
    local success = true
  

    local status, result = xpcall(fn, function(err)
      success = false
      BF.printError(err, trace, '@' .. resource .. ':' .. file)
    end)
  
    return env, success
end 


-- main boot module
BF.modules['boot'] = {}
local module = BF.modules['boot']

local resName = GetCurrentResourceName()
local modType = IsDuplicityVersion() and 'server' or 'client'

module.groupNames        = {"core", "base", "user"}
module.groups            = {}
module.entries           = {}
module.entriesOrders     = {}

for i=1, #module.groupNames, 1 do

  local groupName        = module.groupNames[i]
  local modules          = json.decode(LoadResourceFile(resName, 'modules/' .. groupName .. '/modules.json'))
  module.groups[groupName] = modules

  for j=1, #modules, 1 do
    local modName = modules[j]
    module.entries[modName] = groupName
  end
end

module.getEntryPoints = function(name, group)
    local prefix          = group .. '/'
    local shared, current = false, false

    if LoadResourceFile(resName, 'modules/' .. prefix .. name .. '/shared/main.lua') ~= nil then
        shared = true
    end
    if LoadResourceFile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/main.lua') ~= nil then
        current = true
    end
    return shared, current
end

module.isModuleInGroup = function(name, group)
  return module.entries[name] ~= nil
end
  

module.getModuleGroup = function(name)
    return module.entries[name]
end

module.hasEntryPoints = function(name, group)
    local shared, current = module.getEntryPoints(name, group)
    return shared or current
end

module.createEnv = function(name, group)

    local env = {}
  
    for k,v in pairs(env) do
      env[k] = v
    end
  
    env.__NAME__     = name
    env.__GROUP__    = group
    env.__RESOURCE__ = resName
    env.__DIR__      = 'modules/__' .. group .. '__/' .. name
    env.run          = function(file, _env) return BF.evalfile(env.__RESOURCE__, env.__DIR__ .. '/' .. file, _env or env) end
    env.module       = {}
    env.M            = module.loadModule
  
    env.print = function(...)
  
      local args   = {...}
      local str    = '^7/^5' .. group .. '^7/^3' .. name .. '^7]'
  
      for i=1, #args, 1 do
        str = str .. ' ' .. tostring(args[i])
      end
  
      _print(str)
  
    end
  
    local menv         = setmetatable(env, {__index = _G, __newindex = _G})
    env._ENV           = menv
    env.module.__ENV__ = menv
  
    return env
  
end


module.loadModule = function(name)
  if BF.modules[name] == nil then
    local group = module.getModuleGroup(name)
    if group == nil then
      BF.printError('module [' .. name .. '] is not declared in modules.json', '@' .. resName .. ':modules/core/main/functions.lua')
    end

    local prefix = '' .. group .. '/'

    module.entriesOrders[group] = module.entriesOrders[group] or {}
    TriggerEvent('BF:module:load:before', name, group)

    local menv            = module.createEnv(name, group)
    local shared, current = module.getEntryPoints(name, group)

    print(shared, current)
    local env, success, _success = nil, true, false
    if shared then
    env, _success = BF.evalfile(resName, 'modules/' .. prefix .. name .. '/shared/functions.lua', menv)
    if _success then
        env, _success = BF.evalfile(resName, 'modules/' .. prefix .. name .. '/shared/events.lua', menv)
    else
      print("falseSucess1")
        success = false
    end

    if _success then
        menv, _success = BF.evalfile(resName, 'modules/' .. prefix .. name .. '/shared/main.lua', menv)
    else
      print("falseSucess2")
        success = false
    end

    end

    if current then

    env, _success = BF.evalfile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/functions.lua', menv)

    if _success then
        env, _success = BF.evalfile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/events.lua', menv)
    else
      print("falseSucess3")

        success = false
    end

    if _success then
        env, _success = BF.evalfile(resName, 'modules/' .. prefix .. name .. '/' .. modType .. '/main.lua', menv)
    else
      print("falseSucess4")
        success = false
    end

    end

    if success then

    BF.modules[name] = menv['module']

    module.entriesOrders[group][#module.entriesOrders[group] + 1] = name

    TriggerEvent('BF:module:load:done', name, group)

    else

    BF.printError('module [' .. name .. '] does not exist')
    TriggerEvent('BF:module:load:error', name, group)

    return nil, true

    end

  end

  return BF.modules[name], false
end

module.boot = function()

  for i=1, #module.groupNames, 1 do

    local groupName = module.groupNames[i]
    local group     = module.groups[groupName]
    if(group ~= nil) then
      for j=1, #group, 1 do

        local name = group[j]
  
        if module.hasEntryPoints(name, groupName) then
          M(name, groupName)
        end
  
      end
    end

  end
  
  on('bf:ready', function()
    print('^2ready')
  end)
  
  BF.loaded = true
  
  emit('bf:load')
  
  end
  
  M = module.loadModule
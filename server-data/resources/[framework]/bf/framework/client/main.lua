local module = BF.modules['boot']

if exports.spawnmanager ~= nil then -- TODO remove check if https://github.com/citizenfx/cfx-server-data/pull/104 is merged
    exports.spawnmanager:forceRespawn(false)
end
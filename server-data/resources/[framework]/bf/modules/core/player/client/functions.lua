M('events')
M('serializable')
M('cache')

Player = Extends(Serializable, 'Player')

function Player:constructor(data)

  self.super:ctor(data)

  if data.identityId == nil then
    self:field('identityId')
  end

end

function Player:killedByPlayer(killerSid, KillerCid, deathCause)

 local victimCoords = self:getCoords(true)
 local killerCoords = math.roundVec3(GetEntityCoords(GetPlayerPed(KillerCid)))

 local distance     = #(victimCoords - killerCoords)
 
  local data = {
    victimCoords = victimCoords,
    killerCoords = killerCoords,
    killedByPlayer = true,
    deathCause     = deathCause,
    distance       = math.round(distance, 1),
    killerServerId = killerServerId,
    killerClientId = killerClientId
  }

  emit('bf:player:death', data)
  emitServer('bf:player:death', data)

end

function Player:killed(deathCause)

  local victimCoords = self:getCoords(true)

  local data = {
    victimCoords = victimCoords,
    killedByPlayer = false,
    deathCause     = deathCause
	}

  emit('bf:player:death', data)
  emitServer('bf:player:death', data)

end

function Player:getCoords(rounded)

  local coords = GetEntityCoords(PlayerPedId())

  if (rounded) then
    print("try to round")
    return math.roundVec3(coords, 1)
  end

  return coords

end

PlayerCacheConsumer = Extends(CacheConsumer)

function PlayerCacheConsumer:provide(key, cb)

  request('bf:cache:player:get', function(exists, data)
    cb(exists, exists and Player(data) or nil)
  end, key)

end

Cache.player = PlayerCacheConsumer()

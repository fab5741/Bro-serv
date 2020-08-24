M('events')

Serializable = Extends(EventEmitter, 'Serializable')

function Serializable:constructor(data)

  self.super:ctor()

  self.__ACCESSORS = {}

  for k,v in pairs(data) do
    self:field(k, v)
  end

end

function Serializable:field(name, value)

  self[name] = value

  if not self:hasField(name) then

    self.__ACCESSORS[name] = {

      get = DefineGetter(self, name),

      set = DefineSetter(self, name, function(self, value)
        self[name] = value
        self:emit('change', name, value)
      end)

    }

  end

end

function Serializable:hasField(name)
  return self.__ACCESSORS[name] ~= nil
end

function Serializable:serialize(encode)

  local data = {}

  for name, accessor in pairs(self.__ACCESSORS) do

    local processedGetter = accessor.get(self)

    -- avoid circular references errors
    if (type(processedGetter) == "table" and type(processedGetter.serialize) == "function") then
      processedGetter = processedGetter:serialize()
    end

    data[name] = processedGetter
  end

  return encode == nil and data or encode(data)
  
end
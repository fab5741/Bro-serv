print(BF)
local module = BF.modules['boot']

if not IsDuplicityVersion() then
  module.boot()
end

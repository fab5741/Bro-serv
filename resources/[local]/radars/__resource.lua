resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vRP_stationaryRadars -- thanks to https://github.com/DreanorGTA5Mods/StationaryRadar"

dependencies {
  "bf", 
  "account",
  "vehicles",
  "jobManager"
}

client_scripts{ 
  "client.lua"
}

server_scripts{ 
  "server.lua"
}
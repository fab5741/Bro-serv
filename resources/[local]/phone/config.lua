Config = {}

-- Script locale (only .Lua)
Config.FixePhone = {
  -- Mission Row
  ['911'] = { 
    name =  'mission_row', 
    coords = { x = 441.2, y = -979.7, z = 30.58 } 
  },
  
  ['008-0001'] = {
    name = 'phone_booth',
    coords = { x = 372.25, y = -965.75, z = 28.58 } 
  },
}

Config.KeyOpenClose = 289 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = true -- Use Frazzle's Mumble-VoIP Resource (Recommended!) https://github.com/FrazzIe/mumble-voip
Config.UseTokoVoIP   = false

Config.ShowNumberNotification = false -- Show Number or Contact Name when you receive new SMS

Config.ShareRealtimeGPSDefaultTimeInMs = 1000 * 60 -- Set default realtime GPS sharing expiration time in milliseconds
Config.ShareRealtimeGPSJobTimer = 10 -- Default Job GPS Timer (Minutes)

-- Optional Features (Can all be set to true or false.)
Config.ItemRequired = false -- If true, must have the item "phone" to use it.
Config.NoPhoneWarning = false -- If true, the player is warned when trying to open the phone that they need a phone. To edit this message go to the locales for your language.

-- Optional Discord Logging
Config.UseDiscordLogging = false -- Work in progress. Functions are limited to twitter.
Config.Discord_Webhook = 'https://discord.com/api/webhooks/' -- Set Discord Webhook. See https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
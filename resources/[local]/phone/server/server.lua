math.randomseed(os.time()) 

--- For phone number style XXX-XXXX
function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d-%04d", numBase0, numBase1)
	return num
end
--====================================================================================
--  Utils
--====================================================================================

function getOrGeneratePhoneNumber (discord, cb)
    local discord = discord
    MySQL.ready(function ()
        MySQL.Async.fetchScalar("select players.phone_number FROM players WHERE players.discord = @discord",
        {['@discord'] =  discord},
        function(phone_number)
            if phone_number == '0' or phone_number == nil or phone_number == '' then
                repeat
                    phone_number = getPhoneRandomNumber()
                    MySQL.Async.fetchScalar("select players.discord FROM players WHERE players.phone_number = @phone_number",
                    {['@phone_number'] =  phone_number},
                    function(discord)
                        id = discord
                    end)
                until id == nil
                MySQL.ready(function ()
                    MySQL.Async.insert("UPDATE players SET phone_number = @myPhoneNumber WHERE discord = @discord", { 
                        ['@myPhoneNumber'] = phone_number,
                        ['@discord'] = discord
                    }, function ()
                        cb(phone_number)
                    end)
                end)
            else
                cb(phone_number)
            end
        end)
    end)
   
end
--====================================================================================
--  Contacts
--====================================================================================
function notifyContactChange(source, discord)
    local sourcePlayer = tonumber(source)
    local discord = discord
    if sourcePlayer ~= nil then 
        MySQL.ready(function ()
            MySQL.Async.fetchAll("SELECT * FROM phone_players_contacts WHERE phone_players_contacts.discord = @discord", {
                ['@discord'] = discord
            }, function(res)
                TriggerClientEvent("phone:contactList", sourcePlayer, res)
            end)
        end)
    end
end

RegisterServerEvent('phone:addContact')
AddEventHandler('phone:addContact', function(display, phoneNumber)
    local _source = source
    local sourcePlayer = tonumber(_source)
    local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function ()
        MySQL.Async.insert("INSERT INTO phone_players_contacts (`discord`, `number`,`display`) VALUES (@discord, @number, @display)", {
            ['@discord'] = discord,
            ['@number'] = phoneNumber,
            ['@display'] = display,
        },function()
            notifyContactChange(sourcePlayer, discord)
        end)
    end)
end)

RegisterServerEvent('phone:updateContact')
AddEventHandler('phone:updateContact', function(id, display, phoneNumber)
    local _source = source
    local sourcePlayer = tonumber(_source)
	local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function ()
        MySQL.Async.insert("UPDATE phone_players_contacts SET number = @number, display = @display WHERE id = @id", { 
            ['@number'] = number,
            ['@display'] = display,
            ['@id'] = id,
        },function()
            notifyContactChange(sourcePlayer, discord)
        end)
    end)
end)

RegisterServerEvent('phone:deleteContact')
AddEventHandler('phone:deleteContact', function(id)
    local _source = source
    local sourcePlayer = tonumber(_source)
	local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function ()
        MySQL.Async.execute("DELETE FROM phone_players_contacts WHERE `discord` = @discord AND `id` = @id", {
            ['@discord'] = discord,
            ['@id'] = id,
        }, function(rows)
            notifyContactChange(sourcePlayer, discord)
        end)
    end)
end)

--====================================================================================
--  Messages
--====================================================================================

RegisterServerEvent('phone:_internalAddMessage')
AddEventHandler('phone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function addMessage(source, phone_number, message)
    local sourcePlayer = source
    local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    if message ~= nil then
        if phone_number == "lspd" or phone_number == "lsms" or phone_number == "taxi" or phone_number == "farm"  or phone_number == "wine"  or phone_number == "bennys" then
            TriggerEvent("job:avert:all", phone_number, "~b~Appel reçu.", true)
            TriggerEvent("job:service:get", phone_number, function(inService)
                for k,v in ipairs(inService) do
                    local discordTo = exports.bro_core:GetDiscordFromSource(v)
                    MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
                    {
                        ['@discord'] =  discordTo}, function(player)
                        MySQL.Async.insert("INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)", 
                        {
                            ['@transmitter'] = player,
                            ['@receiver'] = phone_number,
                            ['@message'] = message,
                            ['@isRead'] = 0,
                            ['@owner'] = 0
                        }, function(id)
                            MySQL.Async.fetchAll("SELECT * from phone_messages WHERE `id` = @id", {
                                ['@id'] = id
                            }, function(res)   
                                    TriggerClientEvent("phone:receiveMessage", v, res[1])
                            end)
                        end)
                    end)
                end
            end)

            MySQL.ready(function ()
                    MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
                    {
                        ['@discord'] =  discord}, function(player)
                        MySQL.Async.insert("INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)", 
                        {
                            ['@transmitter'] = phone_number,
                            ['@receiver'] = player,
                            ['@message'] = message,
                            ['@isRead'] = 0,
                            ['@owner'] = 1
                        }, function(id)
                            MySQL.Async.fetchAll("SELECT * from phone_messages WHERE `id` = @id", {
                                ['@id'] = id
                            }, function(res)   
                                    TriggerClientEvent("phone:receiveMessage", sourcePlayer, res[1])
                            end)
                        end)
                    end)

                end)
        else
            MySQL.ready(function ()
                MySQL.Async.fetchScalar("SELECT players.gameId FROM players WHERE players.phone_number = @phone_number", {
                    ['@phone_number'] = phone_number
                }, function(gameId)
                    MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
                    {['@discord'] =  discord},
                    function(myPhone)
                        print(phone_number)
                        print(myPhone)
                        MySQL.Async.insert("INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)", 
                        {
                            ['@transmitter'] = myPhone,
                            ['@receiver'] = phone_number,
                            ['@message'] = message,
                            ['@isRead'] = 0,
                            ['@owner'] = 0
                        }, function(id)
                            print(id)
                            -- TriggerClientEvent("phone:allMessage", osou, getMessages(otherdiscord))
                            MySQL.Async.insert("INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner)", 
                            {
                                ['@transmitter'] = phone_number,
                                ['@receiver'] = myPhone,
                                ['@message'] = message,
                                ['@isRead'] = 1,
                                ['@owner'] = 1
                            }, function(id)
                                MySQL.Async.fetchAll("SELECT * from phone_messages WHERE `id` = @id", {
                                    ['@id'] = id
                                }, function(res)  
                                    print(gameId)
                                    print(sourcePlayer)
                                    if gameId ~= -1 then
                                        TriggerClientEvent("phone:receiveMessage", gameId, res[1])
                                    end
                                    TriggerClientEvent("phone:receiveMessage", sourcePlayer, res[1])
                                end)
                            end) 
                        end) 
                    end)
                end)
            end)
        end
    end
end

function deleteMessage(msgId)
    MySQL.Async.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, discord, phone_number)
    local source = source
    local discord = discord
    MySQL.ready(function ()
		MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
		function(mePhoneNumber)
            MySQL.Async.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
        end)
    end)
end

RegisterServerEvent('phone:sendMessage')
AddEventHandler('phone:sendMessage', function(phoneNumber, message)
    local _source = source
    local sourcePlayer = tonumber(_source)
    addMessage(sourcePlayer, phoneNumber, message)
end)

RegisterServerEvent('phone:deleteMessage')
AddEventHandler('phone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('phone:deleteMessageNumber')
AddEventHandler('phone:deleteMessageNumber', function(number)
    local _source = source
    local sourcePlayer = tonumber(_source)
	local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    deleteAllMessageFromPhoneNumber(sourcePlayer,discord, number)
    -- TriggerClientEvent("phone:allMessage", sourcePlayer, getMessages(discord))
end)

RegisterServerEvent('phone:deleteAllMessage')
AddEventHandler('phone:deleteAllMessage', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
    local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function() 
        MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
        function(mePhoneNumber)
        MySQL.Async.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
                ['@mePhoneNumber'] = mePhoneNumber
            })
        end)
    end)
end)

RegisterServerEvent('phone:setReadMessageNumber')
AddEventHandler('phone:setReadMessageNumber', function(num)
    local _source = source
    local sourcePlayer = tonumber(_source)
	local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function ()
		MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
        function(mePhoneNumber)
            MySQL.Async.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
                ['@receiver'] = mePhoneNumber,
                ['@transmitter'] = num
            })
        end)
    end)
end)

RegisterServerEvent('phone:deleteALL')
AddEventHandler('phone:deleteALL', function()
    local _source = source
    local sourcePlayer = tonumber(_source)
	local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)

    MySQL.ready(function()
        MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
		function(mePhoneNumber)
        MySQL.Async.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
                ['@mePhoneNumber'] = mePhoneNumber
            })
        end)
        MySQL.Async.execute("DELETE FROM phone_players_contacts WHERE `discord` = @discord", {
            ['@discord'] = discord
        })
        MySQL.Async.execute("DELETE FROM phone_players_contacts WHERE `discord` = @discord", {
            ['@discord'] = discord
        })
    end)
    appelsDeleteAllHistorique(discord)
    TriggerClientEvent("phone:contactList", sourcePlayer, {})
    TriggerClientEvent("phone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Async.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('phone:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@user, @num, @incoming, @accepts)", {
            ['@user'] = tostring(appelInfo.transmitter_num),
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true or num == nil then
            num = "###-####"
        end
        print("Second")
        print(appelInfo.receiver_num)
        print(num)
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('phone:getHistoriqueCall')
AddEventHandler('phone:getHistoriqueCall', function()
    local _source = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
        function(num)
            sendHistoriqueCall(sourcePlayer, num)
        end)
    end)
end)

RegisterServerEvent('phone:register_FixePhone')
AddEventHandler('phone:register_FixePhone', function(phone_number, coords)
	Config.FixePhone[phone_number] = {name = _U('phone_booth'), coords = {x = coords.x, y = coords.y, z = coords.z}}
	TriggerClientEvent('phone:register_FixePhone', -1, phone_number, Config.FixePhone[phone_number])
end)

RegisterServerEvent('phone:internal_startCall')
AddEventHandler('phone:internal_startCall', function(source, phone_number, rtcOffer, extraData)  
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    if phone_number == "lspd" or phone_number == "lsms" or phone_number == "taxi" or phone_number == "farm"  or phone_number == "wine"  or phone_number == "bennys" then
        exports.bro_core:Notification("~r~Non disponible")
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcPhone = ''

    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
        function(srcPhone)
            AppelsEnCours[indexCall] = {
                id = indexCall,
                transmitter_src = sourcePlayer,
                transmitter_num = srcPhone,
                receiver_src = nil,
                receiver_num = phone_number,
                is_valid = true,
                is_accepts = false,
                hidden = hidden,
                rtcOffer = rtcOffer,
                extraData = extraData
            }
            print("phone_number")
            print(phone_number)
            if extraData ~= nil and extraData.useNumber ~= nil then
                AppelsEnCours[indexCall].srcPhone = extraData.useNumber
            end
        
            MySQL.Async.fetchScalar('select gameId from  players where phone_number = @phone_number',
            {['@phone_number'] =  phone_number},
            function(srcTo)
                    if srcTo ~= nill then
                        AppelsEnCours[indexCall].receiver_src = srcTo
                        TriggerEvent('phone:addCall', AppelsEnCours[indexCall])
                        TriggerClientEvent('phone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                        TriggerClientEvent('phone:waitingCall', srcTo, AppelsEnCours[indexCall], false)
                    else
                        TriggerEvent('phone:addCall', AppelsEnCours[indexCall])
                        TriggerClientEvent('phone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                    end
            end)
        end)
    end)
end)

RegisterServerEvent('phone:startCall')
AddEventHandler('phone:startCall', function(phone_number, rtcOffer, extraData)
    local _source = source
    TriggerEvent('phone:internal_startCall',_source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('phone:candidates')
AddEventHandler('phone:candidates', function (callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local _source = source
        local to = AppelsEnCours[callId].transmitter_src
        if _source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        TriggerClientEvent('phone:candidates', to, candidates)
    end
end)

RegisterServerEvent('phone:acceptCall')
AddEventHandler('phone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('phone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	    SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('phone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	    end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)

RegisterServerEvent('phone:rejectCall')
AddEventHandler('phone:rejectCall', function (infoCall)
    local _source = source
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('phone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('phone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('phone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('phone:appelsDeleteHistorique')
AddEventHandler('phone:appelsDeleteHistorique', function (numero)
    local _source = source
    local sourcePlayer = tonumber(_source)
    local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function ()
		MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
		function(srcPhone)
            MySQL.Async.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
                ['@owner'] = srcPhone,
                ['@num'] = numero
            })
        end)
    end)
end)

function appelsDeleteAllHistorique(srcdiscord)

    MySQL.ready(function ()
		MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  srcdiscord},
		function(srcPhone)
            MySQL.Async.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
                ['@owner'] = srcPhone
            })
        end)
    end)
end

RegisterServerEvent('phone:appelsDeleteAllHistorique')
AddEventHandler('phone:appelsDeleteAllHistorique', function ()
    local _source = source
    local sourcePlayer = tonumber(_source)
	local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    appelsDeleteAllHistorique(discord)
end)

--====================================================================================
--  OnLoad
--====================================================================================
RegisterNetEvent('phone:playerLoaded')
AddEventHandler('phone:playerLoaded',function()
    local sourcePlayer = source
    local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function ()
		MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
		function(myPhoneNumber)
            getOrGeneratePhoneNumber(discord, function (myPhoneNumber)
                TriggerClientEvent('phone:myPhoneNumber', sourcePlayer, myPhoneNumber)
                MySQL.ready(function ()
                    MySQL.Async.fetchAll("SELECT * FROM phone_players_contacts WHERE phone_players_contacts.discord = @discord", {
                        ['@discord'] = discord
                    }, function(res)
                        TriggerClientEvent("phone:contactList", sourcePlayer, res)
                    end)
                    MySQL.Async.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN players ON players.discord = @discord WHERE phone_messages.receiver = players.phone_number", {
                        ['@discord'] = discord
                    }, function(res)
                        TriggerClientEvent('phone:allMessage', sourcePlayer, res)
                    end)
                end)
                sendHistoriqueCall(sourcePlayer, num)
            end)
        end)
    end)
end)

RegisterServerEvent('phone:allUpdate')
AddEventHandler('phone:allUpdate', function()
    local _source = source
    local sourcePlayer = tonumber(_source)

    local discord = exports.bro_core:GetDiscordFromSource(sourcePlayer)
    MySQL.ready(function ()
		MySQL.Async.fetchScalar('select phone_number from  players where discord = @discord',
        {['@discord'] =  discord},
		function(num)
            TriggerClientEvent("phone:myPhoneNumber", sourcePlayer, num)
            MySQL.ready(function ()
                MySQL.Async.fetchAll("SELECT * FROM phone_players_contacts WHERE phone_players_contacts.discord = @discord", {
                    ['@discord'] = discord
                }, function(res)
                    TriggerClientEvent("phone:contactList", sourcePlayer, res)
                end)
                MySQL.Async.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN players ON players.discord = @discord WHERE phone_messages.receiver = players.phone_number", {
                    ['@discord'] = discord
                }, function(res)
                    TriggerClientEvent("phone:allMessage", sourcePlayer, res)
                end)
            end)
            sendHistoriqueCall(sourcePlayer, num)
        end)
    end)
end)
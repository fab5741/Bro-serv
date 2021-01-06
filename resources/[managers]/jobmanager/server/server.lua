
inService = {
    lspd = {

    },
    lsms = {
    },
    farm = {

    },
    wine = {

    },
    taxi = {

    },
    bennys = {

    }
}

RegisterNetEvent("job:get")
RegisterNetEvent("job:isChef")
RegisterNetEvent("job:set:me")
RegisterNetEvent("job:set")
RegisterNetEvent("job:items:get")
RegisterNetEvent("job:items:withdraw")
RegisterNetEvent("job:items:store")
RegisterNetEvent("job:safe:deposit")
RegisterNetEvent("job:parking:get")
RegisterNetEvent("job:lsms:distress")
RegisterNetEvent("job:lsms:revive")
RegisterNetEvent("job:avert:all")
RegisterNetEvent("job:inService:number")
RegisterNetEvent("job:clock:set")
RegisterNetEvent("job:clock")
RegisterNetEvent("job:service:recruit")
RegisterNetEvent("job:service:promote")
RegisterNetEvent("job:service:demote")
RegisterNetEvent("job:get:player")
RegisterNetEvent("weapon:store")
RegisterNetEvent("weapon:get:all")
RegisterNetEvent("weapon:get")
RegisterNetEvent("job:weapon:licence")
RegisterServerEvent('job:removeWeapons')
RegisterServerEvent('job:cuffGranted')
RegisterServerEvent('job:finesGranted')
RegisterServerEvent('job:finesETA')
RegisterNetEvent("job:facture")
RegisterServerEvent('job:facture2')
RegisterNetEvent("job:sell")
RegisterNetEvent("job:repair:price")

AddEventHandler('job:get', function (cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT jobs.id as job, jobs.name, jobs.label as label, job_grades.label as grade from players, job_grades, jobs where players.job_grade = job_grades.id and jobs.id = job_grades.job and discord = @discord',
        {['discord'] =  discord},
         function(res)
                if(res[1]) then
                    TriggerClientEvent(cb, sourceValue, res)
                else
                    TriggerClientEvent(cb, sourceValue, {job = "Chomeur", grade = "Chomeur"})
                end
            end)
      end)
end)


AddEventHandler('job:isChef', function (cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('SELECT grade FROM job_grades, players, jobs where jobs.id = job_grades.job and players.job_grade = job_grades.id and discord = @discord',
        {['discord'] =  discord},
        function(isChef)
                TriggerClientEvent(cb, sourceValue, isChef)
            end)
      end)
end)


AddEventHandler('job:set:me', function (grade, notif)
    local sourceValue = source
    local source = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local notif = notif
    local gradee = grade
    if notif == nil then
        notif = ""
    end
    print(grade)
    print(notif)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('UPDATE players set job_grade= @grade where discord = @discord',
        {['@discord'] =  discord,
         ['@grade'] = gradee},
        function(res)
            TriggerClientEvent("bf:Notification", sourceValue, "Vous êtes maintenant ~g~"..notif)
        end)
      end)
end)



AddEventHandler('job:set', function (player, grade, notif, notif2)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('UPDATE players set job_grade= @grade where player = @player',
        {['@player'] =  player,
         ['@grade'] = grade},
        function(res)
            TriggerClientEvent("bf:Notification", player, notif)
            TriggerClientEvent("bf:Notification", sourceValue, notif2)
        end)
      end)
end)



AddEventHandler('job:items:get', function (cb, job)
    local sourceValue = source
    local source = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select items.label, job_item.amount, job_item.item from job_item, items where job = @job and items.id = job_item.item',
        {['@job'] = job},
        function(items)
            TriggerClientEvent(cb, sourceValue, items)
        end)
      end)
end)



AddEventHandler('job:items:withdraw', function (item, amount)
    local sourceValue = source
    local source = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select job_grades.job from players, job_grades where job_grades.id = players.job_grade and discord = @discord',
        {['@discord'] = discord},
        function(job)
            MySQL.Async.fetchScalar('select amount from job_item where job = @job and item = @item',
            {
                ['@job'] = job,
                ['@item'] = item
            },
            function(amountItems)
                if amountItems > amount then
                    MySQL.Async.execute('update job_item set amount = amount-@amount where job = @job and item = @item',
                    {
                        ['@job'] = job,
                        ['@item'] = item,
                        ['@amount'] = amount
                    },function(numRows)
                        TriggerClientEvent("items:add", sourceValue, item, amount, "Vous avez retiré des item")
                    end)
                else
                    TriggerClientEvent("bf:Notification", sourceValue, "~r~Le stock n'est pas assez fourni")
                end
            end)
        end)
    end)
end)


AddEventHandler('job:items:store', function (item, amount)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local amount = amount
    local item = item
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select job_grades.job from players, job_grades where job_grades.id = players.job_grade and discord = @discord',
        {['@discord'] = discord},
        function(job)
            MySQL.Async.fetchScalar('select amount from player_item, players where players.id = player_item.player and discord = @discord and player_item.item= @item',
            {
                ['@discord'] = discord,
                ['@item'] = item
            },
            function(amountItems)
                if amountItems > amount then
                    MySQL.Async.execute('INSERT INTO `job_item` (`job`, `item`, `amount`) VALUES (@job, @item, @amount) ON DUPLICATE KEY UPDATE amount=amount+@amount',
                    {
                        ['@job'] = job,
                        ['@item'] = item,
                        ['@amount'] = amount
                    },function(numRows)
                        TriggerClientEvent("items:add", sourceValue, item, -amount, "Vous avez déposé des items")
                    end)
                else
                    TriggerClientEvent("bf:Notification", sourceValue, "~r~Vous n'avez pas cet item")
                end
            end)
        end)
    end)
end)


-- time for each paycheck
local moneyDutyTime = 10 *1000 *60

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(moneyDutyTime)
        -- Check if people are working
        MySQL.ready(function()
            MySQL.Async.fetchAll('select players.gameId, jobs.id as job, job_grades.salary, players.id as player from players, jobs, job_grades where jobs.id = job_grades.job and onDuty = 1 and players.job_grade= job_grades.id',{},
            function(res)
                for k,v in pairs(res) do
                    MySQL.Async.fetchScalar('select amount from job_account, accounts where job_account.job = @job and accounts.id = job_account.account ',
                        {['@job'] = v.job},
                    function(amount)
                        v.salary = v.salary/6
                        if amount > v.salary then
                            MySQL.Async.execute('update job_account, accounts set amount = amount - @salary where job_account.job = @job and accounts.id = job_account.account',{
                                ['@salary'] = v.salary,
                                ['@job'] = v.job
                            },
                            function(affectedRows)
                                MySQL.Async.execute('update accounts, player_account set amount = amount + @salary where player_account.player = @player and player_account.account = accounts.id',{
                                    ['@salary'] = v.salary,
                                    ['@player'] = v.player
                                },
                                function(affectedRows)
                                    if affectedRows == 1 then
                                        -- TriggerClientEvent("phone:account:get", sourceValue)
                                        TriggerClientEvent('bf:Notification', v.gameId, "Vous avez reçu votre paie. ~g~"..v.salary.." $")
                                    else
                                        TriggerClientEvent('bf:Notification', v.gameId, "Vous n'avez pas reçu votre paie. ~r~"..v.salary.." $")
                                    end
                                end)
                            end)
                        else
                            TriggerClientEvent('bf:Notification', v.gameId, "~r~Vous n'avez pas reçu votre paie, la société, n'a pas assez de fond pour vous payer !")
                        end
                    end)
                end
            end)
        end)
    end
end)

--- safe

AddEventHandler('job:safe:deposit', function (withdraw, amount, job)
    local sourceValue = source
    local withdraw = withdraw
    local amount = tonumber(amount)
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

    MySQL.ready(function ()
        if withdraw then
            MySQL.Async.fetchAll('select money from jobs where name = @job',{['job'] = job},
            function(res)
                if res and res[1] and res[1].money >= amount then
                    MySQL.Async.execute('Update players SET liquid=liquid+@amount where discord = @discord',{['amount'] = amount, ['discord'] = discord},
                    function(affectedRows)
                        if affectedRows == 1 then
                            MySQL.Async.execute('Update jobs SET money=money-@amount where name = @job',{['amount'] = amount, ['job'] = job},
                            function(affectedRows)
                                if affectedRows == 1 then
                                    TriggerClientEvent("lspd:notify",  sourceValue,  "CHAR_BANK_FLEECA", -1,"Vous avez retiré ".. amount .. " $", false)
                                end
                            end)
                        end
                    end)
                else
                    TriggerClientEvent("lspd:notify",  sourceValue,  "CHAR_BANK_FLEECA", -1,"Le compte de l'entreprise n'est pas aussi rempli !", false)
                end
            end)
        else
            MySQL.Async.fetchAll('select liquid from players where discord = @discord',{['discord'] = discord},
            function(res)
                if res and res[1] and res[1].liquid >= amount then
                    MySQL.Async.execute('Update players SET liquid=liquid-@amount where discord = @discord',{['amount'] = amount, ['discord'] = discord},
                    function(affectedRows)
                        if affectedRows == 1 then
                            MySQL.Async.execute('Update jobs SET money=money+@amount where name = @job',{['amount'] = amount, ['job'] = job},
                            function(affectedRows)
                                if affectedRows == 1 then
                                    TriggerClientEvent("lspd:notify",  sourceValue,  "CHAR_BANK_FLEECA", -1,"Vous avez déposé ".. amount .. " $", false)
                                end
                            end)
                        end
                    end)
                else
                    TriggerClientEvent("lspd:notify",  sourceValue,  "CHAR_BANK_FLEECA", -1,"Volus n'avez pas tant d'argent !", false)
                end
            end)
        end
    end)
end)



--- Parkings

AddEventHandler('job:parking:get', function (cb, id, job)
    local source = source
    MySQL.ready(function ()
        MySQL.Async.execute('Update job_vehicle SET parking="" where id = @id',{['id'] = id},
        function(affectedRows)
            if affectedRows == 1 then
                MySQL.Async.fetchAll('select job_vehicle.id, name from job_vehicle, vehicles where job_vehicle.id= @id and vehicles.id = job_vehicle.vehicle',{['id'] = id},
                function(res)
                    TriggerClientEvent(cb,  source, res[1].name, res[1].id, job)
                end)
            end
        end)
    end)
end)

-- lsms

AddEventHandler('job:lsms:revive', function (player)
    TriggerClientEvent("job:lsms:revive", player)
end)



AddEventHandler('job:lsms:distress', function(coords, message)
    local sourceValue = source
    if #inService["lsms"] == 0 then
        TriggerClientEvent('bro_core:Notification', sourceValue, "~r~Pas de médecins en ville.~g~ Ce n'était qu'un petit bobo au final.")
        TriggerClientEvent('job:lsms:revive', sourceValue)
    else
        TriggerClientEvent('bro_core:Notification', sourceValue, "~g~Votre appel a été transmis.")
        TriggerEvent("job:alert:all", "lsms", "~b~Coma :", true, coords)
    end
end)



-- homes

AddEventHandler("job:avert:all", function (job, message, silent, pos)
    local sourceValue = source
    local message = message
    local pos = pos

    if #inService[job] == 0 then
        if not silent then
            TriggerClientEvent('bf:Notification', sourceValue, "Personne n'est en service, démerdez vous. Job : ~b~(".. job.. ")")
        end
    else
        for k,v  in pairs (inService[job]) do
            if pos == true then
                TriggerClientEvent("taxi:client:show", v, sourceValue)
            elseif pos ~= nil then
                TriggerClientEvent('bf:Notification', v, message)
                TriggerClientEvent('phone:receiveMessage', v, {
                        transmitter = "lspd",
                        receiver = "mynumber",
                        isRead= 1,
                        owner= 1,
                        message = message.." "..pos
                    }
                )
            else
                TriggerClientEvent('bf:Notification', v, message)
            end
        end
        if not silent then
            TriggerClientEvent('bf:Notification', sourceValue, "Votre appel à été émis pour le ~b~(".. job.. ")")
        end
    end
end)


AddEventHandler("job:inService:number", function (cb, job)
    TriggerClientEvent(cb, source, #inService[job])
end)


-- clock in

AddEventHandler("job:clock:set", function (isIn, source, job)
    if isIn then
        inService[job][#inService[job]+1] = source
    else
        for i = 1, #inService[job] do
            if inService[job][i] == source then
                inService[job][i] = nil
            end
        end
    end
end)

AddEventHandler("job:clock", function (isIn, job)
    local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

    local isIn = isIn
    local job = job
    MySQL.ready(function ()
        MySQL.Async.execute('Update players SET onDuty = @isIn where discord= @discord',{['@discord'] = discord, ['@isIn'] = isIn},
        function(affectedRows)
            if affectedRows > 0 then
                if isIn then
                    TriggerEvent("job:clock:set", true, sourceValue, job)
                    TriggerClientEvent('bf:Notification', sourceValue, "Vous entrez en service")
                else
                    TriggerEvent("job:clock:set", false, sourceValue, job)
                    TriggerClientEvent('bf:Notification', sourceValue, "Vous quittez le service")
                end
            end
        end)
    end)
end)


-- job service manage



AddEventHandler("job:service:recruit", function (job, player)
	local discord = exports.bro_core:GetDiscordFromSource(player)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar("SELECT min(grade), id FROM `job_grades` where job = @job",
        {
            ['@job'] = job,
        }, function(job_grade)
            MySQL.Async.execute('Update players SET job_grade = @job_grade where discord = @discord',
            {
                ['@discord'] = discord,
                ['@job_grade'] = job_grade
            },function(affectedRows)
            end)
        end)
    end)
end)


AddEventHandler("job:service:promote", function (player)
	local discord = exports.bro_core:GetDiscordFromSource(player)
    MySQL.ready(function ()
        MySQL.Async.execute('Update players SET job_grade = @job_grade+1 where discord = @discord',
        {
            ['@discord'] = discord,
            ['@job_grade'] = job_grade
        },function(affectedRows)
        end)
    end)
end)

AddEventHandler("job:service:demote", function (player)
	local discord = exports.bro_core:GetDiscordFromSource(player)
    MySQL.ready(function ()
        MySQL.Async.execute('Update players SET job_grade = @job_grade-1 where discord = @discord',
        {
            ['@discord'] = discord,
            ['@job_grade'] = job_grade
        },function(affectedRows)
        end)
    end)
end)


-- source is global here, don't add to function
AddEventHandler('job:get:player', function(cb)
	local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local cbe = cb
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT jobs.name, players.skin, job_grades.grade FROM players, job_grades, jobs WHERE job_grades.id = players.job_grade and job_grades.job = jobs.id and discord = @discord', {
            ['@discord'] =  discord
        }, function(res)
            if res and res[1] then
                TriggerClientEvent(cbe, sourceValue, res[1])
            else
                TriggerClientEvent(cbe, sourceValue)
            end
        end)
    end)
end)



-- source is global here, don't add to function
AddEventHandler('weapon:store', function(weapon)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.insert('update job_armory,players, job_grades, jobs set amount = amount+1 where weapon = @weapon and jobs.id = job_armory.job and players.discord = @discord and job_grades.id = players.job_grade and jobs.id = job_grades.job', {
            ['@weapon'] =  weapon,
            ['@discord'] =  discord
        }, function(res)
        end)
    end)
end)


-- source is global here, don't add to function
AddEventHandler('weapon:get:all', function(cb)
    local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select * from job_armory,players,job_grades,jobs  where jobs.id = job_armory.job and players.discord = @discord and job_grades.id = players.job_grade and jobs.id = job_grades.job', {
            ['@discord'] =  discord
        }, function(res)
            TriggerClientEvent(cb, sourceValue, res)
        end)
    end)
end)


-- source is global here, don't add to function
AddEventHandler('weapon:get', function(cb, weapon)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar("select amount from job_armory,players, job_grades, jobs where weapon = @weapon and jobs.id = job_armory.job and players.discord = @discord and job_grades.id = players.job_grade and jobs.id = job_grades.job",
    {
        ['@weapon'] =  weapon,
        ['@discord'] =  discord
    }, function(amount)
            if amount > 0 then
                MySQL.Async.insert('update job_armory,players, job_grades, jobs set amount = amount-1 where weapon = @weapon and jobs.id = job_armory.job and players.discord = @discord and job_grades.id = players.job_grade and jobs.id = job_grades.job', {
                    ['@weapon'] =  weapon,
                    ['@discord'] =  discord
                }, function(res)
                    TriggerClientEvent(cb, sourceValue, true, weapon)
                end)
            else
                TriggerClientEvent(cb, sourceValue, false, "")
            end
        end)
    end)
end)

--- LSPD

AddEventHandler('job:weapon:licence', function (t,  bool)
    local discord = exports.bro_core:GetDiscordFromSource(t)
    MySQL.ready(function ()
        MySQL.Async.insert('update players set gun_permis= @bool where discord = @discord', {
            ['@discord'] =  discord,
            ['@bool'] =  bool
        }, function(res)
        end)
    end)
end)

AddEventHandler('job:removeWeapons', function(t)
	TriggerClientEvent("job:removeWeapons", t)
end)

AddEventHandler('job:cuffGranted', function(t)
    local sourceValue = source
	TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
        icon = "CHAR_AGENT14",
        title = 'LSPD', false, 
        text = "Vous avez menotté un joueur"
    })
	TriggerClientEvent('job:handcuff', t)
end)
AddEventHandler('job:finesGranted', function(target, amount)
    local sourceValue = source

    TriggerClientEvent('job:payFines', target, amount, sourceValue)
    TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
        icon = "CHAR_AGENT14",
        title = 'LSPD', false, 
        text = "vous avez amendé pour ~g~"..amount.."$"
    })
end)

AddEventHandler('job:finesETA', function(officer, code)
    if(code==1) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'LSPD', false, 
            text = "Amende déjà en cours"
        })
    elseif(code==2) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'LSPD', false, 
            text = "Fin de la requête (amende)"
        })
    elseif(code==3) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'LSPD', false, 
            text = "Amende refusée"
        })
    elseif(code==0) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'LSPD', false, 
            text = "Amende acceptée"
        })
	end
end)



AddEventHandler("job:facture", function(t, motif, price, job)
    local sourceValue = source
    TriggerClientEvent('job:facture', t, price, motif, job, sourceValue)
    TriggerClientEvent("bf:AdvancedNotification", sourceValue, {
        icon = "CHAR_AGENT14",
        title = job, false, 
        text = "Vous présentez une facture de  ~g~ "..price.."$"
    })
end)

AddEventHandler('job:facture2', function(officer, code)
    if(code==1) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'JOB', false, 
            text = "Facture déjà en cours"
        })
    elseif(code==2) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'JOB', false, 
            text = "Fin de la requête (facture)"
        })
    elseif(code==3) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'JOB', false, 
            text = "Facture refusée"
        })
    elseif(code==0) then
        TriggerClientEvent("bf:AdvancedNotification", officer, {
            icon = "CHAR_AGENT14",
            title = 'JOB', false, 
            text = "Facture acceptée"
        })
	end
end)


-- source is global here, don't add to function
AddEventHandler("job:sell", function (type, job, price, message)
  local sourceValue = source
  local discord = exports.bro_core:GetDiscordFromSource(sourceValue) 
  MySQL.ready(function ()
    MySQL.Async.fetchScalar('SELECT amount FROM `player_item`, players where players.id = player_item.player and discord = @discord and item = @item',
    {
        ['@discord'] =  discord,
        ['@item']  = type
    },
    function(amount)
        if amount > 0 then
            MySQL.Async.execute('UPDATE accounts, job_account SET accounts.amount = accounts.amount + @amount WHERE job_account.job = @job and job_account.account= accounts.id ', 
            {
                ['@job'] = job,
                ['@amount'] = price
            }, function(result)
                if result == 1 then
                    MySQL.Async.execute('UPDATE player_item, players set amount = amount -1 where players.id = player_item.player and discord = @discord and item = @item ', 
                    {
                        ['@discord'] =  discord,
                        ['@item']  =type
                    }, function(result)
                        if result == 1 then
                            TriggerClientEvent("bf:Notification", sourceValue, message)
                        end
                    end)
                end
            end)
        else
            TriggerClientEvent("bf:Notification", sourceValue, "~r~Vous n'avez pas cet item")
        end
    end)
  end)
end)




-- source is global here, don't add to function
AddEventHandler("job:repair:price", function (type, name)
    local sourceValue = source
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('select price from vehicles where name = @name', {
            ['@name'] = name
        }, function(price)
            MySQL.Async.fetchScalar('SELECT AVG(price) FROM `vehicles`', {
            }, function(avg)
            if price == nil then 
                price = avg
                end
                if type == "window" then
                    price = price *0.005
                elseif type == "carroserie" then
                    price = price *0.02
                elseif type == "tyres" then
                    price = price *0.015
                elseif type == "motor" then
                    price = price *0.05
                end
                TriggerClientEvent("bf:Notification", sourceValue, "Prix conseillé : ~g~"..price.." $")
            end)
        end)
    end)
end)

AddEventHandler('playerDropped', function (reason)
    local sourceValue = source
	local discord = exports.bro_core:GetDiscordFromSource(sourceValue)

    local isIn = isIn
    local job = job
    MySQL.ready(function ()
        MySQL.Async.fetchScalar("select jobs.name from players, job_grades,jobs where jobs.id = job_grades.job and players.job_grade = job_grades.id  and discord = @discord", {
            ['@discord'] = discord,
        }, function(job)
            MySQL.Async.execute('Update players SET onDuty = 0 where discord= @discord',{['@discord'] = discord},
            function(affectedRows)
                if affectedRows > 0 then
                    if isIn then
                        TriggerEvent("job:clock:set", true, sourceValue, job)
                        TriggerClientEvent('bf:Notification', sourceValue, "Vous entrez en service")
                    else
                        TriggerEvent("job:clock:set", false, sourceValue, job)
                        TriggerClientEvent('bf:Notification', sourceValue, "Vous quittez le service")
                    end
                end
            end)
        end)
    end)
  end)

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

    }
}

RegisterNetEvent("job:get")

AddEventHandler('job:get', function (cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
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

RegisterNetEvent("job:isChef")

AddEventHandler('job:isChef', function (cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('SELECT grade FROM job_grades, players, jobs where jobs.id = job_grades.job and players.job_grade = job_grades.id and discord = @discord',
        {['discord'] =  discord},
        function(isChef)
                TriggerClientEvent(cb, sourceValue, isChef)
            end)
      end)
end)

RegisterNetEvent("job:set")

AddEventHandler('job:set', function (grade, notif)
    local sourceValue = source
    local source = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

    local gradee = grade
    MySQL.ready(function ()
        MySQL.Async.fetchAll('UPDATE players set job_grade= @grade where discord = @discord',
        {['@discord'] =  discord,
         ['@grade'] = gradee},
        function(res)
            TriggerClientEvent("bf:Notification", sourceValue, "Vous êtes maintenant ~g~"..notif)
        end)
      end)
end)


RegisterNetEvent("job:items:get")

AddEventHandler('job:items:get', function (cb, job)
    local sourceValue = source
    local source = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select items.label, job_item.amount, job_item.item from job_item, items where job = @job and items.id = job_item.item',
        {['@job'] = job},
        function(items)
            TriggerClientEvent(cb, sourceValue, items)
        end)
      end)
end)


RegisterNetEvent("job:items:withdraw")

AddEventHandler('job:items:withdraw', function (item, amount)
    local sourceValue = source
    local source = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
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

RegisterNetEvent("job:items:store")

AddEventHandler('job:items:store', function (item, amount)
    local sourceValue = source
    local source = source
    local discord = exports.bf:GetDiscordFromSource(sourceValue)
    local amount = amount
    local item = item
    print(item)
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
local moneyDutyTime = 60 *1000 *30

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
                            v.salary = v.salary/2
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
       -- MySQL.ready(function ()
         --   MySQL.Async.execute('Update accounts, players, job_grades SET accounts.amount = accounts.amount + job_grades.salary/2 where players.onDuty = 1 and accounts.player = players.id and players.job_grade = job_grades.id',{},
           -- function(affectedRows)
             --   MySQL.Async.fetchAll('select id from jobs',{},
              --  function(res)
                  --  for k,v in pairs(res) do
                     --   MySQL.Async.fetchScalar('select SUM(salary/2) from job_grades, players where players.job_grade = job_grades.id and job = @job and onDuty=1',
                     --   {['@job'] = job},
                      --  function(sum)
                      --      if sum ~= nil then
                    --            MySQL.Async.execute('Update jobs set money = money-@money',
                  --              {['@money'] = sum},
                --                function(numRows)
              --                      TriggerClientEvent('bf:Notification', -1, "Vous avez reçu votre paie")
            --                    end)
                --            end
              --          end)
           ---         end
          --      end)
        --    end)
      --  end)
    end
end)

RegisterNetEvent("jobs:sell")

AddEventHandler('jobs:sell', function (item, price, shop)
    local source = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)


    MySQL.ready(function ()
        MySQL.Async.fetchAll('select money from shops where id = @id',{['id'] = shop},
        function(res)
            if res and res[1] and res[1].money > price then
                MySQL.Async.execute('Update shops SET money=money-@price where id = @id',{['price'] = price, ['id'] = shop},
                function(affectedRows)
                    if(affectedRows == 1) then
                        MySQL.Async.execute('Update players SET liquid=liquid+@price where discord = @discord',{['price'] = price, ['discord'] = discord},
                        function(affectedRows)
                            if(affectedRows == 1) then
                                TriggerEvent("items:sub", item, 1)
                                MySQL.Async.execute('INSERT INTO shop_item (id, shop, item, amount) VALUES(1, @shop, @item, 1) ON DUPLICATE KEY UPDATE amount=amount+1',{
                                    ['shop'] = shop,
                                    ['item'] = item,
                                },
                                function(affectedRows)
                                    if(affectedRows == 1) then
                                        TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Transaction effectué", false)
                                    end
                                end)
                            else
                                TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Error 4", false)
                            end
                        end)
                    else
                        TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Error 3", false)
                    end
                end)
            else
                TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Le magasin ne peut pas vous payer !", false)
            end
        end)
    end)
end)



--- safe
RegisterNetEvent("job:safe:deposit")

AddEventHandler('job:safe:deposit', function (withdraw, amount, job)
    local source = source
    local withdraw = withdraw
    local amount = tonumber(amount)
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

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
                                    TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Vous avez retiré ".. amount .. " $", false)
                                end
                            end)
                        end
                    end)
                else
                    TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Le compte de l'entreprise n'est pas aussi rempli !", false)
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
                                    TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Vous avez déposé ".. amount .. " $", false)
                                end
                            end)
                        end
                    end)
                else
                    TriggerClientEvent("lspd:notify",  source,  "CHAR_BANK_FLEECA", -1,"Volus n'avez pas tant d'argent !", false)
                end
            end)
        end
    end)
end)



--- Parkings
RegisterNetEvent("job:parking:get")

AddEventHandler('job:parking:get', function (cb, id, job)
    local source = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

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
RegisterNetEvent("job:lsms:revive")

AddEventHandler('job:lsms:revive', function (player)
    local source = source
    TriggerClientEvent("job:revive", player)
end)


RegisterNetEvent("job:lsms:distress")

AddEventHandler('job:lsms:distress', function(player)
    --check le nombre d'ambulanciers présent
    --TODO disable or true, when phone woirking
    if #inService["lsms"] == 0 or true then
        TriggerClientEvent('job:lsms:revive', source)
    else
        TriggerClientEvent('bf:Notification', sourceValue, "Appel en cours")
        for k,v in pairs(inService["LSMS"])do
            TriggerClientEvent('bf:Notification', v, "Appel en cours")
        end
    end
end)



-- homes
RegisterNetEvent("job:avert:all")

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
            end
            TriggerClientEvent('bf:Notification', v, message)
        end
        if not silent then
            TriggerClientEvent('bf:Notification', sourceValue, "Votre appel à été émis pour le ~b~(".. job.. ")")
        end
    end
end)

RegisterNetEvent("job:inService:number")

AddEventHandler("job:inService:number", function (cb, job)
    TriggerClientEvent(cb, source, #inService[job])
end)


-- clock in
RegisterNetEvent("job:clock:set")

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
RegisterNetEvent("job:clock")

AddEventHandler("job:clock", function (isIn, job)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)

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


RegisterNetEvent("job:service:recruit")

AddEventHandler("job:service:recruit", function (job, player)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(player)
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
                if affectedRows > 0 then
                end
            end)
        end)
    end)
end)

RegisterNetEvent("job:service:promote")

AddEventHandler("job:service:promote", function (player)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(player)
    MySQL.ready(function ()
        MySQL.Async.execute('Update players SET job_grade = @job_grade+1 where discord = @discord',
        {
            ['@discord'] = discord,
            ['@job_grade'] = job_grade
        },function(affectedRows)
            if affectedRows > 0 then
            end
        end)
    end)
end)
RegisterNetEvent("job:service:demote")

AddEventHandler("job:service:demote", function (player)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(player)
    MySQL.ready(function ()
        MySQL.Async.execute('Update players SET job_grade = @job_grade-1 where discord = @discord',
        {
            ['@discord'] = discord,
            ['@job_grade'] = job_grade
        },function(affectedRows)
            if affectedRows > 0 then
            end
        end)
    end)
end)

RegisterNetEvent("job:get:player")

-- source is global here, don't add to function
AddEventHandler('job:get:player', function(cb)
	local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
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


RegisterNetEvent("weapon:store")

-- source is global here, don't add to function
AddEventHandler('weapon:store', function(weapon)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.insert('update job_armory,players, job_grades, jobs set amount = amount+1 where weapon = @weapon and jobs.id = job_armory.job and players.discord = @discord and job_grades.id = players.job_grade and jobs.id = job_grades.job', {
            ['@weapon'] =  weapon,
            ['@discord'] =  discord
        }, function(res)
        end)
    end)
end)

RegisterNetEvent("weapon:get:all")

-- source is global here, don't add to function
AddEventHandler('weapon:get:all', function(cb)
    local sourceValue = source
	local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.fetchAll('select * from job_armory,players,job_grades,jobs  where jobs.id = job_armory.job and players.discord = @discord and job_grades.id = players.job_grade and jobs.id = job_grades.job', {
            ['@discord'] =  discord
        }, function(res)
            TriggerClientEvent(cb, sourceValue, res)
        end)
    end)
end)

RegisterNetEvent("weapon:get")

-- source is global here, don't add to function
AddEventHandler('weapon:get', function(cb, weapon)
    local sourceValue = source
    local discord = exports.bf:GetDiscordFromSource(sourceValue)
    MySQL.ready(function ()
        MySQL.Async.insert('update job_armory,players, job_grades, jobs set amount = amount-1 where weapon = @weapon and jobs.id = job_armory.job and players.discord = @discord and job_grades.id = players.job_grade and jobs.id = job_grades.job', {
            ['@weapon'] =  weapon,
            ['@discord'] =  discord
        }, function(res)
            TriggerClientEvent(cb, sourceValue, weapon)
        end)
    end)
end)
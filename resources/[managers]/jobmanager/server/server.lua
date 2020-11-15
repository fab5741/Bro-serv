RegisterNetEvent("job:get")

AddEventHandler('job:get', function (cb)
    local sourceValue = source
    for k,v in pairs(GetPlayerIdentifiers(source))do
		
			
		  if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		  elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		  elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		  elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		  elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		  elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		  end
	end
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT jobs.name as job, job_grades.label as grade from players, job_grades, jobs where players.job_grade = job_grades.id and jobs.id = job_grades.job and fivem = @fivem',
        {['fivem'] =  discord}, function(res)
                if(res[1]) then
                    TriggerClientEvent(cb, sourceValue, res)
                else
                    TriggerClientEvent(cb, sourceValue, {job = "Chomeur", grade = "Chomeur"})
                end
            end)
      end)
end)



RegisterNetEvent("job:set")

AddEventHandler('job:set', function (grade)
    local sourceValue = source
    local gradee = grade
    MySQL.ready(function ()
        MySQL.Async.fetchAll('UPDATE players set job_grade= @grade where fivem = @fivem',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5],
         ['grade'] = gradee},
        function(res)
            TriggerClientEvent("job:draw", sourceValue)
        end)
      end)
end)


-- time for each paycheck
local moneyDutyTime = 30 *1000 * 60

-- Key Controls
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(moneyDutyTime)
        print("Time for paycheck")

        -- Check if people are working
        MySQL.ready(function ()
            MySQL.Async.execute('Update accounts, players, job_grades SET accounts.amount = accounts.amount + job_grades.salary/2 where players.onDuty = 1 and accounts.player = players.id and players.job_grade = job_grades.id',{},
            function(affectedRows)
                TriggerClientEvent("lspd:notify",  -1,  "CHAR_BANK_FLEECA", -1,"Vous avez reçu votre paie", false)
            end)
        end)
    end
end)

RegisterNetEvent("jobs:sell")

AddEventHandler('jobs:sell', function (item, price, shop)
    local source = source
        for k,v in pairs(GetPlayerIdentifiers(source))do
            
                
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
            end
    end

    MySQL.ready(function ()
        MySQL.Async.fetchAll('select money from shops where id = @id',{['id'] = shop},
        function(res)
            if res and res[1] and res[1].money > price then
                MySQL.Async.execute('Update shops SET money=money-@price where id = @id',{['price'] = price, ['id'] = shop},
                function(affectedRows)
                    if(affectedRows == 1) then
                        MySQL.Async.execute('Update players SET liquid=liquid+@price where fivem = @fivem',{['price'] = price, ['fivem'] = discord},
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
        for k,v in pairs(GetPlayerIdentifiers(source))do               
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
            end
    end
    MySQL.ready(function ()
        if withdraw then
            MySQL.Async.fetchAll('select money from jobs where name = @job',{['job'] = job},
            function(res)
                if res and res[1] and res[1].money >= amount then
                    MySQL.Async.execute('Update players SET liquid=liquid+@amount where fivem = @fivem',{['amount'] = amount, ['fivem'] = discord},
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
            MySQL.Async.fetchAll('select liquid from players where fivem = @fivem',{['fivem'] = discord},
            function(res)
                if res and res[1] and res[1].liquid >= amount then
                    MySQL.Async.execute('Update players SET liquid=liquid-@amount where fivem = @fivem',{['amount'] = amount, ['fivem'] = discord},
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

AddEventHandler('job:parking:get', function (id)
    local source = source
        for k,v in pairs(GetPlayerIdentifiers(source))do               
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
            end
    end
    print(id)
    MySQL.ready(function ()
        MySQL.Async.execute('Update player_vehicle SET parking="" where id = @id',{['id'] = id},
        function(affectedRows)
            if affectedRows == 1 then
                print("get the car")
                MySQL.Async.fetchAll('select player_vehicle.id, name from player_vehicle, vehicles where player_vehicle.id= @id and vehicles.id = player_vehicle.vehicle',{['id'] = id},
                function(res)
                    TriggerClientEvent("job:getCar",  source, res[1].name, res[1].id)
                end)
            end
        end)
    end)
end)



RegisterNetEvent("job:parking:getAll")

AddEventHandler('job:parking:getAll', function (job)
    local source = source
        for k,v in pairs(GetPlayerIdentifiers(source))do               
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl  = v
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
            end
    end
    MySQL.ready(function ()
            MySQL.Async.fetchAll('select player_vehicle.id, name from player_vehicle, vehicles where parking = @job and vehicles.id = player_vehicle.vehicle',{['job'] = job},
            function(res)
                TriggerClientEvent("job:parking:getAll",  source, job, res)
            end)
    end)
end)




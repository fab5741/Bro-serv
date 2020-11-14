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

AddEventHandler('jobs:sell', function (item, shop)
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

    MySQL.Async.fetchAll('select id, amount from players, player_item where fivem = @fivem and player_item.item = @type and player_item.player = players.id',
    {['fivem'] =  discord,
    ['amount'] = item.amount,
    ['type'] = item.type},
    function(res)
        if res and res[1] and res[1].amount > 0 then
            MySQL.Async.execute('INSERT INTO `player_item` (`player`, `item`, `amount`) VALUES (@id, @type, @amount) ON DUPLICATE KEY UPDATE amount=amount-@amount;',
            {['id'] = res[1].id,
            ['amount'] = item.amount,
            ['type'] = item.type},
            function(affectedRows)
                    MySQL.Async.execute('UPDATE shops SET amount=amount+@amount WHERE type=@shop and item = @item',
                    {['id'] = res[1].id,
                    ['item'] = item.type,
                    ['amount'] = item.amount,
                    ['shop'] = shop},
                    function(res)
                        MySQL.Async.execute('UPDATE players SET liquid = liquid + @amount WHERE players.fivem = @fivem',
                        {['fivem'] =  discord,
                        ['amount'] = item.amount * item.price,
                        },
                        function(res)
                            TriggerClientEvent("job:sell", source, true)
                        end)
                    end)
            end)
        else
            TriggerClientEvent("job:sell", source, false)
        end
    end)
end)
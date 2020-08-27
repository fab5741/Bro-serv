RegisterNetEvent("job:get")

AddEventHandler('job:get', function ()
    local sourceValue = source
    MySQL.ready(function ()
        MySQL.Async.fetchAll('SELECT jobs.name as job, job_grades.label as grade from players, job_grades, jobs where players.job_grade = job_grades.id and jobs.id = job_grades.job and fivem = @fivem',
        {['fivem'] =  GetPlayerIdentifiers(sourceValue)[5]}, function(res)
            if(res[1]) then
             TriggerClientEvent("job:draw", sourceValue, res[1].job, res[1].grade)
            else
              TriggerClientEvent("job:draw", sourceValue, "Chomeur", "Chomeur")
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
local moneyDutyTime = 1800 *1000

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(moneyDutyTime)

        -- Check if people are working
        MySQL.ready(function ()
            MySQL.Async.execute('Update accounts, players, job_grades SET accounts.amount = accounts.amount + job_grades.salary/2 where players.onDuty = 1 and accounts.player = players.id and players.job_grade = job_grades.id',{},
            function(affectedRows)
                TriggerClientEvent("notify:SendNotification", -1, {text= "Vous avez reçu votre paie", type = "error", timeout = 2000})
            end)
        end)
    end
end)
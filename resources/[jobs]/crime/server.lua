RegisterServerEvent('crime:drug:sell')

function isIntrested()
    local percent = math.random(1, 2)
    if percent == 1  then 
      return true
    else 
      return false
    end
end


AddEventHandler('crime:drug:sell', function(deal)
    local sourceValue = source
    local discord = exports.bro_core:GetDiscordFromSource(sourceValue)
    local price = 80.0
    MySQL.ready(function ()
        MySQL.Async.fetchScalar('SELECT count(*) FROM `players`, job_grades where onDuty = true and job_grade = job_grades.id and job_grades.job = 2',{}, function(CopsConnected)
            if CopsConnected > 0 then
                if isIntrested() then
                        MySQL.Async.fetchScalar('SELECT amount from player_item, players where players.discord = @discord and player_item.player = players.id and player_item.item = 7', {
                            ['@discord'] = discord,
                        }, function(amount)
                            if amount > 1 then
                                TriggerClientEvent("crime:drug:sell", sourceValue, price)
                                TriggerClientEvent('bro_core:TextNotification', sourceValue, {text="Vendu pour ~g~ "..price.." $"})
                                
                                local poukichance = math.random (1,4)
                                if poukichance == 1 then
                                    TriggerClientEvent("crime:drug:poucave", sourceValue, deal.x, deal.y, deal.z)
                                end
                            else
                                TriggerClientEvent('bro_core:TextNotification', sourceValue, {text="~r~Tu n'a pas assez de matos."})
                            end
                        end)
                else
                    TriggerClientEvent('bro_core:TextNotification', sourceValue, {text="~r~Je touche pas à ta merde."})
                end
            else
                TriggerClientEvent('bro_core:TextNotification', sourceValue, {text="~r~Pas assez de policiers connecté"})
            end
        end)
    end)
end)
  
-------------------------
--- robery ---
-------------------------
--- Server ---
robberyActive = false
RegisterNetEvent('robery:IsActive')
AddEventHandler('robery:IsActive', function()
	-- Check if active or not
	if robberyActive then
		-- One is active
		TriggerClientEvent('robery:IsActive:Return', source, true)
	else
		-- One is not active
		TriggerClientEvent('robery:IsActive:Return', source, false)
	end
end)

RegisterNetEvent('robery:SetActive')
AddEventHandler('robery:SetActive', function(bool)
	robberyActive = bool
	if bool then
		Wait((1000 * 60 * config.robberyCooldown)) -- Wait 15 minutes
		robberyActive = false
	end
end)
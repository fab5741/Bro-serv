Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)
  Wait(0)

local f1Menu = false
local inputActivating = false

  while true do
    Wait(0)

      if not inputActivating then
        if IsControlPressed(0, 288) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        inputActivating = true
          if f1Menu then
            f1Menu = false

            SendNUIMessage({
              type = 'close'
            })
          else
            f1Menu = true

            SendNUIMessage({
              type = 'open'
            })
          end
        end
      end
      
      if inputActivating then
        if not IsControlPressed(0, 288) then
          inputActivating = false
        end
      end
  end

  GUI.Time = 0

  Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)

			if IsControlPressed(0, 18) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action = 'controlPressed', control = 'ENTER'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 177) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action  = 'controlPressed', control = 'BACKSPACE'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 27) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 200 then
				SendNUIMessage({action  = 'controlPressed', control = 'TOP'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 173) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 200 then
				SendNUIMessage({action  = 'controlPressed', control = 'DOWN'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 174) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action  = 'controlPressed', control = 'LEFT'})
				GUI.Time = GetGameTimer()
			end

			if IsControlPressed(0, 175) and IsInputDisabled(0) and (GetGameTimer() - GUI.Time) > 150 then
				SendNUIMessage({action  = 'controlPressed', control = 'RIGHT'})
				GUI.Time = GetGameTimer()
			end
		end
	end)
end)

Citizen.CreateThread(function() 
  while true do

    Citizen.Wait(0)
    HideHudComponentThisFrame(1);
    HideHudComponentThisFrame(2);
    HideHudComponentThisFrame(3);
    HideHudComponentThisFrame(4);
    HideHudComponentThisFrame(5);
    HideHudComponentThisFrame(6);
    HideHudComponentThisFrame(7);
    HideHudComponentThisFrame(8);
    HideHudComponentThisFrame(9);
    HideHudComponentThisFrame(11);
    HideHudComponentThisFrame(12);
    HideHudComponentThisFrame(13);
    HideHudComponentThisFrame(14);
    HideHudComponentThisFrame(15);
    HideHudComponentThisFrame(17);
    HideHudComponentThisFrame(18);
    HideHudComponentThisFrame(20);
    HideHudComponentThisFrame(21);
    HideHudComponentThisFrame(22);
  end
end)
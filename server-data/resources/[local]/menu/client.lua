Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)
  Wait(0)

  SendNUIMessage({
    type = 'createMenu',
    text = 'Mon super menu'
  })
  SendNUIMessage({
    type = 'createMenuLine',
    text = 'TEst'
  })

  SendNUIMessage({
    type = 'createMenuLine',
    text = 'TEst2'
  })

  SendNUIMessage({
    type = 'createMenuLine',
    text = 'TEs3'
  })


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
end)

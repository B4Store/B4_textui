local callback
local activeNotification = false
-- Add more letters here or whatever you want.
local KEYS = {
  ["E"] = 38,
  ["F"] = 49,
  ["H"] = 74
}

local function onPersist(key)
  if callback then
    CreateThread(function()
      while true do
        if IsControlJustReleased(0, key) then
          SendNUIMessage({
            type = "HIDE"
          })
          callback(key, ("Key %s was pressed"):format(key))
          callback = nil
          break
        end
        Wait(0)
      end
    end)
  end
end

local function updateText(text, key)
  SendNUIMessage({
    type = "UPDATE_TEXT",
    body = {
      message = text,
      key = key:upper()
    }
  })
end

local function showPersist(message, key, cb)
  local findKey = key:upper()
  if activeNotification then
    SendNUIMessage({
      type = "UPDATE_TEXT",
      body = {
        message = message,
        key = findKey
      }
    })
    print(("Updated text to %s"):format(message))
    return
  end

  activeNotification = true
  SendNUIMessage({
    type = "SHOW",
    body = {
      message = message,
      key = findKey
    }
  })

  if cb then
    callback = cb
    onPersist(KEYS[findKey])
  end
end

local function hidePersist()
  if not activeNotification then
    return
  end
  SendNUIMessage({
    type = "HIDE"
  })
  activeNotification = false
  if callback then
    callback(nil, "HIDDEN")
    callback = nil
  end
end

exports('updateText', updateText)
exports('showPersist', showPersist)
exports('hidePersist', hidePersist)



--  -- Uses keys from the KEYS table
--   exports['B4_textui']:showPersist("Open door", "E", function(result, msg)
--     print(result)
--     print(msg)
--   end)

--   -- Custom use
-- CreateThread(function()
--   local ped = PlayerPedId()
--   local activeNotification = false
--   local timeout = 1000
--   while true do
--     local coords = GetEntityCoords(ped)
--     local dist = #(coords - vector3(-232.114, -966.42, 29.27))
--     if dist < 4.0 then
--       if timeout ~= 0 then
--         timeout = 0
--       end
--       if not activeNotification then
--         activeNotification = true
--         exports['B4_textui']:showPersist("Open door", "E")
--       end
--       if IsControlJustReleased(0, 38) then
--         exports['B4_textui']:hidePersist()
--       end
--     else
--       if activeNotification then
--         exports['B4_textui']:hidePersist()
--         activeNotification = false
--       end
--       if timeout ~= 1000 then
--         timeout = 1000
--       end
--     end
--     Wait(TIMEOUT)
--   end
-- end)

--
-- @Project: FiveM Tools
-- @Author: Samuelds, Izio38
-- @License: GNU General Public License v3.0
-- @Source: https://github.com/FivemTools/bf
--

--
-- print table
--
function PrintTable(table, indent)

    if type(table) == "table" then

        if not indent then
            indent = 0
        end

        for k, v in pairs(table) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
                print(formatting)
                PrintTable(v, indent + 1)
            elseif type(v) == "boolean" then
                if v then
                    print(formatting .. "true")
                else
                    print(formatting .. "false")
                end
            elseif type(v) == "nil" then
                print(formatting .. "nil")
            elseif type(v) == "function" then
                print(formatting .. "function")
            else
                print(formatting .. tostring(v) .. " (" .. type(v) .. ")")
            end
        end

    elseif type(table) == "boolean" then

        if table then
            print("true")
        else
            print("false")
        end

    elseif type(table) == "nil" then

        print("nil")

    elseif type(table) == "function" then

        print("function")

    else

        print(tostring(table)  .. " (" .. type(table) .. ")")

    end

end

--
-- Count table
--
function TableLength(table)

    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count

end

--
-- Round number
--
function Round(settings)

    settings = settings or {}
    local number = settings.number or 0
    local decimal = settings.decimal or 1
    local mult = 10 ^ decimal
    return math.floor(number * mult + 0.5) / mult

end

--
-- Comat number
--
function CommaValue(settings)

    settings = settings or {}
    local number = settings.number or ""
    local separator = settings.separator or " "

    if settings.decimal ~= nil then
        number = Round({ number = number, decimal = settings.decimal })
    end

    while true do
        number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1' .. separator .. '%2')
        if k==0 then
            break
        end
    end
    return number

end

--
-- Copy table
--
function Copy(t)

    if type(t) ~= "table" then
        return t
    end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        target[k] = v
    end
    setmetatable(target, meta)
    return target
end

--
-- Clone table
--
function Clone(t)

    if type(t) ~= "table" then
        return t
    end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = Clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target

end

--
-- Debug print
--

debugMode = false

--
--
--
function SetDebug(status)

  assert(type(status) == "boolean" or boolean == 1 or boolean == 0, "SetDebug : status must be boolean or number")

  if status == 1 then
      status = true
  elseif status == 0 then
      status = false
  end
  debugMode = status

end

--
--
--
function DebugPrint(...)

    if debugMode then
    local args = {...}
    local count = #args

    if count > 1 then
        print("------[ " .. args[2].. " ]------")
        PrintTable(args[1])
        print("-----[ END " .. args[2].. " ]-----")
    else
        print("------[ BF_DEBUG ]------")
        PrintTable(args[1])
        print("-----[ END BF_DEBUG ]-----")
    end

    end

end

--
--
--
function TableContainsValue(table, data)

    for key, value in pairs(table) do
        if value == data then
            return key
        end
    end
    return false

end

--
--
--
function GetLastContentValue(table)

    local total = #table
    return table[total]

end

--
--
--
local charset = {}
for i = 48, 57 do table.insert(charset, string.char(i)) end
for i = 65, 90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function GetRandomString(length)

    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomString(length - 1) .. charset[math.random(1, #charset)]
    else
        return ""
    end

end

--
--
--
function GetDistanceBetween3DCoords(x1, y1, z1, x2, y2, z2)

    if x1 ~= nil and y1 ~= nil and z1 ~= nil and x2 ~= nil and y2 ~= nil and z2 ~= nil then
        return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2)
    end
    return -1

end

function comma_value(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
  end


  
  ---============================================================
  -- rounds a number to the nearest decimal places
  --
  function round(val, decimal)
    if (decimal) then
      return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
    else
      return math.floor(val+0.5)
    end
  end
  
  --===================================================================
  -- given a numeric value formats output with comma to separate thousands
  -- and rounded to given decimal places
  --
  --
  function format_num(amount, decimal, prefix, neg_prefix)
    local str_amount,  formatted, famount, remain
  
    decimal = decimal or 2  -- default 2 decimal places
    neg_prefix = neg_prefix or "-" -- default negative sign
  
    famount = math.abs(round(amount,decimal))
    famount = math.floor(famount)
  
    remain = round(math.abs(amount) - famount, decimal)
  
          -- comma to separate the thousands
    formatted = comma_value(famount)
  
          -- attach the decimal portion
    if (decimal > 0) then
      remain = string.sub(tostring(remain),3)
      formatted = formatted .. "." .. remain ..
                  string.rep("0", decimal - string.len(remain))
    end
  
          -- attach prefix string e.g '$' 
    formatted = (prefix or "") .. formatted 
  
          -- if value is negative then format accordingly
    if (amount<0) then
      if (neg_prefix=="()") then
        formatted = "("..formatted ..")"
      else
        formatted = neg_prefix .. formatted 
      end
    end
  
    return formatted
  end


--
-- Format money values
--
function Money(money)
    if money > 0 then
        color = "~g~"
    elseif money < 0 then
        color = "~r~"
    else 
        color ="~w~"
    end
    return color..format_num(money, 0).." ~s~$"
end
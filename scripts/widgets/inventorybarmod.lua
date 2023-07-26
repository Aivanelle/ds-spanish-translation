local Inv = require "widgets/inventorybar"
local GetOriginalDescriptionString = Inv.GetDescriptionString

function Inv:GetDescriptionString(item)
  local str = GetOriginalDescriptionString(self, item)
  local adjective = item:GetAdjective()

  if str ~= "" and adjective then
    if showAdjectivesConfig then
      local name = item:GetDisplayName()

      return str:gsub(escape_lua_pattern(adjective .. " " .. name), ConstructAdjectivedName(item, name, adjective))
    else
      return str:gsub(escape_lua_pattern(adjective .. " "), "")
    end
  end

  return str
end

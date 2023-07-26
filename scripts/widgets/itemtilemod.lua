local ItemTile = require "widgets/itemtile"
local GetOriginalDescriptionString = ItemTile.GetDescriptionString or function() return "" end

function ItemTile:GetDescriptionString()
  local str = GetOriginalDescriptionString(self)
  local adjective = self.item:GetAdjective()

  if str ~= "" and adjective then
    if showAdjectivesConfig then
      local name = self.item:GetDisplayName()

      return str:gsub(escape_lua_pattern(adjective .. " " .. name), ConstructAdjectivedName(self.item, name, adjective))
    else
      return str:gsub(escape_lua_pattern(adjective .. " "), "")
    end
  end

  return str
end

local Inv = require "widgets/inventorybar"
local GetOriginalDescriptionString = Inv.GetDescriptionString or function() return "" end

if anyDLCEnabled then
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
end

local OriginalUpdateCursorText = Inv.UpdateCursorText

function Inv:UpdateCursorText()
  OriginalUpdateCursorText(self)

  if not anyDLCEnabled then self.actionstringtitle:SetColour(NORMAL_TEXT_COLOUR) end

  local item = self:GetCursorItem() or (self.cursortile and self.cursortile.item)

  if colorPerishablesConfig and item --[[and item.components ]]and item.components.perishable and not item.components.perishable:IsFresh() then
    local TEXT_COLOR = item.components.perishable:IsStale() and STALE_TEXT_COLOR or SPOILED_TEXT_COLOR
    self.actionstringtitle:SetColour(TEXT_COLOR)
  end
end

local Inv = require "widgets/inventorybar"
local GetOriginalDescriptionString = Inv.GetDescriptionString or function() return "" end

if anyDLCEnabled then
  function Inv:GetDescriptionString(item)
    local str = GetOriginalDescriptionString(self, item)
    local adjective = item:GetAdjective()
  
    if str ~= "" and adjective then
      if showAdjectivesConfig then
        local name = item:GetDisplayName()
        local grammaticalAdjective = item.components.perishable and item.components.perishable:GetGrammaticalAdjective()
  
        if not grammaticalAdjective then
          return unknownAdjectivesConfig == "default" and egsub(str, adjective .. " " .. name, ConstructAdjectivedName(item, name, adjective)) or
            egsub(str, adjective .. " ", "")
        else
          return egsub(str, adjective .. " " .. name, ConstructAdjectivedName(item, name, grammaticalAdjective))
        end
      else
        return egsub(str, adjective .. " ", "")
      end
    end
  
    return str
  end
end

local OriginalUpdateCursorText = Inv.UpdateCursorText

function Inv:UpdateCursorText()
  OriginalUpdateCursorText(self)

  if not anyDLCEnabled then self.actionstringtitle:SetColour(NORMAL_TEXT_COLOR) end

  local item = self:GetCursorItem() or (self.cursortile and self.cursortile.item)

  if colorPerishablesConfig and item and item.components.perishable and not item.components.perishable:IsFresh() then
    local TEXT_COLOR = item.components.perishable:IsStale() and STALE_TEXT_COLOR or SPOILED_TEXT_COLOR
    self.actionstringtitle:SetColour(TEXT_COLOR)
  end
end

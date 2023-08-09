local ItemTile = require "widgets/itemtile"
local OriginalUpdateTooltip = ItemTile.UpdateTooltip or function() return "" end

function ItemTile:UpdateTooltip()
  OriginalUpdateTooltip(self)

  --[[
    For some reason, SetTooltipColour method doesn't work without any DLC enabled.
    if not anyDLCEnabled then self:SetTooltipColour(NORMAL_TEXT_COLOR) end
  ]]
  if colorPerishablesConfig and self:HasSpoilage() and not self.item.components.perishable:IsFresh() then
    local TEXT_COLOR = self.item.components.perishable:IsStale() and STALE_TEXT_COLOR or SPOILED_TEXT_COLOR
    self:SetTooltipColour(TEXT_COLOR)
  end
end

local GetOriginalDescriptionString = ItemTile.GetDescriptionString or function() return "" end

function ItemTile:GetDescriptionString()
  local str = GetOriginalDescriptionString(self)
  local adjective = self.item:GetAdjective()

  if str ~= "" and adjective then
    if showAdjectivesConfig then
      local name = self.item:GetDisplayName()
      local grammaticalAdjective = self.item.components.perishable and self.item.components.perishable:GetGrammaticalAdjective()

      if not grammaticalAdjective then
        return unknownAdjectivesConfig == "default" and egsub(str, adjective .. " " .. name, ConstructAdjectivedName(self.item, name, adjective)) or
          egsub(str, adjective .. " ", "")
      else
        return egsub(str, adjective .. " " .. name, ConstructAdjectivedName(self.item, name, grammaticalAdjective))
      end
    else
      return egsub(str, adjective .. " ", "")
    end
  end

  return str
end

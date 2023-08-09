local Perishable = require "components/perishable"
local GetOriginalAdjective = Perishable.GetAdjective

function Perishable:GetAdjective()
  local adjective = GetOriginalAdjective(self)

  if self.inst.components.edible and not self:IsFresh() and self.inst:HasTag("frozen") then
    return STRINGS.UI.HUD[self:IsStale() and "STALE_FROZEN" or "SPOILED_FROZEN"]
  end

  return adjective
end

function Perishable:GetGrammaticalAdjective()
  if self.inst.components.grammar then
    if self.inst.components.edible and not self:IsFresh() then
      if self.inst:HasTag("frozen") then return self:GetAdjective() end

      return self.inst:GetGrammaticalSuffix(STRINGS.SUFFIX.PERISHABLE[self:IsStale() and "STALE" or "SPOILED"])
    elseif self.inst.components.eater and not self:IsFresh() then
      return self.inst:GetGrammaticalSuffix(STRINGS.SUFFIX.CREATURE[self:IsStale() and "HUNGRY" or "STARVING"])
    end
  end
end

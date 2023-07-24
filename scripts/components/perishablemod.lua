local Perishable = require "components/perishable"

function Perishable:GetAdjective()
  if self.inst.components.edible then
    if self:IsStale() then
      return self.inst:HasTag("frozen") and STRINGS.UI.HUD.STALE_FROZEN or
        (self.inst:GetGrammaticalSuffix(STRINGS.SUFFIX.PERISHABLE.STALE) or STRINGS.UI.HUD.STALE)
    elseif self:IsSpoiled() then
      return self.inst:HasTag("frozen") and STRINGS.UI.HUD.STALE_FROZEN or
        (self.inst:GetGrammaticalSuffix(STRINGS.SUFFIX.PERISHABLE.SPOILED) or STRINGS.UI.HUD.SPOILED)
    end
  elseif self.inst.components.eater then
    if self:IsStale() then
      return self.inst:GetGrammaticalSuffix(STRINGS.SUFFIX.CREATURE.HUNGRY) or STRINGS.UI.HUD.HUNGRY
    elseif self:IsSpoiled() then
      return self.inst:GetGrammaticalSuffix(STRINGS.SUFFIX.CREATURE.STARVING) or STRINGS.UI.HUD.STARVING
    end
  end
end

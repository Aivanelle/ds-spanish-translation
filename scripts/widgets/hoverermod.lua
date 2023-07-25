local HoverText = require "widgets/hoverer"
local OnUpdateOriginal = HoverText.OnUpdate or function() return "" end

function HoverText:OnUpdate()
  OnUpdateOriginal(self)

  local str = self.text:GetString()
  local lmb = self.owner.components.playercontroller:GetLeftMouseAction()

  if str ~= "" and lmb and lmb.target then
    local adjective = lmb.target:GetAdjective()
    if not adjective then return end

    if showAdjectivesConfig then
      local name = lmb.target:GetDisplayName() or (lmb.target.components.named and lmb.target.components.named.name)

      str = str:gsub(adjective .. " " .. name, ConstructAdjectivedName(lmb.target, name, adjective))
      self.text:SetString(str)
    else
      self.text:SetString(str:gsub(adjective .. " ", ""))
    end
  end
end

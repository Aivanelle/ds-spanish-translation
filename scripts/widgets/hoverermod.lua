local subfmt = _G.subfmt
local stackStyles = _G.stackStyles
local modConfigurationName = _G.ModIndex:GetModConfigurationName("Traducción al Español")
local stackStyleConfig = GetModConfigData("stackStyle", modConfigurationName)
local stackStyle = stackStyles[stackStyleConfig] or stackStyles.default
local HoverText = require "widgets/hoverer"
local OnUpdateOriginal = HoverText.OnUpdate or function() return "" end

function HoverText:OnUpdate()
  OnUpdateOriginal(self)

  local str = self.text:GetString()
  local lmb = self.owner.components.playercontroller:GetLeftMouseAction()

  if str ~= "" and lmb and lmb.target then
    if lmb.target.components.stackable and lmb.target.components.stackable.stacksize > 1 and stackStyleConfig ~= "default" then
      local stack = lmb.target.components.stackable.stacksize

      str = str:gsub("x" .. stack, subfmt(stackStyle, { stack = stack }))
    end

    local adjective = lmb.target:GetAdjective()
    if adjective then
      if showAdjectivesConfig then
        local name = lmb.target:GetDisplayName() or (lmb.target.components.named and lmb.target.components.named.name)

        str = str:gsub(adjective .. " " .. name, ConstructAdjectivedName(lmb.target, name, adjective))
      else
        str = str:gsub(adjective .. " ", "")
      end
    end

    self.text:SetString(str)
  end
end

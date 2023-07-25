local modConfigurationName = _G.ModIndex:GetModConfigurationName("Traducción al Español")
local stackStyleConfig = GetModConfigData("stackStyle", modConfigurationName)

local function stackString(lmb)
  local stackSize = tostring(lmb.target.components.stackable.stacksize)

  if stackStyleConfig == "parenthesis" then
    return "(" .. stackSize .. ")"
  end

  local char = nil
  if stackStyleConfig == "mathematician" then
    char = "× "
  end

  return (char or "x") .. stackSize
end

local HoverText = require "widgets/hoverer"
local OnUpdateOriginal = HoverText.OnUpdate or function() return "" end

function HoverText:OnUpdate()
  OnUpdateOriginal(self)

  local str = self.text:GetString()
  local lmb = self.owner.components.playercontroller:GetLeftMouseAction()

  if str ~= "" and lmb and lmb.target then
    if lmb.target.components.stackable and lmb.target.components.stackable.stacksize > 1 then
      str = str:gsub(" x" .. lmb.target.components.stackable.stacksize, " " .. stackString(lmb))
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

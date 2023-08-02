local modConfigurationName = _G.ModIndex:GetModConfigurationName("Traducción al Español")
local stackStyleConfig = GetModConfigData("stackStyle", modConfigurationName)
local stackStyle = stackStyles[stackStyleConfig] or stackStyles.default
local HoverText = require "widgets/hoverer"
local OnUpdateOriginal = HoverText.OnUpdate or function() return "" end
local insightEnabled = _G.KnownModIndex:IsModEnabled("workshop-2081254154")

function HoverText:OnUpdate()
  OnUpdateOriginal(self)

  if not anyDLCEnabled then self.text:SetColour(NORMAL_TEXT_COLOR) end

  local str = self.text:GetString()
  local lmb = self.owner.components and self.owner.components.playercontroller:GetLeftMouseAction()

  if str ~= "" and lmb and lmb.target then
    local components = lmb.target.components

    if components.stackable and components.stackable:IsStack() and stackStyleConfig ~= "default" then
      local stack = components.stackable:StackSize()

      str = str:gsub("x" .. stack, subfmt(stackStyle, { stack = stack }))
    end

    local adjective = lmb.target:GetAdjective()
    if adjective then
      if showAdjectivesConfig then
        local name = lmb.target:GetDisplayName() or (components.named and components.named.name)
        local grammaticalAdjective = components.perishable and components.perishable:GetGrammaticalAdjective()

        if not grammaticalAdjective then
          str = unknownAdjectivesConfig == "default" and egsub(str, adjective .. " " .. name, ConstructAdjectivedName(lmb.target, name, adjective)) or
            egsub(str, adjective .. " ", "")
        else
          str = egsub(str, adjective .. " " .. name, ConstructAdjectivedName(lmb.target, name, grammaticalAdjective))
        end
      else
        str = egsub(str, adjective .. " ", "")
      end

      if colorPerishablesConfig and not components.perishable:IsFresh() then
        self.text:SetColour(components.perishable:IsStale() and STALE_TEXT_COLOR or SPOILED_TEXT_COLOR)
      end
    end

    -- Just a minor tweak for compatibility with Insight.
    if insightEnabled then
      self.text.string = str
      self.text.inst.TextWidget:SetString(str)
    else
      self.text:SetString(str)
    end
  end
end

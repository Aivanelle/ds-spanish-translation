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
    if lmb.target.components.stackable and lmb.target.components.stackable:IsStack() and stackStyleConfig ~= "default" then
      local stack = lmb.target.components.stackable:StackSize()

      str = str:gsub("x" .. stack, subfmt(stackStyle, { stack = stack }))
    end

    local adjective = lmb.target:GetAdjective()
    if adjective then
      if showAdjectivesConfig then
        local name = lmb.target:GetDisplayName() or (lmb.target.components.named and lmb.target.components.named.name)

        -- For some reason that I can't comprehend, if I escape adjective and name by apart, it won't replace the string.
        str = str:gsub(escape_lua_pattern(adjective .. " " .. name), ConstructAdjectivedName(lmb.target, name, adjective))
      else
        str = str:gsub(escape_lua_pattern(adjective .. " "), "")
      end

      if colorPerishablesConfig and not lmb.target.components.perishable:IsFresh() then
        local TEXT_COLOR = lmb.target.components.perishable:IsStale() and STALE_TEXT_COLOR or SPOILED_TEXT_COLOR
        self.text:SetColour(TEXT_COLOR)
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

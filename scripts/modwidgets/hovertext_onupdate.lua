local ModIndex = _G.ModIndex
local ConfigurationName = ModIndex:GetModConfigurationName("Traducción al Español")

local function stackString(str, lmb)
  local stackStyle = GetModConfigData("stackStyle", ConfigurationName)
  
  if stackStyle == "parenthesis" then
    return str .. " (" .. tostring(lmb.target.components.stackable.stacksize) .. ")"
  end

  local multChar = nil
  if stackStyle == "classic" then
    multChar = " x"
  elseif stackStyle == "mathematician" then
    multChar = " × "
  end

  return str .. multChar .. tostring(lmb.target.components.stackable.stacksize)
end

local TheInput = _G.TheInput
local IsDLCEnabled = _G.IsDLCEnabled
local anyDLCEnabled = IsDLCEnabled(_G.REIGN_OF_GIANTS) or IsDLCEnabled(_G.CAPY_DLC) or IsDLCEnabled(_G.PORKLAND_DLC)
local ProfileStatsSet = _G.ProfileStatsSet
local showAdjectives = GetModConfigData("showAdjectives", ConfigurationName)
local adjectivedName = require("adjectivedperishable")
local HoverText = require "widgets/hoverer"

-- This is just a copy/paste of Klei's code, slightly modified to work with the mod.
if anyDLCEnabled then
  function HoverText:OnUpdate()
    local SW_or_HAM = IsDLCEnabled(_G.CAPY_DLC) or IsDLCEnabled(_G.PORKLAND_DLC)
    local using_mouse = nil

    if SW_or_HAM then
      using_mouse = (self.owner.components and self.owner.components.playercontroller:UsingMouse()) or not TheInput:ControllerAttached()
    else
      using_mouse = self.owner.components and self.owner.components.playercontroller:UsingMouse()
    end

    if using_mouse ~= self.shown then
      if using_mouse then
        self:Show()
      else
        self:Hide()
      end
    end

    if not self.shown then return end

    local str = nil
    local colour = nil

    if self.isFE == false then
      str = self.owner.HUD.controls:GetTooltip() or self.owner.components.playercontroller:GetHoverTextOverride()
      if self.owner.HUD.controls:GetTooltip() then
        colour = self.owner.HUD.controls:GetTooltipColour()
      end
    else
      str = self.owner:GetTooltip()
    end

    local WET_TEXT_COLOUR = _G.WET_TEXT_COLOUR
    local NORMAL_TEXT_COLOUR = _G.NORMAL_TEXT_COLOUR
    local secondarystr = nil

    if not str and self.isFE == false then
      local lmb = self.owner.components.playercontroller:GetLeftMouseAction()
      if lmb then
        str = lmb:GetActionString()

        if not colour and lmb.target then
          colour = (lmb.target and lmb.target:GetIsWet()) and WET_TEXT_COLOUR or NORMAL_TEXT_COLOUR

          if lmb.invobject and not (lmb.invobject.components.weapon or lmb.invobject.components.tool) then
            colour = (lmb.invobject and lmb.invobject:GetIsWet()) and WET_TEXT_COLOUR or NORMAL_TEXT_COLOUR
          end
        elseif not colour and lmb.invobject then
          colour = (lmb.invobject and lmb.invobject:GetIsWet()) and WET_TEXT_COLOUR or NORMAL_TEXT_COLOUR
        end

        if lmb.target and lmb.invobject == nil and lmb.target ~= lmb.doer then
          local name = lmb.target:GetDisplayName() or (lmb.target.components.named and lb.target.components.named.name)
          if name then
            if type(name) == "table" then
              local newname = nil
              for code,text in pairs(name) do
                print(code,text)
                newname = text
                break
              end
              name = newname
            end

            local adjective = lmb.target:GetAdjective()

            if IsDLCEnabled(_G.PORKLAND_DLC) then
              if showAdjectives and adjective then
                str = adjectivedName(lmb)
              elseif not lmb.action.blanktarget or not lmb.action.blanktarget(lmb) then
                str = str.. " " .. name
              else
                str = str
              end
            else
              if showAdjectives and adjective then
                str = adjectivedName(lmb)
              else
                str = str.. " " .. name
              end
            end

            if lmb.target.components.stackable and lmb.target.components.stackable.stacksize > 1 then
              str = stackString(str, lmb)
            end

            if lmb.target.components.inspectable and lmb.target.components.inspectable.recordview and lmb.target.prefab then
              ProfileStatsSet(lmb.target.prefab .. "_seen", true)
            end
          end
        end
      end

      local rmb = self.owner.components.playercontroller:GetRightMouseAction()
      if rmb then
        secondarystr = STRINGS.RMB .. ": " .. rmb:GetActionString()
      end
    end

    if not colour then colour = NORMAL_TEXT_COLOUR end

    if str then
      self.text:SetColour(colour[1], colour[2], colour[3], colour[4])
      self.text:SetString(str)
      self.text:Show()
    else
      self.text:SetColour(colour[1], colour[2], colour[3], colour[4])
      self.text:Hide()
    end

    if secondarystr then
      YOFFSETUP = -40
      YOFFSETDOWN = -20
      self.secondarytext:SetString(secondarystr)
      self.secondarytext:Show()
    else
      self.secondarytext:Hide()
    end

    local changed = (self.str ~= str) or (self.secondarystr ~= secondarystr)
    self.str = str
    self.secondarystr = secondarystr

    if changed then
      local pos = TheInput:GetScreenPosition()
      self:UpdatePosition(pos.x, pos.y)
    end
  end
else
  function HoverText:OnUpdate()
    local using_mouse = self.owner.components and self.owner.components.playercontroller:UsingMouse()
    if using_mouse ~= self.shown then
      if using_mouse then
        self:Show()
      else
        self:Hide()
      end
    end

    if not self.shown then return end

    local str = nil
    if self.isFE == false then
      str = self.owner.HUD.controls:GetTooltip() or self.owner.components.playercontroller:GetHoverTextOverride()
    else
      str = self.owner:GetTooltip()
    end

    local secondarystr = nil

    if not str and self.isFE == false then
      local lmb = self.owner.components.playercontroller:GetLeftMouseAction()
      if lmb then

        str = lmb:GetActionString()

        if lmb.target and lmb.invobject == nil and lmb.target ~= lmb.doer then

          local name = lmb.target:GetDisplayName() or (lmb.target.components.named and lb.target.components.named.name)
          if name then
            if type(name) == "table" then
              local newname = nil
              for code,text in pairs(name) do
                print(code,text)
                newname = text
                break
              end
              name = newname
            end

            local adjective = lmb.target:GetAdjective()
            if showAdjectives and adjective then
              str = adjectivedName(lmb)
            else
              str = str .. " " .. name
            end

            if lmb.target.components.stackable and lmb.target.components.stackable.stacksize > 1 then
              str = stackString(str, lmb)
            end

            if lmb.target.components.inspectable and lmb.target.components.inspectable.recordview and lmb.target.prefab then
              ProfileStatsSet(lmb.target.prefab .. "_seen", true)
            end
          end
        end
      end

      local rmb = self.owner.components.playercontroller:GetRightMouseAction()
      if rmb then
        secondarystr = STRINGS.RMB .. ": " .. rmb:GetActionString()
      end
    end

    if str then
      self.text:SetString(str)
      self.text:Show()
    else
      self.text:Hide()
    end

    if secondarystr then
      YOFFSETUP = -40
      YOFFSETDOWN = -20
      self.secondarytext:SetString(secondarystr)
      self.secondarytext:Show()
    else
      self.secondarytext:Hide()
    end

    local changed = (self.str ~= str) or (self.secondarystr ~= secondarystr)
    self.str = str
    self.secondarystr = secondarystr

    if changed then
      local pos = TheInput:GetScreenPosition()
      self:UpdatePosition(pos.x, pos.y)
    end
  end
end

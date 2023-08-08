local customise_mod = nil
local CustomizationScreen = require "screens/customizationscreen"
local OriginalRefreshOptions = CustomizationScreen.RefreshOptions

function CustomizationScreen:RefreshOptions()
  OriginalRefreshOptions(self)

  if customise_mod == nil then customise_mod = require "customisemod" end

  local spinners = {}
  for k, v in pairs(self.left_spinners) do table.insert(spinners, v) end
  for k, v in pairs(self.right_spinners) do table.insert(spinners, v) end

  for _, spinner in pairs(spinners) do
    for _, child in pairs(spinner:GetParent():GetChildren()) do
      --[[
        Since every option lacks some kind of ID (nothing new), I'm using its texture name as one,
        this is not the best practice, but it's better than using its position index.
        If some mod changes the texture name, this won't work.
      ]]
      local id = child.texture and child.texture:gsub(".tex", "")
      local optionMod = customise_mod[id]

      if optionMod then
        if optionMod.tooltip then
          for _, v in pairs(child:GetParent():GetChildren()) do v:SetTooltip(optionMod.tooltip) end
        end

        if optionMod.options then
          for _, spinnerOption in pairs(spinner.options) do
            local textMod = optionMod.options[spinnerOption.data]
            textMod = type(textMod) == "function" and textMod(spinnerOption.text) or textMod

            -- Assuming that every spinner has a default option.
            if spinnerOption.data == "default" and textMod then spinner:UpdateText(textMod) end
            if textMod then spinnerOption.text = textMod end
          end
        end
      end
    end
  end
end

local OriginalSavePreset = CustomizationScreen.SavePreset

function CustomizationScreen:SavePreset()
  OriginalSavePreset(self)

  for _, frontChild in pairs(_G.TheFrontEnd.screenroot:GetChildren()) do
    if tostring(frontChild) == "BigPopupDialogScreen" then
      for _, menuElement in pairs(frontChild.menu:GetChildren()) do
        if tostring(menuElement) == "SPINNER" then
          for _, spinnerChild in pairs(menuElement:GetChildren()) do
            if tostring(spinnerChild) == "Text - " .. STRINGS.UI.CUSTOMIZATIONSCREEN.CUSTOM_PRESET then
              spinnerChild:SetString(STRINGS.UI.CUSTOMIZATIONSCREEN.PRESET)
              spinnerChild:SetPosition(-180 / 2 - 65, 0, 0)

              break
            end
          end
          break
        end
      end
      break
    end
  end
end

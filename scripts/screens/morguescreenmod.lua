local causesOfDeath = nil
local MorgueScreen = require "screens/morguescreen"
local OriginalRefreshControls = MorgueScreen.RefreshControls

function MorgueScreen:RefreshControls()
  OriginalRefreshControls(self)

  causesOfDeath = {}

  for _, morgue in pairs(self.mogue) do
    local killedBy = STRINGS.NAMES[morgue.killed_by:upper()] or STRINGS.NAMES.SHENANIGANS
    causesOfDeath[killedBy] = true
  end

  --[[
    First, we search in every obituary row a widget called "control" (v), which contains
    days lived, deceased, cause of death and gamemode, every one of them are also widgets,
    3 of them being text widgets and deceased being a widget called "DECEASED" and after that we
    get their corresponding string to find those that are text widgets.
  ]]
  for _, v in pairs(self.obits_rows:GetChildren()) do
    if tostring(v) == "control" then
      for _, widget in pairs(v:GetChildren()) do
        if tostring(widget):find("Text") then
          local str = capitalizeFirstLetter(widget:GetString())

          if causesOfDeath[str] then
            if #str >= 20 then str = str:sub(1, 19) .. "..." end

            widget:SetString(str)
          end
        end
      end
    end
  end
end

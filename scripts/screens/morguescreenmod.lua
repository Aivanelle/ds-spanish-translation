local causesOfDeath = nil
local MorgueScreen = require "screens/morguescreen"
local OriginalRefreshControls = MorgueScreen.RefreshControls
local FirstToUpper = _G.FirstToUpper

function MorgueScreen:RefreshControls()
  OriginalRefreshControls(self)

  causesOfDeath = {}

  for _, morgue in pairs(self.mogue) do
    local killedBy = STRINGS.NAMES[morgue.killed_by:upper()] or STRINGS.NAMES.SHENANIGANS
    causesOfDeath[killedBy] = true
  end

  for _, v in pairs(self.obits_rows:GetChildren()) do
    if tostring(v) == "control" then
      for _, widget in pairs(v:GetChildren()) do
        if tostring(widget):find("Text") then
          local str = FirstToUpper(widget:GetString():lower())

          if causesOfDeath[str] then
            if #str >= 20 then str = str:sub(1, 19) .. "..." end

            widget:SetString(str)
          end
        end
      end
    end
  end
end

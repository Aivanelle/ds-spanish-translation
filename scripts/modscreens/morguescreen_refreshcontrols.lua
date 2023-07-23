local function firstToUpper(str) return (str:gsub("^%l", string.upper)) end

local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Levels = require "map/levels"
local MorgueScreen = require "screens/morguescreen"

local controls_per_screen = 8
local MODCHARACTERLIST = _G.MODCHARACTERLIST
local ANCHOR_MIDDLE = _G.ANCHOR_MIDDLE
local JapaneseOnPS4 = _G.JapaneseOnPS4
local TITLEFONT = _G.TITLEFONT
local GetActiveCharacterList = _G.GetActiveCharacterList

local column_offsets
if JapaneseOnPS4() then
  column_offsets =
  {
    DAYS_LIVED = -35,
    DECEASED = 100,
    CAUSE = 290,
    MODE = 500,
  }
else
  column_offsets =
  {
    DAYS_LIVED = 0,
    DECEASED = 120,
    CAUSE = 290,
    MODE = 460,
  }
end

-- Function found on scripts/screens/morguescreen - Ln: 184
function MorgueScreen:RefreshControls()
  for k, v in pairs(self.list_widgets) do
    v.root:Kill()
  end

  self.list_widgets = {}
    local font_size = 35

    if JapaneseOnPS4() then font_size = 35 * 0.75 end

    local portrate_scale = 0.45
    local spacing = 52

  for k = 1, controls_per_screen do
    local idx = self.control_offset + k

    if self.mogue[idx] then
      local death = self.mogue[idx]
      local group = self.obits_rows:AddChild(Widget("control"))

      local DAYS_LIVED = group:AddChild(Text(TITLEFONT, font_size))
      DAYS_LIVED:SetHAlign(ANCHOR_MIDDLE)
      DAYS_LIVED:SetPosition(column_offsets.DAYS_LIVED, 0, 0)
      DAYS_LIVED:SetRegionSize(400, 70)
      DAYS_LIVED:SetString(death["days_survived"] or "?")

      local DECEASED = group:AddChild(Widget("DECEASED"))
      DECEASED:SetPosition(column_offsets.DECEASED, 0, 0)

      DECEASED.portraitbg = DECEASED:AddChild(Image("images/saveslot_portraits.xml", "background.tex"))
      DECEASED.portraitbg:SetScale(portrate_scale, portrate_scale, 1)
      DECEASED.portraitbg:SetClickable(false)   
      DECEASED.base = DECEASED:AddChild(Widget("base"))

      DECEASED.portrait = DECEASED.base:AddChild(Image())
      DECEASED.portrait:SetClickable(false) 

      local character = death["character"]:lower()
      if character == "maxwell" then character = "waxwell" end

      local atlas = (table.contains(MODCHARACTERLIST, character) and "images/saveslot_portraits/" .. character .. ".xml") or "images/saveslot_portraits.xml"

      if not table.contains(GetActiveCharacterList(), character) then
        character = "random" -- Use a question mark if the character isn't currently active
      end

      DECEASED.portrait:SetTexture(atlas, character .. ".tex")
      DECEASED.portrait:SetScale(portrate_scale, portrate_scale, 1)

      local killed_by = death["killed_by"]:lower()

      if killed_by == "nil" then
        if character == "waxwell" then
          killed_by = "charlie"
        else
          killed_by = "darkness"
        end
      elseif killed_by == "unknown" then
        killed_by = "shenanigans"
      elseif killed_by == "moose" then
        if math.random() < .5 then
          killed_by = "moose1"
        else
          killed_by = "moose2"
        end
      end

      killed_by = STRINGS.NAMES[string.upper(killed_by)] or STRINGS.NAMES.SHENANIGANS
      local CAUSE = nil

      if killed_by:len() > 25 then
        CAUSE = group:AddChild(Text(TITLEFONT, 30))
      else
        CAUSE = group:AddChild(Text(TITLEFONT, font_size))
      end

      CAUSE:SetHAlign(ANCHOR_MIDDLE)
      CAUSE:SetPosition(column_offsets.CAUSE, 0, 0)
      CAUSE:SetRegionSize(400, 70)
      CAUSE:SetString(firstToUpper(killed_by))

      local MODE = group:AddChild(Text(TITLEFONT, font_size))
      MODE:SetHAlign(ANCHOR_MIDDLE)
      MODE:SetPosition(column_offsets.MODE, 0, 0)
      MODE:SetRegionSize(400, 70)
      MODE:SetString(STRINGS.UI.MORGUESCREEN.LEVELTYPE[Levels.GetTypeForLevelID(death["world"])])

      if k <= controls_per_screen then
        group:SetPosition(0, (controls_per_screen - 1) * spacing * .5 - (k - 1) * spacing - 10, 0)
      else
        group:SetPosition(0, (controls_per_screen - 1) * spacing * .5 - (k - 1 - controls_per_screen) * spacing - 10, 0)
      end

      table.insert(self.list_widgets, {root = group, id = idx})
    end
  end
end

-- Global variables that are used across all files.
_G = GLOBAL
require = _G.require
STRINGS = _G.STRINGS

modimport("scripts/spanishstrings.lua")

assert = _G.assert
USE_PREFIX = _G.USE_PREFIX

local function enableSuffixes(table)
  for k, v in pairs(table) do
    if type(v) == "table" then
      enableSuffixes(v)
    else
      assert(type(v) == "string", "Error, suffix string expected, got: " .. type(v))

      USE_PREFIX[v] = false
    end
  end
end

enableSuffixes(STRINGS.SUFFIX)

--[[
  Don't Starve vanilla can't translate these strings via the translator, meaning that translated string in
  the po file do nothing. Translated strings in po files have been deleted just to not have to make any changet
  wice, here in the lua files and there in the po files.
]]
for i = 1, 3 do
  STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS[i] = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELS_ES[i]
  STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC[i] = STRINGS.UI.CUSTOMIZATIONSCREEN.PRESETLEVELDESC_ES[i]
end

local IsDLCEnabled = _G.IsDLCEnabled
local CAPY_DLC = _G.CAPY_DLC

if IsDLCEnabled(CAPY_DLC) then
  STRINGS.UI.CUSTOMIZATIONSCREEN.SHIPWRECKEDLEVELDESC[1] = STRINGS.UI.CUSTOMIZATIONSCREEN.SHIPWRECKEDLEVELDESC_ES[1]
end
---------------------------------------------------------------

local translationFileConfig = GetModConfigData("translationFile")
LoadPOFile("translationfiles/spanish_" .. translationFileConfig:lower() .. ".po", "es")

-- They forgot Wagstaff.
table.insert(_G.CHARACTER_GENDERS.MALE, "wagstaff")

_G.Set = function(list)
  local set = {}
  for _, v in pairs(list) do set[v] = true end
  return set
end

local Set = _G.Set

GetPlayer = _G.GetPlayer
dialogueGenderConfig = GetModConfigData("dialogueGender")
GetGenderStrings = _G.GetGenderStrings

local dialogueScripts =
{
  female = "femalestrings.lua",
  robot = "robotstrings.lua"
}

local function importStrings()
  local playerPrefab = GetPlayer().prefab
  local genderStrings = GetGenderStrings(playerPrefab):lower()

  dialogueScripts["auto"] = genderStrings ~= "male" and genderStrings .. "strings.lua"
  local scriptToImport = dialogueScripts[dialogueGenderConfig]

  if scriptToImport then modimport("scripts/" .. scriptToImport) end
end

local Vector3 = _G.Vector3
local function setWormwoodFont()
  local talkingWormwoodConfig = GetModConfigData("talkingWormwood")

  if talkingWormwoodConfig == "normalFont" and GetPlayer().components.talker then
    GetPlayer().components.talker.font = TALKINGFONT
    GetPlayer().components.talker.colour = Vector3(1, 1, 1, 1)
  end
end

local function translateWebberStrings()
  STRINGS.UI.GENDERSTRINGS.ROBOT.ONE = STRINGS.UI.GENDERSTRINGS.ROBOT.ONE_ES
  STRINGS.UI.ENDGAME.BODY2 = STRINGS.UI.ENDGAME.BODY2_ES
end

local function modSimPostInit(player)
  importStrings()

  USE_PREFIX[STRINGS.SMOLDERINGITEM] = false
  USE_PREFIX[STRINGS.MYSTERIOUS] = false
  USE_PREFIX[STRINGS.FLOODEDITEM] = false

  USE_PREFIX[STRINGS.WET_PREFIX.RABBITHOLE] = false
  USE_PREFIX[STRINGS.NAMES.RABBITHOLE] = false
  USE_PREFIX[STRINGS.NAMES.CRABHOLE] = false

  if player.prefab == "wormwood" then
    setWormwoodFont()
  elseif player.prefab == "webber" then
    translateWebberStrings()
  end
end

AddSimPostInit(modSimPostInit)

local function modTeleportatoBase(inst)
  if inst.components.container.widgetbuttoninfo.text then
    inst.components.container.widgetbuttoninfo.text = STRINGS.UI.TELEPORTATO_BASE_ACTIVATE_ES
  end
end

AddPrefabPostInit("teleportato_base", modTeleportatoBase)

local function modEpitaphs(inst)
  if GetPlayer().prefab == "wolfgang" then
    local WOLFGANG_EPITAPHS = STRINGS.CHARACTERS.WOLFGANG.EPITAPHS
    inst.components.inspectable:SetDescription(WOLFGANG_EPITAPHS[math.random(#WOLFGANG_EPITAPHS)])
  end
end

AddPrefabPostInit("inventorygrave", modEpitaphs)
AddPrefabPostInit("gravestone", modEpitaphs)

local NO_WET_PREFABS = require "sortedprefabs/nowetprefabs"
local function setNoWetPrefix(inst)
  if not inst.no_wet_prefix then inst.no_wet_prefix = true end
end

for _, prefab in ipairs(NO_WET_PREFABS) do AddPrefabPostInit(prefab, setNoWetPrefix) end

GRAMMATICAL_NUMBER =
{
  PLURAL = "PLURAL",
  SINGULAR = "SINGULAR"
}

GENDER =
{
  MASCULINE = "MASCULINE",
  FEMININE = "FEMININE"
}

local function setGrammarComponent(prefabs, gender, grammaticalNumber)
  for _, prefab in ipairs(prefabs) do
    AddPrefabPostInit(prefab, function(inst)
      inst:AddComponent("grammar")
      inst.components.grammar:SetGrammaticalNumber(grammaticalNumber)
      inst.components.grammar:SetGender(gender)
    end)
  end
end

local MASCULINE_PLURAL_PREFABS = require "sortedprefabs/masculinepluralprefabs"
setGrammarComponent(MASCULINE_PLURAL_PREFABS, GENDER.MASCULINE, GRAMMATICAL_NUMBER.PLURAL)

local MASCULINE_SINGULAR_PREFABS = require "sortedprefabs/masculinesingularprefabs"
setGrammarComponent(MASCULINE_SINGULAR_PREFABS, GENDER.MASCULINE, GRAMMATICAL_NUMBER.SINGULAR)

local FEMININE_PLURAL_PREFABS = require "sortedprefabs/femininepluralprefabs"
setGrammarComponent(FEMININE_PLURAL_PREFABS, GENDER.FEMININE, GRAMMATICAL_NUMBER.PLURAL)

local FEMININE_SINGULAR_PREFABS = require "sortedprefabs/femininesingularprefabs"
setGrammarComponent(FEMININE_SINGULAR_PREFABS, GENDER.FEMININE, GRAMMATICAL_NUMBER.SINGULAR)

modimport("scripts/craftmonkeystring.lua")
modimport("scripts/prefabs/maxwellintromod.lua")
modimport("scripts/constructadjectivedname.lua")
modimport("scripts/components/perishablemod.lua")
modimport("scripts/entityscriptmod.lua")
modimport("scripts/modwidgets/hovertext_onupdate.lua")
modimport("scripts/modwidgets/itemtile_getdescriptionstring.lua")
modimport("scripts/modscreens/morguescreen_refreshcontrols.lua")

local ROG_DLC = _G.REIGN_OF_GIANTS
local PORKLAND_DLC = _G.PORKLAND_DLC
local anyDLCEnabled = IsDLCEnabled(ROG_DLC) or IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(PORKLAND_DLC)

if anyDLCEnabled then modimport("scripts/modwidgets/inv_getdescriptionstring.lua") end
if IsDLCEnabled(_G.PORKLAND_DLC) then modimport("scripts/components/grogginessmod.lua") end

LoadPOFile("spanish.po", "es")

_G = GLOBAL
-- They forgot Wagstaff.
table.insert(_G.CHARACTER_GENDERS.MALE, "wagstaff")

modimport "scripts/dlcsupport_stringsmod.lua"

stackStyles =
{
  ["default"] = "x{stack}",
  ["parenthesis"] = "({stack})",
  ["mathematician"] = "× {stack}"
}

-- Global variables that are used across all files.
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

showAdjectivesConfig = GetModConfigData("showAdjectives")
dialogueGenderConfig = GetModConfigData("dialogueGender")
colorPerishablesConfig = GetModConfigData("colorPerishables")
unknownAdjectivesConfig = GetModConfigData("unknownAdjectives")

subfmt = _G.subfmt
require = _G.require

GetPlayer = _G.GetPlayer
GetGenderStrings = _G.GetGenderStrings
ConstructAdjectivedName = _G.ConstructAdjectivedName
KnownModIndex = _G.KnownModIndex

STRINGS = _G.STRINGS
TUNING = _G.TUNING

PORKLAND_DLC = _G.PORKLAND_DLC
IsDLCEnabled = _G.IsDLCEnabled

local ROG_DLC = _G.REIGN_OF_GIANTS
local CAPY_DLC = _G.CAPY_DLC
anyDLCEnabled = IsDLCEnabled(ROG_DLC) or IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(PORKLAND_DLC)

NORMAL_TEXT_COLOR = anyDLCEnabled and _G.NORMAL_TEXT_COLOUR or { 1, 1, 1, 1 }
STALE_TEXT_COLOR = { 250/255, 160/255, 31/255, 1 }
SPOILED_TEXT_COLOR = { 1, 106/255, 106/255, 1 }

function egsub(str, pattern, replacement) return (str:gsub(_G.escape_lua_pattern(pattern), replacement)) end
function _G.capitalizeFirstLetter(str) return (str:lower():gsub("^%l", string.upper)) end

modimport "scripts/stringsmod.lua"

local assert = _G.assert
local USE_PREFIX = _G.USE_PREFIX

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

if IsDLCEnabled(CAPY_DLC) then
  STRINGS.UI.CUSTOMIZATIONSCREEN.SHIPWRECKEDLEVELDESC[1] = STRINGS.UI.CUSTOMIZATIONSCREEN.SHIPWRECKEDLEVELDESC_ES[1]
end

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

local function modWerewilbaFurHands(inst)
  inst.wet_prefix = STRINGS.SUFFIX.WET.CLOTHING.MASCULINE.SINGULAR
end

AddPrefabPostInit("werewilbafur_hands", modWerewilbaFurHands)

local function modConfigurationScreenInit(self, modname)
  local fancyModName = KnownModIndex:GetModFancyName(modname)

  for _, child in pairs(self.root:GetChildren()) do
    if child.GetString and child:GetString() == fancyModName .. " " .. STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX then
      child:SetString(subfmt(STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX, { modname = fancyModName }))
      break
    end
  end
end

AddClassPostConstruct("screens/modconfigurationscreen", modConfigurationScreenInit)

local function pauseScreenInit(self)
  local days = math.floor(GetPlayer().components.age:GetAge() / TUNING.TOTAL_DAY_TIME)
  local survivedDaysText = days == 1 and STRINGS.UI.PAUSEMENU.SURVIVED_DAY or STRINGS.UI.PAUSEMENU.SURVIVED_DAYS

  self.survived_daytext:SetString(string.format(survivedDaysText, days))
end

AddClassPostConstruct("screens/pausescreen", pauseScreenInit)

local dialogueScripts = { female = "femalestrings.lua", robot = "robotstrings.lua" }

local function importStrings()
  local playerPrefab = GetPlayer().prefab
  local genderStrings = GetGenderStrings(playerPrefab):lower()

  dialogueScripts.auto = genderStrings ~= "male" and genderStrings .. "strings.lua"
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

  --[[
    Default prefixes are no longer used, but are necessary in some cases where there are
    prefabs not being managed by the mod.
  ]]
  enableSuffixes(STRINGS.WET_PREFIX)
  USE_PREFIX[STRINGS.UI.HUD.HUNGRY] = false
  USE_PREFIX[STRINGS.UI.HUD.STARVING] = false
  USE_PREFIX[STRINGS.UI.HUD.STALE] = false
  USE_PREFIX[STRINGS.UI.HUD.SPOILED] = false
  USE_PREFIX[STRINGS.UI.HUD.STALE_FROZEN] = false
  USE_PREFIX[STRINGS.UI.HUD.SPOILED_FROZEN] = false

  USE_PREFIX[STRINGS.MYSTERIOUS] = false
  USE_PREFIX[STRINGS.SMOLDERINGITEM] = false
  USE_PREFIX[STRINGS.WITHEREDITEM] = false
  USE_PREFIX[STRINGS.FLOODEDITEM] = false

  USE_PREFIX[STRINGS.NAMES.RABBITHOLE] = false
  USE_PREFIX[STRINGS.NAMES.CRABHOLE] = false

  USE_PREFIX[STRINGS.WET_PREFIX.WETGOOP] = function(inst, name, adjective)
    local wetWetGoopName = name:gsub(" ", " " .. adjective .. " ")
    return name:gsub(name, wetWetGoopName)
  end

  if player.prefab == "wormwood" then
    setWormwoodFont()
  elseif player.prefab == "webber" then
    translateWebberStrings()
  end
end

AddSimPostInit(modSimPostInit)

local NO_WET_PREFABS = require "sortedprefabs/nowetprefabs"
local function setNoWetPrefix(inst)
  if not inst.no_wet_prefix then inst.no_wet_prefix = true end
end

for _, prefab in ipairs(NO_WET_PREFABS) do AddPrefabPostInit(prefab, setNoWetPrefix) end

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

modimport "scripts/craftmonkeystring.lua"
modimport "scripts/entityscriptmod.lua"

modimport "scripts/components/grogginessmod.lua"
modimport "scripts/components/perishablemod.lua"

modimport "scripts/prefabs/maxwellintromod.lua"
modimport "scripts/prefabs/parrotpirate.lua"

modimport "scripts/screens/morguescreenmod.lua"
modimport "scripts/screens/customizationscreenmod.lua"

modimport "scripts/widgets/hoverermod.lua"
modimport "scripts/widgets/inventorybarmod.lua"
modimport "scripts/widgets/itemtilemod.lua"

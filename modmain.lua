_G = GLOBAL
STRINGS = _G.STRINGS

modimport("scripts/spanishstrings.lua")

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
  local talkingWormwood = GetModConfigData("talkingWormwood")

  if talkingWormwood == "normalFont" and GetPlayer().components.talker then
    GetPlayer().components.talker.font = TALKINGFONT
    GetPlayer().components.talker.colour = Vector3(1, 1, 1, 1)
  end
end

local function translateWebberStrings()
  STRINGS.UI.GENDERSTRINGS.ROBOT.ONE = STRINGS.UI.GENDERSTRINGS.ROBOT.ONE_ES
  STRINGS.UI.ENDGAME.BODY2 = STRINGS.UI.ENDGAME.BODY2_ES
end

USE_PREFIX = _G.USE_PREFIX

local function enableSUffixes()
  for _, v in pairs(STRINGS.WET_PREFIX.MALE) do
    if type(v) == "table" then
      for _, WET_PREFIX in pairs(v) do USE_PREFIX[WET_PREFIX] = false end
    elseif type(v) == "string" then USE_PREFIX[v] = false end
  end

  for _, v in pairs(STRINGS.WET_PREFIX.FEMALE) do
    if type(v) == "table" then
      for _, WET_PREFIX in pairs(v) do USE_PREFIX[WET_PREFIX] = false end
    elseif type(v) == "string" then USE_PREFIX[v] = false end
  end
end

local function modPostInit(player)
  enableSUffixes()
  USE_PREFIX[STRINGS.SMOLDERINGITEM] = false
  USE_PREFIX[STRINGS.MYSTERIOUS] = false
  USE_PREFIX[STRINGS.FLOODEDITEM] = false

  USE_PREFIX[STRINGS.WET_PREFIX.RABBITHOLE] = false
  USE_PREFIX[STRINGS.NAMES.RABBITHOLE] = false
  USE_PREFIX[STRINGS.NAMES.CRABHOLE] = false

  importStrings()

  if player.prefab == "wormwood" then
    setWormwoodFont()
  elseif player.prefab == "webber" then
    translateWebberStrings()
  end
end

AddSimPostInit(modPostInit)

local function modAdventureTeleportato(prefab)
  if prefab.components.container.widgetbuttoninfo.text then
    prefab.components.container.widgetbuttoninfo.text = STRINGS.UI.TELEPORTATO_BASE_ACTIVATE_ES
  end
end

AddPrefabPostInit("teleportato_base", modAdventureTeleportato)

local function modEpitaphs(prefab)
  if GetPlayer().prefab == "wolfgang" then
    local wolfgangEpitaphs = STRINGS.CHARACTERS.WOLFGANG.EPITAPHS
    prefab.components.inspectable:SetDescription(wolfgangEpitaphs[math.random(#wolfgangEpitaphs)])
  end
end

AddPrefabPostInit("inventorygrave", modEpitaphs)
AddPrefabPostInit("gravestone", modEpitaphs)

local function setNoWetPrefix(prefab)
  if not prefab.no_wet_prefix then prefab.no_wet_prefix = true end
end

-- Prefabs that mostly contains proper nouns to hide their wet suffix
AddPrefabPostInit("book_birds", setNoWetPrefix)
AddPrefabPostInit("book_brimstone", setNoWetPrefix)
AddPrefabPostInit("book_gardening", setNoWetPrefix)
AddPrefabPostInit("book_meteor", setNoWetPrefix)
AddPrefabPostInit("book_sleep", setNoWetPrefix)
AddPrefabPostInit("book_tentacles", setNoWetPrefix)
AddPrefabPostInit("waxwelljournal", setNoWetPrefix)
AddPrefabPostInit("buriedtreasure", setNoWetPrefix)
AddPrefabPostInit("wilbur_unlock", setNoWetPrefix)

AddPrefabPostInit("bunnyman", setNoWetPrefix)
AddPrefabPostInit("mandrakeman", setNoWetPrefix)
AddPrefabPostInit("parrot_pirate", setNoWetPrefix)
AddPrefabPostInit("pigguard", setNoWetPrefix)
AddPrefabPostInit("pigman", setNoWetPrefix)
AddPrefabPostInit("pigtrader", setNoWetPrefix) -- Unnecessary, I think
AddPrefabPostInit("wildbore", setNoWetPrefix)
AddPrefabPostInit("wildboreguard", setNoWetPrefix)

-- Hamlet city pigs
AddPrefabPostInit("pigman_beautician", setNoWetPrefix)
AddPrefabPostInit("pigman_florist", setNoWetPrefix)
AddPrefabPostInit("pigman_erudite", setNoWetPrefix)
AddPrefabPostInit("pigman_hatmaker", setNoWetPrefix)
AddPrefabPostInit("pigman_storeowner", setNoWetPrefix)
AddPrefabPostInit("pigman_banker", setNoWetPrefix)
AddPrefabPostInit("pigman_collector", setNoWetPrefix)
AddPrefabPostInit("pigman_hunter", setNoWetPrefix)
AddPrefabPostInit("pigman_mayor", setNoWetPrefix)
AddPrefabPostInit("pigman_mechanic", setNoWetPrefix)
AddPrefabPostInit("pigman_professor", setNoWetPrefix)
AddPrefabPostInit("pigman_usher", setNoWetPrefix)
AddPrefabPostInit("pigman_royalguard", setNoWetPrefix)
AddPrefabPostInit("pigman_royalguard_2", setNoWetPrefix)
AddPrefabPostInit("pigman_farmer", setNoWetPrefix)
AddPrefabPostInit("pigman_miner", setNoWetPrefix)
AddPrefabPostInit("pigman_queen", setNoWetPrefix)
AddPrefabPostInit("pigman_beautician_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_florist_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_erudite_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_hatmaker_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_storeowner_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_banker_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_hunter_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_mayor_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_farmer_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_miner_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_collector_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_professor_shopkeep", setNoWetPrefix)
AddPrefabPostInit("pigman_mechanic_shopkeep", setNoWetPrefix)

AddPrefabPostInit("abigail", setNoWetPrefix)
AddPrefabPostInit("glommer", setNoWetPrefix)
AddPrefabPostInit("chester", setNoWetPrefix)
AddPrefabPostInit("ro_bin", setNoWetPrefix)
AddPrefabPostInit("packim", setNoWetPrefix)
AddPrefabPostInit("roc", setNoWetPrefix)
AddPrefabPostInit("roc_head", setNoWetPrefix)
AddPrefabPostInit("roc_leg", setNoWetPrefix)
AddPrefabPostInit("roc_tail", setNoWetPrefix)

-- Hamlet city buildings
AddPrefabPostInit("pig_shop_deli", setNoWetPrefix)
AddPrefabPostInit("pig_shop_general", setNoWetPrefix)
AddPrefabPostInit("pig_shop_hoofspa", setNoWetPrefix)
AddPrefabPostInit("pig_shop_produce", setNoWetPrefix)
AddPrefabPostInit("pig_shop_florist", setNoWetPrefix)
AddPrefabPostInit("pig_shop_antiquities", setNoWetPrefix)
AddPrefabPostInit("pig_shop_academy", setNoWetPrefix)
AddPrefabPostInit("pig_shop_arcane", setNoWetPrefix)
AddPrefabPostInit("pig_shop_weapons", setNoWetPrefix)
AddPrefabPostInit("pig_shop_hatshop", setNoWetPrefix)
AddPrefabPostInit("pig_shop_bank", setNoWetPrefix)
AddPrefabPostInit("pig_shop_tinker", setNoWetPrefix)
AddPrefabPostInit("pig_shop_cityhall", setNoWetPrefix)
AddPrefabPostInit("pig_shop_cityhall_player", setNoWetPrefix)
AddPrefabPostInit("pig_palace", setNoWetPrefix)

local IsDLCInstalled = _G.IsDLCInstalled

if IsDLCInstalled(CAPY_DLC) and IsDLCEnabled(CAPY_DLC) then modimport("scripts/craftmonkeystring.lua") end

modimport("scripts/modwaxwellintro.lua")
modimport("scripts/constructadjectivedname.lua")
modimport("scripts/getdisplayname.lua")
modimport("scripts/modwidgets/hovertext_onupdate.lua")
modimport("scripts/modwidgets/itemtile_getdescriptionstring.lua")
modimport("scripts/modscreens/morguescreen_refreshcontrols.lua")

local ROG_DLC = _G.REIGN_OF_GIANTS
local PORKLAND_DLC = _G.PORKLAND_DLC
local anyDLCEnabled = IsDLCEnabled(ROG_DLC) or IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(PORKLAND_DLC)

if anyDLCEnabled then modimport("scripts/modwidgets/inv_getdescriptionstring.lua") end
if IsDLCEnabled(_G.PORKLAND_DLC) then modimport("scripts/components/grogginessmod.lua") end

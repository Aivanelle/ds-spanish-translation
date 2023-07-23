local function adjectivedName(item)
  if item then
    local prefab = item.prefab
    local PREFABS = require("sortedprefabs")

    if item.components.eater then
      if prefab == "parrot_pirtate" then
        local name = item.components.named.name

        if PREFABS.MALE.NAME[name] then
          STRINGS.UI.HUD.HUNGRY = STRINGS.UI.HUD.MALE.HUNGRY
          STRINGS.UI.HUD.STARVING = STRINGS.UI.HUD.MALE.STARVING
        elseif PREFABS.FEMALE.NAME[name] then
          STRINGS.UI.HUD.HUNGRY = STRINGS.UI.HUD.FEMALE.HUNGRY
          STRINGS.UI.HUD.STARVING = STRINGS.UI.HUD.FEMALE.STARVING
        end
      else
        if PREFABS.MALE.SMALL_ANIMAL[prefab] then
          STRINGS.UI.HUD.HUNGRY = STRINGS.UI.HUD.MALE.HUNGRY
          STRINGS.UI.HUD.STARVING = STRINGS.UI.HUD.MALE.STARVING
        elseif PREFABS.FEMALE.SMALL_ANIMAL[prefab] then
          STRINGS.UI.HUD.HUNGRY = STRINGS.UI.HUD.FEMALE.HUNGRY
          STRINGS.UI.HUD.STARVING = STRINGS.UI.HUD.FEMALE.STARVING
        else
          STRINGS.UI.HUD.HUNGRY = "(HUNGRY ADJECTIVE?) " .. prefab
          STRINGS.UI.HUD.STARVING = "(STARVING ADJECTIVE?) " .. prefab
        end
      end
    elseif item.components.edible then
      if PREFABS.FEMALE.SINGULAR.FOOD[prefab] then
        STRINGS.UI.HUD.STALE = STRINGS.UI.HUD.FEMALE.SINGULAR.STALE
        STRINGS.UI.HUD.SPOILED = STRINGS.UI.HUD.FEMALE.SINGULAR.SPOILED
      elseif PREFABS.FEMALE.PLURAL.FOOD[prefab] then
        STRINGS.UI.HUD.STALE = STRINGS.UI.HUD.FEMALE.PLURAL.STALE
        STRINGS.UI.HUD.SPOILED = STRINGS.UI.HUD.FEMALE.PLURAL.SPOILED
      elseif PREFABS.MALE.SINGULAR.FOOD[prefab] then
        STRINGS.UI.HUD.STALE = STRINGS.UI.HUD.MALE.SINGULAR.STALE
        STRINGS.UI.HUD.SPOILED = STRINGS.UI.HUD.MALE.SINGULAR.SPOILED
      elseif PREFABS.MALE.PLURAL.FOOD[prefab] then
        STRINGS.UI.HUD.STALE = STRINGS.UI.HUD.MALE.PLURAL.STALE
        STRINGS.UI.HUD.SPOILED = STRINGS.UI.HUD.MALE.PLURAL.SPOILED
      else
        STRINGS.UI.HUD.STALE = "(STALE ADJECTIVE?) " .. prefab
        STRINGS.UI.HUD.SPOILED = "(SPOILED ADJECTIVE) " .. prefab
      end
    end

    local displayName = item:GetDisplayName()
    local adjective = item:GetAdjective()
    local fullName =  nil

    if prefab == "batwing" and displayName:find("?") then
      fullName = displayName:gsub("?", " " .. adjective .. "?")
    else
      fullName = displayName .. adjective
    end

    return fullName
  end
end

local ModIndex = _G.ModIndex
local ConfigurationName = ModIndex:GetModConfigurationName("Traducción al Español")
local showAdjectives = GetModConfigData("showAdjectives", ConfigurationName)
local Inv = require "widgets/inventorybar"

-- I don't even know where this is used, but just in case.
-- This is just a copy/paste of Klei's code, slightly modified to work with the mod.
function Inv:GetDescriptionString(item)
  local str = nil
  local in_equip_slot = item and item.components.equippable and item.components.equippable:IsEquipped()
  local active_item = GetPlayer().components.inventory:GetActiveItem()
  if item and item.components.inventoryitem then
    local adjective = item:GetAdjective()
    if showAdjectives and adjective then
      str = adjectivedName(item)
    else
      str = item:GetDisplayName()
    end
  end

  return str or ""
end

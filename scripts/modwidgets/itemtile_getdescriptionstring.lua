local TheInput = _G.TheInput
local ModIndex = _G.ModIndex
local ConfigurationName = ModIndex:GetModConfigurationName("Traducción al Español")
local showAdjectives = GetModConfigData("showAdjectives", ConfigurationName)
local adjectivedName = require("adjectivedperishable")
local ItemTile = require "widgets/itemtile"

-- This is just a copy/paste of Klei's code, slightly modified to work with the mod.
function ItemTile:GetDescriptionString()
  local str = nil
  local in_equip_slot = self.item and self.item.components.equippable and self.item.components.equippable:IsEquipped()
  local active_item = GetPlayer().components.inventory:GetActiveItem()

  if self.item and self.item.components.inventoryitem then
    local adjective = self.item:GetAdjective()
    if showAdjectives and adjective then
      str = adjectivedName(self)
    else
      str = self.item:GetDisplayName()
    end

    if active_item then 
      if not in_equip_slot then
        if active_item.components.stackable and active_item.prefab == self.item.prefab then
          str = str .. "\n" .. STRINGS.LMB .. ": " .. STRINGS.UI.HUD.PUT
        else
          str = str .. "\n" .. STRINGS.LMB .. ": " .. STRINGS.UI.HUD.SWAP
        end
      end

      local actions = GetPlayer().components.playeractionpicker:GetUseItemActions(self.item, active_item, true)
      if actions then
        str = str .."\n" .. STRINGS.RMB .. ": " .. actions[1]:GetActionString()
      end
    else
      local owner = self.item.components.inventoryitem and self.item.components.inventoryitem.owner
      local actionpicker = owner and owner.components.playeractionpicker or GetPlayer().components.playeractionpicker
      local inventory = owner and owner.components.inventory or GetPlayer().components.inventory

      local CONTROL_FORCE_INSPECT = _G.CONTROL_FORCE_INSPECT
      local CONTROL_FORCE_TRADE = _G.CONTROL_FORCE_TRADE
      local CONTROL_FORCE_STACK = _G.CONTROL_FORCE_STACK

      if owner and inventory and actionpicker then
        if TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) then
          str = str .. "\n" .. STRINGS.LMB .. ": " .. STRINGS.INSPECTMOD
        elseif TheInput:IsControlPressed(CONTROL_FORCE_TRADE) then
          str = str .. "\n" .. STRINGS.LMB .. ": " .. ((TheInput:IsControlPressed(CONTROL_FORCE_STACK) and self.item.components.stackable) and (STRINGS.STACKMOD .. " " ..STRINGS.TRADEMOD) or STRINGS.TRADEMOD)
        elseif TheInput:IsControlPressed(CONTROL_FORCE_STACK) and self.item.components.stackable then
          str = str .. "\n" .. STRINGS.LMB .. ": " .. STRINGS.STACKMOD
        end

        local actions = nil
        if inventory:GetActiveItem() then
          actions = actionpicker:GetUseItemActions(self.item, inventory:GetActiveItem(), true)
        end

        if not actions then
          actions = actionpicker:GetInventoryActions(self.item)
        end

        if actions then
          str = str .."\n" .. STRINGS.RMB .. ": " .. actions[1]:GetActionString()
        end
      end
    end
  end
  return str or ""
end

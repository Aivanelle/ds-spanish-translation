return function(inst)
  if inst then
    local item = nil
    if inst.target then item = inst.target else item = inst.item end

    local PREFABS = require("sortedprefabs")
    local prefab = item.prefab

    if item.components.eater then
      if prefab == "parrot_pirate" then
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
        STRINGS.UI.HUD.SPOILED = "(SPOILED ADJECTIVE?) " .. prefab
      end
    end

    local displayName = item:GetDisplayName()
    local adjective = item:GetAdjective()
    local fullName = nil
    
    if prefab == "batwing" and displayName:find("?") then
      fullName = displayName:gsub("?", " " .. adjective .. "?")
    else
      fullName = item:GetDisplayName() .. " " .. adjective
    end

    if inst.target then
      local action = inst:GetActionString()
      return action .. " " .. fullName
    else
      return fullName
    end
  end
end

local function getOldName(inst)
  return (inst.displaynamefn ~= nil and inst:displaynamefn()) or
    (inst.nameoverride and STRINGS.NAMES[inst.nameoverride:upper()]) or
    inst.name
end

local EntityScript = _G.EntityScript

function EntityScript:GetBasicDisplayName()
  -- Special case for blueprints.
  if self.recipetouse then
    local itemBlueprint = STRINGS.NAMES[self.recipetouse:upper()] or STRINGS.NAMES.UNKNOWN

    return STRINGS.BLUEPRINT_ITEM:format(itemBlueprint:lower())
  elseif self.construction_prefab then
    --[[
      Legacy: If a Hamlet building is destroyed and the world is reloaded, it will show "MISSING NAME".
      Since the Major Quality of Life and Bug Fix Update released on April 27, this fix is no longer needed,
      although I'll keep it because it still works and makes me not have to think in a proper fix for a 
      prefab that can have multiple display names.
    ]]
    return STRINGS.NAMES.RECONSTRUCTION_PROJECT
  end

  return getOldName(self)
end

function EntityScript:GetGrammaticalSuffix(suffixes)
  -- Special case for blueprints and sunken Hamlet relics.
  if self.recipetouse then
    return suffixes.MASCULINE.PLURAL
  elseif self.components.sinkable and self.components.sinkable.sunken then
    return suffixes.MASCULINE.SINGULAR
  end

  local grammar = self.components.grammar
  if grammar then
    return (suffixes[grammar.gender] and suffixes[grammar.gender][grammar.grammaticalnumber]) or
      (suffixes.NEUTRAL and suffixes.NEUTRAL[grammar.grammaticalnumber])
  end
end

local function getNewDisplayName(displayName, suffix, replacement)
  if showAdjectivesConfig then
    if not replacement then
      return unknownAdjectivesConfig == "default" and displayName or egsub(displayName, " " .. suffix, "")
    else
      return egsub(displayName, suffix, replacement)
    end
  else
    return egsub(displayName, " " .. suffix, "")
  end
end

-- Thanks simplex.
local GetOriginalDisplayName = EntityScript.GetDisplayName
local EQUIPSLOTS = _G.EQUIPSLOTS

function EntityScript:GetDisplayName()
  local displayName = GetOriginalDisplayName(self)

  local playerVision = GetPlayer().components.vision
  if playerVision and not playerVision.focused and not playerVision:testsight(self) then return displayName end

  local basicDisplayName = self:GetBasicDisplayName()

  if self.recipetouse or self.construction_prefab then
    displayName = egsub(displayName, getOldName(self), basicDisplayName)
  end

  -- If there's no DLC enabled, the function ends here.
  if not anyDLCEnabled then return displayName end

  local grammaticalSuffix = nil
  local isWet = self:GetIsWet()
  local isSmoldering = self.components.burnable and self.components.burnable:IsSmoldering()
  local isWitheredCrop = self.components.crop and self.components.crop:IsWithered()
  local isWitheredPickable = self.components.pickable and self.components.pickable:IsWithered()
  local isHole = self.prefab == "rabbithole" or self.prefab == "crabhole"

  if isHole and self.spring and self.wet_prefix then return displayName end

  --[[
    Mysterious objects are evaluated at last in the original GetDisplayName function, which makes
    that if the object is wet, it will show wet prefix instead of mysterious prefix, maybe this is an
    intentional behaviour, but who knows.
  ]]
  if self.components.mystery and self:HasTag("mystery") then
    -- If there's a mysterious prefab that does not uses a generic suffix, this won't work.
    return egsub(displayName, STRINGS.WET_PREFIX.GENERIC, STRINGS.MYSTERIOUS)
  elseif isSmoldering or isWitheredCrop or isWitheredPickable then
    grammaticalSuffix = self:GetGrammaticalSuffix(STRINGS.SUFFIX[isSmoldering and "SMOLDERING" or "WITHERED"])
    return getNewDisplayName(displayName, STRINGS[isSmoldering and "SMOLDERINGITEM" or "WITHEREDITEM"], grammaticalSuffix)
  elseif (isWet or self.always_wet) and not self.no_wet_prefix then
    local prefabType = nil

    if not isHole and self.wet_prefix then
      return displayName
    elseif self.components.edible and GetPlayer().components.eater and GetPlayer().components.eater:CanEat(self) then
      prefabType = "FOOD"
    elseif self.components.equippable then
      -- To be slightly compatible with mods that add extra item slots like amulets and backpacks
      prefabType = self.components.equippable.equipslot == EQUIPSLOTS.HANDS and "TOOL" or "CLOTHING"
    elseif self.components.fuel then
      prefabType = "FUEL"
    else
      prefabType = "GENERIC"
    end

    grammaticalSuffix = self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET[prefabType])
    return getNewDisplayName(displayName, STRINGS.WET_PREFIX[prefabType], grammaticalSuffix)
  else
    return displayName
  end
end

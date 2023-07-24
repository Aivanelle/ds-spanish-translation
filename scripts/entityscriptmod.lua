local EntityScript = _G.EntityScript

function EntityScript:GetBasicDisplayName()
  -- Special case for blueprints.
  if self.recipetouse then
    local itemBlueprint = STRINGS.NAMES[self.recipetouse:upper()] or STRINGS.NAMES.UNKNOWN

    return STRINGS.BLUEPRINT_ITEM:format(itemBlueprint:lower())
  end

  return (self.displaynamefn ~= nil and self:displaynamefn()) or
    (self.nameoverride and STRINGS.NAMES[string.upper(self.nameoverride)]) or
    self.name
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

local nearsighted_key_blacklist =
{
  NIL = true,
  DARKNESS = true,
  CHARLIE = true,
  HUNGER = true,
  COLD = true,
  HOT = true,
  SHENANIGANS = true,
  RESURRECTION_PENALTY = true,
  DROWNING = true,
  BURNT = true,
  UNKNOWN = true,

  WARBUCKS = true,
  DEVTOOL = true,
}

local function testvisionfn(k, v)
  if v == "" or type(v) == "table" or string.find(v, "%%") or string.find(v, "%{") or nearsighted_key_blacklist[k] then
    return false
  end
  return true
end

-- Thanks Simplex.
local oldGetDisplayName = EntityScript.GetDisplayName
local IsDLCEnabled = _G.IsDLCEnabled
local anyDLCEnabled = IsDLCEnabled(_G.REIGN_OF_GIANTS) or IsDLCEnabled(_G.CAPY_DLC) or IsDLCEnabled(_G.PORKLAND_DLC)
local GetRandomItem = _G.GetRandomItem
local reduce = _G.reduce
local nearsightednames = nil

if oldGetDisplayName and anyDLCEnabled then
  function EntityScript:GetDisplayName()
    if GetPlayer().components.vision and not GetPlayer().components.vision.focused and not GetPlayer().components.vision:testsight(self) then
      if not self.nearsightedname then
        nearsightednames = nearsightednames or reduce(STRINGS.NAMES, testvisionfn)
        self.nearsightedname = GetRandomItem(nearsightednames)
      end

      return self.nearsightedname
    end

    local name = self:GetBasicDisplayName()

    local flooded = self.components.floodable and self.components.floodable.flooded
    if flooded then return ConstructAdjectivedName(self, name, STRINGS.FLOODEDITEM) end

    local smoldering = self.components.burnable and self.components.burnable:IsSmoldering()
    if smoldering then
      return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.SMOLDERING) or STRINGS.SMOLDERINGITEM)
    end

    local witheredPickable = self.components.pickable and self.components.pickable:IsWithered()
    local witheredCrop = self.components.crop and self.components.crop:IsWithered()
    if witheredCrop or witheredPickable then
      return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.WITHERED) or STRINGS.WITHEREDITEM)
    end

    --[[
      Mysterious objects are evaluated at last in the original GetDisplayName function, which makes
      that if the object is wet, it will show wet prefix instead mysterious prefix, maybe this is an
      intentional behaviour, but who knows.
    ]]
    local mysterious = self.components.mystery and self:HasTag("mystery")
    if mysterious then return ConstructAdjectivedName(self, name, STRINGS.MYSTERIOUS) end

    --[[
      This is here to avoid wet prefix overriden and to not hide collapsed adjectives if adjectives are disabled by
      mod configurations.
        Spring = True: Rabbit and Crabbit holes closed.
        Spring = False: Rabbit and Crabbit holes opened.
    ]]
    if (self.prefab == "rabbithole" or self.prefab == "crabhole") then
      if self.spring then
        return ConstructAdjectivedName(self, name, self.wet_prefix)
      elseif showAdjectives then
        return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET.GENERIC) or STRINGS.WET_PREFIX.GENERIC)
      end
    end

    --[[
      Legacy: If a Hamlet building is destroyed and the world is reloaded, it will show "MISSING NAME".
      Since the Major Quality of Life and Bug Fix Update released on April 27, this fix is no longer needed,
      although I'll keep it because it still works and makes me not have to think in a proper fix for a 
      prefab that can have multiple display names.
    ]]
    if self.construction_prefab then name = STRINGS.NAMES.RECONSTRUCTION_PROJECT end

    local isWet = self:GetIsWet()
    if showAdjectivesConfig and ((isWet or self.always_wet) and not self.no_wet_prefix) then
      if self.wet_prefix then
        return ConstructAdjectivedName(self, name, self.wet_prefix)
      elseif self.components.edible and GetPlayer() and GetPlayer().components.eater and GetPlayer().components.eater:CanEat(self) then
        return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET.FOOD) or STRINGS.WET_PREFIX.FOOD)
      elseif self.components.equippable and (self.components.equippable.equipslot == "head" or self.components.equippable.equipslot == "body") then
        return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET.CLOTHING) or STRINGS.WET_PREFIX.CLOTHING)
      elseif self.components.equippable and self.components.equippable.equipslot == "hands" then
        return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET.TOOL) or STRINGS.WET_PREFIX.TOOL)
      elseif self.components.fuel then
        return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET.FUEL) or STRINGS.WET_PREFIX.FUEL)
      else
        return ConstructAdjectivedName(self, name, self:GetGrammaticalSuffix(STRINGS.SUFFIX.WET.GENERIC) or STRINGS.WET_PREFIX.GENERIC)
      end
    end

    return name
  end
end

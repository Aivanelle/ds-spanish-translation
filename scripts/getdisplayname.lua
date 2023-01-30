--[[
    Used to manage some specific cases. Character refers to the player prefab which is needed to apply the
    custom adjective, if no plyer prefab is provided, it will be applied with any character.
    This should probably be something temporary.
]]
local CUSTOM_ADJECTIVE =
{
    POOP =
    {
        ADJECTIVE = STRINGS.WET_PREFIX.MALE.SINGULAR.FUEL,
        CHARACTER = "wilbur"
    },
    
    WEREWILBAFUR_HANDS =
    {
        ADJECTIVE = STRINGS.WET_PREFIX.MALE.SINGULAR.CLOTHING,
        CHARACTER = "wilba"
    }
}

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

local function testvisionfn(k,v)
    if v == "" or type(v) == "table" or string.find(v, "%%") or string.find(v, "%{") or nearsighted_key_blacklist[k] then
        return false
    end
    return true
end

-- Thanks Simplex.
local EntityScript = _G.EntityScript
local oldGetDisplayName = EntityScript.GetDisplayName
local IsDLCEnabled = _G.IsDLCEnabled
local anyDLCEnabled = IsDLCEnabled(_G.REIGN_OF_GIANTS) or IsDLCEnabled(_G.CAPY_DLC) or IsDLCEnabled(_G.PORKLAND_DLC)
local ConstructAdjectivedName = _G.ConstructAdjectivedName
local GetRandomItem = _G.GetRandomItem
local reduce = _G.reduce
local nearsightednames = nil
local ModIndex = _G.ModIndex
local ConfigurationName = ModIndex:GetModConfigurationName("Traducción al Español")
local showAdjectives = GetModConfigData("showAdjectives", ConfigurationName)
local require = _G.require
local PREFABS = require("sortedprefabs")
local Prefix = require("prefixfunctions")

-- GetDisplayName function is found in scripts/entityscript - Ln: 484.
if oldGetDisplayName and anyDLCEnabled then
    function EntityScript:GetDisplayName(...)
        --[[
            This if statement is just a copy/paste of Klei's code, since I'm no longer using the original GetDisplayName function
            anymore, I don't know other way to use it without copying it directly.
        ]]
        if GetPlayer().components.vision and not GetPlayer().components.vision.focused and not GetPlayer().components.vision:testsight(self) then
            if not self.nearsightedname then
                nearsightednames = nearsightednames or reduce(STRINGS.NAMES, testvisionfn)
                self.nearsightedname = GetRandomItem(nearsightednames)
            end
            return self.nearsightedname
        end

        local name = (self.displaynamefn ~= nil and self:displaynamefn()) or (self.nameoverride and STRINGS.NAMES[string.upper(self.nameoverride)]) or self.name
        local smoldering = self.components.burnable and self.components.burnable:IsSmoldering()
        local flooded = self.components.floodable and self.components.floodable.flooded

        if flooded then return ConstructAdjectivedName(self, name, STRINGS.FLOODEDITEM) end
        if smoldering then return ConstructAdjectivedName(self, name, STRINGS.SMOLDERINGITEM) end

        local witheredPickable = self.components.pickable and self.components.pickable:IsWithered()
        local witheredCrop = self.components.crop and self.components.crop:IsWithered()
        local prefab = self.prefab

        if witheredCrop or witheredPickable then
            local witheredPrefix = Prefix.getWitheredPrefix(prefab)
            return ConstructAdjectivedName(self, name, witheredPrefix)
        end

        local mysterious = self.components.mystery and self:HasTag("mystery")
        --[[
            Mysterious objects are evaluated at last in the original GetDisplayName function, which makes that if the object is wet, it will show
            wet prefix instead mysterious prefix, maybe this is an intentional behaviour, but who knows.
        ]]
        if mysterious then return ConstructAdjectivedName(self, name, STRINGS.MYSTERIOUS) end

        -- recipetouse stores which prefab is being used to create a blueprint.
        if self.recipetouse then
            local itemBlueprint = STRINGS.NAMES[self.recipetouse:upper()]
            name = STRINGS.NAMES.BLUEPRINT .. "s para " .. itemBlueprint:lower()
        end
        --[[
            This is here to avoid wet prefix overriden and to not hide collapsed adjectives if adjectives are disabled by
            mod configurations.
                Spring = True: Rabbit and Crabbit holes closed.
                Spring = False: Rabbit and Crabbit holes opened.
        ]]
        if (prefab == "rabbithole" or prefab == "crabhole") and self.spring then
            return ConstructAdjectivedName(self, name, STRINGS.WET_PREFIX.RABBITHOLE)
        end
        --[[
            If a Hamlet building is destroyed and the world is reloaded, it will show "MISSING NAME", I don't know how to show it's
            proper name based on construction_prefab so I'm just setting name as a unique name for all Hamlet reconstruction projects.
                Pretty sad.
        ]]
        if self.construction_prefab then name = STRINGS.NAMES.RECONSTRUCTION_PROJECT end

        local isWet = self:GetIsWet()
        if showAdjectives and ((isWet or self.always_wet) and not self.no_wet_prefix) then
            if CUSTOM_ADJECTIVE[prefab:upper()] then
                local playerPrefab = CUSTOM_ADJECTIVE[prefab:upper()].CHARACTER

                if GetPlayer().prefab == playerPrefab or playerPrefab == "" then
                    return ConstructAdjectivedName(self, name, CUSTOM_ADJECTIVE[prefab:upper()].ADJECTIVE)
                end
            end
            --[[
                If statement isolated mainly because Wigfrid, since she only eats meat or related. If this were part of the
                elseif statements, Wigfrid will return a name with no adjective attached to it.
            ]]
            if self.components.edible and GetPlayer() and GetPlayer().components.eater then
                -- Special case for wet goop if it's wet.
                if self.prefab == "wetgoop" then return name:gsub(" ", " " .. STRINGS.WET_PREFIX.WETGOOP .. " ") end

                if GetPlayer().components.eater:CanEat(self) then
                    local wetFoodPrefix = Prefix.getWetFoodPrefix(prefab)
                    return ConstructAdjectivedName(self, name, wetFoodPrefix)
                end
            end

            if self.components.equippable and (self.components.equippable.equipslot == "head" or self.components.equippable.equipslot == "body") then
                local wetClothingPrefix = Prefix.getWetClothingPrefix(prefab)
                return ConstructAdjectivedName(self, name, wetClothingPrefix)
            elseif self.components.equippable and self.components.equippable.equipslot == "hands" then
                local wetToolPrefix = Prefix.getWetToolPrefix(prefab)
                return ConstructAdjectivedName(self, name, wetToolPrefix)
            elseif self.components.fuel then
                local wetFuelPrefix = Prefix.getWetFuelPrefix(prefab)
                return ConstructAdjectivedName(self, name, wetFuelPrefix)
            else
                if self.recipetouse then return name:gsub("Planos", STRINGS.WET_PREFIX.MALE.PLURAL.BLUEPRINT) end

                -- To manage sunken Hamlet relics.
                if self.components.sinkable and self.components.sinkable.sunken then
                    return ConstructAdjectivedName(self, name, STRINGS.WET_PREFIX.MALE.SINGULAR.GENERIC)
                end

                local wetGenericPrefix = Prefix.getWetGenericPrefix(prefab)
                return ConstructAdjectivedName(self, name, wetGenericPrefix)
            end
        end
        return name
    end
end

-- Just a bunch of if statements.
local PREFABS = require("sortedprefabs")

return {
	getWitheredPrefix = function(prefab)
		local witheredPrefix = nil

		if PREFABS.MALE.WITHERED[prefab] then
			witheredPrefix = STRINGS.WET_PREFIX.MALE.WITHERED
		elseif PREFABS.FEMALE.WITHERED[prefab] then
			witheredPrefix = STRINGS.WET_PREFIX.FEMALE.WITHERED
		else
			witheredPrefix = "(WITHERED ADJECTIVE?) " .. prefab
		end
	
		return witheredPrefix
	end,
	
	getWetFoodPrefix = function(prefab)
		local wetFoodPrefix = nil

		if PREFABS.FEMALE.SINGULAR.FOOD[prefab] then
			wetFoodPrefix = STRINGS.WET_PREFIX.FEMALE.SINGULAR.FOOD
		elseif PREFABS.FEMALE.PLURAL.FOOD[prefab] then
			wetFoodPrefix = STRINGS.WET_PREFIX.FEMALE.PLURAL.FOOD
		elseif PREFABS.MALE.SINGULAR.FOOD[prefab] then
			wetFoodPrefix = STRINGS.WET_PREFIX.MALE.SINGULAR.FOOD
		elseif PREFABS.MALE.PLURAL.FOOD[prefab] then
			wetFoodPrefix = STRINGS.WET_PREFIX.MALE.PLURAL.FOOD
		else
			wetFoodPrefix = "(FOOD ADJECTIVE?) " .. prefab
		end
	
		return wetFoodPrefix
	end,
	
	getWetClothingPrefix = function(prefab)
		local wetClothingPrefix = nil

		if PREFABS.FEMALE.SINGULAR.CLOTHING[prefab] then
			wetClothingPrefix = STRINGS.WET_PREFIX.FEMALE.SINGULAR.CLOTHING
		elseif PREFABS.FEMALE.PLURAL.CLOTHING[prefab] then
			wetClothingPrefix = STRINGS.WET_PREFIX.FEMALE.PLURAL.CLOTHING
		elseif PREFABS.MALE.SINGULAR.CLOTHING[prefab] then
			wetClothingPrefix = STRINGS.WET_PREFIX.MALE.SINGULAR.CLOTHING
		elseif PREFABS.MALE.PLURAL.CLOTHING[prefab] then
			wetClothingPrefix = STRINGS.WET_PREFIX.MALE.PLURAL.CLOTHING
		else
			wetClothingPrefix = "(CLOTHING ADJECTIVE?) " .. prefab
		end
	
		return wetClothingPrefix
	end,
	
	getWetToolPrefix = function(prefab)
		local wetToolPrefix = nil
		
		if PREFABS.FEMALE.SINGULAR.TOOL[prefab] then
			wetToolPrefix = STRINGS.WET_PREFIX.FEMALE.SINGULAR.TOOL
		elseif PREFABS.FEMALE.PLURAL.TOOL[prefab] then
			wetToolPrefix = STRINGS.WET_PREFIX.FEMALE.PLURAL.TOOL
		elseif PREFABS.MALE.SINGULAR.TOOL[prefab] then
			wetToolPrefix = STRINGS.WET_PREFIX.MALE.SINGULAR.TOOL
		else
			wetToolPrefix = "(TOOL ADJECTIVE?) " .. prefab
		end
	
		return wetToolPrefix
	end,
	
	getWetFuelPrefix = function(prefab)
		local wetFuelPrefix = nil
		
		if PREFABS.FEMALE.SINGULAR.FUEL[prefab] then
			wetFuelPrefix = STRINGS.WET_PREFIX.FEMALE.SINGULAR.FUEL
		elseif PREFABS.FEMALE.PLURAL.FUEL[prefab] then
			wetFuelPrefix = STRINGS.WET_PREFIX.FEMALE.PLURAL.FUEL
		elseif PREFABS.MALE.SINGULAR.FUEL[prefab] then
			wetFuelPrefix = STRINGS.WET_PREFIX.MALE.SINGULAR.FUEL
		elseif PREFABS.MALE.PLURAL.FUEL[prefab] then
			wetFuelPrefix = STRINGS.WET_PREFIX.MALE.PLURAL.FUEL
		else
			wetFuelPrefix = "(FUEL ADJECTIVE?) " .. prefab
		end

		return wetFuelPrefix
	end,
	
	getWetGenericPrefix = function(prefab)
		local wetGenericPrefix = nil
		
		if PREFABS.FEMALE.SINGULAR.GENERIC[prefab] then
			wetGenericPrefix = STRINGS.WET_PREFIX.FEMALE.SINGULAR.GENERIC
		elseif PREFABS.FEMALE.PLURAL.GENERIC[prefab] then
			wetGenericPrefix = STRINGS.WET_PREFIX.FEMALE.PLURAL.GENERIC
		elseif PREFABS.MALE.SINGULAR.GENERIC[prefab] then
			wetGenericPrefix = STRINGS.WET_PREFIX.MALE.SINGULAR.GENERIC
		elseif PREFABS.MALE.PLURAL.GENERIC[prefab] then
			wetGenericPrefix = STRINGS.WET_PREFIX.MALE.PLURAL.GENERIC
		else
			wetGenericPrefix = "(GENERIC ADJECTIVE?) " .. prefab
		end
		
		return wetGenericPrefix
	end,
	
	--[[getWetLivingBeingPrefix = function(name)
		local wetLivingBeingPrefix = nil
		
		if PREFABS.MALE.NAME[name] then
			wetLivingBeingPrefix = STRINGS.WET_PREFIX.MALE.SINGULAR.GENERIC
		elseif PREFABS.FEMALE.NAME[name] then
			wetLivingBeingPrefix = STRINGS.WET_PREFIX.FEMALE.SINGULAR.GENERIC
		end
		
		return wetLivingBeingPrefix
	end]]
}
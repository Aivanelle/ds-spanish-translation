local require = _G.require

-- I really don't like how I wrote this function, maybe I should refactor it later.
local function setHumidString(prefab)
	local playerPrefab = GetPlayer().prefab
	local player = nil

	if playerPrefab ~= "wilson" and STRINGS.CHARACTERS[playerPrefab:upper()] and STRINGS.CHARACTERS[playerPrefab:upper()].ANNOUNCE_TOO_HUMID_ES then
		player = GetPlayer().prefab:upper()
	else
		player = "GENERIC"
	end

	local CHARACTER = STRINGS.CHARACTERS[player]
	local PREFABS = require("sortedprefabs")

	if PREFABS.MALE.SINGULAR.CLOTHING[prefab] then
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[1] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.MALE.SINGULAR[1]
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[2] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.MALE.SINGULAR[2]
	elseif PREFABS.FEMALE.SINGULAR.CLOTHING[prefab] then
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[1] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.FEMALE.SINGULAR[1]
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[2] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.FEMALE.SINGULAR[2]
	elseif PREFABS.MALE.PLURAL.CLOTHING[prefab] then
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[1] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.MALE.PLURAL[1]
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[2] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.MALE.PLURAL[2]
	elseif PREFABS.FEMALE.PLURAL.CLOTHING[prefab] then
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[1] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.FEMALE.PLURAL[1]
		STRINGS.CHARACTERS[player].ANNOUNCE_TOO_HUMID[2] = CHARACTER.ANNOUNCE_TOO_HUMID_ES.FEMALE.PLURAL[2]
	end
end

-- Funtion found on components/grogginess - Ln: 118.
local Grogginess = require "components/grogginess"
function Grogginess:onequip(data)
	local GetString = _G.GetString

	if self.groggyweather then
        local hotitems = self:hasoverheatinggear()
		local string = nil

        if hotitems and #hotitems > 0 then
			if not data then
				--[[
					This occurs when the world is loaded and you're wearing something in the fog or if
					fog appears while you're already wearing something.
				]]
				string = hotitems[1].name
				setHumidString(hotitems[1].prefab)
			else
                for i,item in ipairs(hotitems)do
                    if item == data.item then
						-- This occurs when you dress something in the fog.
                        string = item.name
						setHumidString(item.prefab)
                    end
                end
            end

            if string then
				-- Wormwood uses item names at first, so I need to keep the first letter capitalized.
				if self.inst.prefab ~= "wormwood" then string = string:lower() end
                self.inst.components.talker:Say(GetString(self.inst.prefab, "ANNOUNCE_TOO_HUMID"):format(string))
            end
        end
    end
end

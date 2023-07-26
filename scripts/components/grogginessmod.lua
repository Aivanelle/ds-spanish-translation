local GetString = _G.GetString
local Grogginess = require "components/grogginess"

function Grogginess:onequip(data)
  if self.groggyweather then
    local hotitems = self:hasoverheatinggear()

    if hotitems and #hotitems > 0 then
      local item = nil
      local name = nil

      if not data then
        item = hotitems[1]
        name = item.name
      else
        for _, hotitem in ipairs(hotitems) do
          if hotitem == data.item then
            item = hotitem
            name = item.name
          end
        end
      end

      if name then
        local player = self.inst.prefab
        -- Wormwood uses item names at first, so I need to keep the first letter capitalized.
        if player ~= "wormwood" then name = name:lower() end

        local CHARACTER_STRINGS = STRINGS.CHARACTERS[player:upper()] or STRINGS.CHARACTERS.GENERIC
        local grammar = item.components.grammar

        if CHARACTER_STRINGS.ANNOUNCE_TOO_HUMID_ES and grammar then
          CHARACTER_STRINGS.ANNOUNCE_TOO_HUMID[1] = CHARACTER_STRINGS.ANNOUNCE_TOO_HUMID_ES[grammar.gender][grammar.grammaticalnumber][1]
          CHARACTER_STRINGS.ANNOUNCE_TOO_HUMID[2] = CHARACTER_STRINGS.ANNOUNCE_TOO_HUMID_ES[grammar.gender][grammar.grammaticalnumber][2]
        end

        self.inst.components.talker:Say(GetString(player, "ANNOUNCE_TOO_HUMID"):format(name))
      end
    end
  end
end

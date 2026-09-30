AddClassPostConstruct("components/grogginess", function(self)
  function self:onequip(data)
    if not self.groggyweather then return end

    local hotitems = self:hasoverheatinggear()

    if not hotitems or #hotitems <= 0 then return end

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

    if not name then return end

    local player = self.inst.prefab

    -- Wormwood uses item names at first, so I need to keep the first letter capitalized.
    if player ~= "wormwood" then
      name = utf8.lower(name)
    end

    local grammar = item.components.grammar
    local character = player == "wilson" and "GENERIC" or player:upper()
    print(character)
    local TRANSLATION_STRINGS = STRINGS.ES_TRANSLATION.CHARACTERS[character]

    if TRANSLATION_STRINGS and TRANSLATION_STRINGS.ANNOUNCE_TOO_HUMID and grammar then
      local gender = grammar.gender
      local grammaticalNumber = grammar.grammaticalnumber
      local GROGGINESS_STRINGS = STRINGS.CHARACTERS[character]

      GROGGINESS_STRINGS.ANNOUNCE_TOO_HUMID[1] = TRANSLATION_STRINGS.ANNOUNCE_TOO_HUMID[gender][grammaticalNumber][1]
      GROGGINESS_STRINGS.ANNOUNCE_TOO_HUMID[2] = TRANSLATION_STRINGS.ANNOUNCE_TOO_HUMID[gender][grammaticalNumber][2]
    end

    self.inst.components.talker:Say(_G.GetString(player, "ANNOUNCE_TOO_HUMID"):format(name))
  end
end)

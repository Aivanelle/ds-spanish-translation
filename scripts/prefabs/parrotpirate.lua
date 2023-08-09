local function setParrotGender(inst, genderTable, gender)
  for _, v in ipairs(genderTable) do
    if v == inst.components.named.name then
      inst.components.grammar:SetGender(gender)
      break
    end
  end
end

local PARROT_NAMES = nil
local function modParrotPirate(inst)
  if not PARROT_NAMES then PARROT_NAMES = require "sortedprefabs/parrotnames" end

  inst:AddComponent("grammar")
  inst.components.grammar:SetGrammaticalNumber(GRAMMATICAL_NUMBER.SINGULAR)
  inst.components.grammar:SetOnSave(true)

  if inst.components.named and inst.components.named.name then
    setParrotGender(inst, PARROT_NAMES.MASCULINE, GENDER.MASCULINE)

    if not inst.components.grammar.gender then
      setParrotGender(inst, PARROT_NAMES.FEMININE, GENDER.FEMININE)
    end
  end

  local OriginalOnLoad = inst.OnLoad

  inst.OnLoad = function(inst, data)
    OriginalOnLoad(inst, data)

    if inst.components.named and inst.components.named.name then
      inst.components.grammar:SetGender(nil)

      setParrotGender(inst, PARROT_NAMES.MASCULINE, GENDER.MASCULINE)

      if not inst.components.grammar.gender then
        setParrotGender(inst, PARROT_NAMES.FEMININE, GENDER.FEMININE)
      end
    end
  end
end

AddPrefabPostInit("parrot_pirate", modParrotPirate)

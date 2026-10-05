local DIALOGUE_STRINGS = { female = "FEMALE", robot = "ROBOT" }

local function modMaxwellIntro(inst)
  local prefab = GetPlayer().prefab
  local genderStrings = GetGenderStrings(prefab)

  DIALOGUE_STRINGS.auto = genderStrings ~= "MALE" and genderStrings
  local stringsToUse = DIALOGUE_STRINGS[DialogueGenderConfig]

  if not stringsToUse then return end

  inst.components.maxwelltalker.speeches.SANDBOX_1[1].string = STRINGS.ES_TRANSLATION.MAXWELL_SANDBOXINTROS.ONE[stringsToUse]
  inst.components.maxwelltalker.speeches.ADVENTURE_4[1].string = STRINGS.ES_TRANSLATION.MAXWELL_ADVENTUREINTROS.SAYPAL[stringsToUse]
  inst.components.maxwelltalker.speeches.ADVENTURE_TWOLANDS[1].string = STRINGS.ES_TRANSLATION.MAXWELL_ADVENTUREINTROS.SAYPAL[stringsToUse]
end

AddPrefabPostInit("maxwellintro", modMaxwellIntro)

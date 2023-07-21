local dialogueStrings =
{
  female = "FEMALE",
  robot = "ROBOT"
}

local function setIntroGender()
  local playerPrefab = GetPlayer().prefab
  local genderStrings = GetGenderStrings(playerPrefab)

  dialogueStrings["auto"] = genderStrings ~= "MALE" and genderStrings
  local stringsToUse = dialogueStrings[dialogueGenderConfig] 

  if stringsToUse then
    STRINGS.MAXWELL_SANDBOXINTROS.ONE = STRINGS.MAXWELL_SANDBOXINTROS.ONE_ES[stringsToUse]
    STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_4.ONE = STRINGS.MAXWELL_ADVENTUREINTROS.SAYPAL_ES[stringsToUse]
    STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.ONE = STRINGS.MAXWELL_ADVENTUREINTROS.SAYPAL_ES[stringsToUse]
  end
end

local function modMaxwellIntro(prefab)
  setIntroGender()

  prefab.components.maxwelltalker.speeches.SANDBOX_1 =
  {
    appearsound = "dontstarve/maxwell/disappear",
    voice = "dontstarve/maxwell/talk_LP",
    appearanim = "appear",
    idleanim = "idle",
    dialogpreanim = "dialog_pre",
    dialoganim = "dial_loop",
    dialogpostanim = "dialog_pst",
    disappearanim = "disappear",
    disableplayer = true,
    skippable = true,
    {
      string = STRINGS.MAXWELL_SANDBOXINTROS.ONE,
      wait = 2.5,
      anim = nil,
      sound = nil,
    },
    {
      string = STRINGS.MAXWELL_SANDBOXINTROS.TWO,
      wait = 3,
      anim = nil,
      sound = nil,
    },
  }
  
  prefab.components.maxwelltalker.speeches.ADVENTURE_4 =
  {		
    delay = 2,
    voice = "dontstarve/maxwell/talk_LP_world4",
    appearanim = "appear4",
    idleanim= "idle4_loop",
    dialogpreanim = "dialog4_pre",
    dialoganim="dialog4_loop",
    dialogpostanim = "dialog4_pst",
    disappearanim = "disappear4",
    disableplayer = true,
    skippable = true,
    {
      string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_4.ONE,
      wait = 1.5,
      anim = nil,
      sound = nil,
    },
    {
      string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_4.TWO, 
      wait = 3.5, 
      anim = nil, 
      sound = nil,
    },
    {
      string = STRINGS.MAXWELL_ADVENTUREINTROS.LEVEL_4.THREE, 
      wait = 3.5, 
      anim = nil, 
      sound = nil,
    },
  }
  
  prefab.components.maxwelltalker.speeches.ADVENTURE_TWOLANDS =
  {		
    delay = 2,
    voice = "dontstarve/maxwell/talk_LP_world4",
    appearanim = "appear4",
    idleanim= "idle4_loop",
    dialogpreanim = "dialog4_pre",
    dialoganim="dialog4_loop",
    dialogpostanim = "dialog4_pst",
    disappearanim = "disappear4",
    disableplayer = true,
    skippable = true,
    {
      string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.ONE,
      wait = 1.5,
      anim = nil,
      sound = nil,
    },
    {
      string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.TWO, 
      wait = 3.5, 
      anim = nil, 
      sound = nil,
    },
    {
      string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.THREE, 
      wait = 3.5, 
      anim = nil, 
      sound = nil, 
    },
    {
      string = STRINGS.MAXWELL_ADVENTUREINTROS.TWOLANDS.FOUR, 
      wait = 2.5,
      anim = nil,
      sound = nil,
    },
  }
end

AddPrefabPostInit("maxwellintro", modMaxwellIntro)

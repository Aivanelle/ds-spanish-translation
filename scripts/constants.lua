GRAMMATICAL_NUMBER = { PLURAL = "PLURAL", SINGULAR = "SINGULAR" }
GENDER = { MASCULINE = "MASCULINE", FEMININE = "FEMININE" }

STALE_TEXT_COLOR = { 250/255, 160/255, 31/255, 1 }
SPOILED_TEXT_COLOR = { 1, 106/255, 106/255, 1 }

_G = GLOBAL

assert = _G.assert
subfmt = _G.subfmt
require = _G.require

STRINGS = _G.STRINGS
TUNING = _G.TUNING
ROG_DLC = _G.REIGN_OF_GIANTS
CAPY_DLC = _G.CAPY_DLC
PORKLAND_DLC = _G.PORKLAND_DLC

IsDLCEnabled = _G.IsDLCEnabled
ConstructAdjectivedName = _G.ConstructAdjectivedName
GetPlayer = _G.GetPlayer
GetGenderStrings = _G.GetGenderStrings
KnownModIndex = _G.KnownModIndex

AnyDLCEnabled = IsDLCEnabled(ROG_DLC) or IsDLCEnabled(CAPY_DLC) or IsDLCEnabled(PORKLAND_DLC)
NORMAL_TEXT_COLOR = AnyDLCEnabled and _G.NORMAL_TEXT_COLOUR or { 1, 1, 1, 1 }

UsePigLatin = GetModConfigData("usePigLatin")
IsPigLatinAvailable = IsDLCEnabled(PORKLAND_DLC) and UsePigLatin

ShowAdjectivesConfig = GetModConfigData("showAdjectives")
DialogueGenderConfig = GetModConfigData("dialogueGender")
ColorPerishablesConfig = GetModConfigData("colorPerishables")
UnknownAdjectivesConfig = GetModConfigData("unknownAdjectives")

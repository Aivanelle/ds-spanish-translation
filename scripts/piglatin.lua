local utf8 = require("lib/utf8/init"):init()

local pigLatinSpeakers = {
  wilba = true,
  pigman_banker = true,
  pigman_banker_shopkeep = true,
  pigman_beautician = true,
  pigman_beautician_shopkeep = true,
  pigman_collector = true,
  pigman_collector_shopkeep = true,
  pigman_erudite = true,
  pigman_erudite_shopkeep = true,
  pigman_farmer = true,
  pigman_farmer_shopkeep = true,
  pigman_florist = true,
  pigman_florist_shopkeep = true,
  pigman_hatmaker = true,
  pigman_hatmaker_shopkeep = true,
  pigman_hunter = true,
  pigman_hunter_shopkeep = true,
  pigman_mayor = true,
  pigman_mayor_shopkeep = true,
  pigman_mechanic = true,
  pigman_mechanic_shopkeep = true,
  pigman_miner = true,
  pigman_miner_shopkeep = true,
  pigman_professor = true,
  pigman_professor_shopkeep = true,
  pigman_queen = true,
  pigman_royalguard = true,
  pigman_royalguard_2 = true,
  pigman_shopkeep = true,
  pigman_storeowner = true,
  pigman_storeowner_shopkeep = true,
  pigman_usher = true
}

local EXCEPTION = {
  WILBA = true,
  DING = true,
  MMM = true,
  HAMLET = true,
  BUA = true,
  ["ÑAM"] = true,
  ["ÑAMS"] = true
}

local LETTER_BASE = {
  ["Á"] = "A",
  ["É"] = "E",
  ["Í"] = "I",
  ["Ó"] = "O",
  ["Ú"] = "U",
  ["Ü"] = "U"
}

local GLOBAL_SUFFIX = { I = "I", EI = "EI", YEI = "YEI" }

local DIGRAPH = { CH = true, LL = true, QU = true, GU = true }

local INVALID_CONSONANT_CLUSTER = {
  RB = true, RD = true, RG = true, RK = true, RL = true, RM = true, RN = true,
  RP = true, RR = true, RS = true, RT = true, DJ = true, DM = true, DN = true,
  DS = true, GM = true, GN = true, GS = true, MB = true, MN = true, MP = true,
  MS = true, NC = true, ND = true, NF = true, NG = true, NM = true, NN = true,
  NS = true, NT = true, PN = true, PS = true, PT = true, SB = true, SC = true,
  SD = true, SF = true, SG = true, SK = true, SL = true, SM = true, SN = true,
  SP = true, SQ = true, SR = true, ST = true, TL = true, TN = true, TS = true,
  LG = true, LT = true, BJ = true
}

local LAST_LETTER_SUFFIX = {
  A = GLOBAL_SUFFIX.YEI, ["Á"] = GLOBAL_SUFFIX.YEI,
  E = GLOBAL_SUFFIX.I, ["É"] = GLOBAL_SUFFIX.I,
  I = GLOBAL_SUFFIX.YEI, ["Í"] = GLOBAL_SUFFIX.YEI,
}

local function shouldUsePigLatin(prefab)
  return pigLatinSpeakers[prefab]
end

local function getMatchingLetter(word)
  local firstLetter = utf8.sub(word, 1, 1)
  local lastLetter = utf8.sub(word, -1)

  return LETTER_BASE[utf8.upper(firstLetter)] and firstLetter
      or LETTER_BASE[utf8.upper(lastLetter)] and lastLetter
      or firstLetter
end

local function getLetterBase(letter)
  local letter = utf8.upper(letter)

  return LETTER_BASE[letter] or letter
end

local function isFirstLetterSameAsLast(word)
  local firstLetter = getLetterBase(utf8.sub(word, 1, 1))
  local lastLetter = getLetterBase(utf8.sub(word, -1))

  return firstLetter == lastLetter
end

local function getSuffix(lastLetter)
  return (LAST_LETTER_SUFFIX[lastLetter] or GLOBAL_SUFFIX.EI)
end

local function hasInvalidConsonantCluster(word)
  local consonant_cluster = utf8.upper(utf8.sub(word, 2, 3))

  return INVALID_CONSONANT_CLUSTER[consonant_cluster]
end

local function hasDigraph(word)
  local digraph = utf8.upper(utf8.sub(word, 1, 2))

  return DIGRAPH[digraph]
end

local function pigLatinizeWord(word)
  if EXCEPTION[utf8.upper(word)] then return word end

  if utf8.len(word) == 1 then return word .. getSuffix(utf8.upper(word)) end

  if utf8.len(word) == 2 then
    local lastLetter = utf8.upper(utf8.sub(word, 1, 1))

    return utf8.reverse(word) .. getSuffix(lastLetter)
  end

  if hasDigraph(word) then
    local lastLetter = utf8.upper(utf8.sub(word, 2, 2))

    return utf8.sub(word, 3) ..
           utf8.sub(word, 1, 2) ..
           getSuffix(lastLetter)
  end

  if hasInvalidConsonantCluster(word) then
    local lastLetter = utf8.upper(utf8.sub(word, 2, 2))
    
    if isFirstLetterSameAsLast(word) then
      local matchingLetter = getMatchingLetter(word)

      return utf8.sub(word, 3, -2) ..
             matchingLetter ..
             lastLetter ..
             getSuffix(lastLetter)
    end

    return utf8.sub(word, 3) ..
           utf8.sub(word, 1, 2) ..
           getSuffix(lastLetter)
  end

  local lastLetter = utf8.upper(utf8.sub(word, 1, 1))
  
  if isFirstLetterSameAsLast(word) then
    local matchingLetter = getMatchingLetter(word)

    return utf8.sub(word, 2, -2) ..
           matchingLetter ..
           getSuffix(lastLetter)
  end

  return utf8.sub(word, 2) ..
         utf8.sub(word, 1, 1) ..
         getSuffix(lastLetter)
end

local function splitStringByTokens(sentence)
  local sentenceTokens = {}

  for sentenceSection in sentence:gmatch("%S+%s*") do
    local token = sentenceSection:match("^%S+")
    local whitespace = sentenceSection:match("%s*$")

    local prefix = utf8.match(token, "^[^%aáéíóúüñÁÉÍÓÚÜÑ]*")
    local word = utf8.match(token, "[%aáéíóúüñÁÉÍÓÚÜÑ]+[%-%aáéíóúüñÁÉÍÓÚÜÑ]*")
    local suffix = utf8.match(token, "[^%aáéíóúüñÁÉÍÓÚÜÑ]*$")

    if prefix ~= "" then
      table.insert(sentenceTokens, prefix)
    end

    if word then
      local startIndex, endIndex = utf8.find(word, "-")

      if startIndex then
        local startWord = utf8.sub(word, 1, startIndex - 1)
        local endWord = utf8.sub(word, endIndex + 1, -1)

        table.insert(sentenceTokens, pigLatinizeWord(startWord))
        table.insert(sentenceTokens, "-")
        table.insert(sentenceTokens, pigLatinizeWord(endWord))
      else
        table.insert(sentenceTokens, pigLatinizeWord(word))
      end

    end

    if suffix ~= "" then
      table.insert(sentenceTokens, suffix)
    end

    if whitespace ~= "" then
      table.insert(sentenceTokens, whitespace)
    end
  end

  return table.concat(sentenceTokens, "")
end

AddClassPostConstruct("components/talker", function (self)
  local originalSay = self.Say

  function self:Say(script, ...)

    if shouldUsePigLatin(self.inst.prefab) then
      if type(script) == "string" then

        script = splitStringByTokens(script)
      else

        for _, line in ipairs(script) do
          line.message = splitStringByTokens(line.message)
        end

      end
    end

    return originalSay(self, script, ...)
  end
end)

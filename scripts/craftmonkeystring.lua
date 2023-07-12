-- Random Wilbur strings "translated".
if _G.CraftMonkeyString then
  _G.CraftMonkeyString = function()
    --[[
      COMMA: True if it can be a comma right after the punctuation mark, False otherwise.
      MUST_LOWER: In absence of a comma, True if next char must be lowercase, False if it's not necessary.
      OPT_CAP: Means Optional Capitalized. True if next char after the punctuation mark can or cannot be capitalized, False
        if it's not optional, meaning that it must be lowercase or uppercase.
      PERIOD: True if the last punctuation mark must be replaced by a period in the last string of the "monkey sentence" generated, False
        otherwise. Small exception made with the empty punctuation mark.
    ]]
    local MARKS =
    {
      -- {"", ";", {COMMA = false, MUST_LOWER = true, OPT_CAP = false, PERIOD = true}},
      {"¡", "!", {COMMA = true, MUST_LOWER = false, OPT_CAP = false, PERIOD = false}},
      {"¿", "?", {COMMA = true, MUST_LOWER = false, OPT_CAP = false, PERIOD = false}},
      {"", "...", {COMMA = true, MUST_LOWER = false, OPT_CAP = true, PERIOD = false}},
      {"", ",", {COMMA = false, MUST_LOWER = true, OPT_CAP = false, PERIOD = true}},
      {"", ".", {COMMA = false, MUST_LOWER = false, OPT_CAP = false, PERIOD = false}},
      -- Default punctuation mark, this is the most common case just because that's how I programmed it.
      {"", "", {COMMA = false, MUST_LOWER = true, OPT_CAP = false, PERIOD = true}}
    }

    --[[
      Every initial letter of every string generated can be paired with certain characters, the selected characters
      to be paired are personal choice.
      If SUBSEQUENT_LETTERS is empty, it means that the first letter can only be paired with its lowered case.
    ]]
    local INITIAL_LETTERS =
    {
      {
        FIRST_LETTER = "A",
        SUBSEQUENT_LETTERS = {""}
      },
      {
        FIRST_LETTER = "O",
        SUBSEQUENT_LETTERS = {""}
      },
      {
        FIRST_LETTER = "U",
        SUBSEQUENT_LETTERS = {"a", "e", "o", "u"}
      }
    }

    local initialMarkIndex
    local markFrequency = .4
    local LOWERCASE = false

    local function makeString()
      -- By default, every string generated uses the last punctuation mark listed.
      initialMarkIndex = #MARKS

      -- Minus one to exclude the empty punctuation mark, which is the last one listed in MARKS.
      if math.random() <= markFrequency then initialMarkIndex = math.random(#MARKS - 1) end

      local str = MARKS[initialMarkIndex][1]
      local initialLetterIndex = math.random(#INITIAL_LETTERS)
      str = str .. INITIAL_LETTERS[initialLetterIndex].FIRST_LETTER

      if LOWERCASE then str = str:lower() end
      LOWERCASE = false

      local subsequentLetterIndex = 0

      if #INITIAL_LETTERS[initialLetterIndex].SUBSEQUENT_LETTERS ~= 0 then
        subsequentLetterIndex = math.random(#INITIAL_LETTERS[initialLetterIndex].SUBSEQUENT_LETTERS)
      end

      local subsequentLetter

      if subsequentLetterIndex == 0 then
        subsequentLetter = INITIAL_LETTERS[initialLetterIndex].FIRST_LETTER:lower()
      else
        subsequentLetter = INITIAL_LETTERS[initialLetterIndex].SUBSEQUENT_LETTERS[subsequentLetterIndex]
      end

      local characters = math.random(0, 3)

      for i = 1, characters do str = str .. subsequentLetter end

      return str .. "h" .. MARKS[initialMarkIndex][2]
    end

    local str = ""
    local words = math.random(5)

    for i = 1, words do
      str = str .. makeString()

      -- If the last string was generated, it will no longer add a comma or space.
      if i ~= words then
        if MARKS[initialMarkIndex][3].COMMA and math.random() <= .2 then
          LOWERCASE = true
          str = str .. ", "
        else
          str = str .. " "
          LOWERCASE = (MARKS[initialMarkIndex][3].OPT_CAP and math.random() < .5) or MARKS[initialMarkIndex][3].MUST_LOWER
        end
      else
        if MARKS[initialMarkIndex][3].PERIOD then
          -- If the punctuation mark used was empty, it will just add a period.
          if MARKS[initialMarkIndex][2] ~= "" then str = str:sub(1, #str - 1) .. "." else str = str .. "." end
        end
      end
    end

    return str
  end
end

local Grammar = Class(function(self, inst)
  self.inst = inst
  self.grammaticalnumber = nil
  self.gender = nil
end)

function Grammar:SetGrammaticalNumber(grammaticalNumber)
  self.grammaticalnumber = grammaticalNumber or "UNKNOWN"
end

function Grammar:SetGender(gender)
  self.gender = gender or "UNKNOWN"
end

return Grammar

local ConstructOriginalAdjectivedName = _G.ConstructAdjectivedName or function() return "" end

_G.ConstructAdjectivedName = function(inst, name, adjective)
  local adjectivedName = ConstructOriginalAdjectivedName(inst, name, adjective)

  if adjectivedName ~= "" and name:find("?") then
    adjectivedName = name:gsub("?", " " .. adjective .. "?")
  end

  return adjectivedName
end

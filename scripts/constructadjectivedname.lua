if _G.ConstructAdjectivedName then
  local function UsesPrefix(item)
    if type(item) == "string" then return USE_PREFIX[item] end
  end

  -- ConstructAdjectivedName can be found in scripts/dlcsupport_strings.lua - Ln: 77.
  _G.ConstructAdjectivedName = function (inst, name, adjective)
    if name == nil and inst ~= nil and inst.prefab ~= nil then
      name = STRINGS.NAMES[string.upper(inst.prefab)]
    end
    
    name = name or "MISSING NAME"
    
    local usePrefix = UsesPrefix(adjective)
    if usePrefix == nil then
      usePrefix = UsesPrefix(name)
    end
    
    if type(usePrefix) == "function" then
      local tryfunction = usePrefix(inst, name, adjective)
      if type(tryfunction) == "string" then return tryfunction end
    end
    
    -- Just added an extra return for names that use questions marks.
    if name:find("?") then
      return usePrefix ~= false and (adjective .. " " .. name) or (name:gsub("?", " " .. adjective .. "?"))
    end

    return usePrefix ~= false and (adjective .. " " .. name) or (name .. " " .. adjective)
  end
end

local toml=require'toml'

local function generate_opt(opts,path)
  local file=assert(io.open(path..'/yazi.toml','w'))
  file:write(toml.encode(opts))
  file:close()
end

local function generate_keymap(keymaps,path)
  local tbl={}
  for _,v in ipairs(keymaps) do
    table.insert(tbl,{on=v[1],run=v[2],desc=v[3]})
  end
  local file=assert(io.open(path..'/keymap.toml','w'))
  file:write(toml.encode{mgr={prepend_keymap=tbl}})
  file:close()
end

local function generate_lua(fns,path)
  local code={}
  for _,fn in ipairs(fns) do
    table.insert(code,('load(%q)()'):format(string.dump(fn,true)))
  end
  local file=assert(io.open(path..'/init.lua','w'))
  file:write(table.concat(code,'\n'))
  file:close()
end

local M={}

function M.compile(path)
  local yc={}
  yc.fns={}
  yc.keymaps={}

  function yc.register(fn)
    table.insert(yc.fns,fn)
  end

  function yc.keymap(key,map,desc)
    table.insert(yc.keymaps,{key,map,desc})
  end

  yc.opt=setmetatable({},{__index=function(tbl,key)
    rawset(tbl,key,{})
    return rawget(tbl,key)
  end})

  loadfile(path..'/config.lua')(yc)

  setmetatable(yc.opt,nil)

  generate_opt(yc.opt,path)
  generate_keymap(yc.keymaps,path)
  generate_lua(yc.fns,path)
end

return M

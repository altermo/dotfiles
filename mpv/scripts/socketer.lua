local utils = require 'mp.utils'

local dir='/tmp/mpv-sock/'

if not utils.readdir(dir) then
  mp.msg.log('warn',('No `%s` dir found, creating `%s`'):format(dir,dir))

  os.execute(('mkdir -p -- %q'):format(dir))
end
local socket=utils.join_path(dir,tostring(utils.getpid()))
mp.set_property_native('input-ipc-server',socket)

local function refresh_last(first)
  os.execute(('ls -- %q|xargs -I_ sh -c "ps -p _ >/dev/null||rm %q/_"'):format(dir,dir))

  local sockets=utils.readdir(dir,'all')
  assert(table.remove(sockets,1)=='.')
  assert(table.remove(sockets,1)=='..')
  local found
  local ids={}
  for k,v in ipairs(sockets) do
    table.insert(ids,tonumber(v))

    if tonumber(v)==utils.getpid() then
      found=true
    end
  end

  if first and not found then
    table.insert(ids,utils.getpid())
  end

  if #ids==0 then
    os.remove('/tmp/mpv.sock')
    return
  end

  last=math.max(unpack(ids))

  mp.command_native{'run','ln','-s','-f',utils.join_path(dir,tostring(last)),'/tmp/mpv.sock'}
end

mp.register_event('shutdown',function()
  os.remove(socket)

  refresh_last()
end)
refresh_last(true)

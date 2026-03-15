local yc=...

table.insert(yc.pack,{
  use='yazi-rs/plugins:jump-to-char',
  hash='7a4b4237223aaa94e589d1c01a23542a',
  rev='1962818',
})
yc.keymap('f','plugin jump-to-char')
yc.keymap('F','filter --smart')

yc.register(function()
  function Tabs.height() return 0 end

  Header:children_add(function()
    if #cx.tabs == 1 then return "" end
    local spans = {}
    for i = 1, #cx.tabs do
      spans[#spans + 1] = ui.Span(" " .. i .. " ")
    end
    spans[cx.tabs.idx]:reverse()
    return ui.Line(spans)
  end, 9000, Header.RIGHT)
end)

yc.register(function()
  Header:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
      return ui.Line{ui.Span(" . -> "),ui.Span(tostring(h.link_to)):fg('cyan')}
    else
      return
    end
  end, 3300, Status.LEFT)
end)

-- Stop permentantly deleting important stuff
yc.keymap('D','noop')
yc.keymap('<A-C-D>','remove --permanently')

yc.keymap('!','shell "$SHELL" --block','Open shell here')
yc.keymap('I','shell --block -- bat --binary=as-text --decorations never --paging never --color always "$0"|less --SILENT -R +g','Quick view')

yc.keymap('q','close')
yc.keymap('<C-c>','quit')

yc.keymap({'g','r'},'shell -- ya emit cd "$(git rev-parse --show-toplevel)"','Goto git root')
yc.keymap({'g','a'},'shell --block -- ya emit cd "$(dff)"','Dff')
for k,v in pairs{
  t='/tmp',u='/tmp/user',n='/nix',
  e='/etc',l='~/.local',p='~/projects'} do
  yc.keymap({'g',k},'cd '..v,'Goto '..v)
end

yc.opt.mgr.show_hidden=true
yc.opt.mgr.linemode='size'

yc.opt.tasks.image_bound={0,0}

yc.opt.opener={
  all={
    {run='$EDITOR "$@"',desc='$EDITOR',block=true},
    {run='xdg-open "$1"',desc='xdg-open'},
    {run='F="$1" FA="$@" $SHELL',desc='shell-$F',block=true},
  },
  browser={
    {run='firefox "$@"',desc='firefox',orphan=true},
  },
  video={
    {run='mpv --force-window "$@"',desc='mpv',orphan=true},
    {run='mpv --no-video "$@"',desc='mpv-audio-only'},
  },
  audio={
    {run='mpv --no-video "$@"',desc='mpv'},
    {run='mpv --force-window "$@"',desc='mpv-windowed',orphan=true},
  },
  ask={
    {run='ya emit open --interactive',desc='Open with:'}
  },
}

local o_browser={'browser','all'}
local o_audio={'audio','all','browser'}
local o_video={'video','all','browser'}
local o_text={'all','browser'}
local o_ask={'ask','all','browser'}
yc.opt.open.rules={
    {mime='image/*',use=o_browser},
    {mime='application/pdf',use=o_browser},

    {mime='audio/*',use=o_audio},
    {mime='video/*',use=o_video},

    {mime='text/*',use=o_text},
    {mime='application/{json,ndjson,elc}',use=o_text},
    {mime='*/javascript',use=o_text},
    {mime='inode/empty',use=o_text},

    {mime='application/{zlib,zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}',use=o_ask},

    {name='*/',use=o_ask},
    {name='*',use=o_ask},
    {url='*/',use=o_ask},
    {url='*',use=o_ask},
}

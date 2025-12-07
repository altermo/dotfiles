vim.loader.enable()

vim.o.splitbelow=true
vim.o.splitright=true
vim.o.fillchars='vert: ,eob: ,horiz: ,horizup: ,horizdown: ,vertleft: ,vertright: ,verthoriz: '
vim.o.ignorecase=true
vim.o.smartcase=true
vim.o.spelloptions='camel'
vim.o.background='light' --yes, default light theme
vim.o.cmdheight=0
vim.o.laststatus=0
vim.o.statusline=' ' -- if set to '', will interper as unset(default).
vim.o.signcolumn='no'
vim.o.tabstop=4
vim.o.shiftwidth=0
vim.o.smartindent=true
vim.o.cindent=true
vim.o.expandtab=true
vim.o.indentexpr="v:lua.require'nvim-treesitter'.indentexpr()" --the quotes are important
vim.o.linebreak=true
vim.o.showbreak='↳ '
vim.o.breakindent=true
vim.o.list=true
vim.o.conceallevel=2
vim.o.undofile=true
vim.o.swapfile=false
vim.o.scrolloff=5
vim.o.shortmess='ascoOAFWI'
vim.o.virtualedit='block,onemore'
vim.o.shada="'500,/9,:50,<50,@9,s10"
vim.o.nrformats='hex,unsigned'
vim.o.wildmode='longest:full,full' -- for cmdline completion
vim.o.pumheight=5
vim.o.pumblend=20

vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/nvim-mini/mini.nvim',
  {src='https://github.com/nvim-treesitter/nvim-treesitter',version='main'},
  'https://github.com/altermo/small.nvim',
  'https://github.com/altermo/dff',
  {src='https://github.com/saghen/blink.cmp',version=vim.version.range('')},
  'https://github.com/folke/snacks.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/Saghen/blink.pairs',
})

vim.cmd.filetype'indent off'
vim.cmd.syntax'off'

vim.api.nvim_create_autocmd('SafeState',{callback=function ()
  vim.diagnostic.config({virtual_text=true,severity_sort=true,jump={float=true}})

  local rename=vim.lsp.handlers['textDocument/rename']
  vim.lsp.handlers['textDocument/rename']=function(_,result,ctx)
    rename(_,result,ctx)
    local changes=result.changes or result.documentChanges
    vim.notify(('Renamed %s instance in %s file'):format(
      vim.iter(changes):fold(0,function(a,k,n) return a+(#((n or k).edits or (n or k))) end),
      #vim.tbl_keys(changes))) end

  for lsp,opt in pairs({
    lua_ls={settings={Lua={
      runtime={version='LuaJIT',unicodeName=true},
      workspace={library={'/usr/local/share/nvim/runtime/lua/'}}}}},
    clangd={},rust_analyzer={},zls={},
    taplo={},ts_ls={},vimls={},basedpyright={},
    ['nil']={},nixd={},
  }) do
    vim.lsp.config(lsp,opt)
    vim.lsp.enable(lsp)
  end

  require'nvim-treesitter'.install('unstable',{max_jobs=2})
  require'nvim-treesitter'.update({max_jobs=2})
  pcall(vim.treesitter.start)
  vim.api.nvim_create_autocmd('FileType',{callback=function() pcall(vim.treesitter.start) end})
  vim.cmd.syntax'on'

  require'small.typo'.setup{}
  require'small.highlight_selected'.setup{}
  require'small.reminder2'.conf={path='/home/user/.gtd/gtd/plans.md'}
  require'small.reminder2'.setup{}
  require'small.verttab'.setup{}
end,once=true})

require('guess-indent').setup {}

require'oil'.setup{view_options={show_hidden=true},skip_confirm_for_simple_edits=true,keymaps={['<C-h>']=false,['<C-l>']=false}}
vim.api.nvim_create_autocmd('BufWinEnter',{pattern='oil://*',callback=function ()
  pcall(vim.cmd.lcd,require'oil'.get_current_dir()) end})

vim.api.nvim_create_autocmd('InsertCharPre',{callback=function ()
  require'blink.cmp'.setup{
    snippets={expand=function(snippet) vim.snippet.expand(snippet) vim.snippet.stop() end},
    completion={list={selection={preselect=false,auto_insert=true}},
      menu={winblend=vim.o.pumblend,max_height=6,draw={padding=0}}},
    keymap={preset='cmdline',['<Tab>']={'select_next','fallback'},['<S-Tab>']={'select_prev','fallback'}},
    sources={providers={lsp={async=true,fallbacks={}},
      path={opts={trailing_slash=false,show_hidden_files_by_default=true}}}},
    cmdline={enabled=false}}
  vim.api.nvim_set_hl(0,'BlinkCmpLabelMatch',{link='PmenuMatch'})
end,once=true})

require('vim._extui').enable{}

for i in ('hjkl'):gmatch('.') do
  vim.keymap.set({'t','n'},'<C-'..i..'>','<C-\\><C-n><C-w>'..i..'<cmd>if &buftype=="terminal"|startinsert|endif\r')
end

for i=1,9 do
  vim.keymap.set('n','<A-'..i..'>',':tabnext '..i..'\r')
end

vim.keymap.set('n','dc',':lcd ..|pwd\r')
vim.keymap.set('n','cd',':lcd %:p:h|pwd\r')

vim.keymap.set('x','<A-f>','y:<C-u>%s/<C-r>"//g<Left><Left>a<bs>',{silent=false})

for i in ([['"`()[]{}<>]]):gmatch('.') do
  vim.keymap.set('o',i,'i'..i,{silent=true})
  vim.keymap.set('n','v'..i,'vi'..i,{silent=true})
end

for k,v in pairs{
  ['<S-Left>']=('<Left>'):rep(5),['<M-S-h>']=('<Left>'):rep(5),
  ['<S-Right>']=('<Right>'):rep(5),['<M-S-l>']=('<Right>'):rep(5),
  ['<M-b>']='<S-Left>',['<M-f>']='<S-Right>',
  ['<M-h>']='<Left>',['<M-l>']='<Right>',
  ['<A-j>']='<Down>',['<A-k>']='<Up>',
} do
  vim.keymap.set({'i','c'},k,v)
end

vim.keymap.set('t','<C-\\>','<C-\\><C-n>')
vim.keymap.set('t','<C-A-\\>','<C-\\><C-\\>')

for k,v in pairs({
  b={'background','"light"','"dark"'},c={'cmdheight',1,0},l='list',
  m={'conceallevel',2,0},L={'laststatus',2,0},w='wrap',d='diff',
  s='spell',f='foldenable',e='scrollbind',S={'statusline','" "'}
}) do
  v=type(v)=='table' and v or {v,1,0}
  vim.keymap.set('n','yo'..k,('<cmd>let &%s%s=&%s==%s?%s:%s|redraw|echo "%s=".&%s\r')
    :format(k=='d' and 'l:' or '',v[1],v[1],v[2],v[3] or '""',v[2],v[1],v[1]))
end

vim.api.nvim_del_keymap('n','gcc')
vim.keymap.set('n','gc',function () return require('vim._comment').operator()..'_' end,{expr=true})
vim.keymap.set('x','gc',function () return require('vim._comment').operator()..'gv' end,{expr=true})

vim.keymap.set('n','gd',function () return (vim.o.tagfunc~='' or #vim.fn.tagfiles()>0) and '<C-]>' or 'gd' end,{expr=true})

vim.keymap.set('n','<A-a>','G:keepjumps norm! Vgg\r')

vim.keymap.set('n','<A-y>',':let @+=@"\r')
vim.keymap.set({'n','x'},'<A-u>','<cmd>let @"=@+\r')

vim.keymap.set('n','<A-j>',':move +1\r')
vim.keymap.set('n','<A-k>',':move -2\r')

vim.keymap.set('n','<M-x>',':lua=') vim.keymap.set('n','<M-S-.>',':lua=')

vim.keymap.set('n','U',':later 1f\r')

vim.keymap.set('n','<F6>',':source\r')

vim.keymap.set('n','<F7>',':echo v:errmsg\r')

vim.keymap.set('n',',','<C-o>')
vim.keymap.set('n',';','<C-i>')

vim.keymap.set({'n','x'},'.',':')

vim.keymap.set('n','\r','&buftype=="quickfix"?"\r":"dd"',{expr=true})
vim.keymap.set('x','\r','d',{})

vim.keymap.set('n','g:','q:')
vim.keymap.set('n','g/','q/')

vim.keymap.set('n','<C-.>','.',{noremap=true}) vim.keymap.set('n','<A-.>','.',{noremap=true})

vim.keymap.set('n','<tab>','a<C-T><esc>') vim.keymap.set('n','<A-l>','a<C-T><esc>')
vim.keymap.set('n','<S-tab>','a<C-D><esc>') vim.keymap.set('n','<A-h>','a<C-D><esc>')

vim.keymap.set({'n','x'},'j','v:count==0?"gj":"j"',{expr=true})
vim.keymap.set({'x','n'},'k','v:count==0?"gk":"k"',{expr=true})

vim.keymap.set('x','<','<gv') vim.keymap.set('x','<S-tab>','<gv') vim.keymap.set('x','<A-h>','<gv')
vim.keymap.set('x','>','>gv') vim.keymap.set('x','<tab>','>gv') vim.keymap.set('x','<A-l>','>gv')

vim.keymap.set('x','A',[[mode()=="\x16"?"A":"<esc>:au InsertLeave * ++once :'<+1,'>norm! $\".p\r'<A"]],{expr=true})
vim.keymap.set('x','I',[[mode()=="\x16"?"I":"<esc>:au InsertLeave * ++once :'<+1,'>norm! _\".P\r'<I"]],{expr=true})

vim.keymap.set('x','y','ygv<esc>')

vim.keymap.set('n','gV','"`[".strpart(getregtype(),0,1)."`]"',{expr=true,replace_keycodes=false})

vim.keymap.set('x','p','P')
vim.keymap.set('x','P','p')

vim.keymap.set('n',' ln',':lua vim.diagnostic.jump({count=1,_highest=true})\r')
vim.keymap.set('n',' lp',':lua vim.diagnostic.jump({count=-1,_highest=true})\r')
vim.keymap.set('n',' <tab>',':tab split\r')
vim.keymap.set('n',' W','w! /tmp/sw|exe "-tab te cat /tmp/sw|sudo tee > /dev/null %:p"|star')
vim.keymap.set('n',' C',':call setreg("+","<C-r>=expand("%:p")\r")\r',{noremap=true})
vim.keymap.set('n',' y',':lua require"small.nterm".run("EDITOR=nv yazi -- "..vim.fn.expand"%:p")\r')
vim.keymap.set('n',' i',':e %:p:h\r')
vim.keymap.set('n',' r',function () pcall(vim.cmd.lcd,vim.fn.expand'%:p:h') require'dff'.file_expl() end)
vim.keymap.set('n',' e',function ()
  vim.api.nvim_open_win(0,true,{relative='editor',width=vim.o.columns,height=vim.o.lines,row=0,col=0})
  require'small.nterm'.run(('helix %s:%d:%d'):format(vim.fn.expand'%:p',vim.fn.line'.',vim.fn.col'.'))
end)

require'snacks'.setup{
  picker={layout={preview = 'main',hidden={'preview'},layout={
    box='vertical',row=-1,col=-1,width=0.5,height=0.4,
    border=true,{win='input',height=1},{win='list'},{win='preview'}}},
    win={input={keys={['<Esc>']={'close',mode={'n','i'}},['<C-c>']='cancel'}}}}}
for k,v in pairs{f='files',s='grep',h='help',b='buffers',a='pickers'} do
  vim.keymap.set('n',' '..k,'<cmd>lua Snacks.picker.'..v..'()\r')
end
vim.keymap.set('n',' o','<cmd>lua Snacks.picker.pick{finder="recent_files",format="file"}\r')
vim.api.nvim_set_hl(0,'SnacksPickerDir',{link='NormalFloat'})

vim.keymap.set('n',' t',':nohls\r')
vim.keymap.set('n',' le',':set spelllang=en\r',{noremap=true})
vim.keymap.set('n',' ls',':set spelllang=sv\r',{noremap=true})
vim.keymap.set('n',' cr',function () require'small.reminder2'.sidebar() end)
vim.keymap.set('n'," '",':lua require"small.nterm".run("fish",true)\r')
vim.keymap.set('n',' ','<C-w>')

vim.keymap.set('n','vn',function () require'small.treeselect'.current() end)
vim.keymap.set('n','vr',function () require'small.treeselect'.base() end)
vim.keymap.set('x','<C-h>',function () require'small.treeselect'.prev() end)
vim.keymap.set('x','<C-l>',function () require'small.treeselect'.next() end)
vim.keymap.set('x','<C-k>',function () require'small.treeselect'.up() end)
vim.keymap.set('x','<C-j>',function () require'small.treeselect'.down() end)

vim.keymap.set('n','cx',function () require'small.exchange'.ex_oper() end)
vim.keymap.set('n','cX',function () require'small.exchange'.ex_eol() end)
vim.keymap.set('n','cxx',function () require'small.exchange'.ex_line() end)
vim.keymap.set('n','cxc',function () require'small.exchange'.ex_cancel() end)
vim.keymap.set('x','X',function () require'small.exchange'.ex_visual() end)

vim.keymap.set('n','t',function () require'small.fastmultif'.ffind() end)
vim.keymap.set('n','T',function () require'small.fastmultif'.rffind() end)

vim.keymap.set({'x','o'},'im',function () return require'small.textobj'.samecolumn() end,{expr=true})
vim.keymap.set({'x','o'},'ik',function () return require'small.textobj'.samerow() end,{expr=true})

vim.keymap.set('i',':',function () return require'small.whint'.run() end,{expr=true})

vim.keymap.set('n','<C-a>',function () require'small.incdec'.inc(vim.v.count) end)
vim.keymap.set('n','<C-x>',function () require'small.incdec'.dec(vim.v.count) end)

require'small.copyring'.setup()

require'mini.surround'.setup{
  mappings={
    add='S',
    delete='ds',
    find='',
    find_left='',
    highlight='',
    replace='cs',
    update_n_lines='',
  }
}
require'mini.ai'.setup{}

require'blink.pairs'.setup{}

vim.api.nvim_create_autocmd('OptionSet',{callback=function () vim.o.foldmethod=vim.v.option_new==true and 'diff' or 'manual' end,pattern='diff'})

vim.api.nvim_create_autocmd('BufRead',{callback=function() pcall(vim.cmd --[[@as function]],[[noautocmd norm! g`"]]) end})

vim.api.nvim_create_autocmd({'InsertLeave','TextChanged'},{callback=function (ev)
  if ev.file=='' or not vim.o.modified or vim.o.readonly or vim.o.buftype~='' then return end
  vim.cmd.update{'++p',bang=true,mods={emsg_silent=true,lockmarks=true}}
end,group=vim.api.nvim_create_augroup('AutoSave',{})})

vim.api.nvim_create_autocmd('BufReadPre',{callback=function (ev)
  if vim.o.buftype~='' then return end
  vim.schedule_wrap(pcall)(vim.cmd.lcd,{vim.fs.root(ev.file,'.git') or vim.fs.dirname(ev.file),mods={silent=true}})
end,group=vim.api.nvim_create_augroup('AutoCd',{})})

vim.api.nvim_create_autocmd('VimEnter',{callback=function ()
  if vim.api.nvim_buf_line_count(0)>1 or
    vim.api.nvim_buf_get_lines(0,0,-1,false)[1]~='' or
    vim.api.nvim_buf_get_name(0)~='' then return end
  vim.bo.buftype='nowrite'
end,once=true})

function vim.lg(...)
  if vim.in_fast_event() then return vim.schedule_wrap(vim.lg)(...) end
  return vim.fn.writefile(vim.fn.split(vim.inspect(#{...}>1 and {...} or ...),'\n'),'/tmp/nlog','a')
end

vim.fn.timer_start(100,function() vim.fn.execute('silent! checktime') end,{['repeat']=-1})

require'small.macro2'.setup()
vim.keymap.set('n','cq',require'small.macro2'.edit)

vim.api.nvim_create_autocmd('VimLeave',{callback=function() io.stdout:write("\027]111;;\027\\") end})
local function sync_background() io.stdout:write(("\027]11;#%06x\027\\"):format(vim.api.nvim_get_hl(0,{name='Normal'}).bg or 0)) end
vim.api.nvim_create_autocmd('ColorScheme',{callback=vim.schedule_wrap(sync_background)})
vim.api.nvim_create_autocmd('OptionSet',{pattern='background',callback=vim.schedule_wrap(sync_background)})
sync_background()

vim.cmd.hi'clear StatusLine'
vim.cmd.hi'clear StatusLineNC'

-- vim: ts=2 sw=2 conceallevel=2 wrap :

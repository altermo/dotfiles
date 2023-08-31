import os
import json
import re
from libqtile import bar,widget,hook
from libqtile.layout import xmonad,columns
from libqtile.config import Key,Screen,Group,KeyChord
from libqtile.lazy import lazy

HOME=os.getenv('HOME')
DEFAULTIMG=f'{HOME}/.config/qtile/backgrounds/gnome/Icetwigs.jpg'
NITYOPATH=f'{HOME}/.config/nitrogen/bg-saved.cfg'
VAULTPATH=f'{HOME}/.gtd/vault'
mod='mod4'
settings_file=f'{HOME}/.config/qtile/settings.json'
neovimgui='neovide -- '
term1=f'{neovimgui} -c Shell'
term2="alacritty"
term3="xterm -fs 10 -fa monospace -bg black -fg white "
browser1='firefox'
browser2='qutebrowser'
browser3='torbrowser-launcher'
fm1=f'{neovimgui} -c Ranger'
fm2='pcmanfm'
themesetting='lxappearance'
#themesetting='gtk-chtheme'
#themesetting='qt5ct'
topgui='gnome-system-monitor'

websites={
    #git
    'github'                   :'https://github.com',
    'gitmoji'                  :'https://gitmoji.dev',
    'Git-packer'               :'https://github.com/wbthomason/packer.nvim',
    'Git-lazy'                 :'https://github.com/folke/lazy.nvim',
    'Git-neovim'               :'https://github.com/neovim/neovim',
    'Git-treesitter'           :'https://github.com/nvim-treesitter/nvim-treesitter',
    'Git-neorg'                :'https://github.com/nvim-neorg/neorg',
    'Git-emacs'                :'https://github.com/emacs-mirror/emacs',
    'Git-spacevim'             :'https://github.com/SpaceVim/SpaceVim',
    'Git-spacemacs'            :'https://github.com/syl20bnr/spacemacs',
    'Git-doomemacs'            :'https://github.com/doomemacs/doomemacs',
    'Git-pynvim'               :'https://github.com/neovim/pynvim',
    'Git-zig'                  :'https://github.com/ziglang/zig',
    #python
    'python'                   :'https://docs.python.org/3/library/',
    'python-regex'             :'https://docs.python.org/3/library/re.html#regular-expression-syntax',
    'python-reference'         :'https://docs.python.org/3/reference/',
    'python-unittest'          :'https://docs.python.org/3.12/library/unittest.html',
    #google
    'mail'                     :'https://mail.google.com/mail/u/0/h/',
    'maps'                     :'https://www.google.com/maps',
    'gtranslate'               :'https://translate.google.com',
    'google'                   :'https://google.com',
    'classroom'                :'https://classroom.google.com',
    'drive'                    :'https://drive.google.com',
    #other prgm lang
    'fish'                     :'https://fishshell.com/docs/current/commands.html',
    'ANSI'                     :'https://invisible-island.net/xterm/ctlseqs/ctlseqs.html',
    'CSI'                      :'https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_(Control_Sequence_Introducer)_sequences',
    'lua'                      :'https://www.lua.org/manual/5.1',
    'fennel-website'           :'https://fennel-lang.org/',
    'esolang'                  :'https://esolangs.org/wiki/Main_Page',
    'compiler-explorer'        :'https://godbolt.org/',
    'cpp-reference'            :'https://cplusplus.com/reference',
    'cpp'                      :'https://cplusplus.com/',
    'c-stdlib'                 :'https://www.ibm.com/docs/en/i/7.1?topic=extensions-standard-c-library-functions-table-by-name',
    'unicode-table'            :'https://en.wikibooks.org/wiki/Unicode/Character_reference',
    'box-chars'                :'https://en.wikipedia.org/wiki/Box-drawing_character',
    'turbowarp'                :'https://turbowarp.org',
    'turbowarp-doc'            :'https://docs.turbowarp.org',
    'turbowarp-extensions'     :'https://extensions.turbowarp.org',
    'http-codes'               :'https://developer.mozilla.org/en-US/docs/Web/HTTP/Status',
    'autohotkey'               :'https://www.autohotkey.com/docs/AutoHotkey.htm',
    'zig-doc'                  :'https://ziglang.org/documentation/master/',
    'zig'                      :'https://ziglang.org',
    'markdown-basic'           :'https://www.markdownguide.org/basic-syntax/',
    'nim'                      :'https://nim-lang.org/',
    'c-keyword'                :'https://en.cppreference.com/w/c/keyword',
    'this-week-in-neovim'      :'https://dotfyle.com/this-week-in-neovim',
    'lua-ls-annotations'       :'https://github.com/LuaLS/lua-language-server/wiki/Annotations',
    #other
    'schedule'                 :'https://karlskrona.skola24.se/',
    'ted'                      :'https://www.ted.com',
    'mega'                     :'https://mega.nz',
    'wikiperdia'               :'https://en.wikipedia.org',
    'wikiperdia-sv'            :'https://sv.wikipedia.org',
    'translate'                :'https://www.deepl.com/translator',
    'SV-wikt'                  :'https://sv.wiktionary.org',
    'ES-wikt'                  :'https://es.wiktionary.org',
    'EN-wikt'                  :'https://en.wiktionary.org',
    'qtile'                    :'https://docs.qtile.org/en/stable/index.html',
    'periodic-table'           :'https://ptable.com',
    'browser-timeline'         :'https://upload.wikimedia.org/wikipedia/commons/7/74/Timeline_of_web_browsers.svg',
    'keybr'                    :'https://www.keybr.com',
    'speedtype'                :'https://www.speedtyper.dev',
    'chatgpt'                  :'https://chat.openai.com/chat',
    'chatgpt-prompts'          :'https://github.com/f/awesome-chatgpt-prompts',
    'neovim'                   :'https://neovim.io/',
    'proton'                   :'https://mail.proton.me/',
    'semver'                   :'https://semver.org/',
    'wikiperdia-ipa'           :'https://en.wikipedia.org/wiki/Help:IPA?useskin=vector',
    'carbon'                   :'https://carbon.now.sh/',
    'seterra'                  :'https://www.geoguessr.com/seterra/',
    'neovim-reddit'            :'https://www.reddit.com/r/neovim/',
    'neovim-discourse'         :'https://neovim.discourse.group/',
    'waybackmachine'           :'https://web.archive.org/',
    'x86'                      :'https://copy.sh/v86/',
    'browser-emulator'         :'https://www.dejavu.org/1992win.htm',
    'convcommit'               :'https://www.conventionalcommits.org/en/v1.0.0/',
    'youtube-to'               :'https://studio.youtube.com/playlist/PL4O0QLldDCNTWh1Z9l2LE-Iq0QjOBz1At/videos',
    'wolframalpha'             :'https://www.wolframalpha.com/',
    'obsidian'                 :'https://help.obsidian.md/',
    'skype'                    :'https://web.skype.com/',
    'vscode'                   :'https://vscode.dev/',
    #emacs / vim
    'emacs'                    :'https://www.gnu.org/software/emacs',
    'spacemacs'                :'https://develop.spacemacs.org/doc/DOCUMENTATION.html',
    'spacevim'                 :'https://spacevim.org',
    'melp'                     :'https://melpa.org/',
    #lxiym
    'lxiym-c#'                 :'https://learnxinyminutes.com/docs/csharp',
    'lxiym-c'                  :'https://learnxinyminutes.com/docs/c',
    'lxiym-c++'                :'https://learnxinyminutes.com/docs/c++',
    'lxiym-clojure'            :'https://learnxinyminutes.com/docs/clojure',
    'lxiym-clojure-macros'     :'https://learnxinyminutes.com/docs/clojure-macros',
    'lxiym-common-lisp'        :'https://learnxinyminutes.com/docs/common-lisp',
    'lxiym-css'                :'https://learnxinyminutes.com/docs/css',
    'lxiym-elisp'              :'https://learnxinyminutes.com/docs/elisp/',
    'lxiym-emacs'              :'https://learnxinyminutes.com/docs/emacs',
    'lxiym-git'                :'https://learnxinyminutes.com/docs/git',
    'lxiym-haskell'            :'https://learnxinyminutes.com/docs/haskell',
    'lxiym-java'               :'https://learnxinyminutes.com/docs/java',
    'lxiym-javascript'         :'https://learnxinyminutes.com/docs/javascript',
    'lxiym-latex'              :'https://learnxinyminutes.com/docs/latex',
    'lxiym-lua'                :'https://learnxinyminutes.com/docs/lua',
    'lxiym-python'             :'https://learnxinyminutes.com/docs/python',
    'lxiym-rust'               :'https://learnxinyminutes.com/docs/rust',
    'lxiym-zig'                :'https://learnxinyminutes.com/docs/zig/',
    'lxiym-sql'                :'https://learnxinyminutes.com/docs/sql',
    #linux distro
    'AUR'                      :'https://aur.archlinux.org/',
    'archlinux'                :'https://archlinux.org/',
    'distro-timeline'          :'https://upload.wikimedia.org/wikipedia/commons/b/b5/Linux_Distribution_Timeline_21_10_2021.svg',
    'archwiki'                 :'https://wiki.archlinux.org/',
    'kail'                     :'https://www.kali.org/',
    'nix'                      :'https://nixos.org/',
}

def ctest(*paths:str)->str:
    for i in paths:
        if os.path.isfile(i):
            return i
    return paths[-1]
configs={
    'qtile'      :f'{HOME}/.config/qtile/config.py',
    'fish'       :f'{HOME}/.config/fish/config.fish',
    'nu'         :f'{HOME}/.config/nushell/init.nu',
    'nvim'       :ctest(f'{HOME}/.config/nvim/init.lua',f'{HOME}/.config/nvim/init.vim'),
    'vim'        :ctest(f'{HOME}/.vim/vimrc',f'{HOME}/.vimrc'),
    'emacs'      :ctest(f'{HOME}/.config/emacs/config.org',f'{HOME}/.config/emacs/init.el',f'{HOME}/.emacs.d/init.el',f'{HOME}/.emacs.el'),
    'qutebrowser':f'{HOME}/.config/qutebrowser/config.py',
    'zsh'        :f'{HOME}/.zshrc',
    'bash'       :f'{HOME}/.bashrc',
    'firefox'    :f'{HOME}/.config/firefox/userChrome.css',
    'doom'       :ctest(f'{HOME}/.doom.d/conf.org',f'{HOME}/.doom.d/config.el'),
    'gitignore'  :f'{HOME}/.config/git/.gitignore',
    'alacritty'  :f'{HOME}/.config/alacritty/alacritty.yml',
}
projects={
    'ua':f'{HOME}/.config/nvim/.other/ua',
    'nvwm':f'{HOME}/.config/nvim/.other/nvwm',
}

try:
    with open(settings_file) as f:
        settings=json.load(f)
except (FileNotFoundError,json.decoder.JSONDecodeError):
    settings={}
if os.path.exists(NITYOPATH):
    with open(NITYOPATH) as f:
        images=re.findall('file=(.*)',f.read())
        image=(images[0] if len(images) else DEFAULTIMG)
else:image=DEFAULTIMG
if os.path.exists(image):
    if image in settings.get('cache',{}).get('img',{}):
        image_colors=[tuple(i) for i in settings['cache']['img'][image]]
    else:
        try:
            from colorthief import ColorThief
        except ImportError:image_colors=[(0,0,0)]*4
        else:
            image_colors=ColorThief(image).get_palette(3,quality=1000)
            with open(settings_file,'w') as f:
                settings.setdefault('cache',{}).setdefault('img',{})[image]=image_colors
                json.dump(settings,f)
else:image_colors=[(0,0,0)]*4

def menu_list_and_run(_,apps:dict['str','str'],bin:str)->None:
    result=os.popen('printf "'+'\n'.join(apps)+'"|dmenu -i').read()
    if result:os.system(bin%apps[result.removesuffix('\n')])
def smart_kill(q):
    blacklist=[['Navigator','firefox'],['skype','Skype'],['obsidian','obsidian']]
    wm_class=q.current_window.get_wm_class()
    if wm_class not in blacklist:
        q.current_window.kill()
        return
    num_ins_open=0
    for i in q.cmd_windows():
        if wm_class==i['wm_class']:
            num_ins_open+=1
    if num_ins_open>1:
        q.current_window.kill()
        return
    os.system('zenity --text="no" --info &')
SCALE=1.3
def scalescreen(_,scale:int):
    global SCALE
    SCALE+=scale
    SCALE=round(SCALE*10)/10
    os.system(f'xrandr --output LVDS-1 --scale {SCALE}x{SCALE}')
def show_bar_when_switch(_): # TODO
    ...

keys=[
    #hjkl
    Key([mod],'h',lazy.layout.left()),
    Key([mod],'l',lazy.layout.right()),
    Key([mod],'j',lazy.layout.down()),
    Key([mod],'k',lazy.layout.up()),
    Key([mod,'shift'],'h',lazy.layout.shuffle_left()),
    Key([mod,'shift'],'l',lazy.layout.shuffle_right()),
    Key([mod,'shift'],'j',lazy.layout.shuffle_down()),
    Key([mod,'shift'],'k',lazy.layout.shuffle_up()),
    Key([mod,'control'],'h',lazy.layout.grow_left()),
    Key([mod,'control'],'l',lazy.layout.grow_right()),
    Key([mod,'control'],'j',lazy.layout.grow_down()),
    Key([mod,'control'],'k',lazy.layout.grow_up()),
    #window
    Key([mod],'Tab',lazy.group.next_window()),
    Key([mod,'shift'],'Tab',lazy.group.prev_window()),
    Key([mod],'bar',lazy.next_layout()),
    Key([mod,'shift'],'bar',lazy.prev_layout()),
    Key([mod],'w',lazy.function(smart_kill)),
    Key([mod,'shift'],'w',lazy.spawn('sh -c \'xkill -id $(xdotool getactivewindow|xargs printf 0x%x"\n")\'')),
    Key([mod],'f',lazy.window.toggle_floating()),
    #qtile
    Key([mod,'control'],'r',lazy.reload_config()),
    Key(['control','mod1'],'delete',lazy.restart()),
    Key([mod,'control'],'q',lazy.shutdown()),
    #spawn
    Key([mod],'b',lazy.spawn(browser1)),
    Key([mod,'control'],'b',lazy.spawn(f'{browser1} --private-window')),
    Key([mod],'i',lazy.spawn(browser2)),
    Key([mod,'shift'],'i',lazy.spawn(browser3)),
    Key([mod,'control'],'i',lazy.spawn('microsoft-edge-stable')),
    Key([mod],'Return',lazy.spawn(term1)),
    Key([mod,'shift'],'Return',lazy.spawn(term2)),
    Key([mod],'KP_Enter',lazy.spawn(term3)),
    Key([mod],'s',lazy.spawn(themesetting)),
    Key([mod,'shift'],'t',lazy.spawn(topgui)),
    Key([mod],'n',lazy.spawn(fm1)),
    Key([mod,'shift'],'n',lazy.spawn(fm2)),
    Key([mod],'e',lazy.spawn("emacsclient -c -a 'emacs'")),
    Key([mod],'v',lazy.spawn('obsidian')),
    Key([mod,],'o',lazy.spawn(f'{fm1} {VAULTPATH}')),
    Key([mod,'control'],'v',lazy.spawn('pavucontrol')),
    #menu
    Key([mod],'x',lazy.spawn('rofi -show drun')),
    Key([mod,'shift'],'x',lazy.spawn('nwggrid -o 0.5')),
    Key([mod],'d',lazy.spawn('dmenu_run')),
    Key([mod],'y',lazy.spawn('clipmenu')),
    Key([mod,'shift'],'b',lazy.function(menu_list_and_run,websites,'fish -c \'setsid $BROWSER "%s"&\'')),
    Key([mod,'shift'],'e',lazy.function(menu_list_and_run,configs,f'{neovimgui} %s')),
    Key([mod,'shift','control'],'i',lazy.function(menu_list_and_run,{i:i for i in ('firefox','qutebrowser')},'fish -c "set -U BROWSER %s"')),
    #XF86
    Key([],"XF86MonBrightnessUp",lazy.spawn("brightnessctl set +10%")),
    Key([],"XF86MonBrightnessDown",lazy.spawn("brightnessctl set 10%-")),
    Key([],"XF86AudioRaiseVolume",lazy.spawn("amixer sset Master 1%+")),
    Key(['shift'],"XF86AudioRaiseVolume",lazy.spawn("amixer sset Master 10%+")),
    Key([],"XF86AudioLowerVolume",lazy.spawn("amixer sset Master 1%-")),
    Key(['shift'],"XF86AudioLowerVolume",lazy.spawn("amixer sset Master 10%-")),
    Key([],"XF86AudioMute",lazy.spawn("amixer sset Master toggle")),
    #neovim
    # Key([mod],'m',lazy.spawn(f'sh -c "cp ~/.bashrc /tmp/lua/temp.bash;{neovimgui} /tmp/temp.bash"')),
    Key([mod],'m',lazy.spawn(f"fish -c '{neovimgui} $TEMPFILE'")),
    Key([mod,'shift'],'m',lazy.function(menu_list_and_run,{i:i for i in ('lua','md','txt','py','fish')},'fish -c "set -U TEMPFILE /tmp/lua/temp.%s"')),
    Key([mod],'a',lazy.spawn(neovimgui)),
    Key([mod],'t',lazy.spawn(f'{neovimgui} -c \':lua vim.system({{"fish","-i","-c","ntmp;nvr $tmp"}})\'')),
    Key([mod],'c',lazy.spawn(f'{neovimgui} -c "edit .bashrc" -c "au VimEnter * CodiNew python"')), #hack
    Key([mod],'z',lazy.spawn(f'{neovimgui} -c "cd {HOME}/.config/nvim|Dff"')),
    Key([mod,'shift'],'o',lazy.spawn(f'{neovimgui} -c "cd {HOME}/.qscript/scripts|Ranger"')),
    Key([mod,'shift'],'p',lazy.function(menu_list_and_run,projects,f'{neovimgui} -c "Dff %s"')),
    #shell
    Key([mod],'p',lazy.spawn(f'{neovimgui} -c "Shell -c ipython" -c "call feedkeys(\'import os,sys,string,json,math,time,functools,itertools\rfrom __future__ import barry_as_FLUFL\rsys.path.append(\\"{HOME}/.env/lib/python3.11/site-packages\\")\r\')"')),
    #other
    Key([mod,'control','shift'],'b',lazy.spawn(f'sh -c "{browser1} bing.com/search?q=${{RANDOM:0:10000}}"')),
    Key([mod,'shift'],'c',lazy.spawn('sh -c "nitrogen;qtile cmd-obj -o cmd -f reload_config"')),
    Key([mod,'control'],'c',lazy.spawn('sh -c "zenity --question --text \'Are you sure you want to clear cache?\'&&cat %s |jq -c \'.\\"cache\\".\\"img\\"={}\'>/tmp/TmP&&mv /tmp/TmP %s"'.replace('%s',settings_file))),
    Key([mod,'shift'],'g',lazy.spawn('qutebrowser https://chat.openai.com/chat --target=window')),
    Key([mod],'backslash',lazy.spawn('zenity --text="help not configured yet..." --info')),
    Key([mod,'control'],'z',lazy.spawn('betterlockscreen -l')),
    #window2
    KeyChord([mod],'q',[
        Key([],'e',lazy.spawn('sh -c "setxkbmap -option;setxkbmap -option ctrl:swapcaps"')),
        Key([],'v',lazy.spawn('sh -c "setxkbmap -option;setxkbmap -option caps:swapescape"')),
        Key([],'k',lazy.spawn('setxkbmap -option')),
        Key([],'n',lazy.spawn('setxkbmap no')),
        Key([],'s',lazy.spawn('setxkbmap se')),
        Key([],'u',lazy.spawn('setxkbmap us')),
    ]),
    KeyChord([mod],'g',[
        Key([],'i',lazy.function(lambda q:os.system('zenity --text="'+str(q.current_window.info()).replace('"',"'")+'" --info&'))),
        Key([],'b',lazy.hide_show_bar()),
        Key([],'t',lazy.function(lambda q:q.current_window.cmd_down_opacity())),
        Key(['shift'],'t',lazy.function(lambda q:q.current_window.cmd_up_opacity())),
        Key([],'f11',lazy.window.toggle_fullscreen()),
        Key([],'h',lazy.function(lambda q:q.current_window.hide() if q.current_window.cmd_is_visible() else q.current_window.unhide())),
        Key([],'m',lazy.function(lambda q:q.current_window.cmd_toggle_minimize())),
        Key(['shift'],'m',lazy.function(lambda q:q.current_window.cmd_toggle_maximize())),
        Key([],'f',lazy.function(lambda q:q.current_window.cmd_bring_to_front())),
        Key(['control'],'f',lazy.function(lambda q:q.current_window.cmd_static())),
        Key([],'r',lazy.spawn('redshift -O 4000')),
        Key(['shift'],'r',lazy.spawn('sh -c "redshift -P -O 4000"')),
        Key([],'s',lazy.function(scalescreen,.1)),
        Key(['shift'],'s',lazy.function(scalescreen,-.1)),
        Key(['control'],'s',lazy.function(lambda _:os.system(f'zenity --text="{SCALE}" --info&'))),
        Key([],'c',lazy.spawn('scrot')),
        Key(['shift'],'c',lazy.function(lambda q:q.current_window.cmd_center())),
        Key([],'k',lazy.spawn('gkbd-keyboard-display -g 1')),
        Key([],'y',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0')),
        Key(['shift'],'y',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5')),
        Key(['control'],'y',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" -0.5')),
        Key([],'7',lazy.spawn('sh -c "echo $(xsel -ob) >> .config/nvim/.other/vim-plugin-list/raw "')),
        Key([],'F8',lazy.spawn('sh -c "test $(pidof xdotool)&&killall xdotool||xdotool click --delay 5 --repeat 900000 1"')),
        Key([],'F9',lazy.spawn('sh -c "test $(pidof xdotool)&&killall xdotool||xdotool click --delay 5 --repeat 900000 3"')),
    ])
]
groups=[Group(i) for i in "1234567890u"]
for i in (i.name for i in groups):
    keys.extend([
        Key([mod],i,lazy.group[i].toscreen()),
        Key([mod,"shift"],i,lazy.window.togroup(i,switch_group=1)),
    ])

layouts=[
    xmonad.MonadTall(single_border_width=0,border_focus='#ff0000'),
    xmonad.MonadTall(single_border_width=0,ratio=0.6,border_focus='#0000ff'),
    xmonad.MonadTall(single_border_width=0,ratio=0.8,border_focus='#00ff00'),
    columns.Columns(border_on_single=1,border_focus='#ffffff'),
]
screens=[Screen(
    #wallpaper=image,        #slow
    #wallpaper_mode='fill',  #slow
    bottom=bar.Bar([
        widget.GroupBox(disable_drag=1,hide_unused=1,highlight_method='line',highlight_color=[image_colors[0],image_colors[1]],
                        visible_groups=[i.name for i in groups if i.name in '0123456789']),
        widget.WindowTabs(),
        widget.Systray(), #dont remove...
        widget.TextBox(text='',fontsize=80,padding=-10,foreground=image_colors[2]),
        widget.Battery(format='{char} {percent:2.0%}',background=image_colors[2]),
        widget.TextBox(text='',fontsize=80,padding=-10,background=image_colors[2],foreground=image_colors[3]),
        widget.Clock(format="%Y/%m/%d;%V   %H:%M:%S",background=image_colors[3]),
    ],
                   size=24, background=image_colors[0], opacity=0.8,
                   ),)]
os.system('setxkbmap -option caps:swapescape &')
os.system('nitrogen --restore &') #fast

@hook.subscribe.startup_once
def autostart()->None:
    os.system(f'xrandr --output LVDS-1 --scale {SCALE}x{SCALE}')
    os.system('nitrogen --restore &') #fast
    os.system('setxkbmap -option caps:swapescape&')
    os.system('redshift -P -O 4000&')
    os.system('picom &')
    os.system('clipmenud &')
    # os.system('sudo modprobe v4l2loopback')
    os.system('xset s off -dpms')
    os.system('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5')
    os.system('sh -c "emacs --daemon"&')
    os.system('blanket -h&')
# vim:fen:

import os
import json
import re

from websites import websites
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
neovimgui='nvim-qt -- '
term1=f'{neovimgui} -c Shell'
term2="alacritty"
browser1='firefox'
browser2='qutebrowser'
browser3='torbrowser-launcher'
fm1=f'{neovimgui} -c Ranger'
fm2='pcmanfm'
themesetting='lxappearance'
topgui='gnome-system-monitor'

def ctest(*paths:str)->str:
    for i in paths:
        if os.path.isfile(i):return i
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
    'pack':f'{HOME}/.qscript/scripts/packs'
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
image_colors='#00000000',*image_colors[1:]

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
    Key([mod],'plus',lazy.layout.grow()),
    Key([mod],'minus',lazy.layout.shrink()),
    Key([mod,'shift'],'plus',lazy.layout.reset()),
    Key([mod,'shift'],'minus',lazy.layout.flip()),
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
    Key([mod],'Return',lazy.spawn(term1)),
    Key([mod,'shift'],'Return',lazy.spawn(term2)),
    Key([mod,'shift'],'o',lazy.spawn(topgui)),
    Key([mod],'n',lazy.spawn(fm1)),
    Key([mod],'e',lazy.spawn("emacsclient -c -a 'emacs'")),
    Key([mod],'v',lazy.spawn('obsidian')),
    Key([mod,'shift'],'v',lazy.spawn(f'{fm1} {VAULTPATH}')),
    #menu
    Key([mod],'x',lazy.spawn('ulauncher-toggle')),
    Key([mod,'shift'],'x',lazy.spawn('nwggrid -o 0.5')),
    Key([mod],'d',lazy.spawn('dmenu_run')),
    Key([mod],'y',lazy.spawn('clipmenu')),
    Key([mod],'i',lazy.function(menu_list_and_run,websites,'fish -c \'setsid $BROWSER "%s"&\'')),
    Key([mod],'c',lazy.function(menu_list_and_run,configs,f'{neovimgui} %s')),
    #XF86
    Key([],"XF86MonBrightnessUp",lazy.spawn("brightnessctl set +10%")),
    Key([],"XF86MonBrightnessDown",lazy.spawn("brightnessctl set 10%-")),
    Key([],"XF86AudioRaiseVolume",lazy.spawn("amixer sset Master 1%+")),
    Key(['shift'],"XF86AudioRaiseVolume",lazy.spawn("amixer sset Master 10%+")),
    Key([],"XF86AudioLowerVolume",lazy.spawn("amixer sset Master 1%-")),
    Key(['shift'],"XF86AudioLowerVolume",lazy.spawn("amixer sset Master 10%-")),
    Key([],"XF86AudioMute",lazy.spawn("amixer sset Master toggle")),
    #neovim
    Key([mod],'t',lazy.spawn(f"fish -c '{neovimgui} $TEMPFILE'")),
    Key([mod,'shift'],'t',lazy.function(menu_list_and_run,{i:i for i in ('lua','md','txt','py','fish','html')},'fish -c "set -U TEMPFILE /tmp/lua/temp.%s"')),
    Key([mod,'control'],'t',lazy.spawn(f'{neovimgui} -c \':lua vim.system({{"fish","-i","-c","ntmp;nvr $tmp"}})\'')),
    Key([mod],'a',lazy.spawn(neovimgui)),
    #Key([mod,'shift'],'c',lazy.spawn(f'{neovimgui} -c "edit .bashrc" -c "au VimEnter * CodiNew python"')), #TODO
    Key([mod],'z',lazy.spawn(f'{neovimgui} -c "cd {HOME}/.config/nvim|Dff"')),
    Key([mod],'o',lazy.function(menu_list_and_run,projects,f'{neovimgui} -c "Dff %s"')),
    #shell
    Key([mod],'p',lazy.spawn(f'{neovimgui} -c "Shell -c ipython" -c "call feedkeys(\'import os,sys,string,json,math,time,functools,itertools\rfrom __future__ import barry_as_FLUFL\rsys.path.append(\\"{HOME}/.venv/lib/python3.11/site-packages\\")\r\')"')),
    #other
    Key([mod,'shift'],'c',lazy.spawn('sh -c "nitrogen;qtile cmd-obj -o cmd -f reload_config"')),
    Key([mod,'control'],'c',lazy.spawn('sh -c "zenity --question --text \'Are you sure you want to clear cache?\'&&cat %s |jq -c \'.\\"cache\\".\\"img\\"={}\'>/tmp/TmP&&mv /tmp/TmP %s"'.replace('%s',settings_file))),
    Key([mod,'shift'],'g',lazy.spawn('qutebrowser https://chat.openai.com/chat --target=window')),
    Key([mod,'control'],'z',lazy.spawn('betterlockscreen -l')),
    Key([mod],'space',lazy.spawn('mpvc toggle')),
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
        Key([],'m',lazy.function(lambda q:q.current_window.cmd_toggle_minimize())),
        Key([],'f',lazy.function(lambda q:q.current_window.cmd_bring_to_front())),
        Key(['control'],'f',lazy.function(lambda q:q.current_window.cmd_static())),
        Key([],'s',lazy.function(scalescreen,.1)),
        Key(['shift'],'s',lazy.function(scalescreen,-.1)),
        Key(['control'],'s',lazy.function(lambda _:os.system(f'zenity --text="{SCALE}" --info&'))),
        Key([],'space',lazy.spawn('scrot')),
        Key([],'k',lazy.spawn('gkbd-keyboard-display -g 1')),
        Key([],'m',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5')),
        Key(['shift'],'m',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0')),
        Key(['control'],'m',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" -0.5')),
        Key([],'7',lazy.spawn('sh -c "echo $(xsel -ob) >> .config/nvim/.other/vim-plugin-list/raw "')),
        Key([],'c',lazy.spawn('sh -c "test $(pidof xbanish)&&killall xbanish||xbanish -a"')),
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
    xmonad.MonadTall(single_border_width=0,ratio=0.8,border_focus='#00ff00'),
    xmonad.MonadThreeCol(single_border_width=0,ratio=0.5,border_focus='#0000ff',main_centered=False),
    columns.Columns(border_on_single=1,border_focus='#ffffff'),
]
screens=[Screen(
    #wallpaper=image,        #slow
    #wallpaper_mode='fill',  #slow
    bottom=bar.Bar([
        widget.GroupBox(disable_drag=1,hide_unused=1,highlight_method='line',highlight_color=[*[image_colors[0]]*3,image_colors[1]],
                        this_current_screen_border='#00000000',use_mouse_wheel=False,borderwidth=1,inactive='#707070',
                        visible_groups=[i.name for i in groups if i.name in '0123456789']),
        widget.WindowTabs(),
        widget.Systray(), #dont remove...
        widget.TextBox(text='',fontsize=80,padding=-10,foreground=image_colors[2]),
        widget.Battery(format='{char} {percent:2.0%}',background=image_colors[2]),
        widget.TextBox(text='',fontsize=80,padding=-10,background=image_colors[2],foreground=image_colors[3]),
        widget.Clock(format="%Y/%m/%d;%V   %H:%M:%S",background=image_colors[3]),
    ],
                   size=20, background=image_colors[0], opacity=0.8,
                   ),)]
def autoset():
    os.system('setxkbmap -option caps:swapescape &')
    os.system('nitrogen --restore &')
    os.system('redshift -P -O 4000&')
    os.system('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5')
autoset()
@hook.subscribe.startup_once
def autostart()->None:
    os.system(f'xrandr --output LVDS-1 --scale {SCALE}x{SCALE}')
    os.system('picom &')
    os.system('clipmenud &')
    # os.system('modprobe v4l2loopback')
    os.system('xset s off -dpms') #disable screensaver
    os.system('sh -c "emacs --daemon"&')
    os.system('blanket -h&')
    os.system('ulauncher --no-window&') #https://github.com/Ulauncher/Ulauncher/milestone/7
    autoset()
# vim:fen:

# imports
import os
import subprocess
import json
import re
from libqtile import bar,widget,hook,qtile
from libqtile.layout import xmonad,columns
from libqtile.config import Key,Screen,Group,KeyChord,Match
from libqtile.lazy import lazy
#if qtile.core.name=='wayland':raise NotImplementedError('wayland configuration not implemented, fallback default')

# variables
HOME=os.getenv('HOME')
DEFAULTIMG=f'{HOME}/.config/qtile/backgrounds/gnome/Icetwigs.jpg'
NITYOPATH=f'{HOME}/.config/nitrogen/bg-saved.cfg'
VAULTPATH=f'{HOME}/.gtd/vault'
mod='mod4'
settings_file=f'{HOME}/.config/qtile/settings.json'
neovimgui='gnvim.sh'
term1=f'{neovimgui} -c Shell'
term2="kitty"
browser='firefox'
file_manager=f'{neovimgui} -c "lua require\'small.ranger\'.run()"'
topgui='gnome-system-monitor'
from websites import websites
def ctest(*paths:str)->str:
    return [*filter(os.path.isfile,paths),paths[-1]][0]
configs={
    'qtile'    :f'{HOME}/.config/qtile/config.py',
    'fish'     :f'{HOME}/.config/fish/config.fish',
    'nu'       :f'{HOME}/.config/nushell/config.nu',
    'nvim'     :ctest(f'{HOME}/.config/nvim/init.lua',f'{HOME}/.config/nvim/init.vim'),
    'vim'      :ctest(f'{HOME}/.vim/vimrc',f'{HOME}/.vimrc'),
    'emacs'    :ctest(f'{HOME}/.config/emacs/config.org',f'{HOME}/.config/emacs/init.el',f'{HOME}/.emacs.d/init.el',f'{HOME}/.emacs.el'),
    'zsh'      :f'{HOME}/.zshrc',
    'bash'     :f'{HOME}/.bashrc',
    'spacemacs':ctest(f'{HOME}/.spacemacs.d/init.el',f'{HOME}/.spacemacs'),
    'kitty'    :f'{HOME}/.config/kitty/kitty.conf',
    'ranger'   :f'{HOME}/.config/ranger/rc.conf',
    'hyprland' :f'{HOME}/.config/hypr/hyprland.conf',
}
projects={
    'ua':f'{HOME}/.config/nvim/.other/ua',
    'ua_':f'{HOME}/.config/nvim/.other/ua_',
    'pack':f'{HOME}/.qscript/scripts/packs',
    '.qscript':f'{HOME}/.qscript',
    'small':f'{HOME}/.config/nvim/.other/small.nvim',
    'nlim':f'{HOME}/.config/nvim/.other/_later/neolim/',
}

# color theme generator from image
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

# functions
def menu_list_and_run(_,apps:dict['str','str'],bin:str)->None:
    result=os.popen('printf "'+'\n'.join(apps)+'"|dmenu -i').read()
    if result:subprocess.Popen(bin%apps[result.removesuffix('\n')],shell=True)
def smart_kill(q):
    blacklist=[['Navigator','firefox'],['skype','Skype']]
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
    os.system('Xdialog --wmclass dialog --infobox "no" 0x0&')
SCALE=1.3
def scalescreen(_,scale:int):
    global SCALE
    SCALE+=scale
    SCALE=round(SCALE*10)/10
    os.system(f'xrandr --output LVDS-1 --scale {SCALE}x{SCALE}')
def setscale(_,scale:int):
    global SCALE
    SCALE=scale
    SCALE=round(SCALE*10)/10
    os.system(f'xrandr --output LVDS-1 --scale {SCALE}x{SCALE}')
def show_bar_when_switch(_): # TODO
    ...

# keys
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
    Key([mod,'shift'],'w',lazy.window.kill()),
    Key([mod,'control'],'w',lazy.spawn('sh -c \'xkill -id $(xdotool getactivewindow|xargs printf 0x%x"\n")\'')),
    Key([mod],'f',lazy.window.toggle_floating()),
    #qtile
    Key([mod,'control'],'r',lazy.reload_config()),
    Key(['control','mod1'],'delete',lazy.restart()),
    Key([mod,'control'],'q',lazy.shutdown()),
    #spawn
    Key([mod],'b',lazy.spawn(browser)),
    Key([mod],'Return',lazy.spawn(term1)),
    Key([mod,'shift'],'Return',lazy.spawn(term2)),
    Key([mod,'shift'],'o',lazy.spawn(topgui)),
    Key([mod],'n',lazy.spawn(file_manager)),
    Key([mod],'e',lazy.spawn("emacsclient -c -a 'emacs'")),
    Key([mod,'shift'],'e',lazy.spawn("emacs --init-directory=/home/user/.config/emacs/")),
    Key([mod],'v',lazy.spawn(f'{neovimgui} -c "cd {HOME}/.config/nvim|lua require\'small.dff\'.file_expl(\'{VAULTPATH}\')"')),
    #menu
    Key([mod],'x',lazy.spawn('sh -c "setsid $(type rofi&&rofi -show drun||j4-dmenu-desktop --no-exec)"')),
    Key([mod],'y',lazy.spawn('clipmenu')),
    Key([mod],'i',lazy.function(menu_list_and_run,websites,'fish -c \'setsid firefox "%s"&\'')),
    Key([mod],'c',lazy.function(menu_list_and_run,configs,f'{neovimgui} %s')),
    #XF86
    Key([],"XF86MonBrightnessUp",lazy.spawn("brightnessctl set +10%")),
    Key([],"XF86MonBrightnessDown",lazy.spawn("brightnessctl set 10%-")),
    Key(['shift'],"XF86MonBrightnessUp",lazy.spawn("brightnessctl set +1%")),
    Key(['shift'],"XF86MonBrightnessDown",lazy.spawn("brightnessctl set 1%-")),
    Key([],"XF86AudioRaiseVolume",lazy.spawn("pactl set-sink-volume 0 +1%")),
    Key(['shift'],"XF86AudioRaiseVolume",lazy.spawn("pactl set-sink-volume 0 +10%")),
    Key([],"XF86AudioLowerVolume",lazy.spawn("pactl set-sink-volume 0 -1%")),
    Key(['shift'],"XF86AudioLowerVolume",lazy.spawn("pactl set-sink-volume 0 -10%")),
    Key([],"XF86AudioMute",lazy.spawn("pactl set-sink-mute 0 toggle")),
    #neovim
    Key([mod],'s',lazy.spawn(f"fish -c '{neovimgui} $TEMPFILE'")),
    Key([mod,'shift'],'s',lazy.function(menu_list_and_run,{i:i for i in ('lua','md','txt','py','fish','html','c')},'fish -c "set -U TEMPFILE /tmp/user/temp.%s"')),
    Key([mod,'control'],'s',lazy.spawn(f'{neovimgui} -c "lua vim.cmd.edit(\'/tmp/user/temp.\'..vim.fn.rand())"')),
    Key([mod],'a',lazy.spawn(neovimgui)),
    Key([mod],'z',lazy.spawn(f'{neovimgui} -c "cd {HOME}/.config/nvim|lua require\'small.dff\'.file_expl()"')),
    Key([mod],'o',lazy.function(menu_list_and_run,projects,f'{neovimgui} -c "lua require\'small.dff\'.file_expl(\\"%s\\")"')),
    #shell
    Key([mod],'p',lazy.spawn(f'{neovimgui} -c "Shell -c ipython" -c "call feedkeys(\'import os,sys,string,json,math,time,functools,itertools\rfrom __future__ import barry_as_FLUFL\rsys.path.append(\\"{HOME}/.venv/lib/python3.11/site-packages\\")\r\')"')),
    #other
    Key([mod,'shift'],'c',lazy.spawn('sh -c "nitrogen;qtile cmd-obj -o cmd -f reload_config"')),
    Key([mod,'control'],'c',lazy.spawn('sh -c "Xdialog --wmclass dialog --yesno \'Are you sure you want to clear cache?\' 0x0&&cat %s |jq -c \'.\\"cache\\".\\"img\\"={}\'>/tmp/TmP&&mv /tmp/TmP %s"'.replace('%s',settings_file))),
    Key([mod,'shift'],'g',lazy.spawn('surf https://chat.openai.com/chat')),
    Key([mod,'control'],'z',lazy.spawn('slock')),
    Key([mod],'space',lazy.spawn('mpvc toggle')),
    Key([mod,'shift'],'space',lazy.spawn('mpvc next')),
    Key([mod,'shift','mod1'],'space',lazy.spawn('mpvc prev')),
    Key([mod],'period',lazy.spawn('plover -s plover_send_command toggle')),
    #window2
    KeyChord([mod],'q',[
        Key([],'n',lazy.spawn('setxkbmap no')),
        Key([],'s',lazy.spawn('setxkbmap se')),
        Key([],'u',lazy.spawn('setxkbmap us')),
    ]),
    KeyChord([mod],'g',[
        Key([],'i',lazy.function(lambda q:os.system('Xdialog --wmclass dialog --msgbox "'+str(q.current_window.info()).replace('"',"'")+'" 0x0&'))),
        Key([],'b',lazy.hide_show_bar()),
        Key([],'t',lazy.function(lambda q:q.current_window.cmd_down_opacity())),
        Key(['shift'],'t',lazy.function(lambda q:q.current_window.cmd_up_opacity())),
        Key([],'f11',lazy.window.toggle_fullscreen()),
        Key([],'m',lazy.function(lambda q:q.current_window.cmd_toggle_minimize())),
        Key([],'f',lazy.function(lambda q:q.current_window.cmd_bring_to_front())),
        Key(['control'],'f',lazy.function(lambda q:q.current_window.cmd_static())),
        Key([],'s',lazy.function(scalescreen,.1)),
        Key(['shift'],'s',lazy.function(scalescreen,-.1)),
        Key(['control'],'s',lazy.function(lambda _:os.system(f'Xdialog --wmclass dialog --msgbox "{SCALE}" 0x0&'))),
        Key(['shift','control'],'s',lazy.function(setscale,SCALE)),
        Key([],'space',lazy.spawn('scrot')),
        Key([],'k',lazy.spawn('gkbd-keyboard-display -g 1')),
        Key([],'m',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5')),
        Key(['shift'],'m',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0')),
        Key(['control'],'m',lazy.spawn('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" -0.5')),
        Key([],'7',lazy.spawn('sh -c "echo $(xsel -ob) >> .config/nvim/.other/vim-plugin-list/raw "')),
        Key([],'c',lazy.spawn('sh -c "test $(pidof xbanish)&&killall xbanish||xbanish -a"')),
        Key([],'p',lazy.spawn('sh -c "killall picon|setsid picom"')),
    ])
]
groups=[Group(i) for i in "1234567890u"]
groups.append(Group('m',matches=[Match(wm_class='surf')]))
for i in (i.name for i in groups):
    keys.extend([
        Key([mod],i,lazy.group[i].toscreen()),
        Key([mod,"shift"],i,lazy.window.togroup(i,switch_group=1)),
    ])

# layout and screen
layouts=[ xmonad.MonadTall(single_border_width=0,border_focus='#ff0000'),
         #xmonad.MonadTall(single_border_width=0,ratio=0.8,border_focus='#00ff00'),
         xmonad.MonadThreeCol(single_border_width=0,ratio=0.5,border_focus='#0000ff',main_centered=False),
         columns.Columns(border_on_single=1,border_focus='#ffffff'),
         ]
screens=[Screen(
    #wallpaper=image,        #slow
    #wallpaper_mode='fill',  #slow
    bottom=bar.Bar([
        widget.GroupBox(disable_drag=1,hide_unused=1,highlight_method='line',highlight_color=[*[image_colors[0]]*3,image_colors[1]],
                        use_mouse_wheel=False,borderwidth=1,inactive='#707070',
                        visible_groups=[i.name for i in groups if i.name in '0123456789']),
        widget.WindowTabs(),
        widget.Systray(), #dont remove...
        widget.TextBox(text='',fontsize=30,padding=-1,foreground=image_colors[2]),
        widget.Battery(format='{char} {percent:2.0%}',background=image_colors[2]),
        widget.TextBox(text='',fontsize=30,padding=-1,background=image_colors[2],foreground=image_colors[3]),
        widget.Clock(format="%Y/%m/%d;%V %H:%M:%S",background=image_colors[3]),
    ],
                   size=20, background=image_colors[0],opacity=0.8,
                   ),)]

# autostart
def autoset():
    os.system('nitrogen --restore &')
    os.system('xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5 &')
    os.system('setxkbmap no &')
autoset()
@hook.subscribe.startup_once
def autostart()->None:
    os.system(f'xrandr --output LVDS-1 --scale {SCALE}x{SCALE} &')
    os.system('picom &')
    os.system('clipmenud &')
    # os.system('modprobe v4l2loopback')
    os.system('xset s off -dpms &') #disable screensaver
    os.system('sh -c "emacs --daemon"&')
    os.system('sh -c "sleep 10;blanket -h"&') #TODO
    os.system('redshift -P -O 4000&')
    autoset()
# vim:fen:

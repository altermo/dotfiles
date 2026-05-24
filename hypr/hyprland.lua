hl.monitor{output='',mode='preferred',position='auto',scale=1.6}

hl.env('EDITOR','nvim')
hl.env('VISUAL',os.getenv'EDITOR')

hl.config{
  input={
    kb_layout='us,no',
    kb_variant='altgr-intl,',
    follow_mouse=1,
    sensitivity=0.5,
    touchpad={clickfinger_behavior=true},
  },
  general={
    gaps_in=0,
    gaps_out=0,
    border_size=0,
    layout='scrolling',
    col={
      active_border={colors={'rgba(33ccffee)','rgba(00ff99ee)'},angle=45},
      inactive_border='rgba(595959aa)',
    },
  },
  decoration={
    blur={
      size=4,
      passes=2,
      xray=true,
    },
    shadow={enabled=false},
    screen_shader='shaders/redshift.glsl',
    glow={
      enabled=true,
      color='rgba(00000000)',
      color_inactive='rgba(333333ff)',
      render_power=1,
      range=20,
    },
  },
  animations={
    enabled=false,
  },
  scrolling={
    follow_min_visible=0,
  },
  misc={
    disable_hyprland_logo=true,
    disable_splash_rendering=true,
  },
  cursor={
    inactive_timeout=1,
  },
  plugin={dynamic_cursors={
    enabled=true,
    shake={enabled=false},
    mode='rotate',
    ignore_warps=false,
  }},
}

hl.window_rule{match={class=".*"},suppress_event="maximize"}
hl.window_rule{match={float=true},border_size=1}
hl.window_rule{match={class=".*"},opacity=0.95}
hl.window_rule{match={class="kitty"},opacity=0.9}
hl.window_rule{match={class="kitty"},no_blur=true}

local terminal='kitty'
local editor='kitty -e $EDITOR'
local editor2='emacsclient -c -a emacs'
local browser='firefox'
local menu='pwofi --show drun'
local topgui='kitty -e htop'
local mainMod=function(key) return 'SUPER+'..key end

-- layoutmsg
for _,i in pairs{
  {'H','l','left','-0.05'},
  {'L','r','right','+0.05'},
  {'J','l','down','0.5'},
  {'K','r','up','1'}} do
  local key,let,dir,size=table.unpack(i)
  hl.bind(mainMod(key),hl.dsp.layout('focus '..let))
  hl.bind(mainMod('SHIFT+'..key),hl.dsp.layout('swapcol '..let))
  hl.bind(mainMod('SHIFT+CONTROL+'..key),hl.dsp.window.move{direction=dir})
  hl.bind(mainMod('CONTROL+'..key),hl.dsp.layout('colresize '..size))
end
hl.bind(mainMod'T',hl.dsp.layout'promote')
-- mouse
hl.bind(mainMod'mouse:272',hl.dsp.window.drag(),{mouse=true})
hl.bind(mainMod'mouse:273',hl.dsp.window.resize(),{mouse=true})
-- window
hl.bind(mainMod'W',function()
  local awin=hl.get_active_window()
  if not awin then return end
  if awin.class=='firefox' then
    for _,win in next,hl.get_windows() do
      if win.class==awin.class and win~=awin then
        hl.dispatch(hl.dsp.window.close(awin))
        return
      end
    end
    hl.notification.create{text='         no         ',duration=900,color="rgb(ff1ea3)"}
    return
  end
  hl.dispatch(hl.dsp.window.close(awin))
end)
hl.bind(mainMod'SHIFT+W',hl.dsp.window.close())
hl.bind(mainMod'CONTROL+W',hl.dsp.exec_cmd'hyprctl kill')
hl.bind(mainMod'F',hl.dsp.window.float{action='toggle'})
-- hyprland
hl.bind(mainMod'f11',hl.dsp.window.fullscreen{action='toggle'})
hl.bind(mainMod'ALT+SHIFT+Q',hl.dsp.exit())
hl.bind(mainMod'ALT+SHIFT+Z',hl.dsp.exec_cmd'systemctl suspend')
hl.bind(mainMod'SHIFT+Z',hl.dsp.exec_cmd'swaylock -c 000000')
hl.bind(mainMod'ALT+B',hl.dsp.exec_cmd'pkill waybar||waybar')
hl.bind(mainMod'ALT+SPACE',hl.dsp.exec_cmd'grim')
hl.bind(mainMod'ALT+F',hl.dsp.exec_cmd[[wl-freeze -c "hyprctl activewindow -j|jq '.pid'"]])
hl.bind(mainMod'ALT+Y',hl.dsp.exec_cmd'cliphist wipe;wl-copy -c;wl-copy -p -c')
-- spawn
hl.bind(mainMod'B',hl.dsp.exec_cmd(browser))
hl.bind(mainMod'RETURN',hl.dsp.exec_cmd(terminal))
hl.bind(mainMod'O',hl.dsp.exec_cmd(topgui))
hl.bind(mainMod'A',hl.dsp.exec_cmd(editor))
hl.bind(mainMod'E',hl.dsp.exec_cmd(editor2))
hl.bind(mainMod'S',hl.dsp.exec_cmd("fish -c 'cd (dirname $TEMPFILE);exec "..editor.." $TEMPFILE'"))
-- list
hl.bind(mainMod'X',hl.dsp.exec_cmd(menu))
hl.bind(mainMod'C',hl.dsp.exec_cmd(terminal..' -e fish -C "ef $HOME/projects/quick/c--conf/"'))
hl.bind(mainMod'D',hl.dsp.exec_cmd(terminal..' -e fish -C "ef $HOME/projects/quick/"'))
hl.bind(mainMod'I',hl.dsp.exec_cmd('data_select ~/projects/conf/dotfiles/data/links '..browser))
hl.bind(mainMod'Y',hl.dsp.exec_cmd'cliphist list|pwofi --dmenu|cliphist decode|xargs -r wl-copy --')
hl.bind(mainMod'SHIFT+S',hl.dsp.exec_cmd[[fish -c "set -U TEMPFILE /tmp/user/temp.$(printf 'lua\nmd\ntxt\npy\nfish\nhtml\nc\nvim\njava'|pwofi --show dmenu)"]])
hl.bind(mainMod'ALT+H',hl.dsp.exec_cmd[[
  e=$(ls ~/.config/hypr/shaders/|pwofi --show dmenu)
  test -z "$e"&&exit
  hyprctl notify -1 3000 "rgb(ffa500)" "setting screen shader to *$e*"
  hyprctl eval "hl.config{decoration={screen_shader='shaders/$e'}}"
  hyprctl eval "hl.config{debug={damage_tracking=0}}"
  sleep 0.1
  hyprctl eval "hl.config{debug={damage_tracking=2}}"
  ]])
hl.bind(mainMod'ALT+E',function()
  local editor=os.getenv('EDITOR')=='nvim' and 'hx' or 'nvim'
  hl.env('EDITOR',editor)
  hl.env('VISUAL',editor)
  hl.notification.create{text='setting EDITOR to "'..editor..'"',duration=3000,color="rgb(add8e6)"}
end)
-- mpv
hl.bind(mainMod'SPACE',hl.dsp.exec_cmd'mpvc toggle')
hl.bind(mainMod'SHIFT+SPACE',hl.dsp.exec_cmd'mpvc next')
hl.bind(mainMod'CONTROL+SPACE',hl.dsp.exec_cmd'mpv /dev/null')
-- XF86
hl.bind('XF86MonBrightnessUp',hl.dsp.exec_cmd'brightnessctl set +10%',{repeating=true})
hl.bind('XF86MonBrightnessDown',hl.dsp.exec_cmd'brightnessctl set 10%-',{repeating=true})
hl.bind('SHIFT+XF86MonBrightnessUp',hl.dsp.exec_cmd'brightnessctl set +1%',{repeating=true})
hl.bind('SHIFT+XF86MonBrightnessDown',hl.dsp.exec_cmd'brightnessctl set 1%-',{repeating=true})
hl.bind('XF86AudioRaiseVolume',hl.dsp.exec_cmd'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+',{repeating=true})
hl.bind('XF86AudioLowerVolume',hl.dsp.exec_cmd'wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-',{repeating=true})
hl.bind('SHIFT+XF86AudioRaiseVolume',hl.dsp.exec_cmd'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 10%+',{repeating=true})
hl.bind('SHIFT+XF86AudioLowerVolume',hl.dsp.exec_cmd'wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-',{repeating=true})
hl.bind('XF86AudioMute',hl.dsp.exec_cmd'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle',{repeating=true})
hl.bind('XF86AudioMicMute',hl.dsp.exec_cmd'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle',{repeating=true})
-- workspace
for i=1,10 do
  hl.bind(mainMod(i%10),hl.dsp.focus{workspace=i})
  hl.bind(mainMod('SHIFT+'..i%10),hl.dsp.window.move{workspace=i})
end
hl.bind(mainMod'U',hl.dsp.workspace.toggle_special(11))
hl.bind(mainMod'SHIFT+U',hl.dsp.window.move{workspace=11})
hl.bind(mainMod'SHIFT+ESCAPE',hl.dsp.submap('lock'))
hl.define_submap('lock',function()
  hl.bind(mainMod'ESCAPE',hl.dsp.submap('reset'))
end)

hl.on('hyprland.start',function()
  hl.exec_cmd'nice waybar'
  hl.exec_cmd'swaybg -i ~/projects/other/media/backgrounds/gnome/Icetwigs.jpg'
  hl.exec_cmd'wl-paste --type text --watch cliphist -max-items=20 store'
  hl.exec_cmd'sh -c "sleep 10;nice mpv --loop --volume=50 --no-config ~/projects/other/media/music/birds.ogg --scripts= &"'
  hl.exec_cmd'sh -c "sleep 10;nice mpv --loop --volume=50 --no-config ~/projects/other/media/music/d185a0ee12c196724070a9199b3a2b43.mp3 --scripts= &"'
  hl.exec_cmd'hyprctl plugin load "$HYPR_PLUGIN_DIR/lib/libhypr-dynamic-cursors.so"'
end)

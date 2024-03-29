# Source: https://github.com/hyprwm/Hyprland/pull/3535

function _hyprctl_1
    set 1 $argv[1]
    hyprctl instances -j | sed -n 's/.*"instance": "\(.*\)".*/\1/p'
end

function _hyprctl_2
    set 1 $argv[1]
    printf '%s\n' /usr/share/icons/*/cursors | cut -d/ -f5
end

function _hyprctl_3
    set 1 $argv[1]
    hyprctl devices -j | awk '/^"keyboards"/,/^\],$/' | sed -n 's/.*"name": "\(.*\)".*/\1/p'
end

function _hyprctl_4
    set 1 $argv[1]
    hyprctl monitors | sed -n 's/^Monitor \(.*\) (ID .*/\1/p'
end

function _hyprctl_spec_2
set 1 $argv[1]
__fish_complete_path "$1"
end

function _hyprctl
    set COMP_LINE (commandline --cut-at-cursor)

    set COMP_WORDS
    echo $COMP_LINE | read --tokenize --array COMP_WORDS
    if string match --quiet --regex '.*\s$' $COMP_LINE
        set COMP_CWORD (math (count $COMP_WORDS) + 1)
    else
        set COMP_CWORD (count $COMP_WORDS)
    end

    set --local literals "misc:enable_swallow" "dwindle:split_width_multiplier" "3" "debug:suppress_errors" "input:touchpad:drag_lock" "decoration:blur:special" "alterzorder" "misc:groupbar_gradients" "misc:swallow_regex" "setprop" "resizeactive" "dwindle:preserve_split" "dwindle:smart_split" "misc:group_insert_after_current" "misc:key_press_enables_dpms" "preload" "next" "centerwindow" "wayland" "fullscreen" "pass" "execr" "misc:focus_on_activate" "input:tablet:output" "gestures:workspace_swipe_create_new" "general:hover_icon_on_border" "debug:log_damage" "general:col.nogroup_border_active" "general:max_fps" "misc:cursor_zoom_factor" "binds:focus_preferred_method" "misc:close_special_on_empty" "debug:watchdog_timeout" "misc:layers_hog_keyboard_focus" "blurls" "resizewindowpixel" "binds" "decoration:dim_inactive" "dwindle:use_active_for_splits" "cursorpos" "input:touchdevice:output" "workspaces" "input:tablet:transform" "misc:always_follow_on_dnd" "misc:vfr" "list" "gestures:workspace_swipe_distance" "devices" "decoration:dim_around" "input:numlock_by_default" "general:allow_tearing" "input:kb_variant" "misc:animate_mouse_windowdragging" "decoration:shadow_ignore_window" "exit" "gestures:workspace_swipe_invert" "misc:mouse_move_focuses_monitor" "general:cursor_inactive_timeout" "top" "decoration:col.shadow_inactive" "unbind" "movewindoworgroup" "exec" "remove" "layerrule" "autogenerated" "xwayland:force_zero_scaling" "plugin" "lockactivegroup" "general:col.inactive_border" "input:touchpad:clickfinger_behavior" "closewindow" "input:touchdevice:transform" "monitor" "animation" "debug:enable_stdout_logs" "general:col.nogroup_border" "misc:no_direct_scanout" "input:repeat_rate" "dwindle:no_gaps_when_only" "togglegroup" "input:scroll_method" "movecursor" "dwindle:permanent_direction_override" "gestures:workspace_swipe_direction_lock_threshold" "input:touchpad:tap-and-drag" "swapactiveworkspaces" "gestures:workspace_swipe" "decoration:col.shadow" "master:mfact" "setcursor" "gestures:workspace_swipe_forever" "input:sensitivity" "input:touchpad:tap-to-click" "misc:swallow_exception_regex" "misc:cursor_zoom_rigid" "activeworkspace" "debug:int" "decoration:active_opacity" "misc:force_hypr_chan" "togglespecialworkspace" "binds:allow_workspace_cycles" "dwindle:smart_resizing" "general:sensitivity" "misc:group_focus_removed_window" "-j" "prev" "pseudo" "load" "decoration:shadow_offset" "decoration:fullscreen_opacity" "togglefloating" "dwindle:pseudotile" "input:touchpad:tap_button_map" "source" "input:tablet:region_size" "decoration:shadow_render_power" "moveactive" "moveworkspacetomonitor" "general:layout" "mfact" "changegroupactive" "0" "decoration:shadow_range" "instances" "general:extend_border_grab_area" "debug:damage_tracking" "misc:render_ahead_of_time" "bezier" "decoration:screen_shader" "input:tablet:region_position" "togglesplit" "globalshortcuts" "decoration:blur:noise" "input:kb_model" "master:allow_small_split" "decoration:blur:enabled" "master:new_is_master" "killactive" "windowrule" "clients" "gestures:workspace_swipe_fingers" "master:no_gaps_when_only" "fakefullscreen" "env" "x11" "general:col.group_border_locked_active" "mouse" "bottom" "notify" "pin" "animations" "gestures:workspace_swipe_direction_lock" "wallpaper" "master:smart_resizing" "general:no_border_on_floating" "input:follow_mouse" "wsbind" "debug:disable_time" "general:no_cursor_warps" "layoutmsg" "1" "master:always_center_master" "cyclenext" "movecursortocorner" "keyword" "general:apply_sens_to_raw" "general:col.group_border_active" "movewindowpixel" "input:accel_profile" "auto" "input:natural_scroll" "activewindow" "swapwindow" "decoration:blur:contrast" "master:inherit_fullscreen" "misc:allow_session_lock_restore" "input:scroll_button_lock" "5" "input:mouse_refocus" "decoration:blur:new_optimizations" "--instance" "decoration:inactive_opacity" "misc:disable_splash_rendering" "forcerendererreload" "master:orientation" "misc:force_default_wallpaper" "xwayland:use_nearest_neighbor" "hyprpaper" "input:touchpad:scroll_factor" "movecurrentworkspacetomonitor" "toggleopaque" "monitors" "input:kb_options" "focuswindow" "renameworkspace" "misc:render_ahead_safezone" "misc:render_titles_in_groupbar" "workspace" "switchxkblayout" "input:force_no_accel" "misc:groupbar_titles_font_size" "create" "general:border_size" "master:new_on_top" "movewindow" "input:scroll_button" "general:col.group_border_locked" "misc:vrr" "decoration:rounding" "misc:groupbar_text_color" "decoration:blur:ignore_opacity" "general:resize_on_border" "dpms" "submap" "general:gaps_out" "output" "workspaceopt" "misc:disable_autoreload" "debug:overlay" "input:touchpad:disable_while_typing" "input:repeat_delay" "dwindle:special_scale_factor" "-i" "moveintogroup" "layers" "focuswindowbyclass" "misc:new_window_takes_over_fullscreen" "unload" "headless" "input:touchpad:middle_button_emulation" "bind" "input:touchpad:natural_scroll" "general:gaps_in" "seterror" "focusmonitor" "input:kb_rules" "misc:background_color" "decoration:blur:brightness" "binds:pass_mouse_when_bound" "splitratio" "binds:ignore_group_lock" "2" "dwindle:default_split_ratio" "misc:mouse_move_enables_dpms" "misc:animate_manual_resizes" "gestures:workspace_swipe_use_r" "misc:disable_hyprland_logo" "decoration:drop_shadow" "debug:manual_crash" "version" "input:left_handed" "exec-once" "dwindle:force_split" "misc:groupbar_scrolling" "misc:hide_cursor_on_touch" "decoration:blur:xray" "gestures:workspace_swipe_min_speed_to_force" "debug:disable_logs" "input:float_switch_override_focus" "-1" "lockgroups" "binds:scroll_event_delay" "decoration:blur:passes" "windowrulev2" "reload" "animations:enabled" "general:col.active_border" "general:no_focus_fallback" "swapnext" "kill" "input:kb_file" "gestures:workspace_swipe_cancel_ratio" "dispatch" "bringactivetotop" "moveoutofgroup" "getoption" "movetoworkspace" "master:drop_at_cursor" "movetoworkspacesilent" "master:special_scale_factor" "binds:workspace_back_and_forth" "4" "decoration:no_blur_on_oversized" "--batch" "debug:damage_blink" "all" "decoration:shadow_scale" "disable" "global" "focusurgentorlast" "splash" "input:kb_layout" "decoration:blur:size" "movefocus" "decoration:dim_strength" "gestures:workspace_swipe_numbered" "general:col.group_border" "focuscurrentorlast" "decoration:dim_special"

    set --local descriptions
    set descriptions[3] "error"
    set descriptions[10] "set windowrule properties"
    set descriptions[37] "list all keybindings"
    set descriptions[40] "print cursor position"
    set descriptions[42] "list all workspaces with their properties"
    set descriptions[48] "list all connected input devices"
    set descriptions[91] "set cursor theme"
    set descriptions[97] "show info about active workspace"
    set descriptions[106] "JSON output"
    set descriptions[123] "warning"
    set descriptions[125] "list running Hyprland instances"
    set descriptions[133] "list all global shortcuts"
    set descriptions[141] "list all windows with their properties"
    set descriptions[150] "send notification"
    set descriptions[152] "list animations and beziers"
    set descriptions[162] "info"
    set descriptions[166] "execute a keyword"
    set descriptions[173] "print active window name"
    set descriptions[179] "ok"
    set descriptions[182] "use specified Hyprland instance"
    set descriptions[193] "list all outputs with their properties"
    set descriptions[200] "switch keyboard layout"
    set descriptions[217] "creates/destroys a fake output"
    set descriptions[224] "use specified Hyprland instance"
    set descriptions[226] "list all layers"
    set descriptions[235] "show text in error bar"
    set descriptions[243] "hint"
    set descriptions[251] "print Hyprland version"
    set descriptions[261] "no icon"
    set descriptions[266] "reload config file"
    set descriptions[271] "kill an app by clicking on it"
    set descriptions[274] "run a dispatcher"
    set descriptions[277] "print value of config option"
    set descriptions[283] "confused"
    set descriptions[285] "execute multiple commands, separated by ';'"
    set descriptions[292] "print current random splash"

    set --local literal_transitions
    set literal_transitions[1] "set inputs 106 68 37 150 40 152 42 266 10 235 48 271 125 274 166 277 91 173 217 285 133 292 97 141 182 251 224 189 226 200 193; set tos 1 2 3 9 3 3 3 3 3 8 3 3 3 10 11 7 12 3 13 3 3 3 3 3 14 3 14 5 3 15 3"
    set literal_transitions[2] "set inputs 46 109 229; set tos 3 4 4"
    set literal_transitions[5] "set inputs 16 154 229; set tos 4 3 6"
    set literal_transitions[6] "set inputs 287; set tos 3"
    set literal_transitions[7] "set inputs 147 2 4 5 6 8 153 155 9 156 157 12 13 159 160 163 14 15 167 168 170 172 175 176 177 23 178 24 25 26 180 27 28 29 30 31 181 183 32 184 186 33 190 198 34 194 188 197 187 38 39 201 41 43 44 45 202 204 47 205 207 208 209 210 49 50 51 52 53 54 211 212 213 216 56 57 58 219 60 220 221 222 223 66 228 67 70 71 73 231 78 76 77 233 234 79 80 82 237 84 238 85 239 86 240 88 89 90 242 244 92 93 94 95 96 245 246 247 98 248 99 249 250 100 252 102 254 103 104 105 255 256 257 258 110 259 111 113 114 260 263 116 264 267 117 268 269 120 272 273 281 124 126 279 127 282 128 130 284 131 286 288 134 135 136 137 138 293 142 294 143 296 297 298 1 300; set tos 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3"
    set literal_transitions[8] "set inputs 289; set tos 3"
    set literal_transitions[9] "set inputs 3 123 243 162 261 283 179; set tos 3 3 3 3 3 3 3"
    set literal_transitions[10] "set inputs 108 148 69 36 195 112 196 7 72 151 199 262 206 227 236 11 270 81 118 83 119 121 122 161 164 87 165 214 169 215 18 55 174 241 132 21 20 22 218 275 276 62 278 139 280 290 291 63 185 101 144 225 295 191 299 192; set tos 3 3 3 3 3 3 3 16 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3"
    set literal_transitions[11] "set inputs 68 129 199 74 61 265 75 115 140 232 63 158 65 253 215 145 35; set tos 3 3 3 3 3 3 3 4 3 3 3 3 3 3 3 3 3"
    set literal_transitions[13] "set inputs 203 64; set tos 17 19"
    set literal_transitions[16] "set inputs 59 149; set tos 3 3"
    set literal_transitions[17] "set inputs 171 19 146 230; set tos 3 3 3 3"
    set literal_transitions[18] "set inputs 17 107; set tos 3 3"

    set --local match_anything_transitions_from 4 14 12 6 15 19
    set --local match_anything_transitions_to 3 1 3 3 18 3

    set --local state 1
    set --local word_index 2
    while test $word_index -lt $COMP_CWORD
        set --local -- word $COMP_WORDS[$word_index]

        if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
            set --local --erase inputs
            set --local --erase tos
            eval $literal_transitions[$state]

            if contains -- $word $literals
                set --local literal_matched 0
                for literal_id in (seq 1 (count $literals))
                    if test $literals[$literal_id] = $word
                        set --local index (contains --index -- $literal_id $inputs)
                        set state $tos[$index]
                        set word_index (math $word_index + 1)
                        set literal_matched 1
                        break
                    end
                end
                if test $literal_matched -ne 0
                    continue
                end
            end
        end

        if set --query match_anything_transitions_from[$state] && test -n $match_anything_transitions_from[$state]
            set --local index (contains --index -- $state $match_anything_transitions_from)
            set state $match_anything_transitions_to[$index]
            set word_index (math $word_index + 1)
            continue
        end

        return 1
    end

    if set --query literal_transitions[$state] && test -n $literal_transitions[$state]
        set --local --erase inputs
        set --local --erase tos
        eval $literal_transitions[$state]
        for literal_id in $inputs
            if test -n $descriptions[$literal_id]
                printf '%s\t%s\n' $literals[$literal_id] $descriptions[$literal_id]
            else
                printf '%s\n' $literals[$literal_id]
            end
        end
    end

    set command_states 19 12 14 15
    set command_ids 4 2 1 3
    if contains $state $command_states
        set --local index (contains --index $state $command_states)
        set --local function_id $command_ids[$index]
        set --local function_name _hyprctl_$function_id
        set --local --erase inputs
        set --local --erase tos
        $function_name "$COMP_WORDS[$COMP_CWORD]"
    end
    set specialized_command_states 6 4
    set specialized_command_ids 2 2
    if contains $state $specialized_command_states
        set --local index (contains --index $state $specialized_command_states)
        set --local function_id $specialized_command_ids[$index]
        set --local function_name _hyprctl_spec_$function_id
        set --local --erase inputs
        set --local --erase tos
        set --local lines (eval $function_name $COMP_WORDS[$COMP_CWORD])
        for line in $lines
            printf '%s\n' $line
        end
    end

    return 0
end

complete --command hyprctl --no-files --arguments "(_hyprctl)"

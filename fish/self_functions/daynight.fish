function daynight
    switch $argv[1]
    case day
        rm /tmp/night 2>/dev/null
        redshift -PO 4000
        brightnessctl set 100%
        set prof 64b3a368-6785-446f-9d06-8121063bcbfd
        set bg /home/user/.config/qtile/backgrounds/wallpapers/wallpaper-mania.com_High_resolution_wallpaper_background_ID_77701304401.jpg
        set rtheme /usr/share/rofi/themes/gruvbox-dark.rasi
    case night
        touch /tmp/night
        redshift -PO 3000 -g 1:1:1.1
        brightnessctl set 45%
        set prof 3e708a50-f196-4641-8f32-c0eb4e267e23
        set bg /home/user/.config/qtile/backgrounds/download.jpg
        set rtheme /usr/share/rofi/themes/DarkBlue.rasi
    end
    dconf write /com/rafaelmardojai/Blanket/active-preset "'$prof'"
    killall blanket 2>/dev/null
    sh -c "setsid -f blanket -h"
    printf "2c\nfile=$bg\n.\nwq\n"|ed ~/.config/nitrogen/bg-saved.cfg
    printf "1c\n@theme \"$rtheme\"\n.\nwq\n"|ed ~/.config/rofi/config.rasi
    qtile cmd-obj -o cmd -f reload_config
    for i in (nvr --serverlist)
        timeout 1 nvr --servername $i -c "colorscheme own"&
    end
end

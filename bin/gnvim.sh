#! /bin/sh
exec kitty -o window_padding_width=0\
     -o mouse_hide_wait=1\
     -o clear_all_shortcuts=yes\
     -o detect_urls=no\
     -o window_padding_width=20\
     -o map="ctrl++ change_font_size all +1.0"\
     -o map="ctrl+= change_font_size all +1.0"\
     -o map="ctrl+- change_font_size all -1.0"\
     -o map="ctrl+0 change_font_size all 0"\
     -o font_size=14\
     -e nvim "$@"

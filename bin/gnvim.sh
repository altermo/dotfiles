#! /bin/sh
exec kitty -o window_padding_width=0\
     -o mouse_hide_wait=1\
     -o clear_all_shortcuts=yes\
     -o detect_urls=no\
     -e nvim "$@"

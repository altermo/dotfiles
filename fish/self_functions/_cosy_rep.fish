function _cosy_rep
    while true
        clear
        printf '\e[?1000h\e[?25l'
        if test "$(read -n1 -p\ ||exit)" = ""
            printf '\e[?1000l\e[?25h'
            fish
        end
    end
end

function _cosy_rep
    while true
        clear
        printf '\e[?1000h\e[?25l'
        if test "$(read -n1 -p\ ||exit)" = ""
            fish
        end
    end
end

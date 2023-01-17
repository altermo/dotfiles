function fish_prompt
    [ (random 1 50) = 1 ]&&echo -n (set_color yellow)"This is a friendly reminder"
    echo -n (set_color red)(prompt_pwd (pwd -P) 2>/dev/null)(set_color white)'$ '
    set_color normal
    echo -en "\e[?25h"
    printf "\e[?1000;1006;1015h"
end

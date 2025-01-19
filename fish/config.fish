# ;; preload
if not status --is-interactive;exit;end
if tty>/dev/null&&test (math (date +%s) - (stat -c %Y /tmp/gh.not 2>/dev/null||echo 0)) -gt 60
    setsid sh -c 'timeout 1 ping github.com >/dev/null 2>&1 -c 1||exit
    notif=$(gh api notifications|jq "length")
    test 0 = "$notif"||echo -e "\e[7m\ngithub: you have received $notif notifications\e[0m"'&
    disown
    touch /tmp/gh.not
end
tmux ls 2>/dev/null

# ;; vars
alias invim 'not [ $INSIDE_EMACS ]&&[ $NVIM ]'
test "$TEMPFILE"||set -U TEMPFILE /tmp/user/temp.lua
test -d /tmp/user||mkdir /tmp/user
set fish_greeting
set langs 'en' 'sv' 'hu'
set FILEMANAGER yazi
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER 'bat --decorations never --paging=always --pager="less --SILENT -RF"'
set -x MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
set -x PYTHONPATH "$HOME/.venv/lib/python3.13/site-packages"
set -x GTK_THEME Adwaita:dark
set -U fish_user_paths $HOME/.local/bin $HOME/.cargo/bin
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_replace     underscore
set fish_cursor_visual      block
fish_vi_key_bindings

# ;; sources/hooks
if invim
    function __hook_nvim_lcd -v PWD;nvr -c "silent! lcd $PWD" &;end
    nvr -c "silent! lcd $PWD" &
end
if not test -f ~/.config/fish/carapace/carapace.fish
    mkdir -p ~/.config/fish/carapace
    carapace --list|awk '{print $1}'|xargs -I{} touch ~/.config/fish/carapace/{}.fish
end
if not functions -q tide
    set -l _tide_tmp_dir (command mktemp -d)
    curl https://codeload.github.com/ilancosman/tide/tar.gz/v6 | tar -xzC $_tide_tmp_dir
    command cp -R $_tide_tmp_dir/*/{completions,conf.d,functions} $__fish_config_dir
    emit _tide_init_install
end
set -p fish_complete_path ~/.config/fish/carapace
carapace _carapace|source
zoxide init fish|source

# ;; paru
alias paru_update "nm-online >/dev/null&&paru -Syu --devel"
alias paru_clear 'test "$(paru -Qtdq)"&&paru -Qtdq | paru -Rns -'
alias paru_loop_msg 'paru -Qqd | paru -Rsu --print -'
alias pas "paru -S"
alias par "paru -Rc"
alias pac "paru_clear;paru_loop_msg"
alias pauc "paru_update&&paru_clear;paru_loop_msg"
alias paS "paru -Ss"
alias pai "paru -Si"
alias paf "paru -Qo"
alias pal "paru -Ql"
alias paC "paru -Sc"
alias mirrorlist_update "curl -s 'https://archlinux.org/mirrorlist/?country=NO&country=SE&country=DK&country=FI&country=DE&country=PL&protocol=https&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 -|sudo tee /etc/pacman.d/mirrorlist"

# ;; git
abbr gCA "git commit -a -m (git status --porcelain|string join ';')"
abbr gc "git clone"
abbr gp "git push"
abbr gca "git commit -a -m"
abbr ga "git commit -a --amend"
abbr gt "git checkout"
abbr gs "git status"
abbr gd "git diff"
abbr gsa "git stash push"
abbr gsr "git stash pop"
abbr gaa "git add -A -N"

# ;; optinos
alias rm 'rm -I'
alias cp 'cp -rib'
alias xcp 'xcp -rn'
alias mv 'mv -ib'
alias ln 'ln -ibs'
alias mkdir 'mkdir -p'
alias wget 'wget -c'
alias fd 'fd -H'
alias zip 'zip -r -v'
alias termdown 'termdown -B'
alias clear 'TERM=xterm env clear'
alias df 'df -h --output=source,fstype,size,used,pcent,avail,target'

# ;; namig
## spell mistake
abbr :q exit
abbr :Q exit
abbr z.. z\ ..
abbr z/ z\ /
abbr unmount umount
## smaller name
abbr - z\ -
abbr c clear
abbr r $FILEMANAGER
abbr cr touch
abbr mkd mkdir
abbr pow acpi
abbr v nvim
abbr g grep
abbr wifi nmtui-connect
## use other
alias ed "nvim --clean -E"
alias ls 'eza -aF'
alias l 'eza -F'
alias ll 'l -lh --git'
alias la 'ls -lh --git'
alias more "$PAGER"
alias less "$PAGER"
alias cat "bat -pp"
alias lolcat 'dotacat -F 0.05'
alias pip ~/.venv/bin/pip
abbr cp xcp
abbr cd z
abbr tree "eza -T"
abbr find fd
abbr du dua
abbr sudo doas

# ;; nvim
function nvim
    if string match -q -r -- '^[-+]' $argv;or not invim
        env nvim $argv
        return
    end
    [ $argv ]&&nvr $argv||nvr .
    kill (cut -f 6 -d " " /proc/$fish_pid/stat)
end
function nvims
    echo NvChad\nLazyVim|fzf|read out||return 1
    set conf ~/.config/$out
    if not test -d $conf
        switch $out
            case 'NvChad'
                git clone https://github.com/NvChad/starter $conf
                rm -rf $conf/.git
            case 'LazyVim'
                git clone https://github.com/LazyVim/starter $conf
                rm -rf $conf/.git
        end
    end
    NVIM_APPNAME=$out env nvim
end
function nvim_build_prog
    pushd .
    cd /tmp
    while true
        if not ls|grep ltrans > /dev/null
            break
        end
        set total (ls -l|grep ltrans|wc -l)
        set complete (ls -l|grep ltrans.o|wc -l)
        set left (math $total - $complete)
        printf "\r$complete/$left"
        sleep 0.2
    end
    echo
    popd
end
alias nvim2 'NVIM_APPNAME=nvim2 nvim'

# ;; other
abbr dtmp 'cd (mktemp -d -p /tmp/user)'
alias touch 'mkdir -p (dirname $argv)&&env touch'
for i in $langs;for j in $langs
    if test $i != $j
        alias "tra$i$j" "trans -b $i:$j (read)"
    end
end;end
alias clock 'termdown -z -Z "%H : %M : %S"'
function countdown
    set save (hyprctl activeworkspace -j|jq .id)
    termdown $argv
    hyprctl dispatch workspace $save
end
alias tu "HOME=(mktemp -d)"
alias tb "curl -F file=@- 0x0.st"
alias saferm 'shred -uvz'
alias ip "/bin/ip addr | awk '/inet / {print \$2}'"
function lnq;ln $argv (basename $argv);end
function gis
    pushd .
    for i in .mozilla .config .config/nvim .tmp/lua/_later/ .config/dotfiles .qscript .gtd .media
        cd ~/$i
        if test "$(git status --porcelain)"
            echo $i
            git status --porcelain
        end
    end
    popd
end
function exe;test -n "$argv"&&chmod u+x $argv||env ls -p|grep -v /|fzf|xargs -r chmod u+x;end
alias wm "exec Hyprland"
abbr weather "curl wttr.in/\?nFQ"
function cal;env cal -wm --color=always $argv|lolcat;end
alias neofetch 'clear;fastfetch|lolcat'
alias temacs "/home/user/.nelisp/emacs/src/temacs -Q"
alias nemacs "nvim --clean -u /home/user/.nelisp/nelisp/save/setup.lua"

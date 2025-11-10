# ;; preload
if not status --is-interactive;exit;end
if tty>/dev/null&&test (math (date +%s) - (stat -c %Y /tmp/gh.not 2>/dev/null||echo 0)) -gt 60
    sh -c 'timeout 1 ping github.com >/dev/null 2>&1 -c 1||exit
    notif=$(gh api notifications|jq "length")
    test 0 = "$notif"||echo -e "\e[7m\ngithub: you have received $notif notifications\e[0m"'&
    disown
    touch /tmp/gh.not
end

type tmux >/dev/null&&tmux ls 2>/dev/null
type zellij >/dev/null&&zellij ls 2>/dev/null
trash clean-old -f &;disown

# ;; vars
test "$TEMPFILE"||set -U TEMPFILE /tmp/user/temp.lua
test -d /tmp/user||mkdir /tmp/user
set fish_greeting
set langs 'en' 'sv' 'hu'
set FILEMANAGER yazi
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER 'less -RF'
set -x MANPAGER "sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat --style=plain -lman'"
set -x PYTHONPATH "$HOME/.venv/lib/python3.13/site-packages"
set -x GTK_THEME Adwaita:dark
set -U fish_user_paths $HOME/.local/bin $HOME/.cargo/bin

set fish_key_bindings fish_vi_key_bindings
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_replace     underscore
set fish_cursor_visual      block

# ;; sources/hooks
if test ~/.config/fish/config.fish -nt ~/.config/fish/functions/ls.fish
    mkdir -p ~/.config/fish/functions
    function alias_
        alias $argv
        functions $argv[1] > ~/.config/fish/functions/$argv[1].fish
    end
else
    function alias_;end
end

if not test -f ~/.config/fish/completions/carapace.fish
    mkdir -p ~/.config/fish/completions
    for i in (carapace --list|awk '{print $1}')
        printf "complete -e '$i'\ncomplete -c '$i' -f -a '(_carapace_callback $i)'" > ~/.config/fish/completions/$i.fish
    end
    carapace _carapace|head -n21 > ~/.config/fish/functions/_carapace_callback.fish
end

if not functions -q tide
    set -l _tide_tmp_dir (command mktemp -d)
    curl https://codeload.github.com/ilancosman/tide/tar.gz/v6 | tar -xzC $_tide_tmp_dir
    command cp -R $_tide_tmp_dir/*/{completions,conf.d,functions} $__fish_config_dir
end
alias_ tide_config "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='One line' --prompt_spacing=Compact --icons='Few icons' --transient=Yes"

zoxide init fish|source

function invim;not [ $INSIDE_EMACS ]&&[ $NVIM ];end
if invim
    function __hook_nvim_lcd -v PWD;nvr -c "silent! lcd $PWD" &;end
    nvr -c "silent! lcd $PWD" &
end

# ;; paru
alias_ paru_update "nm-online >/dev/null&&paru -Syu --devel"
# alias_ paru_clear 'test "$(paru -Qtdq)"&&paru -Qtdq | paru -Rns -'
alias_ paru_clear 'test "$(paru -Qtdq)"&&paru -Rns -- (paru -Qtdq)'
alias_ paru_loop_msg 'paru -Qqd | paru -Rsu --print -'
alias_ pas "paru -S"
alias_ par "paru -Rc"
alias_ pac "paru_clear;paru_loop_msg"
alias_ pauc "paru_update&&paru_clear;paru_loop_msg"
alias_ paS "paru -Ss"
alias_ pai "paru -Si"
alias_ paf "paru -Qo"
alias_ pal "paru -Ql"
alias_ paC "paru -Sc"
alias_ mirrorlist_update "curl -s 'https://archlinux.org/mirrorlist/?country=NO&country=SE&country=DK&country=FI&country=DE&country=PL&protocol=https&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 -|sudo tee /etc/pacman.d/mirrorlist"

# ;; git
abbr gCA "git commit -a -m (git status --porcelain|string join ';')"
abbr gca "git commit -v -a"
abbr gcaa "git commit -v --amend -a"
abbr gc "git clone"
abbr gp "git push"
abbr gpf "git push --force-with-lease"
abbr gt "git checkout"
abbr gs "git status"
abbr gd "git diff HEAD"
abbr gsa "git stash push"
abbr gsr "git stash pop"
abbr gaa "git add -A -N"
abbr gb "git branch -vv -a"

# ;; options
alias_ rm 'rm -I'
alias_ cp 'cp -rib'
alias_ xcp 'xcp -rn'
alias_ mv 'mv -ib'
alias_ ln 'ln -ibs'
alias_ mkdir 'mkdir -p'
alias_ wget 'wget -c'
alias_ fd 'fd -H'
alias_ zip 'zip -r -v'
alias_ termdown 'termdown -B'
alias_ clear 'TERM=xterm env clear'
alias_ df 'df -h --output=source,fstype,size,used,pcent,avail,target'
alias_ helix 'printf "\\e]11;#e0e2ea\\e\\\\";command helix $argv;printf "\\e]111;"'

# ;; namig
## spell mistake
abbr :q exit
abbr :Q exit
abbr z.. z\ ..
abbr z/ z\ /
abbr unmount umount
## smaller name
abbr - z\ -
abbr ... z\ ../..
abbr .... z\ ../../..
abbr c clear
abbr r $FILEMANAGER
abbr cr touch
abbr mkd mkdir
abbr pow acpi
abbr v nvim
abbr wifi nmtui-connect
abbr hx helix
## use other
alias_ ed "nvim --clean -E"
alias_ ls 'eza -aF'
alias_ l 'eza -F'
alias_ ll 'l -lh --git'
alias_ la 'ls -lh --git'
alias_ more "$PAGER"
alias_ less "$PAGER"
alias_ cat "bat -pp"
alias_ lolcat 'dotacat -F 0.05'
alias_ pip ~/.venv/bin/pip
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
    echo NvChad\nLazyVim\nMiniMax|fzf|read out||return 1
    set conf ~/.config/$out
    if not test -d $conf
        switch $out
            case 'NvChad'
                git clone https://github.com/NvChad/starter $conf
                rm -rf $conf/.git
            case 'LazyVim'
                git clone https://github.com/LazyVim/starter $conf
                rm -rf $conf/.git
            case 'MiniMax'
                git clone https://github.com/nvim-mini/MiniMax $conf
                rm -rf $conf/.git
                NVIM_APPNAME=$out env nvim -l $conf/setup.lua
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
function yazi
    if not invim
        env yazi --cwd-file=/tmp/yazi.cwd $argv
    else
        env yazi --chooser-file=/tmp/yazi.out --cwd-file=/tmp/yazi.cwd $argv
    end
    set out (cat /tmp/yazi.out 2>/dev/null)
    set cwd (cat /tmp/yazi.cwd 2>/dev/null)
    rm /tmp/yazi.out /tmp/yazi.cwd 2>/dev/null
    if test -n "$out";nvim $out;end
    if test -n "$cwd";z $cwd;end
end

# ;; other
abbr dtmp 'cd (mktemp -d -p /tmp/user)'
alias_ touch 'mkdir -p (dirname $argv)&&env touch'
for i in $langs;for j in $langs
    if test $i != $j
        alias_ "tra$i$j" "trans -b $i:$j (read)"
    end
end;end
alias_ clock 'termdown -z -Z "%H : %M : %S"'
function countdown
    set save (hyprctl activeworkspace -j|jq .id)
    termdown $argv
    hyprctl dispatch workspace $save
end
alias_ tu "HOME=(mktemp -d)"
alias_ tb "curl -F file=@- 0x0.st"
alias_ saferm 'shred -uvz'
alias_ ip "/bin/ip addr | awk '/inet / {print \$2}'"
function lnq;ln $argv (basename $argv);end
function gis
    pushd .
    for i in .mozilla .config .config/nvim .config/dotfiles .gtd .media .files .archive
        cd ~/$i
        if test "$(git status --porcelain)"
            echo $i
            git status --porcelain
        end
    end
    popd
end
function exe;test -n "$argv"&&chmod u+x $argv||env ls -p|grep -v /|fzf|xargs -r chmod u+x;end
alias_ wm "exec Hyprland"
abbr weather "curl wttr.in/\?nFQ"
function cal;env cal -wm --color=always $argv|lolcat;end
alias_ neofetch 'clear;fastfetch|lolcat'
alias_ temacs "/home/user/.nelisp/emacs/src/temacs -Q"
function switch_theme_kitty
    if grep -q 'Afterglow' ~/.config/kitty/kitty.conf
        kitty +kitten themes --reload-in=all H-PUX
    else
        kitty +kitten themes --reload-in=all Afterglow
    end
end

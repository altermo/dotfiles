#preload
if not status --is-interactive;exit;end
if tty>/dev/null&&test (math (date +%s) - (stat -c %Y /tmp/gh.not 2>/dev/null||echo 0)) -gt 60
    setsid sh -c 'nm-online -q||exit
    notif=$(gh api notifications|jq "length")
    test 0 = "$notif"||echo -e "\e[7m\ngithub: you have received $notif notifications\e[0m"'&
    disown
    touch /tmp/gh.not
end

#vars
alias invim 'not [ $INSIDE_EMACS ]&&[ $NVIM ]'
test "$TEMPFILE"||set -U TEMPFILE /tmp/user/temp.lua
test -d /tmp/user||mkdir /tmp/user
set fish_greeting
set langs 'en' 'sv' 'hu'
set FILEMANAGER ranger
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER 'bat --decorations never --paging=always --pager="less --SILENT -RF"'
set -x MANPAGER "$PAGER -l man"
set -x PYTHONPATH "$HOME/.venv/lib/python3.12/site-packages"
set -x GTK_THEME Adwaita:dark
set gitdiff "difft --display=inline --syntax-highlight=off --color=always"
set -U fish_user_paths $HOME/.local/bin $HOME/.cargo/bin
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_replace     underscore
set fish_cursor_visual      block
fish_vi_key_bindings

#sources/hooks
if invim
    function __hook_nvim_lcd -v PWD;nvr -c "silent! lcd $PWD" &;end
    nvr -c "silent! lcd $PWD" &
end
if not test -f ~/.config/fish/carapace/carapace.fish
    mkdir -p ~/.config/fish/carapace
    carapace --list|awk '{print $1}'|xargs -I{} touch ~/.config/fish/carapace/{}.fish
end
set -p fish_complete_path ~/.config/fish/carapace
carapace _carapace|source
zoxide init fish|source

#paru
alias paru_update "nm-online >/dev/null&&paru -Syu --devel"
alias paru_clear 'test "$(paru -Qtdq)"&&paru -Qtdq | paru -Rns -'
alias paru_loop_msg 'paru -Qqd | paru -Rsu --print -'
alias pas "paru -S"
alias par "paru -Rc"
alias pac "paru_clear;paru_loop_msg"
alias pauc "paru_update&&paru_clear;paru_loop_msg"
alias paS "paru -Ss"
alias pai "paru -Si"
alias paq "paru -Q"
alias paf "paru -Qo"
alias pal "paru -Ql"
alias paC "paru -Sc"
alias mirrorlist_update "curl -s 'https://archlinux.org/mirrorlist/?country=NO&country=SE&country=DK&country=FI&country=DE&country=PL&protocol=https&use_mirror_status=on' | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 10 -|sudo tee /etc/pacman.d/mirrorlist"

#git
abbr gCA "git commit -a -m (git status --porcelain|string join ';')"
abbr gc "git clone"
abbr gp "git push"
abbr gca "git commit -a -m"
abbr ga "git commit -a --amend"
abbr gt "git checkout"
abbr gs "git status"
abbr gd 'GIT_EXTERNAL_DIFF=$gitdiff git diff'
abbr gdd "git diff"
abbr gsa "git stash push"
abbr gsr "git stash pop"

#optinos
alias rm 'rm -I'
alias cp 'cp -rib'
alias xcp 'xcp -rn'
alias mv 'mv -ib'
alias ln 'ln -ibs'
alias mkdir 'mkdir -p'
alias touch 'mkdir -p (dirname $argv)&&env touch'
alias wget 'wget -c'
alias fd 'fd -H'
alias zip 'zip -r -v'
alias termdown 'termdown -B'
alias clear 'TERM=xterm env clear'
alias lolcat 'dotacat -F 0.05'
alias df 'df -h --output=source,fstype,size,used,pcent,avail,target'

#namig
##shorter names
abbr :q exit
abbr :Q exit
abbr z.. z\ ..
abbr z/ z\ /
abbr - z\ -
abbr t tldr
abbr c clear
abbr r $FILEMANAGER
abbr cr touch
abbr mkd mkdir
abbr pow acpi
abbr v nvim
abbr g grep
abbr wifi nmtui-connect
abbr list_ports 'lsof -i'
abbr unmount umount
##other
alias ed "nvim --clean -E"
#abbr cargob "watchexec cargo check"
#abbr cargoc cargo\ clippy
#alias rich "python -m rich"
#abbr date 'date +"  %H:%M:%S  %Y/%m/%d;%V"'
alias ls 'eza -aF'
alias l 'eza -F'
alias ll 'l -lh --git'
alias la 'ls -lh --git'
abbr cp xcp
alias more "$PAGER"
alias less "$PAGER"
alias cat "bat -pp"
alias pip ~/.venv/bin/pip
abbr cd z
abbr tree "eza -T"
abbr find fd
abbr du dua
abbr sudo doas

#vim
function riv;invim&&sh -c $argv[2]&&kill (cut -f 6 -d " " /proc/$fish_pid/stat)||env $argv[1] $argv[3..];end
function nvim
    if string match -q -r -- '^[-+]' $argv
        env nvim $argv
        return
    end
    riv nvim "[ $argv ]&&nvr $argv||nvr ." $argv
end
function ntime;time $argv[1] +"autocmd VimEnter * quit" $argv[2..];end
alias kpn 'pkill -9 -P 1 "^nvim\$";pkill -9 -P 1 -f language_server_linux_x64'
function nvims;echo vimacs\nNvChad\nSpaceVim\nLazyVim|fzf|read out&&test -n "$out"&&NVIM_APPNAME=$out env nvim;end

#emacs
alias emacs "setsid emacsclient -c -a 'emacs'"
alias ec "setsid emacsclient >/dev/null"
alias rem "killall emacs;env emacs --daemon"
alias temacs  "/home/user/.nelisp/emacs/src/temacs -Q"
alias nemacs  "nvim --clean -u /home/user/.nelisp/nelisp/save/setup.lua"

#other
abbr dtmp 'cd (mktemp -d -p /tmp/user)'
abbr ctu 'cd /tmp/user'
for i in $langs;for j in $langs
    if test $i != $j
        alias "tra$i$j" "trans -b $i:$j (read)"
    end
end;end
alias clock 'termdown -z -Z "%H : %M : %S"'
# alias mousetty 'sudo systemctl start gpm.service'
function clearfuncs;for i in (functions -a);functions -e $i;end;end
function countdown
    set save (hyprctl activeworkspace -j|jq .id)
    termdown $argv
    hyprctl dispatch workspace $save
end
alias tu "HOME=(mktemp -d)"
alias tb "curl -F file=@- 0x0.st"
alias nothing "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash"
alias mkc 'mkdir $argv;cd'
function qunzip;unzip $argv.zip&&cat $argv&&shred -uvz $argv;end
alias saferm 'shred -uvz'
function encrypt;env zip -r --encrypt $argv.zip $argv;end
alias ip "/bin/ip addr | awk '/inet / {print \$2}'"
alias lightup 'brightnessctl set 10+%'
alias lightdown 'brightnessctl set 10-%'
#alias beepoff 'sudo rmmod pcspkr.ko.zst'
function usercreator
    set web (curl "https://randomuser.me/api/?password=upper,lower,special,number,16-20&seed=$argv"(date +%Y50%m01%d) 2>/dev/null)
    echo $web|jq .results[0].login.username -r
    echo $web|jq .results[0].login.password -r
end
alias reset 'exec fish -C "$(status current-commandline|string split \;|tail +2)"'
function update_hosts
    begin;curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
        cat /etc/hosts.own;end|sudo tee /etc/hosts >/dev/null
end
function lnq;ln $argv (basename $argv);end
function gis
    pushd .
    cd ~/.etc/.other
    fish main.fish 2>/dev/null
    for i in .mozilla .config .config/nvim .tmp/lua/_later/ .config/dotfiles .qscript .gtd .etc .tmp/lua/vim-plugin-list/
        cd ~/$i
        if test "$(git status --porcelain)"
            echo $i
            git status --porcelain
        end
    end
    popd
end
function encsend
    zip /tmp/enc-out.zip $argv --encrypt
    /bin/cat /tmp/enc-out.zip|curl -F file=@- -F expires=1 0x0.st
    rm -f /tmp/enc-out.zip
end
function decget;unzip (curl "$argv"|psub);end
function exe;test -n "$argv"&&chmod u+x $argv||env ls -p|grep -v /|fzf|xargs -r chmod u+x;end
# alias tsh "sudo systemd-nspawn -D $HOME/.os /sbin/init"
alias wm "exec Hyprland"
# alias vimtip "curl -s -m 3 https://vtip.43z.one"
# alias nvimtip "curl https://www.vimiscool.tech/neotip"
# abbr icargo evcxr
abbr weather "curl wttr.in/\?nFQ"
abbr scan_open_ports "nmap -p- 127.0.0.1"
function nprog
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
function chat
    hey -c
    printf "\e[A"
    hey -- (read)
end
function chatt
    hey -c
    printf "\e[A"
    set a (read)
    while test -n "$a"
        hey -- $a
        printf "\e[A"
        set a (read)
    end
end
function ffuncs;functions -a|fzf --preview="fish -ic 'type {1}|bat -pp -l fish --color=always'";end
function cal;env cal -wm --color=always $argv|lolcat;end
alias neofetch 'clear;fastfetch|lolcat'

#installer
if not type fisher >/dev/null 2>&1
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end
for i in jorgebucaran/fisher nickeb96/puffer-fish andreiborisov/sponge ilancosman/tide
    cat ~/.config/fish/fish_plugins|string match $i >/dev/null||fisher install $i
end

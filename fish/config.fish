#preload
if not status --is-interactive;exit;end
[ $SHLVL = 1 ]&&echo

#vars
test "$BROWSER"||set -U BROWSER firefox
test "$TEMPFILE"||set -U TEMPFILE /tmp/lua/temp.lua
alias invim 'not [ $INSIDE_EMACS ]&&[ $NVIM ]'
test -d /tmp/user||mkdir /tmp/user
set fish_greeting
set langs 'en' 'es' 'sv' 'hu'
set -x EDITOR nvim #/usr/bin/nvr
set -x VISUAL nvim #/usr/bin/nvr
set -x PAGER 'bat -p --paging=always'
set -x MANPAGER "bat -l man -p"
set -x READ_QUICKLY_RATE 350
set -x PYTHONPATH "$HOME/.venv/lib/python3.11/site-packages"
set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/.doom/bin
set -p fish_function_path ~/.config/fish/self_functions
set -p fish_complete_path ~/.config/fish/self_completions
fish_vi_key_bindings

#hooks
if invim
    function __hook_nvim_lcd -v PWD;nvr -c "silent! lcd $PWD" &;end
    nvr -c "silent! lcd $PWD" &
end

#source
zoxide init fish| source
if not test -f ~/.config/fish/carapace/carapace.fish
    mkdir -p ~/.config/fish/carapace
    carapace --list|awk '{print $1}'|xargs -I{} touch ~/.config/fish/carapace/{}.fish
end
set -p fish_complete_path ~/.config/fish/carapace
carapace _carapace|source
finit

#temp
alias ntmp 'set -U tmp (mktemp -p /tmp/user)'
alias tmp '$EDITOR "$tmp"'
abbr dtmp 'cd (mktemp -d -p /tmp/user)'
abbr nmp 'ntmp;tmp'

#installer
alias yas "yay -S"
alias yaS "yay -Ss"
alias yar "yay -R"
alias yau "yay -Syyu"
alias yac "yay -Yc&&not yay -Qdtq"
alias yauc "yay -Syyu&&yay -Yc&&not yay -Qdtq"
alias yai "yay -Si"
abbr yaq "yay -Q"
abbr yaf "yay -Qo"
abbr yal "yay -Ql"
alias mirror "curl https://archlinux.org/mirrorlist/all/"

#git
abbr gc "git clone"
abbr gp "git push"
abbr g_CA "git commit -a -m (git status --porcelain|string join ';')"
abbr gca "git commit -a -m"
abbr gcd "git checkout development"
abbr gch "git checkout"
abbr gmd "git merge development"
abbr gs "git status"
abbr gd "git diff"
abbr gi "gh gist"

#typical optinos
function cal;command cal -wm --color=always $argv|lolcat;end
alias rm 'rm -I'
alias cp 'cp -rib'
alias xcp 'xcp -rn'
alias mv 'mv -ib'
alias ln 'ln -ibs'
alias mkdir 'mkdir -p'
alias touch 'mkdir -p (dirname $argv)&&command touch'
alias neofetch 'clear;command neofetch'
alias wget 'wget -c'
alias fd 'fd -H'
alias zip 'zip -r -v'
function ranger;riv ranger "nvr -c 'Ranger $argv'" --cmd 'set show_hidden=true' --cmd 'set preview_images=true' $argv;end
abbr date 'date +"  %H:%M:%S  %Y/%m/%d;%V"'
function file;echo (exa -dF --color=always $argv)':'(command file -b $argv);end
alias termdown 'termdown -B'

#namig
##shorter names
abbr :q exit
abbr :Q exit
abbr z.. z\ ..
abbr z/ z\ ..
abbr t tldr
alias c clear
alias r ranger
alias rr "command ranger"
alias py python
alias cr touch
alias mkd mkdir
alias pow acpi
alias s sudo
alias com command
alias v vim
alias g grep
alias img2txt tesseract
alias wifi nmtui-connect
alias h helix
alias cargob bacon
alias cargoc cargo\ clippy
alias rich "python -m rich"
##other is beter
alias ls 'exa -aF'
alias l 'exa -F'
alias ll 'l -lh --git'
alias la 'ls -lh --git'
alias hex hexyl #xxd
alias cp xcp
abbr cd z
alias more 'bat -p --paging=always --pager="less --SILENT -RF"'
alias less 'bat -p --paging=always --pager="less --SILENT -RF"'
alias vim nvim
alias cat "bat -pp"
alias tree "exa -T"
alias nano micro
alias find fd
alias df duf
alias du dua
alias pip ~/.venv/bin/pip
alias sudo doas
#common path
function rtmp;ranger /tmp;end
function rtmpu;ranger /tmp/user;end

#vim
function riv;invim&&sh -c $argv[2]&&kill (cut -f 6 -d " " /proc/$fish_pid/stat)||command $argv[1] $argv[3..];end
function nvim;riv nvim "[ $argv ]&&nvr $argv||nvr ." $argv;end
alias spvim "set -e VIMRUNTIME;command vim"
function nvst
    command nvim .bashrc +q --startuptime /tmp/sut
    cat /tmp/sut|cat|tail +7|cut -c 10-|sort -n>/tmp/sut
end
alias kpn 'pkill -9 -P 1 "nvim\$";pkill -9 -P 1 -f language_server_linux_x64'

#emacs
alias emacs "setsid emacsclient -c -a 'emacs'"
alias ec "command setsid emacsclient >/dev/null"
alias rem "killall emacs;command emacs --daemon"
alias doos "doom sync"

#other
alias doimportantstuff genact
alias list_ports 'lsof -i'
for i in $langs;for j in $langs
    alias "tr$i$j" "trans -b $i:$j"
end;end
abbr hidemouse 'xbanish -a'
alias force_exit 'builtin exit'
alias clock 'termdown -z -Z "%H : %M : %S"'
alias mousefast 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5'
alias mouseslow 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0'
alias mousesnail 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" -0.5'
alias mousewritemove 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" libinput\ Disable\ While\ Typing\ Enabled false'
function testnet;nm-online;end
alias copy 'xsel -b'
function clearfuncs;for i in (functions -a|string split ",");functions -e $i;end;end
function countdown
    set save (wmctrl -d|grep \*|cut -d\  -f 1)
    termdown $argv
    wmctrl -s $save
end
function mnt;udisksctl mount -b /dev/sdb;end
alias tu "env HOME=(mktemp -d) "
alias scud 'env HOME=$PWD '
alias tb "nc termbin.com 9999"
alias nothing "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash"
alias mkc 'mkdir $argv;cd'
function qunzip;unzip $argv.zip&&cat $argv&&shred -uvz $argv;end
alias saferm 'shred -uvz'
function encrypt;command zip -r --encrypt $argv.zip $argv;end
alias ip 'hostname --ip-addresses'
alias lightup 'brightnessctl set 10+%'
alias lightdown 'brightnessctl set 10-%'
alias beepoff 'sudo rmmod pcspkr.ko.zst'
function usercreator
    set web (curl "https://randomuser.me/api/?password=upper,lower,special,number,16-20&seed=$argv"(date +%Y50%m01%d) 2>/dev/null)
    echo $web|jq .results[0].login.username -r
    echo $web|jq .results[0].login.password -r
end
alias reload 'exec fish -C "$(status current-commandline|string split \;|tail +2)"'
alias tidereset 'echo 1 1 1 1 1 1 y|tide configure'
function update_hosts
    set file (mktemp)
    curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts>$file
    cat /etc/hosts.own>>$file
    cat $file|sudo tee /etc/hosts >/dev/null
    rm $file
end
alias blanket "command setsid blanket -h"
function lnq;ln $argv (basename $argv);end
alias wifilist 'nmcli device wifi list'
function fsetsid;setsid fish -ic "$argv";end
function fedit
    set file (fd -t file $argv|fzf -1)
    if not test $file;return;end
    $EDITOR $file
end
alias fixmouse "sudo rmmod psmouse;sudo modprobe psmouse"

#intaller
if not type fisher >/dev/null 2>&1
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end
set _plugins jorgebucaran/fisher nickeb96/puffer-fish andreiborisov/sponge ilancosman/tide
for i in $_plugins
    cat ~/.config/fish/fish_plugins|string match $i >/dev/null||fisher install $i
end

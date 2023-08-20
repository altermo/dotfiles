#preload
if not status --is-interactive;exit;end
if tty >/dev/null&&tty|grep tty >/dev/null;exec zellij;end
[ $SHLVL = 1 ]&&echo

#vars
##dir_path
set USBPATH '/run/media/user/ad55d285-c217-4306-8a5d-3a0aab35c3d4'
set CONFSAVE "$USBPATH/confsave"
set LOGPATH "$HOME/.local/share/qtile/qtile.log" "$HOME/.xsession-errors" "$HOME/.local/state/nvim/log"
set MYTEMP /tmp/user
test -d /tmp/user||mkdir /tmp/user
##file_path
set gtd "$HOME/.gtd"
set burn "$gtd/school.schedule"
set hburn "$gtd/mainin.txt"
##func
function nclfz
    set pa (echo $argv[3..]|string split " "|fzf -1)
    [ "$pa" ]&&$argv[1] "$argv[2]/$pa"
end
alias invim 'not [ $INSIDE_EMACS ]&&[ $NVIM ]'
##variants
test "$BROWSER"||set -U BROWSER firefox
test "$TEMPFILE"||set -U TEMPFILE /tmp/lua/temp.lua
##other
set langs 'en' 'es' 'sv' 'hu'
set -x EDITOR nvim #/usr/bin/nvr
set -x VISUAL nvim #/usr/bin/nvr
set -x PAGER 'bat -p --paging=always'
#set -x MANPAGER "sh -c 'col -bx | bat -l man -p --pager=\"less --SILENT -RF\"'"
set -x MANPAGER "bat -l man -p"
set -x READ_QUICKLY_RATE 350
set -x PYTHONPATH "$HOME/.venv/lib/python3.11/site-packages"
fish_add_path "$HOME/.venv/bin"
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.emacs.d/bin"
set -p fish_function_path ~/.config/fish/self_functions
set -p fish_complete_path ~/.config/fish/self_completions

#hooks
if invim
    function __hook_nvim_lcd -v PWD
        nvr -c "silent! lcd $PWD" &
    end
    nvr -c "silent! lcd $PWD" &
end

#source
zoxide init fish| source
carapace _carapace|source

#translator
for i in $langs;for j in $langs
    alias "tr$i$j" "trans -b $i:$j"
end;end

#temp
alias ntmp 'set -U tmp (mktemp -p $MYTEMP)'
alias tmp '$EDITOR "$tmp"'
abbr dtmp 'cd (mktemp -d -p $MYTEMP)'
abbr nmp 'ntmp;tmp'

#ls and cd
##ls
alias ls 'exa -aF'
alias l 'exa -F'
alias ll 'l -lh --git'
alias la 'ls -lh --git'
alias l. 'ls -d .*' #What?! (bash vesrion: "ls -d $(ls -A|grep '^\.') --color=auto")
##cd
alias .. 'z ..'
alias ... 'z ../..'

#spell corrector
abbr mkr mkd
abbr z/ 'z /'
abbr z.. 'z ..'
abbr :q exit
abbr :Q exit
abbr print printf
abbr cd z

#installer
alias yas "yay -S"
alias yaS "yay -Ss"
alias yar "yay -R"
alias yau "yay -Syyu"
alias yac "yay -Yc"
alias yai "yay -Si"
alias mirror "curl https://archlinux.org/mirrorlist/all/"

#git
abbr gc "git clone"
abbr gp "git push"
abbr g_CA "git commit -a -m (git status --porcelain|string join ';')"
abbr gca "git commit -a -m"
abbr gcd "git checkout development"
abbr gcm "git checkout main"
abbr gs "git status"
abbr gd "git diff"

#typical optinos
alias firefox 'command setsid firefox'
function cal;command cal -wm --color=always $argv|lolcat;end
alias rm 'rm -I'
alias cp 'cp -rib'
alias mv 'mv -ib'
alias ln 'ln -ibs'
alias mkdir 'mkdir -p'
alias neofetch 'clear;command neofetch'
alias wget 'wget -c'
alias fd 'fd -H'
#alias ag 'ag --hidden'
#alias rg 'rg --.'
alias zip 'zip -r -v'
function ranger
    riv ranger "nvr -c 'Ranger $argv'" --cmd 'set show_hidden=true' --cmd 'set preview_images=true' $argv
end
abbr date 'date +"  %H:%M:%S  %Y/%m/%d;%V"'
function file;echo (exa -dF --color=always $argv)':'(command file -b $argv);end
function setsid;command setsid fish -ic "$argv";end
alias termdown 'termdown -B'

#namig
##shorter names
alias fox firefox
alias fire firefox
alias c clear
alias r ranger
alias rr "command ranger"
alias py python
alias cr touch
alias mkd mkdir
alias pow acpi
alias s sudo
alias com command
alias p printf
alias v vim
alias g grep
alias i info
alias rel watch
alias qread read-quickly
alias imgtotxt tesseract
alias sudo doas
alias wifi nmtui-connect
alias hex hexyl #xxd
##other is beter
alias more 'bat -p --paging=always --pager="less --SILENT -RF"'
alias less 'bat -p --paging=always --pager="less --SILENT -RF"'
alias youtube-dl yt-dlp
alias vim nvim
alias cat "bat -pp"
alias tree "exa -T"
alias nano micro
alias find fd
alias df duf
alias du dua
alias pip ~/.venv/bin/pip

#common path
##ranger
function rp;ranger $USBPATH;end
function rtmp;ranger $MYTEMP;end
function rD;ranger ~/Downloads/;end
##fzf
function fc;nclfz ranger $HOME/.config (exa $HOME/.config);end
function fs;nclfz ranger $HOME/.local/share (exa $HOME/.local/share);end
function fl;nclfz nvim / $LOGPATH;end

#musik player
function pm;cd "$USBPATH/apps/musik player fish (7)";fish main.fish;end
function bm;mplayer "$USBPATH/pdf html"/*.mp3;end
function fpm;command setsid mplayer $USBPATH/ncs/(exa $USBPATH/ncs|fzf) >/dev/null 2>&1;end

#vim
function riv
    invim&&sh -c $argv[2]&&kill (cut -f 6 -d " " /proc/$fish_pid/stat)||command $argv[1] $argv[3..]
end
function nvim
    riv nvim "[ $argv ]&&nvr $argv||nvr ." $argv
end
alias spvim "set -e VIMRUNTIME;command vim"
alias snvim 'nvim-qt --server $NVIM'
alias uvim 'command nvim -n -u NONE'
function nvst
    set tmp (mktemp)
    command nvim .bashrc +q --startuptime $tmp
    cat $tmp|tail +7|cut -c 10-|sort -n>/tmp/sut
    rm $tmp
end
alias kpn 'pkill -9 -P 1 "nvim\$";pkill -9 -P 1 -f language_server_linux_x64'
alias pnv 'command nvim +"lua require\'plugins\'" +"PackerCompile"'
function fi
    set mainplugpath "$HOME/.local/share/nvim/site/pack/packer/"
    set subplugpaths "start/" "opt/"
    set pa (for i in $subplugpaths;string split0 $mainplugpath/$i/*|string replace $mainplugpath '';end\
    |fzf --preview "bat -pp $mainplugpath/{}/README.md --color=always")
    [ $pa ]&&ranger $mainplugpath/$pa
end
function fr
    cd /usr/local/share/nvim/runtime/lua/vim/
    set pa (fzf --preview "bat -pp {} --color=always")
    if [ $pa ]
        nvim $pa
    else
        cd -
    end
end

#emacs
alias emacs "emacsclient -c -a 'emacs -nw' -nw"
alias demacs 'command emacs --daemon'
alias em "command emacs -q -l ~/.config/emacs/init.el"
alias ec "command setsid emacsclient >/dev/null"
alias er "killall emacs;command emacs --daemon"
alias doos "doom sync"

#other
alias server "livereload" #python -m http.server
alias cargob bacon
alias cargoc clippy
alias clock 'termdown -z -Z "%H : %M : %S"'
alias idonotknowwhattodo 'firefox https://www.ted.com/'
alias mousefast 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5'
alias mouseslow 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0'
alias mousesnail 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" -0.5'
alias mousewritemove 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" libinput\ Disable\ While\ Typing\ Enabled false'
function ffuncs;functions -a|string split ,|fzf --preview="fish -ic 'type {1}|bat -pp -l fish --color=always'";end
alias pf "fzf --preview '[ -d {} ]&&exa -aF {}||bat {} -pp --color=always'"
alias term 'echo $TERM'
function Res;sudo killall lightdm;end
#function vb;vim $hburn;end
#function vimb;vim $burn;end
function vb
    open "obsidian://open?vault=vault&file=Mainin.md"
end
function testnet;nm-online;end
alias copy 'xsel -b'
function clearfuncs;for i in (functions -a|string split ",");functions -e $i;end;end
function countdown
    set save (wmctrl -d|grep \*|cut -d\  -f 1)
    termdown $argv
    wmctrl -s $save
end
function styles;for i in (seq 110);printf "\e[$i""m$i\t\e[m";[ (math $i%10) = 0 ]&&echo;end;end
function mnt;udisksctl mount -b /dev/sdb;end
alias tu "env HOME=(mktemp -d) "
alias scud 'env HOME=$PWD '
alias givemeno "sudo localectl set-x11-keymap no"
alias tb "nc termbin.com 9999"
alias nothing "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash"
alias ct "touch (date +%Y-%m-%d)'.txt'"
alias mkt 'mkdir (date +%Y-%m-%d)'
alias mkc 'mkdir $argv;cd'
function fec;fennel -c $argv > (echo $argv|sed 's/.fnl$/.lua/');end
function qunzip;unzip $argv.zip&&cat $argv&&shred -uvz $argv;end
alias saferm 'shred -uvz'
function encrypt
    command zip -r --encrypt $argv.zip $argv
    if test $status != 0
        return 1;
    end
    if not test -f $argv.zip
        return 1
    end
    if test $status != 0
        return 1;
    end
    shred -fuz $argv
end
alias ip 'hostname --ip-addresses'
function bak;cp $argv $argv.bak;end
abbr choice 'random choice'
abbr lvl 'echo $SHLVL'
abbr rmheader "tail +2"
alias lightup 'brightnessctl set 10+%'
alias lightdown 'brightnessctl set 10-%'
alias beepoff 'sudo rmmod pcspkr.ko.zst'
function usercreator
    set web (curl "https://randomuser.me/api/?password=upper,lower,special,number,16-20&seed=$argv"(date +%Y50%m01%d) 2>/dev/null)
    echo $web|jq .results[0].login.username -r
    echo $web|jq .results[0].login.password -r
end
alias reload 'exec fish'
alias paths 'echo $PATH|tr " " "\n"'
alias tidereset 'echo 1 1 1 1 1 1 y|tide configure'
function update_hosts
    set file (mktemp)
    curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts>$file
    cat /etc/hosts.own>>$file
    cat $file|sudo tee /etc/hosts >/dev/null
    rm $file
end
alias blanket "command setsid blanket -h"

#intaller
if type fisher >/dev/null 2>&1
    function fins
        set name $argv[1]
        switch $name
        case end
        case start
            set -g _fins
            fins jorgebucaran/fisher
        case clean
            for i in (cat ~/.config/fish/fish_plugins)
                string match $i $_fins >/dev/null||fisher remove $i
            end
        case install
            fins clean
            for i in $_fins
                cat ~/.config/fish/fish_plugins|string match $i >/dev/null||fisher install $i
            end
        case update
            fins clean
            fisher update
        case sync
            fins clean
            fins update
            fins install
        case '*'
            echo $name|grep "[a-zA-Z0-9_.-]\+/[a-zA-Z0-9_.-]\+" >/dev/null 2>&1 ||echo "fins error: name $name invalide"&&echo $name|set -a _fins $name
        end
    end
    fins start
    #keys
    fins nickeb96/puffer-fish
    #other
    fins andreiborisov/sponge
    #visual
    fins ilancosman/tide
    fins end
end
# vim:fen:

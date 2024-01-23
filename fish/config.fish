#preload
if not status --is-interactive;exit;end
if tty>/dev/null&&test (math (date +%s) - (stat -c %Y /tmp/gh.not 2>/dev/null||echo 0)) -gt 60
    setsid sh -c 'nm-online -q||exit
    notif=$(gh api notifications|jq "length")
    test 0 = $notif||echo -e "\e[7m\ngithub: you have received $notif notifications\e[0m"'&
    disown
    touch /tmp/gh.not
end

#vars
alias invim 'not [ $INSIDE_EMACS ]&&[ $NVIM ]'
test "$TEMPFILE"||set -U TEMPFILE /tmp/user/temp.lua
test -d /tmp/user||mkdir /tmp/user
set fish_greeting
set langs 'en' 'es' 'sv' 'hu'
set -x EDITOR nvim #/usr/bin/nvr
set -x VISUAL nvim #/usr/bin/nvr
set -x PAGER 'bat --decorations never --paging=always --pager="less --SILENT -RF"'
set -x MANPAGER "$PAGER -l man"
set -x READ_QUICKLY_RATE 350
set -x PYTHONPATH "$HOME/.venv/lib/python3.11/site-packages"
set -U fish_user_paths $HOME/.local/bin $HOME/.cargo/bin
set -p fish_function_path ~/.config/fish/self_functions
set -p fish_complete_path ~/.config/fish/self_completions
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_replace     underscore
set fish_cursor_visual      block
fish_vi_key_bindings

#hooks
if invim
    function __hook_nvim_lcd -v PWD;nvr -c "silent! lcd $PWD" &;end
    nvr -c "silent! lcd $PWD" &
end

#source
if not test -f ~/.config/fish/carapace/carapace.fish
    mkdir -p ~/.config/fish/carapace
    carapace --list|awk '{print $1}'|xargs -I{} touch ~/.config/fish/carapace/{}.fish
end
set -p fish_complete_path ~/.config/fish/carapace
carapace _carapace|source
zoxide init fish|source

#fzf
function ff;plocate (dirname $PWD/.) $argv|fzf|read out&&test -d $out&&cd $out||begin;test -f $out&&$EDITOR $out;end;end
function ffuncs;functions -a|fzf --preview="fish -ic 'type {1}|bat -pp -l fish --color=always'";end
function fc;command ls ~/.config|fzf|read out&&test $out&&ranger ~/.config/$out;end
function ft;tldr -l|fzf --preview 'tldr --color=always {}'|xargs -r tldr;end

#installer
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
abbr mirror "curl https://archlinux.org/mirrorlist/all/"

#git
#abbr gCA "git commit -a -m (git status --porcelain|string join ';')"
abbr gc "git clone"
abbr gp "git push"
abbr gca "git commit -a -m"
abbr ga "git commit -a --amend"
abbr gt "git checkout"
abbr gmd "git merge development"
abbr gs "git status"
abbr gd "git diff"
abbr gi "gh gist"
abbr gb "git bisect" #Find buged commit

#optinos
function cal;command cal -wm --color=always $argv|lolcat;end
alias rm 'rm -I'
alias cp 'cp -rib'
alias xcp 'xcp -rn'
alias mv 'mv -ib'
alias ln 'ln -ibs'
alias mkdir 'mkdir -p'
alias touch 'mkdir -p (dirname $argv)&&command touch'
alias neofetch 'clear;command fastfetch'
alias wget 'wget -c'
alias fd 'fd -H'
alias zip 'zip -r -v'
alias termdown 'termdown -B'

#namig
##shorter names
abbr :q exit
abbr :Q exit
abbr z.. z\ ..
abbr z/ z\ /
abbr - z\ -
abbr t tldr
abbr c clear
abbr r ranger
abbr rr "command ranger"
abbr cr touch
abbr mkd mkdir
abbr pow acpi
abbr com command
abbr v nvim
abbr g grep
abbr img2txt tesseract
abbr wifi nmtui-connect
abbr list_ports 'lsof -i'
abbr copy 'xsel -b'
##other
alias cargob "watchexec cargo check"
alias cargoc cargo\ clippy
#alias rich "python -m rich"
abbr date 'date +"  %H:%M:%S  %Y/%m/%d;%V"'
alias ls 'exa -aF'
alias l 'exa -F'
alias ll 'l -lh --git'
alias la 'ls -lh --git'
abbr cp xcp
alias more "$PAGER"
alias less "$PAGER"
alias cat "bat -pp"
alias pip ~/.venv/bin/pip
abbr cd z
abbr vim nvim
abbr tree "exa -T"
abbr find fd
abbr df duf
abbr du dua
abbr sudo doas

#vim
function riv;invim&&sh -c $argv[2]&&kill (cut -f 6 -d " " /proc/$fish_pid/stat)||command $argv[1] $argv[3..];end
function nvim
    if string match -q -r -- '^[-+]' $argv
        command nvim $argv
        return
    end
    riv nvim "[ $argv ]&&nvr $argv||nvr ." $argv
end
function ntime;time $argv[1] +"autocmd VimEnter * quit" $argv[2..];end
alias kpn 'pkill -9 -P 1 "^nvim\$";pkill -9 -P 1 -f language_server_linux_x64'
alias vimacs 'NVIM_APPNAME=vimacs command nvim'
alias nvchad 'NVIM_APPNAME=NvChad command nvim'
alias spvim 'NVIM_APPNAME=SpaceVim command nvim'

#emacs
alias emacs "setsid emacsclient -c -a 'emacs'"
alias ec "setsid emacsclient >/dev/null"
alias rem "killall emacs;command emacs --daemon"
alias umacs "command emacs --init-directory=/home/user/.config/emacs/"

#other
function ranger;riv ranger "nvr -c 'lua require\"small.ranger\".run(\"$argv\")'" $argv;end
abbr dtmp 'cd (mktemp -d -p /tmp/user)'
function rtmp;ranger /tmp;end
function rtmpu;ranger /tmp/user;end
alias icat 'test $TERM = xterm-kitty&&kitty +kitten icat $argv||chafa'
for i in $langs;for j in $langs
    alias "tr$i$j" "trans -b $i:$j"
end;end
alias clock 'termdown -z -Z "%H : %M : %S"'
alias mousefast 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0.5'
alias mouseslow 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" 0'
alias mousesnail 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" "libinput Accel Speed" -0.5'
alias mousewritemove 'xinput set-prop "AlpsPS/2 ALPS GlidePoint" libinput\ Disable\ While\ Typing\ Enabled false'
alias mousehide 'xbanish -a'
alias mousetty 'sudo systemctl start gpm.service'
function clearfuncs;for i in (functions -a);functions -e $i;end;end
function countdown
    set save (wmctrl -d|grep \*|cut -d\  -f 1)
    termdown $argv
    wmctrl -s $save
end
function mnt;udisksctl mount -b /dev/sdb;end
alias tu "HOME=(mktemp -d)"
#alias tb "nc termbin.com 9999"
alias tb "curl -F file=@- 0x0.st"
alias nothing "curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash"
alias mkc 'mkdir $argv;cd'
function qunzip;unzip $argv.zip&&cat $argv&&shred -uvz $argv;end
alias saferm 'shred -uvz'
function encrypt;command zip -r --encrypt $argv.zip $argv;end
alias ip "/bin/ip addr | awk '/inet / {print \$2}'"
alias lightup 'brightnessctl set 10+%'
alias lightdown 'brightnessctl set 10-%'
alias beepoff 'sudo rmmod pcspkr.ko.zst'
function usercreator
    set web (curl "https://randomuser.me/api/?password=upper,lower,special,number,16-20&seed=$argv"(date +%Y50%m01%d) 2>/dev/null)
    echo $web|jq .results[0].login.username -r
    echo $web|jq .results[0].login.password -r
end
alias reload 'exec fish -C "$(status current-commandline|string split \;|tail +2)"'
alias tidereset 'echo 1 1 1 1 1 1 1 y|tide configure'
function update_hosts
    begin;curl https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts;
        cat /etc/hosts.own;end|sudo tee /etc/hosts >/dev/null
end
alias blanket "command setsid blanket -h"
function lnq;ln $argv (basename $argv);end
alias wifilist 'nmcli device wifi list'
function fsetsid;setsid fish -ic "$argv";end
function gis
    pushd .
    cd ~/.etc/.other
    fish main.fish 2>/dev/null
    for i in .mozilla .config .config/nvim .config/nvim/.other/_later .config/dotfiles .musiclist .qscript .gtd/vault .etc .config/nvim/.other/small.nvim/ .config/nvim/.other/ua/ .config/nvim/.other/ua_/ .config/nvim/.other/vim-plugin-list/
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
    /bin/cat /tmp/enc-out.zip|curl -F file=@- 0x0.st
    rm -fr /tmp/enc-out.zip
end
function decget;unzip (curl "$argv"|psub);end
alias exe "command ls -p|grep -v /|fzf|xargs -r chmod u+x"
alias tsh "sudo systemd-nspawn -D $HOME/.os /sbin/init"
alias wm "exec sx qtile start"
alias vimtip "curl -s -m 3 https://vtip.43z.one"

#installer
if not type fisher >/dev/null 2>&1
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end
set _plugins jorgebucaran/fisher nickeb96/puffer-fish andreiborisov/sponge ilancosman/tide
for i in $_plugins
    cat ~/.config/fish/fish_plugins|string match $i >/dev/null||fisher install $i
end
# vim:fen:

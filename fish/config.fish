if not status --is-interactive;exit;end
if tty>/dev/null&&test (math (date +%s) - (stat -c %Y /tmp/gh.not 2>/dev/null||echo 0)) -gt 60
    sh -c 'timeout 1 ping github.com >/dev/null 2>&1 -c 1||exit
    notif=$(gh api notifications|jq "length")
    test 0 = "$notif"||echo -e "\e[7m\ngithub: you have received $notif notifications\e[0m"'&
    disown
    touch /tmp/gh.not
end


remind &;disown

type -q tmux&&tmux ls 2>/dev/null
type -q zellij&&zellij ls 2>/dev/null

trash empty --before 30d -f &;disown

# ;; vars
test "$TEMPFILE"||set -U TEMPFILE /tmp/user/temp.lua
test -d /tmp/user||mkdir /tmp/user
set fish_greeting
set langs 'en' 'sv' 'hu'
set -x PAGER 'less -RF'
set -x MANPAGER 'nvim --clean +Man!'
set -U fish_user_paths $HOME/projects/bin/*

set -x HISTFILE $HOME/.cache/bash_history
set -x PYTHON_HISTORY $HOME/.cache/python_history

set fish_key_bindings fish_vi_key_bindings
set fish_cursor_insert      line
set fish_cursor_replace_one underscore
set fish_cursor_replace     underscore
set fish_cursor_visual      block

# ;; sources/hooks
if test ~/.config/fish/config.fish -nt ~/.config/fish/functions/rm.fish
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
        printf "complete -e '$i'\ncomplete -c '$i' -f -a '(_carapace_completer $i)'" > ~/.config/fish/completions/$i.fish
    end
    carapace _carapace|head -n21 > ~/.config/fish/functions/_carapace_completer.fish
    mpvc completion fish > ~/.config/fish/completions/mpvc.fish
end

if not functions -q tide
  set -l _tide_tmp_dir (command mktemp -d)
  curl https://codeload.github.com/ilancosman/tide/tar.gz/v6 | tar -xzC $_tide_tmp_dir
  command cp -R $_tide_tmp_dir/*/{completions,conf.d,functions} $__fish_config_dir
end
alias_ tide_config "tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='One line' --prompt_spacing=Compact --icons='Few icons' --transient=Yes"

zoxide init fish|source

alias invim 'test $NVIM'
if invim
    function __hook_nvim_lcd -v PWD;nvr -c "silent! lcd $PWD" &;end
    nvr -c "silent! lcd $PWD" &
end

# ;; git
abbr gCA "git commit -a -m (git status --porcelain|string join ';')"
abbr gca "git commit -v -a"
abbr gcaa "git commit -v --amend -a"
abbr gcam "git commit -a -m"
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
alias_ fd 'fd -H'
alias_ zip 'zip -r -v'
alias_ termdown 'termdown -B'
alias_ clear 'TERM=xterm env clear'
alias_ df 'df -h --output=source,fstype,size,used,pcent,avail,target'

# ;; namig
## spell mistake
abbr :q exit
abbr :Q exit
abbr unmount umount
## smaller name
abbr - z\ -
abbr ... z\ ../..
abbr .... z\ ../../..
abbr c clear
abbr r yazi
abbr cr touch
abbr mkd mkdir
abbr pow acpi
abbr v nvim
abbr wifi nmtui-connect
## use other
alias_ ed "nvim --clean -E"
alias ls 'eza -aF'
alias l 'eza -F'
alias ll 'eza -F -lh --git'
alias_ la 'eza -aF -lh --git'
alias_ more "$PAGER"
alias_ less "$PAGER"
alias_ cat "bat -pp"
alias_ lolcat 'dotacat -F 0.05'
abbr cp xcp
abbr cd z
abbr tree "eza -T"
abbr find fd
abbr du dua
abbr wget wget2

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
    NVIM_APPNAME=$out env nvim $argv
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
alias_ tu "HOME=(mktemp -d -p /tmp/user --suffix=-home)"
alias_ tb "curl -F file=@- 0x0.st"
alias_ saferm 'shred -uvz'
alias_ myip "ip addr | awk '/inet / {print \$2}'"
function lnq;ln $argv (basename $argv);end
function gis
    pushd .
    for i in .config projects/conf/* projects/other/*
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

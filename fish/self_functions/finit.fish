set logpath "$HOME/.local/share/qtile/qtile.log" "$HOME/.xsession-errors" "$HOME/.local/state/nvim/log"
function ffuncs;functions -a|string split ,|fzf --preview="fish -ic 'type {1}|bat -pp -l fish --color=always'";end
function nclfz
    set pa (echo $argv[3..]|string split " "|fzf -1)
    [ "$pa" ]&&$argv[1] "$argv[2]/$pa"
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
function fi
    set mainplugpath "$HOME/.local/share/nvim/site/pack/pckr/"
    set subplugpaths "start/" "opt/"
    set pa (for i in $subplugpaths;string split0 $mainplugpath/$i/*|string replace $mainplugpath '';end\
    |fzf --preview "bat -pp $mainplugpath/{}/README.md --color=always")
    [ $pa ]&&ranger $mainplugpath/$pa
end
function fc;nclfz ranger $HOME/.config (exa $HOME/.config);end
function fs;nclfz ranger $HOME/.local/share (exa $HOME/.local/share);end
function fl;nclfz nvim / $logpath;end
function ft;tldr (tldr -l|fzf --preview 'tldr --color=always {}');end
function ff
    set pa (echo config\nshare\nlog\nnvim-runtime\nnvim-plugins\nfile-finder\ntldr\n|fzf)
    if not test $pa;return;end
    switch $pa
        case config;fc
        case tldr;ft
        case log;fl
        case share;fs
        case nvim-runtime;fr
        case nvim-plugins;fi
        case file-finder;fsf
    end
end
function finit;end

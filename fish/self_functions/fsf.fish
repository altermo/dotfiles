function fsf
    set DEFAULT_LS 'exa -aF'
    set DEFAULT_CAT 'bat {} -pp --color=always'
    set DEFAULT_FZF_OPTIONS --bind backward-eof:'execute(echo //)+abort'\
        --preview "[ -d {} ]&&$DEFAULT_LS {}||$DEFAULT_CAT {}"
    argparse f/fzf -- $argv
    if set -q argv[1]
        set path (realpath $argv[1])
    else
        set path $PWD
    end
    set fzf_options $DEFAULT_FZF_OPTIONS
    set -q _flag_fzf||set fzf_options $fzf_options -e
    while :;
        if not test -e $path
            echo "$path is not a valid path"
            return 1
        end
        cd $path
        set ret (for i in (command ls -A $path);test -d $i&&echo "$i/"||echo $i ;end|fzf $fzf_options --prompt "$path > " --sync)
        if test $status != 0
            if test "$ret" = //
                set path (realpath "$path/..")
                continue
            end
            cd $path
            return
        end
        set path (realpath "$path/$ret")
        if test -f $path
            $EDITOR $path
            return
        end
    end
end

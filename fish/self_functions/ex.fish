function ex
    not [ -f "$argv[1]" ]&&
        echo "'$argv[1]' is not a valid file!"&&return
    switch "$argv[1]"
        case '*.tar.bz2';tar xvjf "$argv[1]"
        case '*.tar.gz';tar xvzf "$argv[1]"
        case '*.bz2';bunzip2 "$argv[1]"
        case '*.rar';rar x "$argv[1]"
        case '*.gz';gunzip "$argv[1]"
        case '*.tar';tar xvf "$argv[1]"
        case '*.tbz2';tar xvjf "$argv[1]"
        case '*.tgz';tar xvzf "$argv[1]"
        case '*.zip';unzip "$argv[1]"
        case '*.Z';uncompress "$argv[1]"
        case '*.7z';7z x "$argv[1]"
        case '*';echo "don't know how to extract '$argv[1]'"
end;end

function dmacho
    set manual (begin
        apropos ''
        ls /usr/share/fish/man/man1/|awk -F'.' '{print $1" ("$2")"}'
    end|\
    grep -v -E '^.+ \(0\)'|\
    grep -v -E '^.+ \(.+p\)'|\
    awk '{print $1}'|\
    sort|uniq|dmenu|\
    sed -E 's/^\((.+)\)/\1/')
    [ "$manual" ]&&fish -c "man $manual"
end

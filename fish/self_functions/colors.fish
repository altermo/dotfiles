function colors
    function prcolor
        printf "\e[48:5:$argv[1]""m$argv[2]"
    end
    alias res 'printf "\e[0m\n"'
    for i in (seq 0 15)
        prcolor $i " "
    end
    res
    for i in (seq 16 231)
        prcolor $i " "
        [ (math $i%36) = 15 ]&&res
    end
    for i in (seq 232 255)
        prcolor $i " "
    end
    res
end

fsf (){
    while true; do
        if [ ! -e $path ]; then
            echo "$path is not a valid path"
            return 1
        fi
        cd $path
        if [ $status != 0 ]; then
            if [ "$ret" = "//" ];then
            fi
        fi
    done
}

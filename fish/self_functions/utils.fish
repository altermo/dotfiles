function fpd
    set -l dir (pwd -P 2>/dev/null)/.
    while test $dir != /
        set dir (string replace -r '[^/]*/?$' '' $dir)
        test -d $dir"$argv"&&echo $dir"$argv"&&return
    end
end
function pyspark
    python -c "import sys
def main(argv)->None:
    if not argv:print('use: spark 1 2 3');return
    argv=[*map(int,argv)]
    mi=min(argv)
    ma=max(argv)-mi
    print(''.join(('▁','▂','▃','▄','▅','▆','▇','█')[(i-mi)*7//ma] for i in argv))
if __name__=='__main__':
    main(sys.argv[1:])" $argv
end
function countchars
    cat $argv|tr -d '\n'|fold -w 1|sort|uniq -c|sort -n
end
function temp
    nvim -c "set filetype=$argv[1]" /tmp/temp-(date +'%Y%m%d-%H%M%S')
end
function utils
    echo "utils initialed"
end

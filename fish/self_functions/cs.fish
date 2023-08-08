function cs
    not [ -e $CONFSAVE ]&&return
    function copying;echo 'copying '$argv;end
    pushd .
    cd $CONFSAVE
    copying 'mozilla'
    command rm -r mozilla_2
    command mv mozilla mozilla_2
    cp ~/.mozilla/ mozilla
    copying 'emacs'
    command rm -r emacs
    cp ~/.config/emacs emacs
    set save (date +%Y-%m-%d-%H-%M-%S)
    mkdir $save
    cd $save
    copying 'conf'
    mkdir config
    cd config
    cp ~/.config/fish .
    cp ~/.config/nvim .
    cp ~/.config/qtile .
    cp ~/.config/qutebrowser .
    cp ~/.config/firefox .
    cp ~/.doom.d doom
    cd ..
    copying 'packlist'
    type pacman -q&&pacman -Q>packlist.txt
    type pip -q&&pip list>pip.txt 2>/dev/null
    type flatpak -q&&flatpak list>flatpak.txt
    copying 'test'
    cp ~/.test test
    copying 'burn'
    cp ~/.gtd gtd
    copying 'neofetch'
    neofetch --stdout>neofetch.txt
    copying 'scripts'
    cp ~/.qscript scripts
    popd
end

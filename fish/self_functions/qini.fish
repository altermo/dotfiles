set -g ISOPATH ~/.wm/iso
set -g QCOW2PATH ~/.wm/qcow2
alias rqemu "ranger $QEMUPATH"
alias rqcow2 "ranger $QCOW2PATH"
alias riso "ranger $ISOPATH"
function qemucreate
    set setup (mktemp)
    echo "qemu-system-x86_64" \\ >> $setup
    echo "    -cpu host -enable-kvm -smp 3" \\ >> $setup
    echo "    -m 2G" \\ >> $setup
    echo "    -device intel-hda" \\ >> $setup
    echo "    -device hda-duplex" \\ >> $setup
    echo "    -display sdl,grab-mod=rctrl" \\ >> $setup
    set iso (zenity --file-selection --filename="$ISOPATH/" --file-filter='iso | *.iso' 2>/dev/null)
    if [ "$iso" ]
        echo "    -cdrom '$iso'"\\ >>$setup
        echo "$iso"
    else
        echo 'no iso file'
    end
    read name -P'name:'||return
    if [ -e "$QEMUPATH/qemu-$name.sh" ]
        echo 'file alredy exsist'
        exit
    end
    echo "    -drive file='$QCOW2PATH/$name.qcow2',format=qcow2"\\ >>$setup
    cat $setup
    read -P'OK??'||return
    command mv -n $setup "$QEMUPATH/qemu-$name.sh"
    qemu-img create -f qcow2 "$QCOW2PATH/$name.qcow2" 20G>/dev/null
end
function qemuremove
    ls $QEMUPATH
    read name -P'name:'||return
    rm $QCOW2PATH/"$name".qcow2
    rm $QEMUPATH/qemu-"$name".sh
end
function qini
    echo "qemu-extra initilade"
end

# Reference: https://github.com/IlanCosman/tide
set -g __osflavor_use_nerd_font_icon 0  # default: false
function __osflavor_load_nerd_icons --description 'Load Nerd Font os icons'
    set -g __osflavor_dist_darwin     (set_color 333333)"" # from apple.com header
    set -g __osflavor_dist_freebsd    (set_color AB2B28)"" # https://freebsdfoundation.org/about-us/about-the-foundation/project/
    set -g __osflavor_dist_openbsd    (set_color AB2B28)"" # https://freebsdfoundation.org/about-us/about-the-foundation/project/
    set -g __osflavor_dist_dragonfly  (set_color AB2B28)"" # https://freebsdfoundation.org/about-us/about-the-foundation/project/
    set -g __osflavor_dist_cygwin     (set_color 00CCFF)"" # https://answers.microsoft.com/en-us/windows/forum/all/what-is-the-official-windows-8-blue-rgb-or-hex/fd57144b-f69b-42d8-8c21-6ca911646e44
    set -g __osflavor_dist_microsoft  (set_color 00CCFF)"" # https://answers.microsoft.com/en-us/windows/forum/all/what-is-the-official-windows-8-blue-rgb-or-hex/fd57144b-f69b-42d8-8c21-6ca911646e44
    set -g __osflavor_dist_android    (set_color 3C3F41)"ﲎ" # https://developer.android.com/distribute/marketing-tools/brand-guidelines
    set -g __osflavor_dist_alpine     (set_color 0D597F)"" # from alpine logo
    set -g __osflavor_dist_arch       (set_color 4D4D4D)"" # from arch wiki header
    set -g __osflavor_dist_centos     (set_color D4D4D4)"" # https://wiki.centos.org/ArtWork/Brand/Logo, monochromatic
    set -g __osflavor_dist_devuan                       "" # logo is monochromatic
    set -g __osflavor_dist_elementary (set_color D4D4D4)"" # https://elementary.io/brand, encouraged to be monochromatic
    set -g __osflavor_dist_fedora     (set_color 294172)"" # from logo https://fedoraproject.org/w/uploads/2/2d/Logo_fedoralogo.png
    set -g __osflavor_dist_gentoo     (set_color 54487A)"" # https://wiki.gentoo.org/wiki/Project:Artwork/Colors
    set -g __osflavor_dist_mageia     (set_color 262F45)"" # https://wiki.mageia.org/en/Artwork_guidelines
    set -g __osflavor_dist_manjaro    (set_color 35BF5C)"" # from https://gitlab.manjaro.org/artwork/branding/logo/-/blob/master/logo.svg
    set -g __osflavor_dist_mint       (set_color 69B53F)"" # extracted from https://linuxmint.com/web/img/favicon.ico
    set -g __osflavor_dist_nixos      (set_color 5277C3)"" # https://github.com/NixOS/nixos-artwork/tree/master/logo
    set -g __osflavor_dist_opensuse   (set_color 173f4f)"" # https://en.opensuse.org/openSUSE:Artwork_brand
    set -g __osflavor_dist_raspberry  (set_color A22846)"" # https://static.raspberrypi.org/files/Raspberry_Pi_Visual_Guidelines_2020.pdf
    set -g __osflavor_dist_rhel       (set_color 000000)"" # https://www.redhat.com/en/about/brand/standards/color
    set -g __osflavor_dist_sabayon                      "" # Can't find colors, and they are rebranding anyway
    set -g __osflavor_dist_slackware                    "" # Doesn't really have a logo, and the colors are too close to PWD blue anyway
    set -g __osflavor_dist_ubuntu     (set_color D4D4D4)"" # https://design.ubuntu.com/brand/
end


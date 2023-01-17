# author: T.Imanishi
# default prompt
set -g __osflavor_dist_OTHERS (set_color cyan)"❯❮❯"

# pre-defined osflavor for major distributions

# Windows
set -l ms_o (set_color f25022 red)
set -l ms_g (set_color 74ba00 green)
set -l ms_b (set_color 00a4ef blue)
set -l ms_y (set_color ffb900 yellow)
set -g __osflavor_dist_microsoft "$ms_o■$ms_g■$ms_b■$ms_y■"

# Classic Macintosh Rainbow
set -l mac_g (set_color 61bb46 green)
set -l mac_y (set_color fdb827 yellow)
set -l mac_o (set_color f5821f yellow)
set -l mac_r (set_color e03a3e red)
set -l mac_p (set_color 9a3d97 magenta)
set -l mac_b (set_color 009ddc blue)
set -g __osflavor_dist_darwin "$mac_g|$mac_y|$mac_o|$mac_r|$mac_p|$mac_b|"

# Ubuntu - https://design.ubuntu.com/brand/colour-palette/
set -l ubuntu_o (set_color e95420 yellow)   # Orange
set -l ubuntu_a (set_color 5e2750 magenta)  # Mid Aubergine
set -l ubuntu_g (set_color aea79f white)    # Warm Grey
set -g __osflavor_dist_ubuntu "$ubuntu_g❯$ubuntu_a❯$ubuntu_o❯"

# Fedora - https://fedoraproject.org/wiki/Logo/UsageGuidelines
# terminal needs 24bit color suppert
set -l fedora_b (set_color 3c6eb4 blue)  # Fedora Blue
set -l fedora_d (set_color 294172 blue)  # Fedora Dark Blue
set -l fedora_g (set_color white)        # White
set -g __osflavor_dist_fedora "$fedora_g❯$fedora_d❯$fedora_b❯"

# Raspberry Pi - https://static.raspberrypi.org/files/Raspberry_Pi_Visual_Guidelines.pdf
set -l pi_r (set_color c51a4a red)
set -l pi_g (set_color 6cc04a green)
set -g __osflavor_dist_raspberry "$pi_g⡱$pi_r❆"

# CentOS - https://wiki.centos.org/ArtWork/Brand/Logo
set -l cent_g (set_color 9ccd2a green)
set -l cent_o (set_color efa724 yellow)
set -l cent_p (set_color a14f8c magenta)
set -l cent_b (set_color 262577 blue)
set -g __osflavor_dist_centos "$cent_g❖$cent_o❖$cent_p❖$cent_b❖"

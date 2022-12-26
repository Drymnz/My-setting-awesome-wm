#!/usr/bin/env bash

#Programas extras
pkg_video_app="parole gst-libav"
pkg_musci_view="lollypop"
pkg_imagenes_app="eog"
pkg_edit_text="mousepad"
pkg_zip_app="ark p7zip unzip unrar"
pkg_them_fonts="gnome-font-viewer mate-icon-theme mate-icon-theme-faenza mate-themes lxqt-qtplugin lxqt-themes"
pkg_them_fonts_two="exo xfwm4-themes ttf-dejavu noto-fonts noto-fonts-emoji ttf-liberation wqy-zenhei gnome-themes-extra"
pkg_them_fonst_third="ttf-croscore"

#Gestor
pkg_gestor_disco="gnome-disk-utility"
pkg_gestor_energia="xfce4-power-manager"
pkg_gestor_password="gnome-keyring libsecret libgnome-keyring"
pkg_gestor_audio="pavucontrol"
pkg_gestor_temas="lxappearance"

#Listado de paquetes
pkg_gestores="${pkg_gestor_disco} ${pkg_gestor_energia} ${pkg_gestor_password} ${pkg_gestor_audio}"
pkg_extras_one="${pkg_video_app} ${pkg_musci_view} ${pkg_imagenes_app} ${pkg_edit_text} "
pkg_extras_two="${pkg_zip_app} ${pkg_them_fonts} ${pkg_them_fonts_two} ${pkg_them_fonst_third} ${pkg_gestor_temas}"

#Unificado
instar_extends="${pkg_gestores} ${pkg_extras_one} ${pkg_extras_two}"

#Fuente de microsoft
dir_gits="${HOME}/temp-git"


function install_extends_fonts_microsoft(){
    pwd_temp=${pwd}
    clear
    mkdir -p ${dir_gits}/Microsoft
    ##Fonts
    git clone https://aur.archlinux.org/ttf-ms-fonts.git ${dir_gits}/Microsoft
    cd ${dir_gits}/Microsoft
    makepkg -si
    cd ${pwd_temp}
}

function install_yay(){
    pwd_temp=${pwd}
    clear
    mkdir -p ${dir_gits}/Yay
    git clone https://aur.archlinux.org/yay-bin.git ${dir_gits}/Yay
    cd ${dir_gits}/Yay
    makepkg -si
    cd ${pwd_temp}
}

function install_extends(){
    mkdir -p "$HOME"/.local/share/keyrings
    sudo pacman -S --needed ${instar_extends} --noconfirm
}

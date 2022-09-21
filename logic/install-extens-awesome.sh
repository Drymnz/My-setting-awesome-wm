#!/usr/bin/env bash

#Programas extras
pkg_video_app="parole"
pkg_musci_view="lollypop"
pkg_imagenes_app="eog"
pkg_edit_text="mousepad"
pkg_zip_app="ark p7zip unzip unrar"
pkg_them_fonts="gnome-font-viewer mate-icon-theme mate-icon-theme-faenza mate-themes lxqt-qtplugin lxqt-themes"
pkg_them_fonts_two="exo xfwm4-themes ttf-dejavu noto-fonts noto-fonts-emoji"
#Gestor
pkg_gestor_disco="gnome-disk-utility"
pkg_gestor_energia="xfce4-power-manager"
pkg_gestor_password="xfce4-appfinder"

#Listado de paquetes
pkg_gestores="${pkg_gestor_disco} ${pkg_gestor_energia} ${pkg_gestor_password}"
pkg_extras_one="${pkg_video_app} ${pkg_musci_view} ${pkg_imagenes_app} ${pkg_edit_text}"
pkg_extras_two="${pkg_zip_app} ${pkg_them_fonts} ${pkg_them_fonts_two}"

#Unificado
instar_extends="${pkg_gestores} ${pkg_extras_one} ${pkg_extras_two}"

function install_extends(){
    sudo pacman -S --needed ${instar_extends} --noconfirm
}

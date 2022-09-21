#!/usr/bin/env bash

#Herramientas para awesome 
pkg_xorg="xorg xorg-xinit xorg-xinput"
#Ventana de permisos 
pkg_polkit="polkit-kde-agent"
#Requisitos del escritorio
pkg_terminal="alacritty"
#El escritorio
pkg_awesome="awesome"
#Para captura de pantalla
pkg_scrot="scrot"
#Navegador
pkg_navegador="firefox"ç
#lanzador de aplicacioens
pkg_rofi="rofi"
#Transparencia
pkg_picom="picom"
#Programas extras
pkg_video_app="parole"
pkg_imagenes_app="eog"
pkg_zip_app="ark p7zip unzip unrar"
pkg_edit_text="mousepad"
pkg_them_fonts="gnome-font-viewer mate-icon-theme mate-icon-theme-faenza mate-themes lxqt-qtplugin lxqt-themes"
pkg_them_fonts_two="exo xfwm4-themes ttf-dejavu noto-fonts noto-fonts-emoji"
#Controladores
pkg_android="android-tools gvfs-mtp"
pkg_ntfs="ntfs-3g"
pkg_exfast="exfat-utils"
pkg_usb="usbutils usb_modeswitch gvfs"
pkg_iphone="gvfs-afc"
pkg_mac="apparmor"
#Manejador de fichero
pkg_file_manger="thunar thunar-volman thunar-media-tags-plugin thunar-archive-plugin"
#Gestor de escritrorios
pkg_sddm="sddm sddm-kcm"
#Reproductor de musica en terminal
pkg_mpd="mpd mpc ncmpcpp"
#Gestor
pkg_gestor_disco="gnome-disk-utility"
pkg_gestor_energia="xfce4-power-manager"
pkg_gestor_contraseñas="xfce4-appfinder"
#comandos de pacman 
no_confirmar="--noconfirm"
sudo="sudo"

#Listado de paquetes
pkg_requisitos="${pkg_xorg}  ${pkg_terminal}"
pkg_controladores="${pkg_mac}  ${pkg_iphone} ${pkg_usb} ${pkg_exfast} ${pkg_ntfs} ${pkg_android} "
pkg_herramientas_escritorio="${pkg_scrot} ${pkg_rofi} ${pkg_picom} ${pkg_video_app} ${pkg_imagenes_app} ${pkg_zip_app} ${pkg_polkit} ${pkg_edit_text} ${pkg_them_fonts_two} ${pkg_them_fonts} "
pkg_herramientas_usuario="${pkg_navegador} ${pkg_mpd} ${pkg_gestor_contraseñas} ${pkg_gestor_energia} ${pkg_gestor_disco} "
#Variable de instalacion
instalar_pkg_uno="${sudo} pacman -Syu ${pkg_requisitos} ${pkg_herramientas_escritorio} ${pkg_herramientas_usuario} ${pkg_controladores} ${no_confirmar} "

function solicitu_permisos(){
    clear
    echo " "
    echo " "
    echo "¡¡¡Permisos!!!"
    echo " "
    echo " "

}

function instalacion_awesome-wm(){
    ##Instar variable 
    solicitu_permisos
    ${instalar_pkg_uno}
    ##Escritorio
    solicitu_permisos
    ${sudo} pacman -Syu ${pkg_awesome} --noconfirm
    ##Gestor de session
    solicitu_permisos
    ${sudo} pacman -Syu ${pkg_sddm} --noconfirm
    ##Gestor de archivos
    solicitu_permisos
    ${sudo} pacman -Syu ${pkg_file_manger} --noconfirm
}

#Copiar la configuracion
function copiar_configuraracion(){
        echo "Creando carpetas"
        mkdir -p "$HOME"/.config
        mkdir -p "$HOME"/.config/alacritty
        mkdir -p "$HOME"/.config/awesome
        mkdir -p "$HOME"/.ncmpcpp
        mkdir -p "$HOME"/.mpd
        sudo mkdir -p /etc/sddm.conf.d
        echo "Copiando la configuracion"
        cp -r /etc/xdg/awesome/rc.lua "$HOME"/.config/awesome/rc.lua
        cp -r /usr/share/doc/alacritty/example/alacritty.yml "$HOME"/.config/alacritty/alacritty.yml
        echo "Copiando la configuracion"
        cp -r configuracionAWM/* "$HOME"/.config/awesome
        cp -r configuracionAlacritty/* "$HOME"/.config/alacritty
        cp -r configuracionMpd/* "$HOME"/.mpd
        cp -r configuracionNcmpcpp/* "$HOME"/.ncmpcpp
        sudo cp -r configuracionSession/* /etc/sddm.conf.d
        systemctl enable sddm.service
}

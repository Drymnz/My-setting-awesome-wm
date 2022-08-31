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
pkd_scrot="scrot"
#Navegador
pkg_navegador="firefox"
#Manejador de fichero
pkg_file_manger="thunar"
#Gestor de escritrorios
pkg_sddm="sddm sddm-kcm"
#Reproductor de musica en terminal
pkg_mpd="mpd mpc ncmpcpp"
#no_confirmar="--noconfirm"
no_confirmar="--noconfirm"
sudo="sudo"

#Listado de paquetes
pkg_requisitos="${pkg_xorg}  ${pkg_terminal}"
pkg_herramientas_escritorio="${pkg_file_manger} ${pkd_scrot}  ${pkg_polkit}"
pkg_herramientas_usuario="${pkg_navegador} ${pkg_mpd}"
#Variable de instalacion
instalar_pkg_uno="${sudo} pacman -Syu ${pkg_requisitos} ${pkg_herramientas_escritorio} ${pkg_herramientas_usuario} ${no_confirmar}"

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
    ##Gestro de session
    solicitu_permisos
    ${sudo} pacman -Syu ${pkg_sddm} --noconfirm
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

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
pkg_sddm="sddm 	sddm-kcm"
#Reproductor de musica en terminal
pkg_sddm="mpd mpc ncmpcpp"
#no_confirmar="--noconfirm"
no_confirmar=" "
sudo="sudo"

#Listado de paquetes
pkg_requisitos="${pkg_xorg}  ${pkg_terminal}  ${pkd_scrot}  ${pkg_polkit}  ${pkg_navegador}  ${pkg_sddm}  ${no_confirmar}"
pkg_herramientas="${pkg_file_manger}  ${pkg_sddm}  ${no_confirmar}"

function instalacion_awesome-wm(){
    ##Requisitos
    ${sudo} pacman -Ss ${pkg_requisitos}
    ##Escritorio
    ${sudo} pacman -Ss ${pkg_awesome}  ${no_confirmar}
    ##Herramientas
    ${sudo} pacman -Ss ${pkg_herramientas}
}

#Copiar la configuracion
function copiar_configuraracion(){
        echo "Creando carpetas"
        mkdir -p "$HOME"/.config
        mkdir -p "$HOME"/.config/alacritty
        mkdir -p "$HOME"/.config/awesome
        mkdir -p "$HOME"/.ncmpcpp
        mkdir -p "$HOME"/.mpd
        echo "Copiando la configuracion"
        cp -r /etc/xdg/awesome/rc.lua "$HOME"/.config/awesome/rc.lua
        cp -r /usr/share/doc/alacritty/example/alacritty.yml "$HOME"/.config/alacritty/alacritty.yml
        echo "Copiando la configuracion"
        cp -r configuracionAWM/* "$HOME"/.config/awesome
        cp -r configuracionAlacritty/* "$HOME"/.config/alacritty
        cp -r configuracionMpd/* "$HOME"/.mpd
        cp -r configuracionNcmpcpp/* "$HOME"/.ncmpcpp
        sudo systemctl enable sddm.service
}

#!/bin/env bash

##importaciones
#source ./installation\ logic/message.sh

##variables para la instalacion
pkg_gpu=""
pkg_xorg="xorg xorg-xinit xorg-xinput"
pkg_terminal="alacritty"
pkg_awesome="awesome"
pkg_polkit="polkit-kde-agent"
pkg_navegador="firefox"
pkg_file_manger="thunar"
pkg_sddm="sddm 	sddm-kcm"
pkd_scrot="scrot"
#gestor
arch_linux="sudo pacman -Syu"
arch_no_confirm="--noconfirm"

function refrescar(){
    #requisitos
    requisito_esritorio="${arch_linux} ${pkg_gpu} ${pkg_xorg} ${arch_no_confirm}"
    requisito_configuracion="${arch_linux} ${pkg_terminal} ${pkg_polkit} ${pkg_navegador} ${pkd_scrot} ${arch_no_confirm}"
    requisito_manejador_entorno_seccion="${arch_linux} ${pkg_sddm} ${arch_no_confirm}"
    requisito_extras="${arch_linux} ${pkg_file_manger} ${arch_no_confirm} "
    requisito_entorno="${arch_linux} ${pkg_awesome} ${arch_no_confirm}"
}

##funcion de instalacion
function install_start(){
    ${requisito_esritorio}
    ${requisito_configuracion}
    ${requisito_manejador_entorno_seccion}
    ${requisito_extras}
    ${requisito_entorno}
}

#funcion mensajes
function print(){
    local menssage=$1
    echo "${menssage}"
}

##funcion de graficos
function install_graficos(){
    print "¿Desea instalr un controlador grafico? [Y/n]"
    read -r gpu
    
    case "$gpu" in
        [yY])
            print "1) xf86-video-intel 	2) xf86-video-amdgpu 3) nvidia 4) saltar"
            read -r -p "Seleccion una opcion(default 1): " opcio
            case $opcio in
                [1])
                    pkg_gpu='xf86-video-intel'
                ;;
                
                [2])
                    pkg_gpu='xf86-video-amdgpu'
                ;;
                
                [3])
                    pkg_gpu='nvidia nvidia-settings nvidia-utils'
                ;;
                
                [4])
                    pkg_gpu=""
                ;;
                [*])
                    pkg_gpu='xf86-video-intel'
                ;;
            esac
            
        ;;
        *)
            pkg_gpu=" "
        ;;
    esac
}



print "¿Desea iniciar la instalacion? [Y/n]"
read -r  starti

case "$starti" in
    [yY])
        install_graficos
        refrescar
        install_start
        echo "Creando carpetas"
        mkdir -p $HOME/.config
        mkdir -p $HOME/.config/alacritty
        mkdir -p $HOME/.config/awesome
        echo "Copiando la configuracion"
        cp -r /etc/xdg/awesome/rc.lua $HOME/.config/awesome/rc.lua
        cp -r /usr/share/doc/alacritty/example/alacritty.yml $HOME/.config/alacritty/alacritty.yml
        echo "Copiando la configuracion"
        cp -r configuracionAWM/* $HOME/.config/awesome
        cp -r configuracionAlacritty/* $HOME/.config/alacritty
        systemctl enable sddm.service
    ;;
    *)
        print "Bye"
    ;;
esac
#!/bin/env bash
#!/bin/bash

##importaciones
source ./installation\ logic/message.sh
source ./installation\ logic/cargar_configuracion_default.sh

##variables para la instalacion
pkg_gpu=""
pkg_xorg="xorg xorg-xinit xorg-xinput"
pkg_terminal="alacritty"
pkg_awesome="awesome"
pkg_polkit="polkit-kde-agent"
pkg_navegador="firefox"
pkg_file_manger="thunar"
#gestor
arch_linux="pacman -Syu"

function refrescar(){
    #requisitos
    requisito_esritorio="${arch_linux} ${pkg_gpu} ${pkg_xorg}"
    requisito_entorno="${arch_linux} ${pkg_awesome}"
    requisito_configuracion="${arch_linux} ${pkg_terminal} ${pkg_polkit} ${pkg_navegador} ${pkg_file_manger}"
}

##funcion de instalacion
function install_start(){
    echo ${requisito_esritorio}" & "${requisito_configuracion}" & " ${requisito_entorno}
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
        #install_graficos
        #refrescar
        #install_start
        configurar
    ;;
    *)
        print "Bye"
    ;;
esac

# comienza la instalacion de los paquetes
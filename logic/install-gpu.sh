#!/usr/bin/env bash

pkg_gpu=" "

function instalacion_gpu(){
    echo "¿Desea instalr un controlador grafico? [S/n]"
    read -r gpu
    
    if [[ "${gpu}" == "s" ]] || [[ "${gpu}" == "S" ]]
       then
            echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3) nvidia 4) saltar"
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
                    pkg_gpu=" "
                ;;
                [*])
                    pkg_gpu='xf86-video-intel'
                ;;
            esac
    fi
    # si escojigo una grafica instala sino nada
    ! [[ "${pkg_gpu}" == " " ]] && echo sudo pacman -Syu "${pkg_gpu}"
}


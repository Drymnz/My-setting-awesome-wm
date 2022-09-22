#!/usr/bin/env bash

pkg_gpu="0"

function instalacion_gpu(){
    echo "¿Desea instalar un controlador grafico? [S/n]"
    read -r gpu
    
    if [[ "${gpu}" == "s" ]] || [[ "${gpu}" == "S" ]]
       then
            echo "1) INTEL 	2) AMD 3) NVIDIA 4) saltar"
            read -r -p "Seleccion una opcion(default 1): " opcio
            case $opcio in
                [1])
                    pkg_gpu='xf86-video-intel mesa lib32-mesa'
                ;;
                
                [2])
                    pkg_gpu='xf86-video-amdgpu xf86-video-ati mesa lib32-mesa'
                ;;
                
                [3])
                    pkg_gpu='nvidia nvidia-settings nvidia-utils'
                ;;
                
                [4])
                    pkg_gpu="0"
                ;;
                [*])
                    pkg_gpu='xf86-video-intel mesa lib32-mesa'
                ;;
            esac
    fi
    # si escojigo una grafica instala sino nada
    ! [[ "${pkg_gpu}" == "0" ]] && sudo pacman -S --needed ${pkg_gpu} --noconfirm
}


#!/usr/bin/env bash

pkg_gpu="0"
pkg_mesa="mesa lib32-mesa"

function instalacion_gpu(){
    echo "¿Desea instalar un controlador grafico? [S/n]"
    read -r gpu
    
    if [[ "${gpu}" == "s" ]] || [[ "${gpu}" == "S" ]]
       then
            echo "1) INTEL 	2) AMD 3) NVIDIA 4) saltar"
            read -r -p "Seleccion una opcion(default 1): " opcio
            case $opcio in
                [1])
                    pkg_gpu="xf86-video-intel ${pkg_mesa}"
                ;;
                
                [2])
                    pkg_gpu="xf86-video-amdgpu xf86-video-ati ${pkg_mesa}"
                ;;
                
                [3])
                    pkg_gpu="nvidia nvidia-settings nvidia-utils ${pkg_mesa}"
                ;;
                
                [4])
                    pkg_gpu="0"
                ;;
                [*])
                    pkg_gpu="xf86-video-intel ${pkg_mesa}"
                ;;
            esac
    fi
    # si escojigo una grafica instala sino nada
    ! [[ "${pkg_gpu}" == "0" ]] && sudo pacman -S --needed ${pkg_gpu} --noconfirm
}

instalacion_gpu


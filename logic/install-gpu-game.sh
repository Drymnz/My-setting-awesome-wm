#!/usr/bin/env bash

#Listado Opengl
pkg_opengl_standar="ftgl opengl-man-pages libvdpau-va-gl"
pkg_opengl_intel="intel-compute-runtime intel-graphics-compiler"
pkg_opengl_amd="opencl-mesa lib32-opencl-mesa"
pkg_opengl_nvidia="opencl-nvidia bumblebee"

#Listado Vulkan
pkg_vulkan_standar="vulkan-mesa-layers lib32-vulkan-mesa-layers vulkan-extra-layers \
vulkan-validation-layers lib32-vulkan-validation-layers vulkan-icd-loader lib32-vulkan-icd-loader \
vulkan-headers vulkan-tools vkd3d lib32-vkd3d vulkan-swrast vulkan-extra-tools"
pkg_vulkan_intel="vulkan-intel  lib32-vulkan-intel"
pkg_vulkan_amd="vulkan-radeon lib32-vulkan-radeon amdvlk lib32-amdvlk"
pkg_vulkan_nvidia="lib32-vulkan-mesalayers lib32-opencl-nvidia primus_vk lib32-primus_vk "

#Listado Mesa
pkg_mesa_standar="mesa lib32-mesa glu lib32-glu lib32-glew glslang freeglut lib32-freeglut \
libepoxy lib32-libepoxy openra meson systemd git dbus libinih"

#Listado wine
pkg_wine="wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls \
mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error \
lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo \
sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama \
ncurses lib32-ncurses ocl-icd lib32-ocl-icd libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader"

#Listado Otros
pkg_otros_standar="shaderc libretro-shaders-slang mesa-demos  lib32-mesa-demos libva-mesa-driver \
lib32-libva-mesa-driver lib32-mesa-vdpau nvtop"
pkg_otros_intel="intel-gmmlib intel-gpu-tools intel-graphics-compiler lib32-libva-intel-driver igsc intel-media-driver"
pkg_otros_amd="distorm"
pkg_otros_nvidia="nvidia-dkms nvidia-utils libvdpau libxnvctrl nvidia-prime nvidia-settings nccl lib32-libvdpau \
cuda cuda-tools cudnn nvidia-cg-toolkit python-cuda python-cuda-docs python-pycuda lib32-nvidia-cg-toolkit lib32-nvidia-utils"

##Variabla de instalacion
pkg_all_standar="${pkg_opengl_standar} ${pkg_vulkan_standar} ${pkg_mesa_standar} ${pkg_otros_standar} ${pkg_wine} "


function instalacion_gpu_game(){
    echo "¿Desea instalar paquetas para jugar (Vulkan,OpenGl,Mesa y otros)? [S/n]"
    read -r gpu
    
    if [[ "${gpu}" == "s" ]] || [[ "${gpu}" == "S" ]]
       then
            echo "1) INTEL 	2) AMD 3) NVIDIA 4) saltar"
            read -r -p "Seleccion una opcion(default 1): " opcio
            case $opcio in
                [1])
                    pkg_gpu_game="${pkg_all_standar} ${pkg_opengl_intel} ${pkg_vulkan_intel} ${pkg_otros_intel}"
                ;;
                
                [2])
                    pkg_gpu_game="${pkg_all_standar} ${pkg_opengl_amd} ${pkg_vulkan_amd} ${pkg_otros_amd}"
                ;;
                
                [3])
                    pkg_gpu_game="${pkg_all_standar} ${pkg_opengl_nvidia} ${pkg_vulkan_nvidia} ${pkg_otros_nvidia}"
                ;;
                
                [4])
                    pkg_gpu_game="0"
                ;;
                [*])
                    pkg_gpu_game="${pkg_all_standar} ${pkg_opengl_intel} ${pkg_vulkan_intel} ${pkg_otros_intel}"
                ;;
            esac
            else
            pkg_gpu_game="0"
    fi
    # si escojigo una grafica instala sino nada
    ! [[ "${pkg_gpu_game}" == "0" ]] && sudo pacman -S --needed ${pkg_gpu_game}
}

instalacion_gpu_game
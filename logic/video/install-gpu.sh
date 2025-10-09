#!/usr/bin/env bash

# Paquetes base
pkg_mesa="mesa lib32-mesa"

# Funciones de color
show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }

instalacion_gpu(){
    clear
    show_message "INSTALACIÓN DE DRIVERS DE VIDEO"
    echo ""
    echo "Seleccione su configuración de GPU:"
    echo ""
    echo "  1) Intel"
    echo "  2) AMD (Open Source)"
    echo "  3) NVIDIA (Open Source - Nouveau)"
    echo "  4) NVIDIA (Propietario)"
    echo "  5) Híbrida: Intel + NVIDIA (dedicada)"
    echo "  6) Híbrida: AMD + NVIDIA (dedicada)"
    echo "  7) Híbrida: Intel + AMD (dedicada)"
    echo "  8) Ninguno/Saltar"
    echo ""
    read -r -p "Opción (default 8): " opcion
    
    case $opcion in
        1)
            pkg_gpu="xf86-video-intel ${pkg_mesa}"
            show_message "Instalando drivers Intel..."
            ;;
        2)
            pkg_gpu="xf86-video-amdgpu xf86-video-ati ${pkg_mesa}"
            show_message "Instalando drivers AMD..."
            ;;
        3)
            pkg_gpu="xf86-video-nouveau ${pkg_mesa}"
            show_message "Instalando drivers NVIDIA open source..."
            ;;
        4)
            # NVIDIA propietario
            echo ""
            echo "Versión del driver NVIDIA:"
            echo "  1) nvidia (últimas GPUs)"
            echo "  2) nvidia-lts (kernel LTS)"
            echo "  3) nvidia-dkms (todas las versiones)"
            echo ""
            read -r -p "Opción (default 1): " nvidia_version
            
            case $nvidia_version in
                2) pkg_gpu="nvidia-lts nvidia-settings nvidia-utils ${pkg_mesa}" ;;
                3) pkg_gpu="nvidia-dkms nvidia-settings nvidia-utils ${pkg_mesa}" ;;
                *) pkg_gpu="nvidia nvidia-settings nvidia-utils ${pkg_mesa}" ;;
            esac
            
            show_message "Instalando drivers NVIDIA propietarios..."
            show_warning "Se recomienda bloquear actualizaciones del kernel"
            ;;
        5)
            # Intel + NVIDIA
            echo ""
            echo "Versión del driver NVIDIA:"
            echo "  1) nvidia    2) nvidia-lts    3) nvidia-dkms"
            read -r -p "Opción (default 1): " nvidia_version
            
            case $nvidia_version in
                2) pkg_nvidia="nvidia-lts" ;;
                3) pkg_nvidia="nvidia-dkms" ;;
                *) pkg_nvidia="nvidia" ;;
            esac
            
            pkg_gpu="xf86-video-intel ${pkg_nvidia} nvidia-settings nvidia-utils nvidia-prime ${pkg_mesa}"
            show_message "Instalando configuración híbrida Intel + NVIDIA..."
            show_warning "Usa 'prime-run' para ejecutar apps con NVIDIA"
            ;;
        6)
            # AMD + NVIDIA
            echo ""
            echo "Versión del driver NVIDIA:"
            echo "  1) nvidia    2) nvidia-lts    3) nvidia-dkms"
            read -r -p "Opción (default 1): " nvidia_version
            
            case $nvidia_version in
                2) pkg_nvidia="nvidia-lts" ;;
                3) pkg_nvidia="nvidia-dkms" ;;
                *) pkg_nvidia="nvidia" ;;
            esac
            
            pkg_gpu="xf86-video-amdgpu xf86-video-ati ${pkg_nvidia} nvidia-settings nvidia-utils nvidia-prime ${pkg_mesa}"
            show_message "Instalando configuración híbrida AMD + NVIDIA..."
            show_warning "Usa 'prime-run' para ejecutar apps con NVIDIA"
            ;;
        7)
            # Intel + AMD
            pkg_gpu="xf86-video-intel xf86-video-amdgpu xf86-video-ati ${pkg_mesa}"
            show_message "Instalando configuración híbrida Intel + AMD..."
            ;;
        *)
            show_warning "Saltando instalación de drivers de video"
            return 0
            ;;
    esac
    
    # Instalar paquetes
    sudo pacman -Syu --needed ${pkg_gpu} --noconfirm
    
    show_message "Drivers de video instalados correctamente"
}

# Ejecutar instalación
instalacion_gpu
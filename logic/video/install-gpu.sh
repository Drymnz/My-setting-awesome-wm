#!/usr/bin/env bash

# =============================================================================
# install-gpu.sh
# Instalación de drivers de video para Arch Linux
#
# NOTA: Este script solo usa paquetes del repositorio [extra] y [core].
#       No requiere [multilib] habilitado.
#       Los paquetes lib32-* (32 bits) se manejan en install-gaming.sh
# =============================================================================

# Paquete base de gráficos (requerido por todas las opciones)
pkg_mesa="mesa"

# --- Funciones de salida visual ---
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
            # Driver Intel: xf86-video-intel para Xorg + mesa para OpenGL
            pkg_gpu="xf86-video-intel ${pkg_mesa}"
            show_message "Instalando drivers Intel..."
            ;;

        2)
            # Drivers AMD: amdgpu (GPUs modernas) + ati (GPUs antiguas) + mesa
            pkg_gpu="xf86-video-amdgpu xf86-video-ati ${pkg_mesa}"
            show_message "Instalando drivers AMD..."
            ;;

        3)
            # Nouveau: driver open source no oficial para NVIDIA
            # Menor rendimiento que el propietario pero sin dependencias extra
            pkg_gpu="xf86-video-nouveau ${pkg_mesa}"
            show_message "Instalando drivers NVIDIA open source (Nouveau)..."
            ;;

        4)
            # NVIDIA propietario: mejor rendimiento, requiere kernel compatible
            echo ""
            echo "Versión del driver NVIDIA:"
            echo "  1) nvidia      — para el kernel estándar (recomendado)"
            echo "  2) nvidia-lts  — para el kernel LTS"
            echo "  3) nvidia-dkms — compila el módulo, compatible con cualquier kernel"
            echo ""
            read -r -p "Opción (default 1): " nvidia_version

            case $nvidia_version in
                2) pkg_gpu="nvidia-lts nvidia-settings nvidia-utils ${pkg_mesa}" ;;
                3) pkg_gpu="nvidia-dkms nvidia-settings nvidia-utils ${pkg_mesa}" ;;
                *) pkg_gpu="nvidia nvidia-settings nvidia-utils ${pkg_mesa}" ;;
            esac

            show_message "Instalando drivers NVIDIA propietarios..."
            show_warning "Se recomienda bloquear actualizaciones del kernel para evitar incompatibilidades"
            ;;

        5)
            # Híbrida Intel + NVIDIA (laptops con gráfica dedicada)
            # nvidia-prime permite alternar entre Intel (ahorro) y NVIDIA (rendimiento)
            # Usar 'prime-run <app>' para ejecutar con la GPU NVIDIA
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
            show_warning "Usa 'prime-run <aplicación>' para ejecutar con la GPU NVIDIA"
            ;;

        6)
            # Híbrida AMD + NVIDIA
            # Similar a Intel+NVIDIA pero con GPU integrada AMD
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
            show_warning "Usa 'prime-run <aplicación>' para ejecutar con la GPU NVIDIA"
            ;;

        7)
            # Híbrida Intel + AMD (sin NVIDIA)
            # Común en algunos equipos con gráfica integrada Intel y discreta AMD
            pkg_gpu="xf86-video-intel xf86-video-amdgpu xf86-video-ati ${pkg_mesa}"
            show_message "Instalando configuración híbrida Intel + AMD..."
            ;;

        *)
            # Opción por defecto: no instalar ningún driver adicional
            show_warning "Saltando instalación de drivers de video"
            return 0
            ;;
    esac

    # Instalar todos los paquetes seleccionados
    # --needed evita reinstalar paquetes ya instalados
    sudo pacman -Syu --needed ${pkg_gpu} --noconfirm

    show_message "Drivers de video instalados correctamente"
}

# --- Punto de entrada ---
instalacion_gpu
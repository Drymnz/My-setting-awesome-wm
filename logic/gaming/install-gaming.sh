#!/usr/bin/env bash

# =============================================================================
# install-gaming.sh
# Instalación de paquetes para gaming en Arch Linux
#
# REQUIERE [multilib] habilitado — este script lo configura automáticamente
# ya que la mayoría de librerías de gaming son de 32 bits (lib32-*).
# =============================================================================

# --- Funciones de salida visual ---
show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }
show_error()   { echo -e "\033[0;31m==>\033[0m $1"; }

# --- Función para habilitar multilib ---
# Necesario para instalar librerías de 32 bits (lib32-*)
enable_multilib() {
    if grep -q "^\[multilib\]" /etc/pacman.conf; then
        show_message "Repositorio [multilib] ya está habilitado"
    else
        show_warning "Habilitando repositorio [multilib] (requerido para gaming)..."
        sudo sed -i '/^#\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
        sudo pacman -Sy
        show_message "[multilib] habilitado correctamente"
    fi
}

# --- Paquetes Vulkan base (todos los sistemas) ---
pkg_vulkan_base="vulkan-mesa-layers lib32-vulkan-mesa-layers \
vulkan-validation-layers lib32-vulkan-validation-layers \
vulkan-icd-loader lib32-vulkan-icd-loader \
vulkan-headers vulkan-tools \
vkd3d lib32-vkd3d \
vulkan-extra-layers vulkan-extra-tools"
# vulkan-*           → API gráfica moderna, necesaria para juegos AAA y Proton
# vkd3d              → traducción de DirectX 12 a Vulkan (juegos de Windows)

# --- OpenGL base ---
pkg_opengl_base="ftgl opengl-man-pages libvdpau-va-gl"
# ftgl           → renderizado de fuentes con OpenGL
# libvdpau-va-gl → aceleración de video por hardware vía VA-API

# --- Mesa base (renderizado de gráficos) ---
pkg_mesa_base="mesa lib32-mesa glu lib32-glu glslang freeglut lib32-freeglut"
# mesa      → implementación open source de OpenGL/Vulkan
# glu       → utilidades OpenGL
# glslang   → compilador de shaders GLSL
# freeglut  → librería de ventanas para OpenGL

# --- Extras de rendimiento y video ---
pkg_extras="shaderc libretro-shaders-slang mesa-demos lib32-mesa-demos \
libva-mesa-driver lib32-libva-mesa-driver lib32-mesa-vdpau"
# shaderc              → compilador de shaders (requerido por juegos Vulkan)
# libretro-shaders     → shaders para emuladores
# mesa-demos           → herramientas de prueba OpenGL (glxgears, etc.)
# libva-mesa-driver    → aceleración de video VA-API con Mesa
# lib32-mesa-vdpau     → aceleración VDPAU de 32 bits

# --- Wine (para correr juegos/apps de Windows) ---
pkg_wine="wine-staging giflib lib32-giflib libpng lib32-libpng \
libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 \
openal lib32-openal v4l-utils lib32-v4l-utils \
libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib \
libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite \
libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama \
libgcrypt lib32-libgcrypt"
# wine-staging → versión de Wine con más parches y compatibilidad
# El resto son dependencias de Wine para audio, video, red y gráficos

# --- Drivers específicos por GPU ---

# Intel: Vulkan + OpenCL + VA-API
pkg_intel="vulkan-intel lib32-vulkan-intel intel-compute-runtime \
intel-media-driver intel-gmmlib lib32-libva-intel-driver"

# AMD: Vulkan + OpenCL + driver Xorg
pkg_amd="vulkan-radeon lib32-vulkan-radeon opencl-mesa lib32-opencl-mesa xf86-video-amdgpu"

# NVIDIA Open Source (Nouveau): rendimiento limitado, sin soporte oficial
pkg_nvidia_nouveau="xf86-video-nouveau"

# NVIDIA Propietario: detecta qué variante está instalada para agregar solo utils
if pacman -Q nvidia &>/dev/null || pacman -Q nvidia-dkms &>/dev/null; then
    # Ya tiene el driver base, solo agregar utilidades y librerías 32 bits
    pkg_nvidia_proprietary="nvidia-utils lib32-nvidia-utils nvidia-settings \
opencl-nvidia lib32-opencl-nvidia libvdpau lib32-libvdpau"
else
    # Instalar todo desde cero
    pkg_nvidia_proprietary="nvidia nvidia-utils lib32-nvidia-utils nvidia-settings \
opencl-nvidia lib32-opencl-nvidia libvdpau lib32-libvdpau"
fi

install_gaming() {
    clear
    show_message "INSTALACIÓN DE PAQUETES PARA GAMING"
    echo ""
    show_warning "Este script requiere [multilib] y lo habilitará automáticamente"
    echo ""

    # === Habilitar multilib (obligatorio para lib32-*) ===
    enable_multilib

    # === Selección de GPU ===
    echo ""
    echo "Seleccione su tarjeta gráfica:"
    echo ""
    echo "  1) Intel"
    echo "  2) AMD"
    echo "  3) NVIDIA (Open Source - Nouveau)"
    echo "  4) NVIDIA (Propietario)"
    echo "  5) Saltar"
    echo ""
    read -r -p "Opción (default 5): " gpu_option

    # Paquetes base comunes a todas las GPUs
    pkg_gaming="${pkg_vulkan_base} ${pkg_opengl_base} ${pkg_mesa_base} ${pkg_extras}"

    case $gpu_option in
        1)
            show_message "Configurando para Intel..."
            pkg_gaming="${pkg_gaming} ${pkg_intel}"
            ;;
        2)
            show_message "Configurando para AMD..."
            pkg_gaming="${pkg_gaming} ${pkg_amd}"
            ;;
        3)
            show_message "Configurando para NVIDIA (Nouveau)..."
            show_warning "Nouveau tiene rendimiento limitado; se recomienda el driver propietario"
            pkg_gaming="${pkg_gaming} ${pkg_nvidia_nouveau}"
            ;;
        4)
            show_message "Configurando para NVIDIA (Propietario)..."
            pkg_gaming="${pkg_gaming} ${pkg_nvidia_proprietary}"
            ;;
        *)
            show_warning "Saltando instalación de gaming"
            return 0
            ;;
    esac

    # === Steam (opcional) ===
    echo ""
    echo "¿Desea instalar Steam? [S/n]"
    read -r install_steam
    if [[ "${install_steam,,}" == "s" ]] || [[ -z "$install_steam" ]]; then
        pkg_gaming="${pkg_gaming} steam"
    fi

    # === Wine (opcional) ===
    echo ""
    echo "¿Desea instalar Wine-Staging (correr juegos/apps de Windows)? [s/N]"
    read -r install_wine
    if [[ "${install_wine,,}" == "s" ]]; then
        pkg_gaming="${pkg_gaming} ${pkg_wine}"
    fi

    # === Lutris (opcional) ===
    echo ""
    echo "¿Desea instalar Lutris (gestor de juegos)? [s/N]"
    read -r install_lutris
    if [[ "${install_lutris,,}" == "s" ]]; then
        pkg_gaming="${pkg_gaming} lutris"
    fi

    # === GameMode y MangoHud (opcional) ===
    echo ""
    echo "¿Desea instalar GameMode y MangoHud (rendimiento y overlay)? [S/n]"
    read -r install_perf
    if [[ "${install_perf,,}" == "s" ]] || [[ -z "$install_perf" ]]; then
        pkg_gaming="${pkg_gaming} gamemode lib32-gamemode mangohud lib32-mangohud"
    fi

    # === Instalar todos los paquetes seleccionados ===
    echo ""
    show_message "Instalando paquetes de gaming..."
    sudo pacman -S --needed ${pkg_gaming} --noconfirm

    # === Configuración adicional para NVIDIA propietario ===
    if [[ $gpu_option -eq 4 ]]; then
        echo ""
        echo "¿Desea agregar módulos NVIDIA al initramfs? [S/n]"
        echo "  (Recomendado para mayor estabilidad y soporte DRM)"
        read -r nvidia_modules
        if [[ "${nvidia_modules,,}" == "s" ]] || [[ -z "$nvidia_modules" ]]; then
            show_message "Agregando módulos NVIDIA al initramfs..."

            # Verificar espacio disponible en /boot antes de regenerar
            boot_space=$(df /boot | tail -1 | awk '{print $4}')
            if [[ $boot_space -lt 100000 ]]; then
                show_warning "Poco espacio en /boot. Limpiando caché de paquetes..."
                sudo pacman -Sc --noconfirm
            fi

            sudo pacman -S --needed mkinitcpio pacman-contrib --noconfirm

            # Agregar módulos al initramfs (evita pantalla negra al iniciar con NVIDIA)
            sudo sed -i 's/^MODULES=(/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
            sudo mkinitcpio -P
            sudo grub-mkconfig -o /boot/grub/grub.cfg
            show_message "Módulos NVIDIA agregados correctamente"
        fi
    fi

    echo ""
    show_message "Instalación de gaming completada"
    echo ""
    show_warning "Recomendaciones:"
    echo "  - Reinicie el sistema para aplicar todos los cambios"
    [[ "${install_steam,,}" == "s" ]] || [[ -z "$install_steam" ]] && \
        echo "  - En Steam: Ajustes → Compatibilidad → Activar Proton para todos los juegos"
    [[ "${install_perf,,}" == "s" ]] || [[ -z "$install_perf" ]] && \
        echo "  - MangoHud: agrega 'MANGOHUD=1 %command%' en opciones de lanzamiento de Steam"
}

# --- Punto de entrada ---
install_gaming
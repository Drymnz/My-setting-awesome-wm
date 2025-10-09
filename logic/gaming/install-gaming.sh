#!/usr/bin/env bash

show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }

# Paquetes base para gaming
pkg_vulkan_base="vulkan-mesa-layers lib32-vulkan-mesa-layers vulkan-validation-layers \
lib32-vulkan-validation-layers vulkan-icd-loader lib32-vulkan-icd-loader \
vulkan-headers vulkan-tools vkd3d lib32-vkd3d vulkan-extra-layers vulkan-extra-tools"

pkg_opengl_base="ftgl opengl-man-pages libvdpau-va-gl"

pkg_mesa_base="mesa lib32-mesa glu lib32-glu glslang freeglut lib32-freeglut"

pkg_wine="wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap \
gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils \
libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib \
libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite \
libxinerama lib32-libxinerama libgcrypt lib32-libgcrypt"

pkg_extras="shaderc libretro-shaders-slang mesa-demos lib32-mesa-demos \
libva-mesa-driver lib32-libva-mesa-driver lib32-mesa-vdpau"

# Paquetes específicos por GPU
# Intel
pkg_intel="vulkan-intel lib32-vulkan-intel intel-compute-runtime intel-media-driver \
intel-gmmlib lib32-libva-intel-driver"

# AMD
pkg_amd="vulkan-radeon lib32-vulkan-radeon opencl-mesa lib32-opencl-mesa \
xf86-video-amdgpu"

# NVIDIA Open Source
pkg_nvidia_nouveau="mesa lib32-mesa xf86-video-nouveau"

# NVIDIA Propietario (detecta si ya tienes nvidia o nvidia-dkms instalado)
if pacman -Q nvidia &>/dev/null; then
    pkg_nvidia_proprietary="nvidia-utils lib32-nvidia-utils nvidia-settings \
opencl-nvidia lib32-opencl-nvidia libvdpau lib32-libvdpau"
elif pacman -Q nvidia-dkms &>/dev/null; then
    pkg_nvidia_proprietary="nvidia-utils lib32-nvidia-utils nvidia-settings \
opencl-nvidia lib32-opencl-nvidia libvdpau lib32-libvdpau"
else
    pkg_nvidia_proprietary="nvidia nvidia-utils lib32-nvidia-utils nvidia-settings \
opencl-nvidia lib32-opencl-nvidia libvdpau lib32-libvdpau"
fi

install_gaming() {
    clear
    show_message "INSTALACIÓN DE PAQUETES PARA GAMING"
    echo ""
    show_warning "Esto instalará: Vulkan, OpenGL, Wine, y drivers específicos"
    echo ""
    
    # Detectar GPU
    echo "Seleccione su tarjeta gráfica:"
    echo ""
    echo "  1) Intel"
    echo "  2) AMD"
    echo "  3) NVIDIA (Open Source - Nouveau)"
    echo "  4) NVIDIA (Propietario)"
    echo "  5) Saltar"
    echo ""
    read -r -p "Opción (default 5): " gpu_option
    
    # Construir lista de paquetes
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
            pkg_gaming="${pkg_gaming} ${pkg_nvidia_nouveau}"
            ;;
        4)
            show_message "Configurando para NVIDIA (Propietario)..."
            pkg_gaming="${pkg_gaming} ${pkg_nvidia_proprietary}"
            show_warning "NOTA: Asegúrese de tener los drivers NVIDIA base instalados"
            ;;
        *)
            show_warning "Saltando instalación de gaming"
            return 0
            ;;
    esac
    
    # Preguntar por Wine
    echo ""
    echo "¿Desea instalar Wine (para juegos de Windows)? [S/n]"
    read -r install_wine
    if [[ "${install_wine,,}" == "s" ]] || [[ -z "$install_wine" ]]; then
        pkg_gaming="${pkg_gaming} ${pkg_wine}"
    fi
    
    # Preguntar por Steam
    echo ""
    echo "¿Desea instalar Steam? [S/n]"
    read -r install_steam
    if [[ "${install_steam,,}" == "s" ]] || [[ -z "$install_steam" ]]; then
        show_message "Steam se instalará desde los repositorios multilib"
        pkg_gaming="${pkg_gaming} steam"
        
        # Habilitar multilib si no está habilitado
        if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
            show_warning "Habilitando repositorio multilib..."
            sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
            sudo pacman -Sy
        fi
    fi
    
    # Preguntar por Lutris
    echo ""
    echo "¿Desea instalar Lutris (gestor de juegos)? [s/N]"
    read -r install_lutris
    if [[ "${install_lutris,,}" == "s" ]]; then
        pkg_gaming="${pkg_gaming} lutris"
    fi
    
    # Preguntar por GameMode
    echo ""
    echo "¿Desea instalar GameMode (optimización de rendimiento)? [S/n]"
    read -r install_gamemode
    if [[ "${install_gamemode,,}" == "s" ]] || [[ -z "$install_gamemode" ]]; then
        pkg_gaming="${pkg_gaming} gamemode lib32-gamemode"
    fi
    
    # Preguntar por MangoHud
    echo ""
    echo "¿Desea instalar MangoHud (overlay de rendimiento)? [s/N]"
    read -r install_mangohud
    if [[ "${install_mangohud,,}" == "s" ]]; then
        pkg_gaming="${pkg_gaming} mangohud lib32-mangohud"
    fi
    
    # Instalar paquetes
    show_message "Instalando paquetes de gaming..."
    sudo pacman -S --needed ${pkg_gaming} --noconfirm
    
    # Configuraciones adicionales para NVIDIA
    if [[ $gpu_option -eq 4 ]]; then
        echo ""
        show_warning "Configuraciones adicionales para NVIDIA:"
        echo ""
        echo "¿Desea agregar módulos NVIDIA al initramfs? [S/n]"
        read -r nvidia_modules
        if [[ "${nvidia_modules,,}" == "s" ]] || [[ -z "$nvidia_modules" ]]; then
            show_message "Agregando módulos NVIDIA..."
            
            # Verificar espacio en /boot
            boot_space=$(df /boot | tail -1 | awk '{print $4}')
            if [[ $boot_space -lt 100000 ]]; then
                show_warning "Poco espacio en /boot. Limpiando..."
                sudo pacman -Sc --noconfirm
            fi
            
            # Instalar herramientas si no existen
            sudo pacman -S --needed mkinitcpio pacman-contrib --noconfirm
            
            sudo sed -i 's/^MODULES=(/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
            sudo mkinitcpio -P
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    fi
    
    show_message "Instalación de paquetes para gaming completada"
    echo ""
    show_warning "Recomendaciones:"
    echo "  - Reinicie el sistema para aplicar todos los cambios"
    echo "  - Verifique que su GPU esté correctamente configurada"
    if [[ "${install_steam,,}" == "s" ]] || [[ -z "$install_steam" ]]; then
        echo "  - Para Steam, habilite Proton en la configuración"
    fi
}
}

install_gaming
#!/usr/bin/env bash

show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }

# Paquetes esenciales para Awesome WM
pkg_xorg="xorg xorg-xinit xorg-xinput"
pkg_awesome="awesome"
pkg_terminal="alacritty"
pkg_polkit="polkit-kde-agent"
pkg_dark="gtk3 gtk4"
pkg_sddm="sddm"
pkg_file_manager="thunar thunar-volman thunar-media-tags-plugin thunar-archive-plugin"

# Utilidades básicas
pkg_screenshot="scrot xclip"
pkg_display="lxrandr"
pkg_browser="firefox"
pkg_compositor="picom"
pkg_audio="pavucontrol pulseaudio"
pkg_text_editor="nano"

# Música (opcional)
pkg_music="mpd mpc ncmpcpp"

install_awesome_base() {
    clear
    show_message "INSTALACIÓN BASE DE AWESOME WM"
    echo ""
    
    # Actualizar sistema
    show_message "Actualizando sistema..."
    sudo pacman -Syyu --noconfirm
    
    # Xorg
    show_message "Instalando Xorg..."
    sudo pacman -S --needed ${pkg_xorg} --noconfirm
    
    # Awesome WM
    show_message "Instalando Awesome WM..."
    sudo pacman -S --needed ${pkg_awesome} --noconfirm
    
    # Terminal
    show_message "Instalando terminal..."
    sudo pacman -S --needed ${pkg_terminal} --noconfirm
    
    # Gestor de sesión
    show_message "Instalando gestor de sesión (SDDM)..."
    sudo pacman -S --needed ${pkg_sddm} --noconfirm
    sudo systemctl enable sddm.service
    
    # Gestor de archivos
    show_message "Instalando gestor de archivos..."
    sudo pacman -S --needed ${pkg_file_manager} --noconfirm
    
    # Utilidades básicas
    show_message "Instalando utilidades básicas..."
    sudo pacman -S --needed ${pkg_polkit} ${pkg_screenshot} ${pkg_display} \
    ${pkg_browser} ${pkg_compositor} ${pkg_audio} \
    ${pkg_text_editor}  ${pkg_dark} --noconfirm
    
    # Preguntar por reproductor de música
    echo ""
    echo "¿Desea instalar MPD/NCMPCPP (reproductor de música)? [S/n]"
    read -r install_music
    if [[ "${install_music,,}" == "s" ]] || [[ -z "$install_music" ]]; then
        show_message "Instalando reproductor de música..."
        sudo pacman -S --needed ${pkg_music} --noconfirm
    fi
    
    show_message "Instalación base de Awesome WM completada"
}

install_awesome_base
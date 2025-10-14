#!/usr/bin/env bash

show_message() { echo -e "\033[0;32m==>\033[0m $1"; }

# Aplicaciones multimedia
pkg_video="totem gst-libav"
pkg_music_player="lollypop"
pkg_image_viewer="eog"
pkg_editor="mousepad"

# Temas y fuentes
pkg_themes_base="lxappearance gnome-themes-extra"
pkg_themes_mate="mate-icon-theme mate-icon-theme-faenza mate-themes"
pkg_themes_lxqt="lxqt-qtplugin lxqt-themes"
pkg_themes_xfce="xfwm4-themes"

pkg_fonts_base="ttf-dejavu noto-fonts noto-fonts-emoji ttf-liberation"
pkg_fonts_asian="wqy-zenhei"
pkg_fonts_extra="ttf-croscore gnome-font-viewer"

# Gestores de audio
pkg_audio_manager="pavucontrol pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber"

install_awesome_apps() {
    clear
    show_message "INSTALACIÓN DE APLICACIONES Y TEMAS"
    echo ""
    
    # Aplicaciones multimedia
    echo "¿Desea instalar aplicaciones multimedia? [S/n]"
    read -r install_multimedia
    if [[ "${install_multimedia,,}" == "s" ]] || [[ -z "$install_multimedia" ]]; then
        show_message "Instalando aplicaciones multimedia..."
        
        echo "  1) Todas"
        echo "  2) Solo video"
        echo "  3) Solo música"
        echo "  4) Solo imágenes"
        echo "  5) Solo editor de texto"
        read -r -p "Opción (default 1): " multimedia_option
        
        case $multimedia_option in
            2) sudo pacman -S --needed ${pkg_video} --noconfirm ;;
            3) sudo pacman -S --needed ${pkg_music_player} --noconfirm ;;
            4) sudo pacman -S --needed ${pkg_image_viewer} --noconfirm ;;
            5) sudo pacman -S --needed ${pkg_editor} --noconfirm ;;
            *)
                sudo pacman -S --needed ${pkg_video} ${pkg_music_player} \
                               ${pkg_image_viewer} ${pkg_editor} --noconfirm
                ;;
        esac
    fi
    
    # Temas
    echo ""
    echo "¿Desea instalar temas y gestor de apariencia? [S/n]"
    read -r install_themes
    if [[ "${install_themes,,}" == "s" ]] || [[ -z "$install_themes" ]]; then
        show_message "Instalando temas..."
        sudo pacman -S --needed ${pkg_themes_base} --noconfirm
        
        echo ""
        echo "¿Desea instalar paquetes de temas adicionales? [S/n]"
        read -r install_extra_themes
        if [[ "${install_extra_themes,,}" == "s" ]] || [[ -z "$install_extra_themes" ]]; then
            sudo pacman -S --needed ${pkg_themes_mate} ${pkg_themes_lxqt} \
                                   ${pkg_themes_xfce} --noconfirm
        fi
    fi
    
    # Fuentes
    echo ""
    echo "¿Desea instalar fuentes? [S/n]"
    read -r install_fonts
    if [[ "${install_fonts,,}" == "s" ]] || [[ -z "$install_fonts" ]]; then
        show_message "Instalando fuentes básicas..."
        sudo pacman -S --needed ${pkg_fonts_base} --noconfirm
        
        echo ""
        echo "¿Desea instalar fuentes asiáticas? [s/N]"
        read -r install_asian
        if [[ "${install_asian,,}" == "s" ]]; then
            sudo pacman -S --needed ${pkg_fonts_asian} --noconfirm
        fi
        
        echo ""
        echo "¿Desea instalar fuentes adicionales? [s/N]"
        read -r install_extra_fonts
        if [[ "${install_extra_fonts,,}" == "s" ]]; then
            sudo pacman -S --needed ${pkg_fonts_extra} --noconfirm
        fi
    fi
    
    # Gestor de audio
    show_message "Instalando gestor de audio..."
    sudo pacman -S --needed ${pkg_audio_manager} --noconfirm
    systemctl --user enable --now pipewire pipewire-pulse wireplumber
    
    show_message "Aplicaciones y temas instalados correctamente"
}

install_awesome_apps
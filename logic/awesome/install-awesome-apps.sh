#!/usr/bin/env bash

# =============================================================================
# install-awesome-apps.sh
# Instalación de aplicaciones, temas y fuentes para Awesome WM
#
# NOTA: No requiere [multilib]. Todos los paquetes son de [extra] y [core].
# =============================================================================

# --- Funciones de salida visual ---
show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }

# --- Aplicaciones multimedia ---
pkg_multimedia="totem gst-libav lollypop eog mousepad"
# totem      → reproductor de video
# gst-libav  → codecs multimedia para GStreamer (mp4, mkv, etc.)
# lollypop   → reproductor de música
# eog        → visor de imágenes (Eye of GNOME)
# mousepad   → editor de texto simple

# --- Temas base (siempre se instalan con Awesome) ---
pkg_themes_base="lxappearance gnome-themes-extra"
# lxappearance      → gestor de apariencia GTK
# gnome-themes-extra → temas Adwaita y otros

# --- Temas adicionales (opcional) ---
pkg_themes_extra="mate-icon-theme mate-icon-theme-faenza mate-themes lxqt-qtplugin lxqt-themes"
# mate-icon-theme         → íconos estilo MATE
# mate-icon-theme-faenza  → íconos Faenza
# mate-themes             → temas GTK estilo MATE
# lxqt-qtplugin/themes    → soporte de temas para aplicaciones Qt

# --- Fuentes base (siempre se instalan) ---
pkg_fonts_base="ttf-dejavu noto-fonts noto-fonts-emoji ttf-liberation"
# ttf-dejavu      → fuente clásica de propósito general
# noto-fonts      → fuente Google con amplia cobertura de idiomas
# noto-fonts-emoji → emojis
# ttf-liberation  → equivalente libre a Times/Arial/Courier

# --- Fuentes adicionales (opcional) ---
pkg_fonts_extra="ttf-croscore gnome-font-viewer wqy-zenhei"
# ttf-croscore      → fuentes Chrome OS (Arimo, Tinos, Cousine)
# gnome-font-viewer → visor gráfico de fuentes
# wqy-zenhei        → fuente CJK (chino, japonés, coreano)

# --- Audio ---
pkg_audio="pavucontrol pipewire pipewire-pulse wireplumber"
# pavucontrol    → mezclador de audio gráfico (PulseAudio/PipeWire)
# pipewire       → servidor de audio moderno
# pipewire-pulse → compatibilidad con aplicaciones PulseAudio
# wireplumber    → gestor de sesión para PipeWire

install_awesome_apps() {
    clear
    show_message "INSTALACIÓN DE APLICACIONES Y TEMAS"
    echo ""

    # === Multimedia (opcional) ===
    echo "¿Desea instalar aplicaciones multimedia? [S/n]"
    echo "  (video, música, imágenes, editor de texto)"
    read -r -p "Opción: " install_multimedia
    if [[ "${install_multimedia,,}" == "s" ]] || [[ -z "$install_multimedia" ]]; then
        show_message "Instalando aplicaciones multimedia..."
        sudo pacman -S --needed ${pkg_multimedia} --noconfirm
    else
        show_warning "Saltando aplicaciones multimedia"
    fi

    # === Temas base (obligatorio para Awesome WM) ===
    echo ""
    show_message "Instalando temas base..."
    sudo pacman -S --needed ${pkg_themes_base} --noconfirm

    # === Temas adicionales (opcional) ===
    echo ""
    echo "¿Desea instalar temas adicionales (MATE, LXQt)? [s/N]"
    read -r install_extra_themes
    if [[ "${install_extra_themes,,}" == "s" ]]; then
        show_message "Instalando temas adicionales..."
        sudo pacman -S --needed ${pkg_themes_extra} --noconfirm
    else
        show_warning "Saltando temas adicionales"
    fi

    # === Fuentes base (obligatorio) ===
    echo ""
    show_message "Instalando fuentes base..."
    sudo pacman -S --needed ${pkg_fonts_base} --noconfirm

    # === Fuentes adicionales (opcional) ===
    echo ""
    echo "¿Desea instalar fuentes adicionales y soporte CJK? [s/N]"
    read -r install_extra_fonts
    if [[ "${install_extra_fonts,,}" == "s" ]]; then
        show_message "Instalando fuentes adicionales..."
        sudo pacman -S --needed ${pkg_fonts_extra} --noconfirm
    else
        show_warning "Saltando fuentes adicionales"
    fi

    # === Audio (obligatorio) ===
    echo ""
    show_message "Instalando gestor de audio (PipeWire)..."
    sudo pacman -S --needed ${pkg_audio} --noconfirm

    # Activar PipeWire para el usuario actual
    systemctl --user enable --now pipewire pipewire-pulse wireplumber

    echo ""
    show_message "Aplicaciones y temas instalados correctamente"
}

# --- Punto de entrada ---
install_awesome_apps
#!/usr/bin/env bash

# === Funciones visuales ===
show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }
show_error()   { echo -e "\033[0;31m==>\033[0m $1"; }

# === Resolver rutas base ===
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT=""

if [[ -d "$SCRIPT_DIR/../../configuracionAWM" ]]; then
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
elif [[ -d "$SCRIPT_DIR/../configuracionAWM" ]]; then
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
    PROJECT_ROOT="$(pwd)"
fi

show_message "Usando raíz del proyecto: $PROJECT_ROOT"

apply_configs() {
    clear
    show_message "APLICACIÓN DE CONFIGURACIONES PERSONALIZADAS"
    echo ""

    # Crear directorios necesarios
    show_message "Creando directorios..."
    mkdir -p "$HOME"/.config/{awesome,alacritty,nano}
    mkdir -p "$HOME"/.{ncmpcpp,mpd}
    mkdir -p "$HOME"/.ncmpcpp/lyrics
    mkdir -p "$HOME"/.mpd/playlists
    mkdir -p "$HOME"/Music

    # === Awesome WM ===
    if [[ -d "${PROJECT_ROOT}/configuracionAWM" ]]; then
        show_message "Copiando configuración de Awesome..."
        cp -r /etc/xdg/awesome/rc.lua "$HOME/.config/awesome/rc.lua" 2>/dev/null
        cp -r "${PROJECT_ROOT}/configuracionAWM/"* "$HOME/.config/awesome/"
        show_message "Configuración de Awesome aplicada"
    else
        show_warning "No se encontró configuracionAWM"
    fi

    # === Alacritty ===
    if [[ -d "${PROJECT_ROOT}/configuracionAlacritty" ]]; then
        show_message "Copiando configuración de Alacritty..."
        mkdir -p "$HOME/.config/alacritty"
        [[ ! -f "$HOME/.config/alacritty/alacritty.toml" ]] && \
            cp /usr/share/doc/alacritty/example/alacritty.toml "$HOME/.config/alacritty/" 2>/dev/null
        cp -r "${PROJECT_ROOT}/configuracionAlacritty/"* "$HOME/.config/alacritty/"
        show_message "Configuración de Alacritty aplicada"
    fi

    # === MPD y NCMPCPP ===
    if [[ -d "${PROJECT_ROOT}/configuracionMpd" ]] || [[ -d "${PROJECT_ROOT}/configuracionNcmpcpp" ]]; then
        show_message "Copiando configuración de música..."
        [[ -d "${PROJECT_ROOT}/configuracionMpd" ]] && cp -r "${PROJECT_ROOT}/configuracionMpd/"* "$HOME/.mpd/"
        [[ -d "${PROJECT_ROOT}/configuracionNcmpcpp" ]] && cp -r "${PROJECT_ROOT}/configuracionNcmpcpp/"* "$HOME/.ncmpcpp/"
        [[ -d "${PROJECT_ROOT}/Music" ]] && cp -r "${PROJECT_ROOT}/Music/"* "$HOME/Music/"
        command -v mpc &>/dev/null && mpc update 2>/dev/null
        show_message "Configuración de música aplicada"
    fi

    # === Nano ===
    if [[ -d "${PROJECT_ROOT}/configuracionNano" ]]; then
        show_message "Copiando configuración de Nano..."
        sudo mkdir -p /etc/sddm.conf.d
        sudo cp -r "${PROJECT_ROOT}/configuracionNano/nanorc" /etc/nanorc
        show_message "Configuración de Nano aplicada"
    fi

    # === Bash ===
    if [[ -d "${PROJECT_ROOT}/configuracionBash" ]]; then
        show_message "Copiando configuración de Bash..."
        cp -r "${PROJECT_ROOT}/configuracionBash/.bashrc" "$HOME/" 2>/dev/null
        show_message "Configuración de Bash aplicada"
    fi

    # === SDDM ===
    if [[ -d "${PROJECT_ROOT}/configuracionSession" ]]; then
        show_message "Copiando configuración de SDDM..."
        sudo mkdir -p /etc/sddm.conf.d
        sudo cp -r "${PROJECT_ROOT}/configuracionSession/sddm.conf" /etc/sddm.conf.d/sddm.conf
        show_message "Configuración de SDDM aplicada"
    fi

    # === Bloqueo de kernel ===
    if [[ -d "${PROJECT_ROOT}/configuracionPacman" ]]; then
        echo ""
        echo "¿Desea bloquear actualizaciones del kernel? [s/N]"
        read -r block_kernel
        if [[ "${block_kernel,,}" == "s" ]]; then
            show_message "Aplicando bloqueo de kernel..."
            sudo cp -r "${PROJECT_ROOT}/configuracionPacman/"* /etc/pacman.conf
            show_message "Kernel bloqueado en pacman.conf"
        fi
    fi

    show_message "Configuraciones aplicadas correctamente"
    echo ""
    show_warning "IMPORTANTE: Reinicia la sesión o el sistema para que los cambios tengan efecto"
}

apply_configs

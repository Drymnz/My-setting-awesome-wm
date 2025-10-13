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
echo ""

apply_configs() {
    clear
    show_message "APLICACIÓN DE CONFIGURACIONES PERSONALIZADAS"
    echo ""

    # Crear directorios necesarios
    show_message "Creando directorios base..."
    mkdir -p "$HOME"/.config/{awesome,alacritty,nano}
    mkdir -p "$HOME"/.{ncmpcpp,mpd}
    mkdir -p "$HOME"/.ncmpcpp/lyrics
    mkdir -p "$HOME"/.mpd/playlists
    mkdir -p "$HOME"/Music
    echo ""

    # === Awesome WM ===
    if [[ -d "${PROJECT_ROOT}/configuracionAWM" ]]; then
        read -rp "¿Aplicar configuración de AwesomeWM? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Copiando configuración de Awesome..."
            cp -r /etc/xdg/awesome/rc.lua "$HOME/.config/awesome/rc.lua" 2>/dev/null
            cp -r "${PROJECT_ROOT}/configuracionAWM/"* "$HOME/.config/awesome/"
            show_message "Configuración de Awesome aplicada"
        else
            show_warning "Saltando configuración de Awesome"
        fi
    fi
    echo ""

    # === Alacritty ===
    if [[ -d "${PROJECT_ROOT}/configuracionAlacritty" ]]; then
        read -rp "¿Aplicar configuración de Alacritty? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Copiando configuración de Alacritty..."
            mkdir -p "$HOME/.config/alacritty"
            [[ ! -f "$HOME/.config/alacritty/alacritty.toml" ]] && \
            cp /usr/share/doc/alacritty/example/alacritty.toml "$HOME/.config/alacritty/" 2>/dev/null
            cp -r "${PROJECT_ROOT}/configuracionAlacritty/"* "$HOME/.config/alacritty/"
            show_message "Configuración de Alacritty aplicada"
        else
            show_warning "Saltando configuración de Alacritty"
        fi
    fi
    echo ""

    # === MPD y NCMPCPP ===
    if [[ -d "${PROJECT_ROOT}/configuracionMpd" ]] || [[ -d "${PROJECT_ROOT}/configuracionNcmpcpp" ]]; then
        read -rp "¿Aplicar configuración de MPD/NCMPCPP? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Copiando configuración de música..."
            [[ -d "${PROJECT_ROOT}/configuracionMpd" ]] && cp -r "${PROJECT_ROOT}/configuracionMpd/"* "$HOME/.mpd/"
            [[ -d "${PROJECT_ROOT}/configuracionNcmpcpp" ]] && cp -r "${PROJECT_ROOT}/configuracionNcmpcpp/"* "$HOME/.ncmpcpp/"
            [[ -d "${PROJECT_ROOT}/Music" ]] && cp -r "${PROJECT_ROOT}/Music/"* "$HOME/Music/"
            command -v mpc &>/dev/null && mpc update 2>/dev/null
            show_message "Configuración de música aplicada"
        else
            show_warning "Saltando configuración de música"
        fi
    fi
    echo ""

    # === Nano ===
    if [[ -d "${PROJECT_ROOT}/configuracionNano" ]]; then
        read -rp "¿Aplicar configuración de Nano? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Copiando configuración de Nano..."
            sudo cp -r "${PROJECT_ROOT}/configuracionNano/nanorc" /etc/nanorc
            show_message "Configuración de Nano aplicada"
        else
            show_warning "Saltando configuración de Nano"
        fi
    fi
    echo ""

    # === Bash ===
    if [[ -d "${PROJECT_ROOT}/configuracionBash" ]]; then
        read -rp "¿Aplicar configuración de Bash (.bashrc)? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Copiando configuración de Bash..."
            cp -r "${PROJECT_ROOT}/configuracionBash/.bashrc" "$HOME/" 2>/dev/null
            show_message "Configuración de Bash aplicada"
        else
            show_warning "Saltando configuración de Bash"
        fi
    fi
    echo ""

    # === SDDM ===
    if [[ -d "${PROJECT_ROOT}/configuracionSession" ]]; then
        read -rp "¿Aplicar configuración de SDDM? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Copiando configuración de SDDM..."
            sudo mkdir -p /etc/sddm.conf.d
            sudo cp -r "${PROJECT_ROOT}/configuracionSession/sddm.conf" /etc/sddm.conf.d/sddm.conf
            show_message "Configuración de SDDM aplicada"
        else
            show_warning "Saltando configuración de SDDM"
        fi
    fi
    echo ""

    # === Bloqueo de kernel ===
    if [[ -d "${PROJECT_ROOT}/configuracionPacman" ]]; then
        read -rp "¿Desea bloquear actualizaciones del kernel en pacman.conf? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Aplicando bloqueo de kernel..."
            sudo cp -r "${PROJECT_ROOT}/configuracionPacman/"* /etc/pacman.conf
            show_message "Kernel bloqueado correctamente"
        else
            show_warning "Saltando bloqueo de kernel"
        fi
    fi
    echo ""

    # === Modo oscuro GTK ===
    read -rp "¿Aplicar configuración de modo oscuro GTK? [s/N]: " resp
    if [[ "${resp,,}" == "s" ]]; then
        show_message "Aplicando modo oscuro (GTK3/GTK4)..."
        mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"

        cat > "$HOME/.config/gtk-3.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=Noto Sans 10
gtk-application-prefer-dark-theme=1
EOF

        cat > "$HOME/.config/gtk-4.0/settings.ini" <<EOF
[Settings]
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Adwaita
gtk-font-name=Noto Sans 10
gtk-application-prefer-dark-theme=1
EOF

        if command -v gsettings &>/dev/null; then
            gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null
            gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
            show_message "Preferencia global de tema oscuro aplicada mediante gsettings"
        else
            show_warning "gsettings no está instalado; se aplicó solo en GTK"
        fi
    else
        show_warning "Saltando configuración GTK"
    fi

    echo ""
    show_message "Proceso completado."
    show_warning "IMPORTANTE: Reinicia la sesión o el sistema para aplicar todos los cambios."
}

apply_configs

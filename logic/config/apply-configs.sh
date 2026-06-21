#!/usr/bin/env bash

# =============================================================================
# apply-configs.sh
# Aplica las configuraciones personalizadas del proyecto
#
# Solo pregunta dos cosas:
#   1) Configuración de Awesome WM
#   2) Configuración de la terminal (Alacritty)
# El resto se aplica automáticamente.
# =============================================================================

# --- Funciones de salida visual ---
show_message() { echo -e "\033[0;32m==>\033[0m $1"; }
show_warning() { echo -e "\033[1;33m==>\033[0m $1"; }
show_error()   { echo -e "\033[0;31m==>\033[0m $1"; }

# --- Resolver ruta raíz del proyecto ---
# Funciona tanto si se ejecuta desde logic/config/ como desde la raíz
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -d "$SCRIPT_DIR/../../configuracionAWM" ]]; then
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
elif [[ -d "$SCRIPT_DIR/../configuracionAWM" ]]; then
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
else
    PROJECT_ROOT="$(pwd)"
fi

show_message "Raíz del proyecto: $PROJECT_ROOT"
echo ""

apply_configs() {
    clear
    show_message "APLICACIÓN DE CONFIGURACIONES PERSONALIZADAS"
    echo ""

    # === Crear directorios base necesarios (siempre) ===
    show_message "Creando directorios de configuración..."
    mkdir -p "$HOME/.config/{awesome,alacritty,nano}"
    mkdir -p "$HOME/."{ncmpcpp,mpd}
    mkdir -p "$HOME/.ncmpcpp/lyrics"
    mkdir -p "$HOME/.mpd/playlists"
    mkdir -p "$HOME/Music"
    echo ""

    # === Pregunta 1: Configuración de Awesome WM ===
    if [[ -d "${PROJECT_ROOT}/configuracionAWM" ]]; then
        read -rp "¿Aplicar configuración de Awesome WM? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Aplicando configuración de Awesome WM..."

            # Copiar rc.lua base del sistema como respaldo si no existe
            cp -n /etc/xdg/awesome/rc.lua "$HOME/.config/awesome/rc.lua" 2>/dev/null

            # Copiar toda la configuración personalizada
            cp -r "${PROJECT_ROOT}/configuracionAWM/"* "$HOME/.config/awesome/"
            show_message "Awesome WM configurado"
        else
            show_warning "Saltando configuración de Awesome WM"
        fi
    fi
    echo ""

    # === Pregunta 2: Configuración de la terminal (Alacritty) ===
    if [[ -d "${PROJECT_ROOT}/configuracionAlacritty" ]]; then
        read -rp "¿Aplicar configuración de Alacritty (terminal)? [s/N]: " resp
        if [[ "${resp,,}" == "s" ]]; then
            show_message "Aplicando configuración de Alacritty..."

            mkdir -p "$HOME/.config/alacritty"

            # Copiar config de ejemplo del sistema como base si no existe
            [[ ! -f "$HOME/.config/alacritty/alacritty.toml" ]] && \
                cp /usr/share/doc/alacritty/example/alacritty.toml \
                   "$HOME/.config/alacritty/" 2>/dev/null

            cp -r "${PROJECT_ROOT}/configuracionAlacritty/"* "$HOME/.config/alacritty/"
            show_message "Alacritty configurado"
        else
            show_warning "Saltando configuración de Alacritty"
        fi
    fi
    echo ""

    # === Configuraciones automáticas (sin preguntar) ===
    show_message "Aplicando configuraciones automáticas..."

    # Nano
    if [[ -f "${PROJECT_ROOT}/configuracionNano/nanorc" ]]; then
        sudo cp "${PROJECT_ROOT}/configuracionNano/nanorc" /etc/nanorc
        show_message "Nano configurado"
    fi

    # Bash
    if [[ -f "${PROJECT_ROOT}/configuracionBash/.bashrc" ]]; then
        cp "${PROJECT_ROOT}/configuracionBash/.bashrc" "$HOME/.bashrc"
        show_message "Bash (.bashrc) configurado"
    fi

    # SDDM (gestor de sesión)
    if [[ -f "${PROJECT_ROOT}/configuracionSession/sddm.conf" ]]; then
        sudo mkdir -p /etc/sddm.conf.d
        sudo cp "${PROJECT_ROOT}/configuracionSession/sddm.conf" /etc/sddm.conf.d/sddm.conf
        show_message "SDDM configurado"
    fi

    # MPD y NCMPCPP (reproductor de música)
    [[ -d "${PROJECT_ROOT}/configuracionMpd" ]] && \
        cp -r "${PROJECT_ROOT}/configuracionMpd/"* "$HOME/.mpd/" && \
        show_message "MPD configurado"

    [[ -d "${PROJECT_ROOT}/configuracionNcmpcpp" ]] && \
        cp -r "${PROJECT_ROOT}/configuracionNcmpcpp/"* "$HOME/.ncmpcpp/" && \
        show_message "NCMPCPP configurado"

    [[ -d "${PROJECT_ROOT}/Music" ]] && \
        cp -r "${PROJECT_ROOT}/Music/"* "$HOME/Music/"

    # Actualizar biblioteca de MPD si está disponible
    command -v mpc &>/dev/null && mpc update 2>/dev/null

    # Modo oscuro GTK3 y GTK4
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

    # Aplicar tema oscuro globalmente si gsettings está disponible
    if command -v gsettings &>/dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
    fi
    show_message "Modo oscuro GTK aplicado"

    echo ""
    show_message "Configuraciones aplicadas correctamente"
    show_warning "Reinicia la sesión o el sistema para ver todos los cambios."
}

# --- Punto de entrada ---
apply_configs
#!/bin/bash
# ===================================
# PASO 1: Preparación inicial
# ===================================

# Configurar teclado español
loadkeys la-latin1

# Verificar modo UEFI
echo "Verificando modo UEFI..."
if [ -d /sys/firmware/efi/efivars ]; then
    echo "✓ Sistema iniciado en modo UEFI"
else
    echo "✗ ERROR: Sistema NO está en modo UEFI"
    exit 1
fi

# Conectar Wi-Fi (interactivo)
echo ""
echo "=== Configuración de Wi-Fi ==="
echo "¿Necesitas conectar Wi-Fi? (s/n)"
read -r respuesta

if [ "$respuesta" = "s" ]; then
    echo "Iniciando iwctl..."
    echo "  device list"
    echo "  station wlan0 scan"
    echo "  station wlan0 get-networks"
    echo "  station wlan0 connect \"NOMBRE_WIFI\""
    echo "  exit"
    iwctl
fi

# Sincronizar hora
timedatectl set-ntp true

echo "✓ PASO 1 completado"
echo "Siguiente: ejecutar 02-particionado.sh"
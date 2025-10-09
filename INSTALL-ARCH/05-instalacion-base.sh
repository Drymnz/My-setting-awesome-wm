#!/bin/bash
# ===================================
# PASO 5: Instalación del sistema base (simplificado)
# ===================================

echo "=== PASO 5: Instalación del sistema base ==="
echo ""

echo "¿Deseas optimizar los mirrors con reflector antes de instalar? (SI/NO)"
read -r RESP

if [ "$RESP" = "SI" ]; then
    echo ""
    echo "# --- Comandos que se ejecutarán ---"
    echo "pacman -Sy --noconfirm reflector"
    echo "reflector --country Guatemala,Mexico --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
    echo ""
    read -p "Presiona ENTER para continuar..."
    pacman -Sy --noconfirm reflector
    reflector --country Guatemala,Mexico --protocol https --sort rate --save /etc/pacman.d/mirrorlist
else
    echo "Saltando optimización de mirrors."
fi

echo ""
echo "# --- Instalando sistema base ---"
read -p "Presiona ENTER para iniciar la instalación..."

pacstrap /mnt base linux-zen linux-zen-headers linux-firmware vim networkmanager iwd wpa_supplicant

if [ $? -eq 0 ]; then
    echo ""
    echo "✓ Sistema base instalado correctamente"
else
    echo ""
    echo "✗ ERROR durante la instalación"
    exit 1
fi

echo ""
echo "# --- Generar fstab ---"
echo "genfstab -U /mnt >> /mnt/etc/fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "✓ PASO 5 completado"
echo "Siguiente: ejecutar 06-configuracion-sistema.sh (dentro del chroot)"

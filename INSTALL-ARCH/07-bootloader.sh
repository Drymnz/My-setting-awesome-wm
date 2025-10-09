#!/bin/bash
# ===================================
# PASO 7: Instalación de GRUB (UEFI)
# ===================================
# ESTE SCRIPT SE EJECUTA DENTRO DEL CHROOT

echo "=== PASO 7: Instalación del bootloader GRUB ==="

# Verificar que estamos en chroot
if [ ! -d /boot/EFI ] && [ ! "$(ls -A /boot 2>/dev/null)" ]; then
    echo "✗ ERROR: Este script debe ejecutarse dentro del chroot"
    echo "Ejecuta: arch-chroot /mnt"
    exit 1
fi

# Verificar que /boot esté montado
if [ -z "$(ls -A /boot)" ]; then
    echo "✗ ERROR: /boot parece estar vacío"
    echo "Asegúrate de que la partición EFI esté montada en /boot"
    exit 1
fi

echo "1. Instalando GRUB y efibootmgr..."
pacman -S --noconfirm grub efibootmgr

echo ""
echo "2. Instalando GRUB en modo UEFI..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

if [ $? -ne 0 ]; then
    echo "✗ ERROR: Falló la instalación de GRUB"
    exit 1
fi

echo ""
echo "3. Configurando hibernación con swap..."

# Leer UUID de swap
if [ -f /root/swap_uuid.txt ]; then
    SWAP_UUID=$(cat /root/swap_uuid.txt)
    echo "UUID de swap detectado: $SWAP_UUID"
    
    # Crear backup de grub
    cp /etc/default/grub /etc/default/grub.backup
    
    # Agregar resume al GRUB
    sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 resume=UUID=$SWAP_UUID\"/" /etc/default/grub
    
    echo "✓ Configuración de hibernación agregada a GRUB"
else
    echo "⚠️  No se encontró UUID de swap, omitiendo configuración de hibernación"
fi

echo ""
echo "4. Generando archivo de configuración de GRUB..."
grub-mkconfig -o /boot/grub/grub.cfg

if [ $? -eq 0 ]; then
    echo "✓ GRUB instalado y configurado correctamente"
else
    echo "✗ ERROR al generar configuración de GRUB"
    exit 1
fi

echo ""
echo "5. Habilitando NetworkManager e iwd..."
systemctl enable NetworkManager
systemctl enable iwd

echo ""
echo "✓ PASO 7 completado"
echo ""
echo "Estado del bootloader:"
efibootmgr
echo ""
echo "Siguiente: ejecutar 08-entorno-grafico.sh (también dentro del chroot)"
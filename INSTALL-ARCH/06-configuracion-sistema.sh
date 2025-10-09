#!/bin/bash
# ===================================
# PASO 6: Configuración del sistema
# ===================================
# ESTE SCRIPT SE EJECUTA DENTRO DEL CHROOT O SE ENTRA AUTOMÁTICAMENTE

echo "=== PASO 6: Configuración del sistema ==="
echo ""

# Verificar si estamos dentro del chroot (si no existe /root/swap_uuid.txt, probablemente no)
if [ ! -f /root/swap_uuid.txt ]; then
    echo "No se detectó el entorno chroot. Intentando entrar automáticamente..."
    if mountpoint -q /mnt; then
        echo ""
        echo "Entrando al sistema con: arch-chroot /mnt"
        echo ""
        exec arch-chroot /mnt /bin/bash -c "/root/06-configuracion-sistema.sh"
        exit 0
    else
        echo "✗ ERROR: No se pudo entrar al chroot. Asegúrate de que /mnt esté montado y contenga el sistema base."
        exit 1
    fi
fi

# ===================================
# CONFIGURACIÓN DENTRO DEL CHROOT
# ===================================

echo "1. Configurando zona horaria..."
ln -sf /usr/share/zoneinfo/America/Guatemala /etc/localtime
hwclock --systohc

echo ""
echo "2. Configurando idioma..."
echo "es_GT.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=es_GT.UTF-8" > /etc/locale.conf

echo ""
echo "3. Configurando teclado..."
echo "KEYMAP=la-latin1" > /etc/vconsole.conf

echo ""
echo "4. Configurando hostname..."
echo "Ingresa el nombre de tu equipo (ejemplo: archlinux-pc):"
read -r HOSTNAME
echo "$HOSTNAME" > /etc/hostname

echo ""
echo "5. Configurando archivo hosts..."
cat > /etc/hosts << EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
EOF

echo ""
echo "6. Configurando contraseña de root..."
passwd

echo ""
echo "7. Crear usuario nuevo"
echo "Ingresa el nombre de usuario:"
read -r NEWUSER

# Crear usuario y guardarlo para pasos posteriores
useradd -m -G wheel -s /bin/bash "$NEWUSER"
echo "$NEWUSER" > /root/usuario_nombre.txt

echo ""
echo "Contraseña para el usuario $NEWUSER:"
passwd "$NEWUSER"

echo ""
echo "✓ Usuario '$NEWUSER' creado y guardado en /root/usuario_nombre.txt"

echo ""
echo "✓ Configuración básica completada"
echo ""
echo "Resumen de configuración:"
echo "  Zona horaria: America/Guatemala"
echo "  Idioma: es_GT.UTF-8"
echo "  Teclado: la-latin1 (Español Latinoamericano)"
echo "  Hostname: $HOSTNAME"
echo "  Usuario: $NEWUSER"
echo ""
echo "✓ PASO 6 completado"
echo "Siguiente: ejecutar 07-bootloader.sh (dentro del chroot)"

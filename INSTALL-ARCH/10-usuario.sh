#!/bin/bash
# ===================================
# PASO 10: Creación de usuario
# ===================================
# ESTE SCRIPT SE EJECUTA DENTRO DEL CHROOT

echo "=== PASO 10: Creación de usuario ==="

echo "Ingresa el nombre del usuario a crear:"
read -r USERNAME

if [ -z "$USERNAME" ]; then
    echo "✗ ERROR: Nombre de usuario vacío"
    exit 1
fi

# Verificar si el usuario ya existe
if id "$USERNAME" &>/dev/null; then
    echo "✗ ERROR: El usuario $USERNAME ya existe"
    exit 1
fi

echo ""
echo "Creando usuario $USERNAME..."

# Crear usuario con directorio home
useradd -m -G wheel,audio,video,optical,storage,power,network -s /bin/bash "$USERNAME"

if [ $? -ne 0 ]; then
    echo "✗ ERROR al crear usuario"
    exit 1
fi

echo ""
echo "Configurando contraseña para $USERNAME:"
passwd "$USERNAME"

echo ""
echo "Configurando sudo..."

# Instalar sudo si no está instalado
if ! command -v sudo &> /dev/null; then
    echo "Instalando sudo..."
    pacman -S --noconfirm sudo
fi

# Habilitar wheel group en sudoers
if grep -q "^# %wheel ALL=(ALL:ALL) ALL" /etc/sudoers; then
    sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
    echo "✓ Grupo wheel habilitado en sudoers"
else
    echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers
    echo "✓ Grupo wheel agregado a sudoers"
fi

echo ""
echo "✓ Usuario $USERNAME creado correctamente"
echo ""
echo "Grupos del usuario:"
groups "$USERNAME"

echo ""
echo "✓ PASO 10 completado"
echo ""
echo "El usuario $USERNAME tiene permisos sudo"
echo ""
echo "Siguiente: ejecutar 11-finalizar.sh (también dentro del chroot)"
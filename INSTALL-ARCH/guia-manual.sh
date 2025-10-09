
# --- Formatear ---
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3

# --- Montar ---
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot
swapon /dev/sda2

# --- Instalar sistema base con kernel ZEN + Wi-Fi ---
pacstrap /mnt base linux-zen linux-zen-headers linux-firmware vim network-manager-applet wpa_supplicant

# --- Generar fstab y entrar ---
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# --- Zona horaria, idioma, teclado ---
ln -sf /usr/share/zoneinfo/America/Guatemala /etc/localtime
hwclock --systohc
echo "es_GT.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=es_GT.UTF-8" > /etc/locale.conf
echo "KEYMAP=la-latin1" > /etc/vconsole.conf

# --- Hostname y contraseña root ---
echo "aslinos-pc" > /etc/hostname
passwd

# --- Instalar GRUB (UEFI) ---
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# --- Activar red ---
systemctl enable NetworkManager

# --- Entorno gráfico: Awesome + SDDM ---
pacman -S --noconfirm xorg awesome sddm lxappearance nitrogen picom rofi alacritty network-manager-applet
systemctl enable sddm

# --- Drivers gráficos ---
pacman -S --noconfirm mesa xf86-video-intel vulkan-intel
pacman -S --noconfirm nvidia nvidia-utils nvidia-prime bbswitch

# --- Activar swap e hibernación ---
swapon --show
cat /etc/fstab
# Copiar UUID de swap y usarlo en:
# /etc/default/grub → GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet resume=UUID=TU_UUID_SWAP"
grub-mkconfig -o /boot/grub/grub.cfg

# --- Finalizar ---
exit
umount -R /mnt
reboot
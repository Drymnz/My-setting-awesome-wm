#Actualizar lista de MirrorList
#sudo pacman -S --needed reflector --noconfirm
sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
clear

#Actualizar Sistema
sudo pacman -Syu
clear

#Eliminar cache de descargas de programas
echo "Tamaño del cache pacman y yay"
du -sh /var/cache/pacman/pkg/
du -sh ~/.cache/yay
sudo pacman -Scc
yay -Scc

#Eliminar paquetes huerfanos
#sudo pacman -Rns $(pacman -Qdtq)

#Eliminar cache
echo "Tamaño del cache general del usario"
du -sh .cache
rm -rf .cache/*

#Eliminar configuraciones (cuidado)
echo "Tamaño de la carpeta config"
du -sh .config

#Revisar servicios de systemD
#systemctl --failed
#sudo journalctl -p 3 -xb

#Eliminar registro de journal
echo "Tamaño de journal"
du -sh /var/log/journal
sudo rm -rf /var/log/journal/*

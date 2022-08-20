# My-setting-awesome-wm
<img src='/recursos-git/00_1366x768_scrot.png'>
<img src='/recursos-git/01_1366x768_scrot.png'>

* ## Requisitos a usar
* #### git
    Se requiere instalar git para poder clonar el repo.

    ```
    sudo pacman -Syu git
    ```

* ## Instalacion
    ### Instalacion Arch Linux
    Esta parte es par aun sistema basado en Arch Linux

    ```bash
    $ git clone https://github.com/Drymnz/My-setting-awesome-wm.git
    $ cd ./My-setting-awesome-wm
    $ chmod +x ./install-on-arch.sh
    $ ./install-on-arch.sh
    ```
* ## Error comun
    ### Wallpaper
    La primera ves no cargar por que la dirrecion del wallpaper esta mal

    ```bash
    cd ~/.config/awesome/
    ```

    * editar el rc.lua
    * en la parte (url_wallpaper = "$HOME/.config/awesome/wallpaper/Ruka Sarashina.jpg")
    *  cambiar el $HOME por su usario /home/{tu usario}
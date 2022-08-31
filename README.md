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
* ## Tabla de atajos de escritorio
    W = home / tecla windos
    A = Atl
    S = Shift
    C = Control
    Tab = Tabulador
    Entrar = Enter / Entrar / Return
    space = Barra espaciadora
    num = munero de teclado 1 al 9

| Tacla | Descipcion |
| --------- | --------- |
| W + s |Ver ayuda | 
| A + C + -> |Mover al escritorio izquierdo|
| A + C + <- | Mover al escritorio derecha" | 
| W + S + s | Captura de pantalla en area | 
| A + Tab | Siguiente ventana | 
| A + Tab +S | Anterior ventana | 
| A + S + w | Reproduce cancion / Detiene la cancion | 
| A + S + s | Siguiente cancion | 
| A + S + a | Anterior cancion | 
| A + S + x | Bajar volumen a la musica | 
| A + S + z |Subir volumen a la musica | 
| W + w | Ver menu | 
| W + Entrar | Abrier terminal | 
| W + C + r | Refrescar awesome wm | 
| W + space | Siguiente ordenamiento de escritorio | 
| W + A + space | Siguiente ordenamiento de escritorio | 
| W + C + n | Restaura las ventanas miminizada | 
| W + A + p | Apagar el equipo| 
| W + A + r | Reiniciar el equipo| 
| W + f | Ventana en pantalla completa| 
| W + S + f | Cerrar ventana| 
| W + <- | Ajustar ventana a la mita de pantalla izquierda | 
| W + -> | Ajustar ventana a la mita de pantalla derecha | 
| W + C + Return | Mover focus a master| 
| W + C + p | Intercambiar posicion con el siguiente| 
| W + C + o | Intercambiar posicion con el anterior| 
| W + t | Mantener en la ventana superior| 
| W + n | Miminizar la ventana| 
| W + m | (un)maximize| 
| W + C + m | (un)maximize vertically (only tili)| 
| W + S + m | (un)maximize horizontally (only tili)| 
| W + num | Ver escritorio -> #{num} | 
| W + S +num | Mover venatana enfocada al escritorio #{num} | 


* ## Error comun
    ### Wallpaper
    La primera ves no cargar por que la dirrecion del wallpaper esta mal

    ```bash
    cd ~/.config/awesome/
    ```

    * editar el rc.lua
    * en la parte (url_wallpaper = "$HOME/.config/awesome/wallpaper/Ruka Sarashina.jpg")
    *  cambiar el $HOME por su usario /home/{tu usario}

    ### Actualizar el listado de musica
    * Abrier terminal
    * escribir 
    ```bash
    ncmpcpp
    ```
    * pulsar 2
    * pulsar u
    * anadir las canciones que esten en la carpeta $HOME/Music
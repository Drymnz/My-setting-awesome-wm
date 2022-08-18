
dir=""

function copiar_configuracion_default(){
    echo "Copiando la configuracion"
    cp -r /etc/xdg/awesome/rc.lua ~/.configl/awesome/rc.lua
    cp -r /usr/share/doc/alacritty/example/alacritty.yml ~/.configl/alacritty/alacritty.yml
}

function copiar_configuracion_personal(){
    echo "Copiando la configuracion"
    cp -r ./configurarcionAWM/* ~/.configl/awesome/
    cp -r ./configuracionAlacritty/* ~/.configl/alacritty/
}

function configurar(){
    echo "Creando carpetas"
    mkdir -p ~/.configl/
    mkdir -p ~/.configl/alacritty
    mkdir -p ~/.configl/awesome
    ## ejecutando la copia de los archivos
    copiar_configuracion_default
    copiar_configuracion_personal
}

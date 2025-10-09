local menubar = require("menubar")

-- 🔧 Definición de modificadores
local modkey_shift = "Shift"
local modkey_alt = "Mod1"
local modkey_control = "Control"
local modkey_tab = "Tab"

-- Configuración de estilo del lanzador
menubar.menu_gen.all_menu_dirs = {"/usr/share/applications/", "/usr/local/share/applications",
                                  "/home/eddie/.local/share/applications"}

-- Configuración del terminal
menubar.utils.terminal = "alacritty"

function relizar_kyes(modkey, awful, hotkeys_popup, gears, terminal)
    -- {{{ Key bindings (https://awesomewm.org/apidoc/input_handling/awful.key.html)

    globalkeys = gears.table.join( -- 🧩 Sistema y ayuda
    awful.key({modkey}, "s", hotkeys_popup.show_help, {
        description = "mostrar ayuda",
        group = "awesome"
    }), awful.key({modkey, "Control"}, "r", awesome.restart, {
        description = "reiniciar awesome",
        group = "awesome"
    }), awful.key({modkey, "Shift"}, "#19", awesome.quit, {
        description = "cerrar sesión",
        group = "awesome"
    }), awful.key({modkey, modkey_shift}, "s", function()
        awful.spawn.with_shell(
            "scrot -s -f ~/%Y-%m-%d-%T-screenshot.png && xclip -selection clipboard -t image/png $(ls $HOME/ | grep screenshot.png | tr '\n' ' ' | awk '{print pwd $NF}')")
    end, {
        description = "Captura de pantalla en area",
        group = "Captura de pantalla"
    }), -- 🖥️ Navegación entre tags
    awful.key({modkey}, "Left", awful.tag.viewprev, {
        description = "tag anterior",
        group = "tag"
    }), awful.key({modkey}, "Right", awful.tag.viewnext, {
        description = "tag siguiente",
        group = "tag"
    }), awful.key({modkey}, "Tab", awful.tag.history.restore, {
        description = "regresar al tag anterior",
        group = "tag"
    }), -- 🪟 Navegación entre clientes
    awful.key({modkey_alt}, modkey_tab, function()
        awful.client.focus.byidx(1)
    end, {
        description = "enfocar siguiente cliente",
        group = "client"
    }), -- 🔁 Intercambio de clientes
    awful.key({modkey, "Shift"}, "j", function()
        awful.client.swap.byidx(1)
    end, {
        description = "intercambiar con siguiente",
        group = "client"
    }), awful.key({modkey, "Shift"}, "k", function()
        awful.client.swap.byidx(-1)
    end, {
        description = "intercambiar con anterior",
        group = "client"
    }), -- 🖥️ Control de pantallas
    awful.key({modkey, "Control"}, "j", function()
        awful.screen.focus_relative(1)
    end, {
        description = "enfocar siguiente pantalla",
        group = "screen"
    }), awful.key({modkey, "Control"}, "k", function()
        awful.screen.focus_relative(-1)
    end, {
        description = "enfocar pantalla anterior",
        group = "screen"
    }), -- 🚀 Lanzadores
    awful.key({modkey}, "Return", function()
        awful.spawn(menubar.utils.terminal)
    end, {
        description = "Abrir terminal",
        group = "Lanzador"
    }), awful.key({modkey}, "w", function()
        mymainmenu:show()
    end, {
        description = "mostrar menú principal",
        group = "launcher"
    }), awful.key({modkey}, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, {
        description = "ejecutar comando",
        group = "launcher"
    }), awful.key({modkey}, "d", function()
        menubar.show()
    end, {
        description = "mostrar barra de menú",
        group = "launcher"
    }), awful.key({modkey, "Shift"}, "f", function()
        awful.spawn.with_shell("thunar")
    end, {
        description = "abrir gestor de archivos (Thunar)",
        group = "launcher"
    }), -- 🎚️ Control de volumen
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
    end, {
        description = "subir volumen",
        group = "audio"
    }), awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
    end, {
        description = "bajar volumen",
        group = "audio"
    }), awful.key({}, "XF86AudioMute", function()
        awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
    end, {
        description = "silenciar",
        group = "audio"
    }), -- 🎵 Multimedia con mpc (MPD)
    awful.key({}, "XF86AudioPlay", function()
        awful.spawn.with_shell("mpc toggle &")
    end, {
        description = "reproducir / pausar",
        group = "music"
    }), awful.key({}, "XF86AudioNext", function()
        awful.spawn.with_shell("mpc next &")
    end, {
        description = "siguiente canción",
        group = "music"
    }), awful.key({}, "XF86AudioPrev", function()
        awful.spawn.with_shell("mpc prev &")
    end, {
        description = "canción anterior",
        group = "music"
    }), awful.key({}, "XF86AudioStop", function()
        awful.spawn.with_shell("mpc stop &")
    end, {
        description = "detener reproducción",
        group = "music"
    }), awful.key({modkey_alt, modkey_shift}, "o", function()
        awful.spawn.with_shell("mpc toggle &")
    end, {
        description = "Reproduce/Detiene la canción",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "l", function()
        awful.spawn.with_shell("mpc next &")
    end, {
        description = "Siguiente canción",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "k", function()
        awful.spawn.with_shell("mpc prev &")
    end, {
        description = "Anterior canción",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "-", function()
        awful.spawn.with_shell("mpc volume -3 &")
    end, {
        description = "Bajar volumen música",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "+", function()
        awful.spawn.with_shell("mpc volume +3 &")
    end, {
        description = "Subir volumen música",
        group = "Music"
    }), -- 🌞 Control de brillo
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn("brightnessctl set +5%")
    end, {
        description = "subir brillo",
        group = "brillo"
    }), awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("brightnessctl set 5%-")
    end, {
        description = "bajar brillo",
        group = "brillo"
    }), awful.key({}, "XF86ScreenSaver", function()
        local estado_actual = awful.util.pread("brightnessctl get")
        if estado_actual == "0" then
            awful.spawn("brightnessctl set +10%")
        else
            awful.spawn("brightnessctl set 0%")
        end
    end, {
        description = "apagar / encender pantalla",
        group = "brillo"
    }), -- 🧩 Control de layout
    awful.key({modkey}, "l", function()
        awful.tag.incmwfact(0.05)
    end, {
        description = "aumentar ancho maestro",
        group = "layout"
    }), awful.key({modkey}, "h", function()
        awful.tag.incmwfact(-0.05)
    end, {
        description = "disminuir ancho maestro",
        group = "layout"
    }), awful.key({modkey, "Shift"}, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end, {
        description = "aumentar clientes maestros",
        group = "layout"
    }), awful.key({modkey, "Shift"}, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end, {
        description = "disminuir clientes maestros",
        group = "layout"
    }), awful.key({modkey}, "space", function()
        awful.layout.inc(1)
    end, {
        description = "siguiente layout",
        group = "layout"
    }), awful.key({modkey, "Shift"}, "space", function()
        awful.layout.inc(-1)
    end, {
        description = "layout anterior",
        group = "layout"
    }), -- 🔄 Restaurar ventanas minimizadas
    awful.key({modkey, "Control"}, "n", function()
        local c = awful.client.restore()
        if c then
            c:emit_signal("request::activate", "key.unminimize", {
                raise = true
            })
        end
    end, {
        description = "restaurar minimizada",
        group = "client"
    }))

    -- 🎛️ Teclas por cliente
    clientkeys = gears.table.join(awful.key({modkey, modkey_control}, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {
        description = "pantalla completa",
        group = "client"
    }), awful.key({modkey, "Shift"}, "q", function(c)
        c:kill()
    end, {
        description = "cerrar ventana",
        group = "client"
    }), awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {
        description = "alternar flotante",
        group = "client"
    }), awful.key({modkey, modkey_control}, "Left", function(c)
        if awful.client.swap.byidx(1) then
            c:swap(awful.client.swap.byidx(1))
        end
    end, {
        description = "intercambiar con el siguiente",
        group = "Ventana"
    }), awful.key({modkey, modkey_control}, "Right", function(c)
        if awful.client.swap.byidx(-1) then
            c:swap(awful.client.swap.byidx(-1))
        end
    end, {
        description = "intercambiar con el anterior",
        group = "Ventana"
    }), awful.key({modkey, "Control"}, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, {
        description = "mover a maestro",
        group = "client"
    }), awful.key({modkey}, "o", function(c)
        c:move_to_screen()
    end, {
        description = "mover a otra pantalla",
        group = "client"
    }), awful.key({modkey}, "t", function(c)
        c.ontop = not c.ontop
    end, {
        description = "mantener encima",
        group = "client"
    }), awful.key({modkey}, "n", function(c)
        c.minimized = true
    end, {
        description = "minimizar",
        group = "client"
    }), awful.key({modkey}, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, {
        description = "maximizar",
        group = "client"
    }), awful.key({modkey, "Control"}, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, {
        description = "maximizar verticalmente",
        group = "client"
    }), awful.key({modkey, "Shift"}, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, {
        description = "maximizar horizontalmente",
        group = "client"
    }))

    -- 🔢 Tags (1-9)
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys, awful.key({modkey}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                if tag.selected then
                    awful.tag.history.restore()
                else
                    tag:view_only()
                end
            end
        end, {
            description = "ver/toggle tag #" .. i,
            group = "tag"
        }), awful.key({modkey, "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                    tag:view_only()
                end
            end
        end, {
            description = "mover y seguir a tag #" .. i,
            group = "tag"
        }))
    end
end

--[[ -- documentacion para la modificacion de ventan (https://awesomewm.org/apidoc/core_components/client.html#Object_properties)
        awful.key({modkey}, "Left", function(c)
            if c.maximized then
                miminizar(c)
                miminizar(c)
            else
                miminizar(c)
            end
            c.width = ((c.width) / 2) - 15
            -- c:relative_move(0, 0, (c.width)/2, (c.width)/2)--este comando crece
        end, {
            description = "Ajustar ventana a la mita de pantalla izquierda",
            group = "Ventana"
        }) ]]

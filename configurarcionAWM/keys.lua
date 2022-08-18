function relizar_kyes(modkey, awful, hotkeys_popup, gears)
    -- {{{ Key bindings mas informacion (https://awesomewm.org/apidoc/input_handling/awful.key.html)
    modkey_alt = "Mod1" -- boton ALT
    modkey_control = "Control"
    modkey_shift = "Shift"
    modkey_tab = "Tab"
    -- funciones de ayuda
    function miminizar(c)
        c.maximized = not c.maximized
        c:raise()
    end
    -- el primer atajo es bueno para ver cules teclas hay establecido
    globalkeys = gears.table.join(awful.key({modkey}, "s", hotkeys_popup.show_help, {
        description = "Ver ayuda",
        group = "awesome"
    }), 
    -- verte en las mesas de trabajo
    awful.key({modkey_alt, modkey_control}, "Left", awful.tag.viewprev, {
        description = "Ver escritorio Iquierdo",
        group = "mover"
    }), awful.key({modkey_alt, modkey_control}, "Right", awful.tag.viewnext, {
        description = "Ver escritorio derecha",
        group = "mover"
    }), awful.key({modkey_alt}, modkey_tab, function()
        awful.client.focus.byidx(1)
    end, {
        description = "Siguiente de la pila",
        group = "client"
    }), awful.key({modkey_alt, modkey_shift}, modkey_tab, function()
        awful.client.focus.byidx(-1)
    end, {
        description = "Anterior de la pila",
        group = "client"
    }), awful.key({modkey}, "w", function()
        mymainmenu:show()
    end, {
        description = "Ver menu",
        group = "awesome"
    }), -- Layout manipulation
    awful.key({modkey}, "u", awful.client.urgent.jumpto, {
        description = "Saltar a la venta abierta",
        group = "client"
    }), awful.key({modkey}, modkey_tab, function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, {
        description = "go back",
        group = "client"
    }), -- Standard program
    awful.key({modkey}, "Return", function()
        awful.spawn(terminal)
    end, {
        description = "Abrier terminal",
        group = "launcher"
    })-- teclas para manejar el awesomeWM
    , awful.key({modkey, modkey_control}, "r", awesome.restart, {
        description = "Refrescar",
        group = "awesome"
    }), awful.key({modkey, modkey_control}, "h", function()
        awful.tag.incncol(1, nil, true)
    end, {
        description = "increase the number of columns",
        group = "layout"
    }), awful.key({modkey, modkey_control}, "l", function()
        awful.tag.incncol(-1, nil, true)
    end, {
        description = "decrease the number of columns",
        group = "layout"
    }), awful.key({modkey}, "space", function()
        awful.layout.inc(1)
    end, {
        description = "Seleccionar siguiente",
        group = "layout"
    }), awful.key({modkey, modkey_shift}, "space", function()
        awful.layout.inc(-1)
    end, {
        description = "Selecionar previo",
        group = "layout"
    }), awful.key({modkey, modkey_control}, "n", function()
        local c = awful.client.restore()
        -- Focus restored cliente
        if c then
            c:emit_signal("request::activate", "key.unminimize", {
                raise = true
            })
        end
    end, {
        description = "Restaurar minimizado",
        group = "client"
    }), -- Prompt
    awful.key({modkey}, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, {
        description = "Ejecutar aviso",
        group = "launcher"
    }), -- Menubar
    awful.key({modkey}, "p", function()
        --awful.spawn("rofi -show run")
        --awful.spawn("alacritty")
    end, {
        description = "Ver rofi",
        group = "launcher"
    }),
    awful.key({modkey,modkey_alt}, "p", function()
        awful.spawn("alacritty -e sudo poweroff")
    end, {
        description = "Apagar el equipo",
        group = "Power"
    }),
    awful.key({modkey,modkey_alt}, "r", function()
        awful.spawn("alacritty -e sudo reboot")
    end, {
        description = "Apagar el equipo",
        group = "Power"
    })
)

    clientkeys = gears.table.join(awful.key({modkey}, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {
        description = "Alternar a pantalla completa",
        group = "client"
    }), awful.key({modkey, modkey_shift}, "c", function(c)
        c:kill()
    end, {
        description = "close",
        group = "client"
    }),
    -- documentacion para la modificacion de ventan (https://awesomewm.org/apidoc/core_components/client.html#Object_properties)
    awful.key({modkey}, "Left", function(c)
        if c.maximized then
            miminizar(c)
            miminizar(c)
        else
            miminizar(c)
        end
        c.width= (c.width)/2
        --c:relative_move(0, 0, (c.width)/2, (c.width)/2)--este comando crece
    end, {
        description = "Mover a la izquierda con mita de pantalla",
        group = "mover"
    }), awful.key({modkey}, "Right", function(c)
        if c.maximized then
            miminizar(c)
            miminizar(c)
        else
            miminizar(c)
        end
        c.x = (c.width)/2
        c.width= (c.width)/2
    end, {
        description = "Mover a la derecha con mita de pantalla",
        group = "mover"
    })
    , 
     awful.key({modkey, modkey_control}, "space", awful.client.floating.toggle, {
        description = "Altenar a flotante",
        group = "client"
    }), awful.key({modkey, modkey_control}, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, {
        description = "Mover focus a master",
        group = "client"
    }), awful.key({modkey}, "t", function(c)
        c.ontop = not c.ontop
    end, {
        description = "Mantener en la parte superior",
        group = "client"
    }), awful.key({modkey}, "n", function(c)
        -- El cliente tiene actualmente el foco de entrada, por lo que no se puede
        -- minimizado, ya que los clientes minimizados no pueden tener el foco.
        c.minimized = true
    end, {
        description = "minimize",
        group = "client"
    }), awful.key({modkey}, "m", function(c)
        miminizar(c)
    end, {
        description = "(un)maximize",
        group = "client"
    }), awful.key({modkey, modkey_control}, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, {
        description = "(un)maximize vertically (only tili)",
        group = "client tili"
    }), awful.key({modkey, modkey_shift}, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, {
        description = "(un)maximize horizontally (only tili)",
        group = "client tili"
    }))
    -- Vincule todos los números clave a las etiquetas.
    -- Tenga cuidado: usamos códigos clave para que funcione en cualquier diseño de teclado.
    -- Esto debería estar en la fila superior de su teclado, generalmente del 1 al 9.
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys, -- View tag only.
        awful.key({modkey}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, {
            description = "Ver escritorio -> #" .. i,
            group = "mover"
        }), -- Toggle tag display.
        awful.key({modkey, modkey_control}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, {
            description = "Traer ventan del escritorio #" .. i,
            group = "mover"
        }), -- Move client to tag.
        awful.key({modkey, modkey_shift}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end
        end, {
            description = "Mover venatana enfocada al escritorio #" .. i,
            group = "mover"
        }))
    end
end

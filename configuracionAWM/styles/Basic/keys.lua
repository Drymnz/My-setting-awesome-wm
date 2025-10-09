local menubar = require("menubar")
menubar.utils.terminal = "alacritty"

function relizar_kyes(modkey, awful, hotkeys_popup, gears)
    -- Teclas globales
    globalkeys = gears.table.join(
        -- Ayuda y navegación
        awful.key({modkey}, "s", hotkeys_popup.show_help, {description = "mostrar ayuda", group = "awesome"}),
        awful.key({modkey}, "Left", awful.tag.viewprev, {description = "tag anterior", group = "tag"}),
        awful.key({modkey}, "Right", awful.tag.viewnext, {description = "tag siguiente", group = "tag"}),
        awful.key({modkey}, "Escape", awful.tag.history.restore, {description = "regresar", group = "tag"}),
        
        -- Enfoque de clientes
        awful.key({modkey}, "j", function() awful.client.focus.byidx(1) end, {description = "siguiente cliente", group = "client"}),
        awful.key({modkey}, "k", function() awful.client.focus.byidx(-1) end, {description = "cliente anterior", group = "client"}),
        awful.key({modkey}, "w", function() mymainmenu:show() end, {description = "mostrar menú", group = "awesome"}),
        
        -- Intercambiar clientes
        awful.key({modkey, "Shift"}, "j", function() awful.client.swap.byidx(1) end, {description = "intercambiar con siguiente", group = "client"}),
        awful.key({modkey, "Shift"}, "k", function() awful.client.swap.byidx(-1) end, {description = "intercambiar con anterior", group = "client"}),
        
        -- Control de pantallas
        awful.key({modkey, "Control"}, "j", function() awful.screen.focus_relative(1) end, {description = "siguiente pantalla", group = "screen"}),
        awful.key({modkey, "Control"}, "k", function() awful.screen.focus_relative(-1) end, {description = "pantalla anterior", group = "screen"}),
        
        -- Programas
        awful.key({modkey}, "Return", function() awful.spawn(terminal) end, {description = "abrir terminal", group = "launcher"}),
        awful.key({modkey, "Control"}, "r", awesome.restart, {description = "reiniciar awesome", group = "awesome"}),
        awful.key({modkey, "Shift"}, "q", awesome.quit, {description = "salir de awesome", group = "awesome"}),
        
        -- Layout
        awful.key({modkey}, "l", function() awful.tag.incmwfact(0.05) end, {description = "aumentar ancho maestro", group = "layout"}),
        awful.key({modkey}, "h", function() awful.tag.incmwfact(-0.05) end, {description = "disminuir ancho maestro", group = "layout"}),
        awful.key({modkey}, "space", function() awful.layout.inc(1) end, {description = "siguiente layout", group = "layout"}),
        awful.key({modkey, "Shift"}, "space", function() awful.layout.inc(-1) end, {description = "layout anterior", group = "layout"}),
        
        -- Prompts
        awful.key({modkey}, "r", function() awful.screen.focused().mypromptbox:run() end, {description = "ejecutar prompt", group = "launcher"}),
        awful.key({modkey}, "p", function() menubar.show() end, {description = "mostrar menubar", group = "launcher"})
    )

    -- Teclas de cliente
    clientkeys = gears.table.join(
        awful.key({modkey}, "f", function(c) c.fullscreen = not c.fullscreen; c:raise() end, {description = "pantalla completa", group = "client"}),
        awful.key({modkey, "Shift"}, "c", function(c) c:kill() end, {description = "cerrar", group = "client"}),
        awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {description = "flotante", group = "client"}),
        awful.key({modkey}, "t", function(c) c.ontop = not c.ontop end, {description = "mantener encima", group = "client"}),
        awful.key({modkey}, "n", function(c) c.minimized = true end, {description = "minimizar", group = "client"}),
        awful.key({modkey}, "m", function(c) c.maximized = not c.maximized; c:raise() end, {description = "maximizar", group = "client"})
    )

    -- Vincular números a tags
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys,
            awful.key({modkey}, "#" .. i + 9, function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then tag:view_only() end
            end, {description = "ver tag #" .. i, group = "tag"}),
            
            awful.key({modkey, "Shift"}, "#" .. i + 9, function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then client.focus:move_to_tag(tag) end
                end
            end, {description = "mover a tag #" .. i, group = "tag"})
        )
    end

    -- Botones de cliente
    clientbuttons = gears.table.join(
        awful.button({}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}) end),
        awful.button({modkey}, 1, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}); awful.mouse.client.move(c) end),
        awful.button({modkey}, 3, function(c) c:emit_signal("request::activate", "mouse_click", {raise = true}); awful.mouse.client.resize(c) end)
    )
end
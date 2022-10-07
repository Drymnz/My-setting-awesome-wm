-- IMPORTACIONES O REQUERIMIENTOS DE LA EJECUCION
-- documentacion (https://awesomewm.org/apidoc/index.html)
pcall(require, "luarocks.loader")
-- Biblioteca impresionante estándar del entorno
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Biblioteca de widgets y diseños
local wibox = require("wibox")
-- Biblioteca de manejo de temas
local beautiful = require("beautiful")
-- Biblioteca de notificaciones
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Habilite el widget de ayuda de teclas rápidas para VIM y otras aplicaciones
-- cuando se abre un cliente con un nombre coincidente:
require("awful.hotkeys_popup.keys")
-- colores para modificar
require("color")
-- portar para la funcion de bar (cargar la barra)
require("bar")
-- importar para cargar lo comandos de tecla global
require("keys")
-- NOTA COLOCAR LA RUTA DEL LA IMAGEN /home/{usario}/.config/awesome/wallpaper/Ruka Sarashina.jpg"
url_wallpaper = "/home/drymnz/.config/awesome/wallpaper/Ruka Sarashina.jpg"
-- {{{ Manejo de errores
-- Compruebe si Awesome encontró un error durante el inicio y volvió a
-- otra configuración (Este código solo se ejecutará para la configuración alternativa)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end
-- Manejar errores de tiempo de ejecución después del inicio
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}
-- {{{ Definiciones de variables
-- Definir el fondo de pantalla por defecto.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
-- variables globales
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Tecla de modo predeterminada.
-- Usualmente, Mod4 es la tecla con un logo entre Control y Alt.
-- Esta definicio de Mod4 se refiere a la tecla de inicio del teclado
-- tambien conocida como tecla de windows
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
awful.layout.suit.floating, 
awful.layout.suit.tile, 
awful.layout.suit.tile.left,
awful.layout.suit.tile.bottom,
awful.layout.suit.tile.top, 
awful.layout.suit.fair,
awful.layout.suit.fair.horizontal,
awful.layout.suit.spiral, 
awful.layout.suit.spiral.dwindle,
awful.layout.suit.max, 
awful.layout.suit.max.fullscreen, 
awful.layout.suit.magnifier,
awful.layout.suit.corner.nw 
-- awful.layout.suit.corner.ne,
-- awful.layout.suit.corner.sw,
-- awful.layout.suit.corner.se,
}
-- }}}
-- {{{ Menú
-- Crear un widget de inicio y un menú principal
myawesomemenu = {
    {"hotkeys", function()
    hotkeys_popup.show_help(nil, awful.screen.focused())end}, 
{"manual", terminal .. " -e man awesome"},
{"edit config", editor_cmd .. " " .. awesome.conffile},
{"restart", awesome.restart},
{"quit", function()
awesome.quit()
end}}
--Listado de app del menu
mymainmenu = awful.menu({
    items = {
        {"awesome", myawesomemenu, beautiful.awesome_icon}, {"open terminal", terminal}}
})
mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})
-- Indicador de mapa de teclado y conmutador
mykeyboardlayout = awful.widget.keyboardlayout()
-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
-- Crear un wibox para cada pantalla y agregarlo
local taglist_buttons = gears.table.join(awful.button({}, 1, function(t)
    t:view_only()
end), awful.button({modkey}, 1, function(t)
    if client.focus then
        client.focus:move_to_tag(t)
    end
end), awful.button({}, 3, awful.tag.viewtoggle), awful.button({modkey}, 3, function(t)
    if client.focus then
        client.focus:toggle_tag(t)
    end
end), awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
end), awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
end))
-- Distancia entre laterales
--beautiful.useless_gap = 15
--awful.screen.connect_for_each_screen(function(s)
--    s.padding = 15 -- entre la ventan aun siendo no siendo tile
--end)
local tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal("request::activate", "tasklist", {
            raise = true
        })
    end
end), awful.button({}, 3, function()
    awful.menu.client_list({
        theme = {
            width = 250
        }
    })
end), awful.button({}, 4, function()
    awful.client.focus.byidx(1)
end), awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
end))
-- Distancia entre laterales
--awful.screen.connect_for_each_screen(function(s)
--    s.padding = 15 -- entre la ventan aun siendo no siendo tile
--end)
-- Manjador de walllpaper
local function set_wallpaper(s)
    -- Si encontro la imagen del fondo de pantalla
    local f=io.open(url_wallpaper,"r") 
    if f~=nil 
    then 
        io.close(f) 
        gears.wallpaper.maximized(url_wallpaper, s, true)-- un archivo formato imagen
    else 
        if beautiful.wallpaper then
            -- Fondo de pantalla
            local wallpaper = beautiful.wallpaper
            -- Si encontro la imagen del fondo de pantalla por defecto
            if type(wallpaper) == "function" then
                wallpaper = wallpaper(s)
            end
            gears.wallpaper.maximized(wallpaper, s, true)-- un archivo formato imagen
        end
        -- NOTA : En este punto se coloca el fondo de pantalla
        gears.wallpaper.set("000000")--un color solido
    end
end
-- Vuelva a configurar el fondo de pantalla cuando cambie la geometría de una pantalla (por ejemplo, una resolución diferente)
screen.connect_signal("property::geometry", set_wallpaper)
-- }}}
-- funcion de configuracion de barra (archivo bar.lua)
throw_bar(awful, set_wallpaper, tasklist_buttons, wibox, gears, color, taglist_buttons)
-- {{{ Mouse bindings
root.buttons(
    gears.table.join(awful.button({}, 3,
    function()
    mymainmenu:toggle()
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)))
-- }}}
-- cargar la configuracion de teclas / atajo de teclas 
relizar_kyes(modkey, awful, hotkeys_popup, gears)
-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Normas a aplicar a nuevos clientes (a través de la señal "gestionar").).
awful.rules.rules = { --- Todos los clientes coincidirán con esta regla.
{
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen
    }
}, -- Floating clients.
{
            --NOTA ESTE ES UN EJEMPLO DE UNA REGLA UNA FORMA DE DECIR COMOQUIERE QUE 
    -- SE ABRA SIEMPRE ESTA APLICACION (https://awesomewm.org/doc/api/libraries/awful.rules.html#)
    --[[ rule = { 
        name = "MPlayer" --app
    },
    properties = { -- propiedades alteradas (https://awesomewm.org/doc/api/classes/client.html )
        floating = true 
        screen = 1, tag = "2"-- Ejemplo de denomiar aplicaciones en las pantalla 
    } ]]
    rule_any = {
        instance = {"DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry"},
        class = {"Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin", -- kalarm.
        "Sxiv", "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui", "veromix", "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {"Event Tester" -- xev.
        },
        role = {"AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up" -- e.g. Google Chrome's (detached) Developer Tools.
        }
    },
    properties = {
        floating = true 
    }
},
{
    -- Agregar barras de título a clientes y cuadros de diálogo normales
    rule_any = {
        type = {"normal", "dialog"}
    },
    properties = {
        titlebars_enabled = true -- oculatar la barra de las ventanas
    }
} -- Set Firefox to always map on the tag named "2" on screen 1.
-- { rule = { class = "Firefox" },
--   properties = { screen = 1, tag = "2" } },
}
-- }}}


-- {{{ Señales
-- Función de señal para ejecutar cuando aparece un nuevo cliente.
client.connect_signal("manage", function(c)
    -- Establecer las ventanas en el esclavo,
    -- es decir, ponerlo al final de otros en lugar de configurarlo como maestro.
    -- si no es asombroso.inicio, entonces horrible.cliente.setslave(c) final
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        --Evitar la visibilidad entre escritorios 
        awful.placement.no_offscreen(c)
    end
end)
-- Agregue una barra de título si las barras de título habilitadas están configuradas como verdaderas en las reglas.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(awful.button({}, 1, function()
        c:emit_signal("request::activate", "titlebar", {
            raise = true
        })
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        c:emit_signal("request::activate", "titlebar", {
            raise = true
        })
        awful.mouse.client.resize(c)
    end))

    awful.titlebar(c):setup{
        -- Documentacion (https://awesomewm.org/apidoc/popups_and_bars/awful.titlebar.html)
        { -- Izquierda
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Medio
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Derecha
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Habilite el enfoque descuidado, de modo que el enfoque siga al mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {
        raise = false
    })
end)
-- cuando la ventan esta seleccionada
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
-- cuando la ventan no esta seleccionada
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}
-- aplicaciones de ejecucion al inicio del entorno
--awful.util.spawn("picom")--tranparencia
--awful.spawn.with_shell("/usr/lib/polkit-kde-authentication-agent-1 &")--lanzador de ventana para permisos
--color del listado aplicaciones de segundo plano
beautiful.bg_systray = "000000"
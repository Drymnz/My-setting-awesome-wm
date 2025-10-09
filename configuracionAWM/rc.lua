-- CONFIGURACIÓN PRINCIPAL DE AWESOMEWM
-- documentacion (https://awesomewm.org/apidoc/index.html)
pcall(require, "luarocks.loader")

-- Biblioteca impresionante estándar del entorno
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Biblioteca de widgets y diseños
-- Biblioteca de widgets y diseños
local wibox = require("wibox")
-- Biblioteca de manejo de temas
local beautiful = require("beautiful")
-- Biblioteca de notificaciones
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Habilite el widget de ayuda de teclas rápidas para VIM y otras aplicaciones
-- cuando se abre un cliente con un nombre coincidente:
require("awful.hotkeys_popup.keys")

-- Módulos personalizados
require("color")
require("bar")
require("keys")

-- Variables globales
-- NOTA COLOCAR LA RUTA DEL LA IMAGEN /home/{usario}/.config/awesome/wallpaper/Ruka Sarashina.jpg"
url_wallpaper = "/home/drymnz/.config/awesome/wallpaper/Hollow-Knight.jpg" 
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Manejo de errores de inicio
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Hubo errores durante el inicio",
        text = awesome.startup_errors
    })
end

-- Manejo de errores en tiempo de ejecución
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true
        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "¡Ocurrió un error!",
            text = tostring(err)
        })
        in_error = false
    end)
end

-- Definir el fondo de pantalla
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Layouts disponibles
awful.layout.layouts = {
    -- puede agregar mas si lo desea, mas informacion (https://awesomewm.org/apidoc/libraries/awful.layout.html)
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    awful.layout.suit.tile.bottom
}

-- Configuración del menú principal
myawesomemenu = {
    {"Atajos de teclado", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
    {"Manual", terminal .. " -e man awesome"},
    {"Editar configuración", editor_cmd .. " " .. awesome.conffile},
    {"Reiniciar", awesome.restart},
    {"Salir", function() awesome.quit() end}
}

-- Estilo del menú
beautiful.menu_height = 20
beautiful.menu_width = 200
beautiful.menu_bg_normal = color_black
beautiful.menu_fg_normal = color_white
beautiful.menu_bg_focus = color_gold_bright
beautiful.menu_fg_focus = color_black

-- Submenús
navegadores_internet = {
    {"Firefox", "firefox"}
}

mymainmenu = awful.menu({
    items = {
        {"Awesome", myawesomemenu, beautiful.awesome_icon},
        {"Navegador", navegadores_internet},
        {"Terminal", terminal},
        {"Archivos", "thunar"}
    }
})

--Modificar el icono del menu
mylauncher = awful.widget.launcher({menu = mymainmenu})
-- Indicador de mapa de teclado y conmutador
mykeyboardlayout = awful.widget.keyboardlayout()

-- Botones para tags
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Botones para lista de tareas
local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

-- Espaciado entre ventanas (reducido a la mitad)
beautiful.useless_gap = 7
awful.screen.connect_for_each_screen(function(s)
    s.padding = 8
end)

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

screen.connect_signal("property::geometry", set_wallpaper)

-- Crear barra
throw_bar(awful, set_wallpaper, tasklist_buttons, wibox, gears, taglist_buttons)

-- Botones del ratón globales
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- Botones del ratón para clientes
clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({modkey}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({modkey}, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Cargar configuración de teclas
relizar_kyes(modkey, awful, hotkeys_popup, gears)
root.keys(globalkeys)

-- Reglas para clientes
awful.rules.rules = {
    -- Regla global para todos los clientes
    {
        rule = {},
        properties = {
            border_color = color_gold_deep,
            border_width = 3,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    -- Configuración de titlebars
    {
        rule_any = {type = {"normal", "dialog"}},
        properties = {titlebars_enabled = false}
    }
}

-- Función de señal para ejecutar cuando aparece un nuevo cliente.
client.connect_signal("manage", function(c)
    if awesome.startup and not c.size_hints.user_position 
       and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Configuración de titlebar
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        { -- Izquierda
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Centro
            {
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Derecha
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enfoque sigue al ratón
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- Ventana enfocada
client.connect_signal("focus", function(c)
    c.opacity = 1
    c.border_color = color_gold_bright
end)

-- Ventana desenfocada
client.connect_signal("unfocus", function(c)
    c.opacity = 0.85
    c.border_color = color_shadow_dark
end)

-- Aplicaciones de inicio automático
awful.util.spawn("picom")
awful.spawn.with_shell("/usr/lib/polkit-kde-authentication-agent-1 &")
awful.spawn.with_shell("mpd &")
awful.spawn.with_shell("nm-applet &")
--awful.spawn.with_shell("/usr/bin/pipewire &")--controlador de audio
--awful.spawn.with_shell("/usr/bin/pipewire-pulse &")--controlador de audio
-- Color del systray
beautiful.bg_systray = color_bronze-- Activar Num Lock al inicio
awful.spawn.with_shell("setleds -D +num")

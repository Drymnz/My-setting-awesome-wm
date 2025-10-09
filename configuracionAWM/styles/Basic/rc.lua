-- CONFIGURACIÓN DE AWESOMEWM
pcall(require, "luarocks.loader")

-- Bibliotecas
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

-- Módulos personalizados
require("color")
require("bar")
require("keys")

-- Configuración
url_wallpaper = "/home/drymnz/.config/awesome/wallpaper/Ruka Sarashina.jpg"
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Manejo de errores
if awesome.startup_errors then
    naughty.notify({preset = naughty.config.presets.critical, title = "Error de inicio", text = awesome.startup_errors})
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true
        naughty.notify({preset = naughty.config.presets.critical, title = "Error", text = tostring(err)})
        in_error = false
    end)
end

-- Tema
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
}

-- Menú
myawesomemenu = {
    {"Atajos", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end},
    {"Manual", terminal .. " -e man awesome"},
    {"Editar config", editor_cmd .. " " .. awesome.conffile},
    {"Reiniciar", awesome.restart},
    {"Salir", function() awesome.quit() end}
}

mymainmenu = awful.menu({
    items = {
        {"awesome", myawesomemenu, beautiful.awesome_icon},
        {"Terminal", terminal}
    }
})

mylauncher = awful.widget.launcher({image = beautiful.awesome_icon, menu = mymainmenu})
mykeyboardlayout = awful.widget.keyboardlayout()
mytextclock = wibox.widget.textclock()

-- Botones para tags
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({modkey}, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

-- Botones para tasklist
local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({}, 3, function() awful.menu.client_list({theme = {width = 250}}) end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

-- Wallpaper
local function set_wallpaper(s)
    local f = io.open(url_wallpaper, "r")
    if f ~= nil then
        io.close(f)
        gears.wallpaper.maximized(url_wallpaper, s, true)
    elseif beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then wallpaper = wallpaper(s) end
        gears.wallpaper.maximized(wallpaper, s, true)
    else
        gears.wallpaper.set("#000000")
    end
end

screen.connect_signal("property::geometry", set_wallpaper)

-- Crear barra
throw_bar(awful, set_wallpaper, tasklist_buttons, wibox, gears, taglist_buttons)

-- Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

-- Cargar teclas
relizar_kyes(modkey, awful, hotkeys_popup, gears)
root.keys(globalkeys)

-- Reglas
awful.rules.rules = {
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
    },
    {
        rule_any = {
            instance = {"DTA", "copyq", "pinentry"},
            class = {"Arandr", "Blueman-manager", "Gpick", "Kruler", "MessageWin", "Sxiv", "Wpa_gui"},
            name = {"Event Tester"},
            role = {"AlarmWindow", "ConfigManager", "pop-up"}
        },
        properties = {floating = true}
    },
    {
        rule_any = {type = {"normal", "dialog"}},
        properties = {titlebars_enabled = true}
    }
}

-- Señales
client.connect_signal("manage", function(c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(
        awful.button({}, 1, function() c:emit_signal("request::activate", "titlebar", {raise = true}); awful.mouse.client.move(c) end),
        awful.button({}, 3, function() c:emit_signal("request::activate", "titlebar", {raise = true}); awful.mouse.client.resize(c) end)
    )

    awful.titlebar(c):setup {
        {awful.titlebar.widget.iconwidget(c), buttons = buttons, layout = wibox.layout.fixed.horizontal},
        {align = "center", widget = awful.titlebar.widget.titlewidget(c), buttons = buttons, layout = wibox.layout.flex.horizontal},
        {
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

client.connect_signal("mouse::enter", function(c) c:emit_signal("request::activate", "mouse_enter", {raise = false}) end)
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Configuraciones adicionales
beautiful.bg_systray = "#000000"
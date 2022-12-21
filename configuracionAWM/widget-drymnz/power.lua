--lo siguiente lo aprendi intrepretando el siguiete repositorio
--https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-menu-widget
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- variable de HOME
local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/.config/awesome/Iconos/'

--todo un widget tiene cosas primitias 
--(https://awesomewm.org/doc/api/classes/wibox.container.background.html#wibox.container.background.bgimage)
local texto = "-POWER-"

local power_menu = wibox.widget {
    ---lo que va a contener
    {
        --puede contenre lo que otro widget
        markup = texto,
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    },
    --parametros
    --dibujarlo con una forma https://awesomewm.org/doc/api/libraries/gears.shape.html
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
}

--Muetra una ventana personalizada 
--(https://awesomewm.org/doc/api/classes/awful.popup.html)
menu = awful.popup {
    ontop = true,
    visible = false,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    border_width = 1,
    border_color = beautiful.bg_focus,
    maximum_width = 600,
    offset = { y = 5 },
    widget = {}
}
--Las filas
rows = { layout = wibox.layout.fixed.horizontal }

--Listado de acciones
local menu_items = {
    { name = 'Cerrar Seccion', command = function () awesome.quit() end },
    { name = 'Bloquear',command = function() awful.spawn.with_shell("i3lock") end },
    { name = 'Reiniciar', command = function() awful.spawn.with_shell("reboot") end },
    { name = 'Apagar',command = function() awful.spawn.with_shell("shutdown now") end },
}

--La accion del listado
for _, item in ipairs(menu_items) do
    local row = wibox.widget {
        {
            {
                text = item.name,
                font = beautiful.font,
                widget = wibox.widget.textbox
            },
            margins=10,
            fg = "#000000",
            bg = "#e6e6e6",
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 4)
            end,
            layout = wibox.container.background
        },
        margins = 5,
        color = "#000000",
        layout = wibox.container.margin
    }
    
    --ejecutar la accion con el click
    row:buttons(
        awful.util.table.join(
            awful.button(
                {}, 
                1, 
                function()
                    menu.visible = not menu.visible
                    item.command()
                end
            )
        )
    )

    table.insert(rows, row)
end

menu:setup(rows)

power_menu:buttons(
    awful.util.table.join(
        awful.button(
            {}, 1, 
            function()
                if menu.visible then
                    menu.visible = not menu.visible
                else
                    menu:move_next_to(mouse.current_widget_geometry)
                end
            end
        )
    )
)

return power_menu

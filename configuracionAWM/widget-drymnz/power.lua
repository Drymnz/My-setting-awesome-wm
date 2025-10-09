-- Lo siguiente lo aprendí interpretando el siguiente repositorio
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-menu-widget
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Variable de HOME
local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/.config/awesome/Iconos/'

-- Widget principal del botón power (SIN FONDO, LETRAS NEGRAS)
local power_menu = wibox.widget {
    {
        {
            markup = '<span foreground="#000000" font="bold 11">⏻ POWER</span>',
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        },
        margins = 6,
        widget = wibox.container.margin
    },
    bg = "#00000000",  -- Transparente (sin fondo)
    fg = "#000000",    -- Letras negras
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 6)
    end,
    widget = wibox.container.background,
}

-- Efecto hover en el botón principal (opcional, puedes ajustarlo)
power_menu:connect_signal("mouse::enter", function(c)
    c:set_bg("#33333333")  -- Fondo semi-transparente al pasar el mouse
end)
power_menu:connect_signal("mouse::leave", function(c)
    c:set_bg("#00000000")  -- Sin fondo
end)

-- Popup del menú
local menu = awful.popup {
    ontop = true,
    visible = false,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,
    border_width = 2,
    border_color = "#444444",
    maximum_width = 700,
    offset = { y = 5 },
    widget = {}
}

-- Las filas
local rows = { 
    layout = wibox.layout.fixed.horizontal,
    spacing = 10
}

-- Listado de acciones (sin bloquear)
local menu_items = {
    { 
        name = 'Cerrar Sesión', 
        icon = '🚪',
        color = "#4CAF50",
        command = function() awesome.quit() end 
    },
    { 
        name = 'Reiniciar', 
        icon = '🔄',
        color = "#FF9800",
        command = function() awful.spawn.with_shell("reboot") end 
    },
    { 
        name = 'Apagar',
        icon = '⏻',
        color = "#F44336",
        command = function() awful.spawn.with_shell("shutdown now") end 
    },
    {
        name = 'Cancelar',
        icon = '✖',
        color = "#9E9E9E",
        command = function() menu.visible = false end
    }
}

-- Crear los botones del menú
for _, item in ipairs(menu_items) do
    local row = wibox.widget {
        {
            {
                {
                    markup = '<span font="16">' .. item.icon .. '</span>',
                    align = 'center',
                    widget = wibox.widget.textbox
                },
                {
                    markup = '<span font="bold 11">' .. item.name .. '</span>',
                    align = 'center',
                    widget = wibox.widget.textbox
                },
                spacing = 8,
                layout = wibox.layout.fixed.vertical
            },
            margins = 15,
            widget = wibox.container.margin
        },
        bg = "#2a2a2a",
        fg = "#FFFFFF",
        forced_width = 140,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 8)
        end,
        widget = wibox.container.background
    }
    
    -- Efectos hover
    row:connect_signal("mouse::enter", function(c)
        c:set_bg(item.color)
        c:set_fg("#000000")
    end)
    
    row:connect_signal("mouse::leave", function(c)
        c:set_bg("#2a2a2a")
        c:set_fg("#FFFFFF")
    end)
    
    -- Cambiar cursor
    local old_cursor, old_wibox
    row:connect_signal("mouse::enter", function()
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand1"
    end)
    
    row:connect_signal("mouse::leave", function()
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)
    
    -- Ejecutar la acción con el click
    row:buttons(
        awful.util.table.join(
            awful.button(
                {}, 
                1, 
                function()
                    item.command()
                    if item.name ~= 'Cancelar' then
                        menu.visible = false
                    end
                end
            )
        )
    )

    table.insert(rows, row)
end

-- Configurar el popup
menu:setup({
    rows,
    margins = 15,
    widget = wibox.container.margin
})

-- Botón principal para mostrar/ocultar el menú
power_menu:buttons(
    awful.util.table.join(
        awful.button(
            {}, 
            1, 
            function()
                if menu.visible then
                    menu.visible = false
                else
                    menu:move_next_to(mouse.current_widget_geometry)
                end
            end
        )
    )
)

return power_menu
local power = require("widget-drymnz.power")
local info = require("widget-drymnz.informacion-sistema")

function throw_bar(awful, set_wallpaper, tasklist_buttons, wibox, gears, taglist_buttons)
    awful.screen.connect_for_each_screen(function(s)
        -- Fondo de pantalla
        set_wallpaper(s)

        -- Cada pantalla tiene su propia tabla de etiquetas.
        awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[2])

        -- Widgets básicos
        s.mypromptbox = awful.widget.prompt()
        s.mylayoutbox = awful.widget.layoutbox(s)

        -- Botones del layoutbox
        s.mylayoutbox:buttons(gears.table.join(awful.button({}, 1, function()
            awful.layout.inc(1)
        end), awful.button({}, 3, function()
            awful.layout.inc(-1)
        end), awful.button({}, 4, function()
            awful.layout.inc(1)
        end), awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)))

        -- Crear un widget de lista de etiquetas
        s.mytaglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            style = {
                bg_empty = color_brown_deep,
                fg_empty = color_white,
                bg_focus = color_gold_bright, -- Dorado brillante cuando tiene ventanas
                fg_focus = color_black,
                bg_occupied = color_amber, -- Ámbar cuando está ocupado pero no enfocado
                fg_occupied = color_black
            },
            buttons = taglist_buttons
        }

        -- Lista de tareas (ventanas abiertas)
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            style = {
                bg_normal = color_brown_deep,
                bg_focus = color_amber,
                fg_normal = color_white,
                fg_focus = color_black,
                disable_task_name = true, -- desactiva el nombre de la ventana
                border_width = 1,
                border_color = color_bronze,
                shape = gears.shape.rectangle
            },
            layout = {-- configuraciones de la ventana
                spacing_widget = {
                    {
                        forced_width = 5,
                        forced_height = 24,
                        thickness = 1,
                        color = color_bronze,
                        widget = wibox.widget.separator
                    },
                    valign = "center",
                    halign = "center",
                    widget = wibox.container.place
                },
                spacing = 1,
                layout = wibox.layout.fixed.horizontal
            },
            buttons = tasklist_buttons
        }

        -- crear la barra de tareas / estados (https://awesomewm.org/apidoc/popups_and_bars/awful.wibar.html)
        s.mywibox = awful.wibar({
            position = "top",
            border_width = 0, -- SIN BORDE
            screen = s,
            bg = color_bronze, -- Amarillo oscuro/bronce
            fg = color_white,
            height = 25
        })

        -- Configuración de widgets en la barra
        s.mywibox:setup{
            layout = wibox.layout.align.horizontal,
            { -- Izquierda
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox
            },
            s.mytasklist, -- Centro
            { -- Derecha
                layout = wibox.layout.fixed.horizontal,
                wibox.widget.systray(),
                wibox.widget.textclock('%B %d -- %H:%M --'),
                info(4), -- RAM usado
                info(7), -- texto "RAM :"
                info(1), -- % CPU
                info(2), -- texto "% GHz :"
                info(5), -- GHz (antes MHz)
                info(3), -- texto "MB CPU :"
                power,
                s.mylayoutbox
            }
        }
    end)
end

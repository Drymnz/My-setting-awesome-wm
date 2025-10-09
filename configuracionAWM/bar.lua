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
        s.mylayoutbox:buttons(gears.table.join(
            awful.button({}, 1, function()
                awful.layout.inc(1)
            end), 
            awful.button({}, 3, function()
                awful.layout.inc(-1)
            end), 
            awful.button({}, 4, function()
                awful.layout.inc(1)
            end), 
            awful.button({}, 5, function()
                awful.layout.inc(-1)
            end)
        ))

        -- Crear un widget de lista de etiquetas
        s.mytaglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            style = {
                bg_empty = color_brown_deep,
                fg_empty = color_white,
                bg_focus = color_gold_bright,
                fg_focus = color_black,
                bg_occupied = color_amber,
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
                disable_task_name = true,
                border_width = 1,
                border_color = color_bronze,
                shape = gears.shape.rectangle
            },
            layout = {
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
            border_width = 0,
            screen = s,
            bg = color_bronze,
            fg = color_white,
            height = 25
        })

        -- Configuración de widgets en la barra (MEJORADA)
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
                spacing = 5,
                wibox.widget.systray(),
                info("separador"),
                
                -- Reloj
                wibox.widget.textclock('<span font="bold 10">%B %d • %H:%M</span>'),
                info("separador"),
                
                -- RAM
                info("ram_label"),
                info("espacio"),
                info("ram_usado"),
                info("espacio"),
                info("ram_mb"),
                info("separador"),
                
                -- CPU Porcentaje
                info("cpu_label"),
                info("espacio"),
                info("cpu_porcentaje"),
                info("cpu_simbolo"),
                info("separador"),
                
                -- CPU GHz
                info("cpu_ghz"),
                info("espacio"),
                info("cpu_ghz_label"),
                info("separador"),
                
                -- Temperatura
                info("temp_label"),
                info("espacio"),
                info("temp_valor"),
                info("temp_simbolo"),
                info("separador"),
                
                -- Power Menu
                power,
                info("espacio"),
                s.mylayoutbox
            }
        }
    end)
end
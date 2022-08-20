function throw_bar(awful,set_wallpaper,tasklist_buttons,wibox,gears,color,taglist_buttons)

    awful.screen.connect_for_each_screen(function(s)
        -- Fondo de pantalla
        set_wallpaper(s)
        
        -- Cada pantalla tiene su propia tabla de etiquetas.
        awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])
        -- Crear un cuadro de diálogo para cada pantalla
        s.mypromptbox = awful.widget.prompt()
        -- Cree un widget de cuadro de imagen que contendrá un icono que indica qué diseño estamos usando.
        -- Necesitamos un cuadro de diseño por pantalla.
        s.mylayoutbox = awful.widget.layoutbox(s)
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
                bg_empty = color_white, -- cuando esta vacio la mesa de trabajo
                fg_empty = color_black,
                bg_focus = color_yellow_two , -- cuando esta enfoca/tu posicion la mesa de trabajo
                fg_focus = color_black,
                bg_occupied = color_blue_one, -- cuando esta ocupada pero no esta seleccionada la mesa de trabajo
                fg_occupied = color_black
            },
            buttons = taglist_buttons
        }
        -- Crear un widget de lista de tareas, el listado de programas abiertos en la mesa de trabajo actual
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            style = {
                bg_normal = color_yellow_two,
                bg_focus = color_blue_one,
                disable_task_name = true, -- desactiva el nombre de la ventana
                border_width = 1,
                border_color = color_green_one,
                shape = gears.shape.rounded_bar
            },
            layout = { -- etiqueta de la ventana mostrada
                spacing_widget = {
                    {
                        forced_width = 5,
                        forced_height = 24,
                        thickness = 1,
                        color = color_green_two,

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
        -- crear la barra de tareas / estados
        s.mywibox = awful.wibar({
            position = "top",
            border_width=1,--borde
            border_color=color_black,--color de borde
            screen = s,
            bg = color_blue_one,
            fg = color_black,
            width = "60%",
            height = 25,
            shape = gears.shape.rounded_rect
        })
        -- Add widgets to the wibox
        s.mywibox:setup{
            layout = wibox.layout.align.horizontal,
            { -- iquierda widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox
            },
            s.mytasklist, -- Widget medio
            { -- derecha widgets
                layout = wibox.layout.fixed.horizontal,
                -- mykeyboardlayout, el tecldo 
                wibox.widget.systray {
                    string = color_yellow_two
                }, -- las terea en segundo plano
                wibox.widget.textclock('%B %d -- %H:%M --'), -- Crear un widget de reloj de texto (https://awesomewm.org/apidoc/widgets/wibox.widget.textclock.html)
                s.mylayoutbox -- este es el de como sera ordenado las ventanas
            }
        }
    end)
    -- }}}
end
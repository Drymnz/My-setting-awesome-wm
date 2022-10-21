
function throw_bar(awful,set_wallpaper,tasklist_buttons,wibox,gears,color,taglist_buttons)

    awful.screen.connect_for_each_screen(function(s)

        -- widget personales(https://awesomewm.org/doc/api/classes/wibox.widget.textbox.html)
        time_update = 2
        --uso de ram
        mostra_men_user = awful.widget.watch('bash -c "free -m | grep Mem | awk \'{print $3}\'"', time_update)
        text_memoria = wibox.widget{
            markup = ' MB ',
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        }
        --uso de cpu
        mostra_cpu_user = awful.widget.watch('bash -c "top -b -n1 | grep %Cpu | awk \'{print $2 + $4}\'"', time_update)
        porcentaje_cpu = wibox.widget{
            markup = '%--',
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        }
        --espacio en blando
        spec_men_cpu = wibox.widget{
            markup = ' MB CPU :',
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        }
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
        -- crear la barra de tareas / estados (https://awesomewm.org/apidoc/popups_and_bars/awful.wibar.html)
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
            s.mytasklist, -- Widget medio listado de aplicaciones abiertas
            --- {{{ Volume Indicator
            { -- derecha widgets
                layout = wibox.layout.fixed.horizontal,
                -- mykeyboardlayout, el tecldo 
                wibox.widget.systray {
                }, 
                -- las terea en segundo plano
                wibox.widget.textclock('%B %d -- %H:%M --'), -- Crear un widget de reloj de texto (https://awesomewm.org/apidoc/widgets/wibox.widget.textclock.html)
                -- uso de memoria          
                mostra_men_user,
                spec_men_cpu,
                mostra_cpu_user,
                porcentaje_cpu,
                s.mylayoutbox, -- este es el de como sera ordenado las ventanas      
            }
        }
    end)
    -- }}}
end
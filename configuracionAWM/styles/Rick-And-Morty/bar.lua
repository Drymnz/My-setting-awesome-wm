
function throw_bar(awful,set_wallpaper,tasklist_buttons,wibox,gears,color,taglist_buttons)

    awful.screen.connect_for_each_screen(function(s)
        -- widget personales(https://awesomewm.org/doc/api/classes/wibox.widget.textbox.html)
        time_update = 2
        --uso de ram
        --mostra_men_user = awful.widget.watch('bash -c "free -m | grep Mem | awk \'{print $3}\'"', time_update)
        --text_memoria = wibox.widget{
        --    markup = ' MB ',
        --    align  = 'center',
        --    valign = 'center',
        --    widget = wibox.widget.textbox
        --}
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
            buttons = taglist_buttons
        }
        -- Crear un widget de lista de tareas, el listado de programas abiertos en la mesa de trabajo actual
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }
        -- crear la barra de tareas / estados (https://awesomewm.org/apidoc/popups_and_bars/awful.wibar.html)
        s.mywibox = awful.wibar({
            position = "top",
            screen = s
        })
        -- Add widgets to the wibox
        s.mywibox:setup{
            layout = wibox.layout.align.horizontal,
            {-- iquierda widgets
                layout = wibox.layout.fixed.horizontal,
                mylauncher,
                s.mytaglist,
                s.mypromptbox
            },
            s.mytasklist,  -- Widget medio listado de aplicaciones abiertas
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox
            }
        }
    end)
end
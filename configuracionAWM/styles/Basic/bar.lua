function throw_bar(awful, set_wallpaper, tasklist_buttons, wibox, gears, taglist_buttons)
    awful.screen.connect_for_each_screen(function(s)
        -- Fondo de pantalla
        set_wallpaper(s)
        
        -- Etiquetas (tags) para cada pantalla
        awful.tag({"1", "2", "3", "4", "5", "6", "7", "8", "9"}, s, awful.layout.layouts[1])
        
        -- Widgets de la pantalla
        s.mypromptbox = awful.widget.prompt()
        s.mylayoutbox = awful.widget.layoutbox(s)
        
        -- Botones para cambiar layout
        s.mylayoutbox:buttons(gears.table.join(
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(1) end),
            awful.button({}, 5, function() awful.layout.inc(-1) end)
        ))
        
        -- Widget de lista de etiquetas
        s.mytaglist = awful.widget.taglist {
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons
        }
        
        -- Widget de lista de tareas
        s.mytasklist = awful.widget.tasklist {
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons
        }
        
        -- Crear la barra superior
        s.mywibox = awful.wibar({position = "top", screen = s})
        
        -- Configurar widgets en la barra
        s.mywibox:setup {
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
                mykeyboardlayout,
                wibox.widget.systray(),
                mytextclock,
                s.mylayoutbox
            }
        }
    end)
end
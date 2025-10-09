-- Teclas de cliente (client.lua)
-- Teclas específicas para manejo de ventanas
local gears = require("gears")

local M = {}

function M.get_client_keys(modkey, modkey_control, awful)
    return gears.table.join(awful.key({modkey, modkey_control}, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {
        description = "pantalla completa",
        group = "client"
    }), awful.key({modkey, "Control"}, "space", awful.client.floating.toggle, {
        description = "alternar flotante",
        group = "client"
    }), awful.key({modkey, modkey_control}, "Left", function(c)
        if awful.client.swap.byidx(1) then
            c:swap(awful.client.swap.byidx(1))
        end
    end, {
        description = "intercambiar con el siguiente",
        group = "Ventana"
    }), awful.key({modkey, modkey_control}, "Right", function(c)
        if awful.client.swap.byidx(-1) then
            c:swap(awful.client.swap.byidx(-1))
        end
    end, {
        description = "intercambiar con el anterior",
        group = "Ventana"
    }), awful.key({modkey, "Control"}, "Return", function(c)
        awful.layout.set(awful.layout.layouts[#awful.layout.layouts])
        c:swap(awful.client.getmaster())
    end, {
        description = "mover a maestro",
        group = "client"
    }), awful.key({modkey}, "o", function(c)
        c:move_to_screen()
    end, {
        description = "mover a otra pantalla",
        group = "client"
    }), awful.key({modkey}, "t", function(c)
        c.ontop = not c.ontop
    end, {
        description = "mantener encima",
        group = "client"
    }), awful.key({modkey}, "n", function(c)
        c.minimized = true
    end, {
        description = "minimizar",
        group = "client"
    }), awful.key({modkey}, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, {
        description = "maximizar",
        group = "client"
    }), awful.key({modkey, "Control"}, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, {
        description = "maximizar verticalmente",
        group = "client"
    }), awful.key({modkey, "Shift"}, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, {
        description = "maximizar horizontalmente",
        group = "client"
    }), awful.key({modkey, "Shift"}, "q", function(c)
        c:kill()
    end, {
        description = "cerrar ventana",
        group = "client"
    }))
end

return M

--[[
ATAJOS DE VENTANAS (CLIENT)

CONTROL DE VENTANAS:
  • modkey + Ctrl + f       → Pantalla completa
  • modkey + Ctrl + space   → Alternar flotante
  • modkey + Ctrl + ←       → Intercambiar con siguiente
  • modkey + Ctrl + →       → Intercambiar con anterior
  • modkey + Ctrl + Enter   → Mover a maestro
  • modkey + o              → Mover a otra pantalla
  • modkey + t              → Mantener encima
  • modkey + n              → Minimizar
  • modkey + m              → Maximizar
  • modkey + Ctrl + m       → Maximizar verticalmente
  • modkey + Shift + m      → Maximizar horizontalmente
  • modkey + Shift + q      → Cerrar ventana
]]

local menubar = require("menubar")

-- Definición de modificadores
local modkey_shift = "Shift"
local modkey_alt = "Mod1"
local modkey_control = "Control"
local modkey_tab = "Tab"

-- Configuración de estilo del lanzador
menubar.menu_gen.all_menu_dirs = {"/usr/share/applications/", "/usr/local/share/applications",
                                  "/home/eddie/.local/share/applications"}

-- Configuración del terminal
menubar.utils.terminal = "alacritty"

-- Importar módulos de teclas
local media_keys = require("keys.media")
local custom_keys = require("keys.custom")
local client_keys_module = require("keys.client")

function relizar_kyes(modkey, awful, hotkeys_popup, gears, terminal)
    -- Key bindings básicas

    globalkeys = gears.table.join( -- Sistema y ayuda
    awful.key({modkey}, "s", hotkeys_popup.show_help, {
        description = "mostrar ayuda",
        group = "awesome"
    }), awful.key({modkey, "Control"}, "r", awesome.restart, {
        description = "reiniciar awesome",
        group = "awesome"
    }), 
awful.key({ modkey, "Shift" }, "0", function()
    -- Bloquea la sesión a nivel de systemd
    awful.spawn("loginctl lock-session")
    -- Apaga la pantalla (DPMS)
    awful.spawn.with_shell("xset dpms force off")
end, {
    description = "bloquear pantalla (sin programas externos)",
    group = "awesome"
})



    , -- Navegación entre tags
    awful.key({modkey}, "Left", awful.tag.viewprev, {
        description = "tag anterior",
        group = "tag"
    }), awful.key({modkey}, "Right", awful.tag.viewnext, {
        description = "tag siguiente",
        group = "tag"
    }), awful.key({modkey}, "Tab", awful.tag.history.restore, {
        description = "regresar al tag anterior",
        group = "tag"
    }), -- Navegación entre clientes
    awful.key({modkey_alt}, modkey_tab, function()
        awful.client.focus.byidx(1)
    end, {
        description = "enfocar siguiente cliente",
        group = "client"
    }), -- Intercambio de clientes
    awful.key({modkey, "Shift"}, "j", function()
        awful.client.swap.byidx(1)
    end, {
        description = "intercambiar con siguiente",
        group = "client"
    }), awful.key({modkey, "Shift"}, "k", function()
        awful.client.swap.byidx(-1)
    end, {
        description = "intercambiar con anterior",
        group = "client"
    }), -- Control de pantallas
    awful.key({modkey, "Control"}, "j", function()
        awful.screen.focus_relative(1)
    end, {
        description = "enfocar siguiente pantalla",
        group = "screen"
    }), awful.key({modkey, "Control"}, "k", function()
        awful.screen.focus_relative(-1)
    end, {
        description = "enfocar pantalla anterior",
        group = "screen"
    }), -- Lanzadores básicos
    awful.key({modkey}, "Return", function()
        awful.spawn(menubar.utils.terminal)
    end, {
        description = "Abrir terminal",
        group = "Lanzador"
    }), awful.key({modkey}, "w", function()
        mymainmenu:show()
    end, {
        description = "mostrar menú principal",
        group = "launcher"
    }), awful.key({modkey}, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, {
        description = "ejecutar comando",
        group = "launcher"
    }), awful.key({modkey}, "d", function()
        menubar.show()
    end, {
        description = "mostrar barra de menú",
        group = "launcher"
    }), awful.key({modkey, "Shift"}, "f", function()
        awful.spawn.with_shell("GTK_THEME=Adwaita:dark thunar")
    end, {
        description = "abrir gestor de archivos (Thunar)",
        group = "launcher"
    }), -- Control de layout
    awful.key({modkey}, "space", function()
        awful.layout.inc(1)
    end, {
        description = "siguiente layout",
        group = "layout"
    }), awful.key({modkey, "Shift"}, "space", function()
        awful.layout.inc(-1)
    end, {
        description = "layout anterior",
        group = "layout"
    }), -- Restaurar ventanas minimizadas
    awful.key({modkey, "Control"}, "n", function()
        local c = awful.client.restore()
        if c then
            c:emit_signal("request::activate", "key.unminimize", {
                raise = true
            })
        end
    end, {
        description = "restaurar minimizada",
        group = "client"
    }), -- Importar teclas de otros módulos
    media_keys.get_keys(awful), custom_keys.get_keys(modkey_alt, modkey_shift, awful))

    -- Teclas por cliente
    clientkeys = client_keys_module.get_client_keys(modkey, modkey_control, awful)

    -- Tags (1-9)
    for i = 1, 9 do
        globalkeys = gears.table.join(globalkeys, awful.key({modkey}, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                if tag.selected then
                    awful.tag.history.restore()
                else
                    tag:view_only()
                end
            end
        end, {
            description = "ver/toggle tag #" .. i,
            group = "tag"
        }), awful.key({modkey, "Shift"}, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                    tag:view_only()
                end
            end
        end, {
            description = "mover y seguir a tag #" .. i,
            group = "tag"
        }))
    end
end

--[[
ATAJOS DE TECLADO BÁSICOS

SISTEMA:
  • modkey + s              → Mostrar ayuda
  • modkey + Ctrl + r       → Reiniciar awesome
  • modkey + Shift + 0      → Cerrar sesión

TAGS:
  • modkey + ←              → Tag anterior
  • modkey + →              → Tag siguiente
  • modkey + Tab            → Regresar al tag anterior
  • modkey + 1-9            → Ver/toggle tag #
  • modkey + Shift + 1-9    → Mover ventana a tag #

CLIENTES:
  • Alt + Tab               → Enfocar siguiente cliente
  • modkey + Shift + j      → Intercambiar con siguiente
  • modkey + Shift + k      → Intercambiar con anterior

PANTALLAS:
  • modkey + Ctrl + j       → Enfocar siguiente pantalla
  • modkey + Ctrl + k       → Enfocar pantalla anterior

LANZADORES:
  • modkey + Enter          → Abrir terminal
  • modkey + w              → Mostrar menú principal
  • modkey + r              → Ejecutar comando
  • modkey + d              → Mostrar barra de menú
  • modkey + Shift + f      → Abrir gestor de archivos

LAYOUTS:
  • modkey + space          → Siguiente layout
  • modkey + Shift + space  → Layout anterior

RESTAURAR:
  • modkey + Ctrl + n       → Restaurar ventana minimizada
]]

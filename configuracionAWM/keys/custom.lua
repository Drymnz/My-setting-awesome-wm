-- Teclas personalizadas (custom.lua)
-- Atajos no estándar y comandos personalizados
local gears = require("gears")

local M = {}

function M.get_keys(modkey_alt, modkey_shift, awful)
    return gears.table.join( -- Control de música personalizado (Alt + Shift + teclas)
    awful.key({modkey_alt, modkey_shift}, "o", function()
        awful.spawn.with_shell("mpc toggle &")
    end, {
        description = "Reproduce/Detiene la canción",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "l", function()
        awful.spawn.with_shell("mpc next &")
    end, {
        description = "Siguiente canción",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "k", function()
        awful.spawn.with_shell("mpc prev &")
    end, {
        description = "Anterior canción",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "i", function()
        awful.spawn.with_shell("mpc volume -3 &")
    end, {
        description = "Bajar volumen música",
        group = "Music"
    }), awful.key({modkey_alt, modkey_shift}, "u", function()
        awful.spawn.with_shell("mpc volume +3 &")
    end, {
        description = "Subir volumen música",
        group = "Music"
    }), -- Camtura de pantalla
    awful.key({modkey, modkey_shift}, "s", function()
        awful.spawn.with_shell([[
        dir="$HOME/Imágenes"
        mkdir -p "$dir"
        file="$dir/$(date +'%Y-%m-%d-%H-%M-%S')-screenshot.png"
        scrot -s -f "$file"
        xclip -selection clipboard -t image/png -i "$file"
    ]])
    end, {
        description = "Captura de pantalla en área",
        group = "Captura de pantalla"
    }))
end

return M

--[[
ATAJOS PERSONALIZADOS

CONTROL DE MÚSICA (Alt + Shift):
  • Alt + Shift + o         → Reproducir/Pausar
  • Alt + Shift + l         → Siguiente canción
  • Alt + Shift + k         → Canción anterior
  • Alt + Shift + i         → Bajar volumen música (-3%)
  • Alt + Shift + j         → Subir volumen música (+3%)

  • modkey + Shift + s      → Captura de pantalla en área

]]

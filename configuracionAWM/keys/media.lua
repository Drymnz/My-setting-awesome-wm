-- Teclas de hardware multimedia (media.lua)
-- Teclas predeterminadas de la PC (volumen, brillo, multimedia)

local gears = require("gears")

local M = {}

function M.get_keys(awful)
    return gears.table.join(
        -- Control de volumen
        awful.key({}, "XF86AudioRaiseVolume", function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
        end, {
            description = "subir volumen",
            group = "audio"
        }),
        awful.key({}, "XF86AudioLowerVolume", function()
            awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
        end, {
            description = "bajar volumen",
            group = "audio"
        }),
        awful.key({}, "XF86AudioMute", function()
            awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
        end, {
            description = "silenciar",
            group = "audio"
        }),
        
        -- Multimedia con teclas de hardware (MPD)
        awful.key({}, "XF86AudioPlay", function()
            awful.spawn.with_shell("mpc toggle &")
        end, {
            description = "reproducir / pausar",
            group = "music"
        }),
        awful.key({}, "XF86AudioNext", function()
            awful.spawn.with_shell("mpc next &")
        end, {
            description = "siguiente canción",
            group = "music"
        }),
        awful.key({}, "XF86AudioPrev", function()
            awful.spawn.with_shell("mpc prev &")
        end, {
            description = "canción anterior",
            group = "music"
        }),
        awful.key({}, "XF86AudioStop", function()
            awful.spawn.with_shell("mpc stop &")
        end, {
            description = "detener reproducción",
            group = "music"
        }),
        
        -- Control de brillo
        awful.key({}, "XF86MonBrightnessUp", function()
            awful.spawn("brightnessctl set +5%")
        end, {
            description = "subir brillo",
            group = "brillo"
        }),
        awful.key({}, "XF86MonBrightnessDown", function()
            awful.spawn("brightnessctl set 5%-")
        end, {
            description = "bajar brillo",
            group = "brillo"
        }),
        awful.key({}, "XF86ScreenSaver", function()
            local estado_actual = awful.util.pread("brightnessctl get")
            if estado_actual == "0" then
                awful.spawn("brightnessctl set +10%")
            else
                awful.spawn("brightnessctl set 0%")
            end
        end, {
            description = "apagar / encender pantalla",
            group = "brillo"
        })
    )
end

return M

--[[
TECLAS DE HARDWARE MULTIMEDIA

VOLUMEN:
  • XF86AudioRaiseVolume    → Subir volumen (+5%)
  • XF86AudioLowerVolume    → Bajar volumen (-5%)
  • XF86AudioMute           → Silenciar/Activar

MULTIMEDIA (teclas de hardware):
  • XF86AudioPlay           → Reproducir/Pausar
  • XF86AudioNext           → Siguiente canción
  • XF86AudioPrev           → Canción anterior
  • XF86AudioStop           → Detener reproducción

BRILLO:
  • XF86MonBrightnessUp     → Subir brillo (+5%)
  • XF86MonBrightnessDown   → Bajar brillo (-5%)
  • XF86ScreenSaver         → Apagar/Encender pantalla
]]
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Widget personales (https://awesomewm.org/doc/api/classes/wibox.widget.textbox.html)
local time_update = 2

-- Uso de CPU en porcentaje
local mostra_cpu_user = awful.widget.watch('bash -c "top -b -n1 | grep %Cpu | awk \'{print $2 + $4}\'"', time_update)

-- Frecuencia CPU en GHz (convertido de MHz)
local mostra_cpu_user_ghz = awful.widget.watch('bash -c "cat /proc/cpuinfo | grep \'cpu MHz\' | head -n 1 | awk \'{printf \\\"%.2f\\\", $4/1000}\'"', time_update)

-- Uso de RAM en MB
local mostra_mem_user = awful.widget.watch('bash -c "free -m | grep Mem | awk \'{print $3}\'"', time_update)

-- Temperatura del sistema
local temp_system = awful.widget.watch('bash -c "cat /sys/class/thermal/thermal_zone*/temp | head -n 1 | awk \'{print ($1 / 1000) + 10}\'"', time_update)

-- Función para crear widgets con estilo
local function crear_widget_texto(text, color, font_size)
    return wibox.widget{
        markup = '<span foreground="' .. (color or "#FFFFFF") .. '" font="' .. (font_size or "10") .. '">' .. text .. '</span>',
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

-- Función para crear separador visual
local function crear_separador()
    return wibox.widget {
        {
            widget = wibox.widget.separator,
            orientation = "vertical",
            forced_width = 1,
            color = "#555555",
            thickness = 1,
        },
        left = 8,
        right = 8,
        widget = wibox.container.margin
    }
end

-- Labels mejorados con colores
local label_cpu_porcentaje = crear_widget_texto("CPU:", "#fbff00ff", "bold 10")
local simbolo_porcentaje = crear_widget_texto("%", "#FFFFFF", "9")

local label_cpu_ghz = crear_widget_texto("GHz", "#FFFFFF", "9")

local label_ram = crear_widget_texto("RAM:", "#87CEEB", "bold 10")
local label_ram_mb = crear_widget_texto("MB", "#FFFFFF", "9")

local label_temp = crear_widget_texto("TEMP:", "#000000f6", "bold 10")
local simbolo_celsius = crear_widget_texto("°C", "#FFFFFF", "9")

-- Espacio en blanco pequeño
local espacio_pequeno = wibox.widget{
    markup = " ",
    widget = wibox.widget.textbox
}

-- Función principal de exportación
local function informacion(user_args)
    if user_args == "cpu_porcentaje" then
        return mostra_cpu_user
    elseif user_args == "cpu_label" then
        return label_cpu_porcentaje
    elseif user_args == "cpu_simbolo" then
        return simbolo_porcentaje
    elseif user_args == "cpu_ghz" then
        return mostra_cpu_user_ghz
    elseif user_args == "cpu_ghz_label" then
        return label_cpu_ghz
    elseif user_args == "ram_usado" then
        return mostra_mem_user
    elseif user_args == "ram_label" then
        return label_ram
    elseif user_args == "ram_mb" then
        return label_ram_mb
    elseif user_args == "temp_valor" then
        return temp_system
    elseif user_args == "temp_label" then
        return label_temp
    elseif user_args == "temp_simbolo" then
        return simbolo_celsius
    elseif user_args == "separador" then
        return crear_separador()
    elseif user_args == "espacio" then
        return espacio_pequeno
    end
end

return informacion
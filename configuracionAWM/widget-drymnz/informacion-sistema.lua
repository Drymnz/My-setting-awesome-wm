local awful = require("awful")
local wibox = require("wibox")

-- Tiempo de actualización
local time_update = 2

-- Uso de CPU
local mostra_cpu_user = awful.widget.watch('bash -c "top -b -n1 | grep %Cpu | awk \'{print $2 + $4}\'"', time_update)

-- CPU en GHz (convertido desde MHz)
local mostra_cpu_user_ghz = awful.widget.watch('bash -c "cat /proc/cpuinfo | grep \'cpu MHz\' | head -n 1 | awk \'{printf \\"%.2f\\", $4/1000}\'"', time_update)

-- Uso de RAM
local mostra_men_user = awful.widget.watch('bash -c "free -m | grep Mem | awk \'{print $3}\'"', time_update)

-- Temperatura
local temp_system = awful.widget.watch('bash -c "cat /sys/class/thermal/thermal_zone*/temp | head -n 1 | awk \'{print ($1 / 1000) + 10}\'"', time_update)

-- Función de mostrar en widget
local function mostrar(text)
    return wibox.widget{
        markup = text,
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

-- Textos
local porcentaje_cpu = mostrar("% GHz :")
local spec_men_cpu = mostrar(" MB CPU :")
local ram = mostrar(" RAM :")
local spec_blank = mostrar(" ")
local text_temp_system = mostrar(" temp :")
local sigbo_temp = mostrar(" °C  ")

-- Función de exportación
local function informacion(user_args)
    if user_args == 1 then
        return mostra_cpu_user
    elseif user_args == 2 then
        return porcentaje_cpu
    elseif user_args == 3 then
        return spec_men_cpu
    elseif user_args == 4 then
        return mostra_men_user
    elseif user_args == 5 then
        return mostra_cpu_user_ghz  -- Ahora en GHz
    elseif user_args == 6 then
        return spec_blank
    elseif user_args == 7 then
        return ram
    elseif user_args == 8 then
        return temp_system
    elseif user_args == 9 then
        return text_temp_system
    elseif user_args == 10 then
        return sigbo_temp
    end
end

return informacion
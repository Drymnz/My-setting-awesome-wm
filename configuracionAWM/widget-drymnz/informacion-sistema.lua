local awful = require("awful")
local wibox = require("wibox")


-- widget personales(https://awesomewm.org/doc/api/classes/wibox.widget.textbox.html)
local time_update = 2

--uso de cpu
local mostra_cpu_user = awful.widget.watch('bash -c "top -b -n1 | grep %Cpu | awk \'{print $2 + $4}\'"', time_update)

--en MHz                                               cat /proc/cpuinfo | grep 'cpu MHz' | head -n 1 | awk '{print $4}'
local mostra_cpu_user_mhz = awful.widget.watch('bash -c "cat /proc/cpuinfo | grep \'cpu MHz\' | head -n 1 | awk \'{print $4}\' "', time_update)

--uso de ram
local mostra_men_user = awful.widget.watch('bash -c "free -m | grep Mem | awk \'{print $3}\'"', time_update)

--temperatura                          cat /sys/class/thermal/thermal_zone*/temp |  head -n 1 | awk '{print ($1 / 1000) + 10}'
local temp_system = awful.widget.watch('bash -c "cat /sys/class/thermal/thermal_zone*/temp | head -n 1 | awk \'{print ($1 / 1000) + 10}\'"', time_update)


--funciion de mostrar en widget
local function mostrar(text)
    return wibox.widget{
        markup = text,
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
    }
end

-- mostara un porcentaje %
local porcentaje_cpu = mostrar("% MHZ :")

--espacio en entre cpu y ram
local spec_men_cpu = mostrar(" MB CPU :")

--espacio en entre ram
local ram = mostrar(" RAM :")

--espacio 
local spec_blank = mostrar(" ")

--temperatura °C
local text_temp_system = mostrar(" temp :")

--temperatura °C
local sigbo_temp = mostrar(" °C  ")


--una forma de importar
local function informacion(user_args)
    
    --exprotar  --uso de cpu
    if user_args == 1 then
        return mostra_cpu_user

    ---- mostara un porcentaje %
    elseif user_args == 2 then
        return porcentaje_cpu
    
    --espacio en entre cpu y ram
    elseif user_args == 3 then
        return spec_men_cpu

    --uso de ram
    elseif user_args == 4 then
        return mostra_men_user

    --uso de cpu en mhz
    elseif user_args == 5 then
        return mostra_cpu_user_mhz

    --solo espacio
    elseif user_args == 6 then
        return spec_blank 

    --solo espacio
    elseif user_args == 7 then
        return ram 

    --temp system
    elseif user_args == 8 then
        return temp_system

    --temp system
    elseif user_args == 9 then
        return text_temp_system
    
    --temp system
    elseif user_args == 10 then
        return sigbo_temp
    end
end

return informacion
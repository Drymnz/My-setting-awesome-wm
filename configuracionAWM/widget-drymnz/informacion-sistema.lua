local awful = require("awful")
local wibox = require("wibox")


-- widget personales(https://awesomewm.org/doc/api/classes/wibox.widget.textbox.html)
local time_update = 2

--uso de cpu
local mostra_cpu_user = awful.widget.watch('bash -c "top -b -n1 | grep %Cpu | awk \'{print $2 + $4}\'"', time_update)

--uso de ram
local mostra_men_user = awful.widget.watch('bash -c "free -m | grep Mem | awk \'{print $3}\'"', time_update)

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
local porcentaje_cpu = mostrar("%--")

--espacio en entre cpu y ram
local spec_men_cpu = mostrar(" MB CPU :")

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
    end 
end

return informacion
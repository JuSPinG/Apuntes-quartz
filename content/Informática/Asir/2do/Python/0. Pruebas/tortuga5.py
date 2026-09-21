from turtle import *
from math import sin

speed(0)
hideturtle()
cont = 10000-360*12 # 16

color1 = 0
color2 = 255

colores = [color1, color2]
aumento = 2

vuelta = True

while True:
    if len(hex(color1).split("x")[1]) == 1:
        colores[0] = '#' + ('0' + hex(color1).split("x")[1])*3
    
    else: colores[0] = "#" + (hex(color1).split("x")[1])*3

    if len(hex(color2).split("x")[1]) == 1:
        colores[1] = '#' + ('0' + hex(color2).split("x")[1])*3

    else: colores[1] = "#" + (hex(color2).split("x")[1])*3

    color(colores[cont % len(colores)])

    if vuelta == True:
        color1 += aumento
        color2 -=aumento

        if color2 <= aumento:
            vuelta = False
    
    elif vuelta == False:
        color1 -= aumento
        color2 += aumento

        if color2 >= 255:
            vuelta = True


    cont -= 1
    begin_fill()
    circle(cont*0.1)
    left(1)
    end_fill()
    if cont == 0:
        break
done()

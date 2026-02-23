from turtle import *

cont = 180
bgcolor("gray")
penup()
setpos(-90, -90)
pendown()
hideturtle()
speed(0)

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


    print(colores)
    
    forward(cont)
    left(cont**(0.85))
    pensize(cont**(0.7))
    cont += 1

exitonclick()
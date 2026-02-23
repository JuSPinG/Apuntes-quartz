from turtle import *

cont = 180
bgcolor("gray")
penup()
setpos(-90, -90)
pendown()
hideturtle()
speed(0)

colores = ["cyan", "magenta", "yellow"]

while True:

    forward(cont)
    left(cont**(0.85))
    pensize(cont**(0.7))
    color(colores[cont % len(colores)])
    cont += 1
    print(cont)
    print(pos())

exitonclick()
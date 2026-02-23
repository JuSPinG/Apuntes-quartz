from turtle import *
from math import sin

speed(0)
hideturtle()
cont = 10000-360*16 # 12

a, b, c = 0, 0, 0

idaA = True
idaB = True
idaC = True

while True:

    colormode(255)
    if idaA == True:
        a += 1
        if a >= 250:
            idaA = False
            
    if idaB == True:
        b += 2
        if b >= 250:
            idaB = False
    if idaC == True:
        c += 3
        if c >= 250:
            idaC = False
            
    ### VUELTA ###
    if idaA == False:
        a -= 1
        if a == 0:
            idaA = True
    if idaB == False:
        b -= 1
        if b == 0:
            idaB = True
    if idaC == False:
        c -= 1
        if c == 0:
            idaC = True
    color(a, b, c)


    cont -= 1
    begin_fill()
    circle(cont*0.1)
    left(1)
    end_fill()
    if cont == 0:
        break
done()

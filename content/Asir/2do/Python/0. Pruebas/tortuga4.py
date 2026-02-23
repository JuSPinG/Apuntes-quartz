from turtle import *
from math import sin

speed(0)
hideturtle()
cont = 0

cont = 0
while True:
    cont += 1
    circle(cont*sin(cont))
    left(1)
done()
from turtle import *
from math import sin
from random import randint

speed(0)
hideturtle()
colormode(255)

while True:

    color(randint(0, 255), randint(0, 255), randint(0, 255))
    setheading(0)
    left(randint(1, 360000)/1000)
    forward(1000)
    setpos(0, 0)
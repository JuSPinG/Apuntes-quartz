import pynput
from time import sleep

mouse = pynput.mouse.Controller()
keyboard = pynput.keyboard.Controller()

sleep(3)

cont = 0

for i in range(0, 100):
    mouse.click(pynput.mouse.Button.left, count=100)
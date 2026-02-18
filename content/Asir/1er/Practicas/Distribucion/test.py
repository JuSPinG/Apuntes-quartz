import matplotlib.pyplot as plt
import random

MAX_VALUE = 9

dist = [[0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

for i in range(0, 20000):
    dist[0][int(random.randint(0, int((MAX_VALUE - 1) / 4)) * random.randint(0, int((MAX_VALUE - 1) / 4)) + random.randint(0, (MAX_VALUE - 1) - 4) + 1)] += 1
    dist[1][int(random.uniform(1, int(MAX_VALUE / 3)) * random.uniform(1, int(MAX_VALUE / 3)))] += 1
    dist[2][round(random.uniform(1, int(MAX_VALUE / 3)) * random.uniform(1, int(MAX_VALUE / 3)))] += 1
    dist[3][int(random.uniform(0, int((MAX_VALUE - 1) / 4)) * random.uniform(0, int((MAX_VALUE - 1) / 4)) + random.uniform(0, (MAX_VALUE - 1) - 4) + 1)] += 1
    dist[4][round(random.uniform(0, int((MAX_VALUE - 1) / 4)) * random.uniform(0, int((MAX_VALUE - 1) / 4)) + random.uniform(0, (MAX_VALUE - 1) - 4) + 1)] += 1 ###

print(dist)

plt.plot(dist[0])
plt.plot(dist[1])
plt.plot(dist[2])
plt.plot(dist[3])
plt.plot(dist[4])
plt.show()
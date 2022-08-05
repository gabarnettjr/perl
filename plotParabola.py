import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(-1, 1, 26)
y = x**2
plt.plot(x, y)
plt.show()
print("x has " + str(len(x)) + " elements.")
print("y has " + str(len(y)) + " elements.")

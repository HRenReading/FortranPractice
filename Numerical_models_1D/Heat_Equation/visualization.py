import numpy as np
import matplotlib.pyplot as plt
from matplotlib import animation


"""
Animation of the temperature profile variation.
"""
# read the necessary parameters in .txt file
params = {}
with open("parameters.txt") as f:
    for line in f:
        key, value = line.strip().split("=")
        params[key.strip()] = float(value)

nx = int(params["nx"])
dx = params["dx"]
Lx = params["Lx"]
dt = params["dt"]
nt = int(params["num_steps"])
Tmax = params["Tmax"]
# --- Load temperature time series ---
n_outputs = int(nt * dt) + 1  # one file per second
T = np.zeros((n_outputs, nx))
for i in range(n_outputs):
    if i == 0:
        T[0] = np.loadtxt("results/initial.txt")
    else:
        T[i] = np.loadtxt(f"results/T_{i}s.txt")

# --- Spatial grid ---
x = np.linspace(0, Lx, nx)

# --- Set up the plot ---
fig, ax = plt.subplots()
line, = ax.plot(x, T[0], lw=2, color='darkorange')
ax.set_xlim(0, Lx)
ax.set_ylim(np.min(T), np.max(T))
ax.set_xlabel("x (m)")
ax.set_ylabel("Temperature (K)")
title = ax.set_title("Time = 0 s")

# --- Update function for animation ---
def update(frame):
    line.set_ydata(T[frame])
    title.set_text(f"Time = {frame} s")
    return line, title

# --- Create animation ---
ani = animation.FuncAnimation(
    fig, update, frames=n_outputs, interval=100, blit=True
)
ani.save("results/temp_profile.mp4")

plt.show()
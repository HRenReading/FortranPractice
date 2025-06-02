import numpy as np
import matplotlib.pyplot as plt
from matplotlib import animation

# --- Read parameters ---
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
hmax = params["hmax"]
H1 = params["H1"]
H2 = params["H2"]

# --- Load elevation time series for 2 layers ---
n_outputs = int(nt * dt) + 1
eta1 = np.zeros((n_outputs, nx))
eta2 = np.zeros((n_outputs, nx))
for i in range(n_outputs):
    if i == 0:
        data = np.loadtxt("results/initial.txt")
    else:
        data = np.loadtxt(f"results/h_{i}s.txt")
    if data.ndim == 1:
        data = np.expand_dims(data, axis=0)
    eta1[i] = data[0] - H1
    eta2[i] = data[1] - H2

# --- Grid and figure setup ---
x = np.linspace(0, Lx, nx)
fig, ax = plt.subplots()
line1, = ax.plot(x, eta1[0], lw=2, color='deepskyblue', label='Upper Layer')
line2, = ax.plot(x, eta2[0], lw=2, color='darkblue', label='Lower Layer')
ax.set_xlim(0, Lx)
ax.set_ylim(min(eta2.min(), eta1.min()), max(eta1.max(), eta2.max()))
ax.set_xlabel("x (m)")
ax.set_ylabel("Elevation anomaly (m)")
title = ax.set_title("Time = 0 s")
ax.legend()

# --- Animation update ---
def update(frame):
    line1.set_ydata(eta1[frame])
    line2.set_ydata(eta2[frame])
    title.set_text(f"Time = {frame} s")
    return line1, line2, title

# --- Animate and save ---
ani = animation.FuncAnimation(
    fig, update, frames=n_outputs, interval=33, blit=True
)
ani.save("results/two_layer_surface_elevation.mp4")
plt.show()
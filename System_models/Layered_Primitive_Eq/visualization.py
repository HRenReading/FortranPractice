import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import os

# --- Load model parameters ---
params = {}
with open("parameters.txt") as f:
    for line in f:
        key, value = line.strip().split("=")
        params[key.strip()] = float(value)

nl = int(params["nl"])
nx = int(params["nx"])
ny = int(params["ny"])
Lx = params["Lx"]
Ly = params["Ly"]
dt = params["dt"]
nt = int(params["nt"])

# --- Define grid in kilometers ---
x = np.linspace(0, Lx / 1000, nx)
y = np.linspace(0, Ly / 1000, ny)
X, Y = np.meshgrid(x, y, indexing="ij")

# --- Time stamps: every 1 minute (in minutes) ---
output_interval = int(60 / dt)
num_outputs = nt // output_interval
times = list(range(1, num_outputs + 1))  # [1, 2, ..., N] minutes

titles = ['Layer 1', 'Layer 2']
aspect_ratio = Lx / Ly
fig_width = 12
fig_height = fig_width / aspect_ratio
fig, axs = plt.subplots(2, 2, figsize=(fig_width, fig_height))
plt.tight_layout()

# --- Initial data to set up color levels ---
h0 = np.fromfile("results/h_1m", dtype=np.float32).reshape((nl, nx, ny), order='F')
T0 = np.fromfile("results/T_1m", dtype=np.float32).reshape((nl, nx, ny), order='F')

# --- Setup plot titles and axes ---
for k in range(nl):
    axs[0, k].set_title(f"h ({titles[k]})")
    axs[0, k].set_xlabel("x (km)")
    axs[0, k].set_ylabel("y (km)")
    axs[0, k].set_aspect("equal")

    axs[1, k].set_title(f"T ({titles[k]})")
    axs[1, k].set_xlabel("x (km)")
    axs[1, k].set_ylabel("y (km)")
    axs[1, k].set_aspect("equal")

# --- Update function ---
def update(frame_idx):
    t = times[frame_idx]  # in minutes
    h_file = f"results/h_{t}m"
    T_file = f"results/T_{t}m"

    if not os.path.exists(h_file) or not os.path.exists(T_file):
        print(f"Missing file: {h_file} or {T_file}")
        return []

    h = np.fromfile(h_file, dtype=np.float32).reshape((nl, nx, ny), order='F')
    T = np.fromfile(T_file, dtype=np.float32).reshape((nl, nx, ny), order='F')

    for k in range(nl):
        axs[0, k].cla()
        axs[1, k].cla()

        hc = axs[0, k].contourf(X, Y, h[k], levels=20, cmap='Blues')
        axs[0, k].set_title(f"h ({titles[k]}), t={t} min")
        axs[0, k].set_xlabel("x (km)")
        axs[0, k].set_ylabel("y (km)")
        axs[0, k].set_aspect("equal")

        Tc = axs[1, k].contourf(X, Y, T[k], levels=20, cmap='coolwarm')
        axs[1, k].set_title(f"T ({titles[k]}), t={t} min")
        axs[1, k].set_xlabel("x (km)")
        axs[1, k].set_ylabel("y (km)")
        axs[1, k].set_aspect("equal")

    return []

# --- Create animation ---
ani = animation.FuncAnimation(fig, update, frames=len(times), blit=False)

# --- Save animation ---
ani.save("results/simulation_animation.mp4", fps=5, dpi=120)
plt.show()

# Load initial temperature field
T = np.fromfile("results/initial_T", dtype=np.float32).reshape((nl, nx, ny), order='F')
print("Initial T range:", np.min(T), np.max(T))

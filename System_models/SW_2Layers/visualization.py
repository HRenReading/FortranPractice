import numpy as np
import matplotlib.pyplot as plt
from matplotlib import animation
import os

# --- Load simulation parameters from Fortran ---
params = {}
with open("parameters.txt") as f:
    for line in f:
        key, value = line.strip().split("=")
        params[key.strip()] = float(value)

nx = int(params["nx"])
ny = int(params["ny"])
nl = int(params["nl"])  # <- NEW: number of layers
dx = params["dx"]
dy = params["dy"]
Lx = params["Lx"]
Ly = params["Ly"]
dt = params["dt"]
nt = int(params["nt"])

# --- Grid for plotting ---
x = np.linspace(0, Lx, nx)
y = np.linspace(0, Ly, ny)
X, Y = np.meshgrid(x, y, indexing='ij')  # match (nx, ny)

# --- Gather result file names ---
result_dir = "results"
files = sorted([
    f for f in os.listdir(result_dir)
    if f.startswith("h_") and f.endswith("s")
], key=lambda name: int(name.split("_")[1].replace("s", "")))

times = [int(f.split("_")[1].replace("s", "")) for f in files]

# --- Read initial condition ---
with open("results/initial", "rb") as f:
    h0 = np.fromfile(f, dtype=np.float32).reshape((nl, nx, ny), order='F')

# --- Plot initial condition ---
fig_init, axes = plt.subplots(1, 2, figsize=(12, 5))
for layer in range(nl):
    im = axes[layer].imshow(h0[layer], origin="lower", extent=[0, Lx, 0, Ly],
                            cmap="Blues", aspect='auto')
    axes[layer].set_title(f"Initial Water Depth (Layer {layer + 1})")
    axes[layer].set_xlabel("x (m)")
    axes[layer].set_ylabel("y (m)")
    fig_init.colorbar(im, ax=axes[layer], label='Depth (m)')
plt.tight_layout()
plt.savefig("results/initial_condition_layers.png", dpi=150)
plt.show()

# --- Read all time steps into h_series[layer][time][x, y]
h_series = [ [] for _ in range(nl) ]
for fname in files:
    with open(os.path.join(result_dir, fname), 'rb') as f:
        h = np.fromfile(f, dtype=np.float32).reshape((nl, nx, ny), order="F")
        for layer in range(nl):
            h_series[layer].append(h[layer])

# --- Set up plot ---
fig, axes = plt.subplots(1, 2, figsize=(12, 5))
pcms = []
for layer in range(nl):
    pcm = axes[layer].pcolormesh(X, Y, h_series[layer][0], shading='auto', cmap='Blues')
    fig.colorbar(pcm, ax=axes[layer], label='Water depth (m)')
    axes[layer].set_title(f"Time = 0 s (Layer {layer + 1})")
    axes[layer].set_xlabel("x")
    axes[layer].set_ylabel("y")
    pcms.append(pcm)

# --- Animation update function ---
def update(frame):
    for layer in range(nl):
        pcms[layer].set_array(h_series[layer][frame].ravel())
        axes[layer].set_title(f"Time = {times[frame]} s (Layer {layer + 1})")
    return pcms

# --- Create and save animation ---
ani = animation.FuncAnimation(
    fig, update, frames=len(h_series[0]), interval=30, blit=False
)

ani.save("results/SWE_2Layer_2D.mp4", fps=20)
plt.show()
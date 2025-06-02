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
dx = params["dx"]
dy = params["dy"]
Lx = params["Lx"]
Ly = params["Ly"]
dt = params["dt"]
nt = int(params["nt"])

# --- Grid for plotting ---
x = np.linspace(0, Lx, nx)
y = np.linspace(0, Ly, ny)
X, Y = X, Y = np.meshgrid(x, y, indexing='ij')  # Be careful: x is rows, y is columns, match (nx, ny)

# --- Gather result file names ---
result_dir = "results"
files = sorted([
    f for f in os.listdir(result_dir)
    if f.startswith("T_") and f.endswith("s")
], key=lambda name: int(name.split("_")[1].replace("s", "")))

times = [int(f.split("_")[1].replace("s", "")) for f in files]

with open("results/initial", "rb") as f:
    T0 = np.fromfile("results/initial", dtype=np.float32).reshape((nx, ny), order='F')

plt.figure(figsize=(8, 5))
plt.imshow(T0, origin="lower", extent=[0, Lx, 0, Ly],
           cmap="Reds", aspect='auto')
plt.colorbar(label="Temperature")
plt.title("Initial Temperature Distribution")
plt.xlabel("x (m)")
plt.ylabel("y (m)")
plt.tight_layout()
plt.savefig("results/initial_condition.png", dpi=150)
plt.show()

# --- Read all data into array for animation ---
# --- Read all data into array for animation ---
T_series = []
for fname in files:
    with open(os.path.join(result_dir, fname), 'rb') as f:
        T = np.fromfile(f, dtype=np.float32).reshape((nx, ny), order="F")
        T_series.append(T)

# --- Set up plot ---
fig, ax = plt.subplots()
pcm = ax.pcolormesh(X, Y, T_series[0], shading='auto', cmap='Reds')
fig.colorbar(pcm, ax=ax, label='Temperature')
ax.set_xlabel("x")
ax.set_ylabel("y")
ax.set_title("Time = 0 s")

# --- Animation function ---
def update(frame):
    pcm.set_array(T_series[frame].ravel())
    ax.set_title(f"Time = {times[frame]} s")
    return pcm,

# --- Create and save animation ---
ani = animation.FuncAnimation(
    fig, update, frames=len(T_series), interval=30, blit=True
)

ani.save("results/advection_diffusion_2D.mp4", fps=20)
plt.show()

import numpy as np
from multiprocessing import Pool, cpu_count

class Vector3D:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

class Particle:
    def __init__(self, position, velocity, mass):
        self.position = position
        self.velocity = velocity
        self.mass = mass

def compute_forces_chunk(args):
    particles, start, end, G = args
    num_particles = len(particles)
    forces = [Vector3D(0, 0, 0) for _ in range(num_particles)]
    for i in range(start, end):
        for j in range(num_particles):
            if i != j:
                dx = particles[j].position.x - particles[i].position.x
                dy = particles[j].position.y - particles[i].position.y
                dz = particles[j].position.z - particles[i].position.z
                distance = np.sqrt(dx**2 + dy**2 + dz**2)
                force_magnitude = G * particles[i].mass * particles[j].mass / distance**2
                fx = force_magnitude * dx / distance
                fy = force_magnitude * dy / distance
                fz = force_magnitude * dz / distance
                forces[i].x += fx
                forces[i].y += fy
                forces[i].z += fz
    return forces[start:end]

def compute_forces_parallel(particles, G=6.67430e-11):
    num_particles = len(particles)
    num_chunks = cpu_count()
    chunk_size = num_particles // num_chunks
    args = [(particles, i * chunk_size, (i + 1) * chunk_size, G) for i in range(num_chunks)]
    
    with Pool(processes=num_chunks) as pool:
        forces_chunks = pool.map(compute_forces_chunk, args)
    
    forces = [Vector3D(0, 0, 0) for _ in range(num_particles)]
    for i in range(num_chunks):
        start = i * chunk_size
        end = (i + 1) * chunk_size
        for j in range(start, end):
            forces[j] = forces_chunks[i][j - start]
    
    return forces

def update_particles(particles, forces, dt):
    for i in range(len(particles)):
        particles[i].velocity.x += forces[i].x / particles[i].mass * dt
        particles[i].velocity.y += forces[i].y / particles[i].mass * dt
        particles[i].velocity.z += forces[i].z / particles[i].mass * dt
        particles[i].position.x += particles[i].velocity.x * dt
        particles[i].position.y += particles[i].velocity.y * dt
        particles[i].position.z += particles[i].velocity.z * dt

def simulate(particles, num_steps, dt):
    for _ in range(num_steps):
        forces = compute_forces_parallel(particles)
        update_particles(particles, forces, dt)

# Example usage
particles = [
    Particle(Vector3D(0.49729, 0.966226, 0.428681), Vector3D(0.198307, 0.361111, 0.689255), 0.223625 * (10 ** 10)),
    Particle(Vector3D(0.964621, 0.821291, 0.419606), Vector3D(0.662684, 0.587032, 0.16395), 0.364583 * (10 ** 10)),
    Particle(Vector3D(0.020512, 0.015483, 0.220429), Vector3D(0.340974, 0.021423, 0.830723), 0.152234 * (10 ** 10)),
    Particle(Vector3D(0.967333, 0.542652, 0.476052), Vector3D(0.267489, 0.542374, 0.945749), 0.289386 * (10 ** 10)),
    Particle(Vector3D(0.129828, 0.036068, 0.901068), Vector3D(0.341789, 0.620712, 0.605176), 0.625194 * (10 ** 10)),
    Particle(Vector3D(0.360191, 0.230534, 0.795457), Vector3D(0.645617, 0.484988, 0.961972), 0.848607 * (10 ** 10)),
    Particle(Vector3D(0.966311, 0.59361, 0.141998), Vector3D(0.677856, 0.129522, 0.422948), 0.943829 * (10 ** 10)),
    Particle(Vector3D(0.973433, 0.26352, 0.962326), Vector3D(0.091437, 0.564834, 0.232784), 0.014364 * (10 ** 10)),
    Particle(Vector3D(0.859302, 0.90352, 0.46878), Vector3D(0.864171, 0.291022, 0.077413), 0.869917 * (10 ** 10)),
    Particle(Vector3D(0.913648, 0.644178, 0.668867), Vector3D(0.971718, 0.82145, 0.852497), 0.349954 * (10 ** 10)),
    Particle(Vector3D(0.474571, 0.435113, 0.346686), Vector3D(0.269302, 0.337521, 0.651064), 0.79614 * (10 ** 10)),
    Particle(Vector3D(0.63553, 0.514166, 0.194046), Vector3D(0.11376, 0.185229, 0.999429), 0.91927 * (10 ** 10)),
]

simulate(particles, num_steps=50000, dt=0.001)
for p in particles:
    print(f"Particle: position=({p.position.x}, {p.position.y}, {p.position.z}), "
          f"velocity=({p.velocity.x}, {p.velocity.y}, {p.velocity.z}), mass={p.mass}")

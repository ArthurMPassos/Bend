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
    Particle(Vector3D(0.0, 0.0, 0.0), Vector3D(0.0, 0.0, 0.0), 1.0e10),
    Particle(Vector3D(1.0, 0.0, 0.0), Vector3D(0.0, 1.0, 0.0), 1.0e10),
    Particle(Vector3D(0.0, 1.0, 0.0), Vector3D(-1.0, 0.0, 0.0), 1.0e10)
]

simulate(particles, num_steps=100, dt=0.01)
for p in particles:
    print(f"Particle: position=({p.position.x}, {p.position.y}, {p.position.z}), "
          f"velocity=({p.velocity.x}, {p.velocity.y}, {p.velocity.z}), mass={p.mass}")

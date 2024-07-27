import random

class Vector3D:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def __repr__(self):
        return f"3DVector {{x: {self.x}, y: {self.y}, z: {self.z}}}"

class Particle:
    def __init__(self, position, velocity, mass):
        self.position = position
        self.velocity = velocity
        self.mass = mass

    def __repr__(self):
        return f"Particle {{position: {self.position}, velocity: {self.velocity}, mass: {self.mass}}}"

particles = []

for _ in range(100):
    position = Vector3D(random.random(), random.random(), random.random())
    velocity = Vector3D(random.random(), random.random(), random.random())
    mass = random.random() #+ 10**20
    particles.append(Particle(position, velocity, mass))

for particle in particles:
    print(particle)

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

position = Vector3D(0.491631, 0.990048, 0.810397)
velocity = Vector3D(0.938405, 0.893660, 0.058849)
mass = 0.415048 + 10.0 ** 20.0

particle = Particle(position, velocity, mass)

print(f"Particle: position=({particle.position.x}, {particle.position.y}, {particle.position.z}), "
      f"velocity=({particle.velocity.x}, {particle.velocity.y}, {particle.velocity.z}), "
      f"mass={particle.mass}")

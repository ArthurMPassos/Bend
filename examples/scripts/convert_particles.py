import re

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

def parse_particles_from_file(filename):
    with open(filename, 'r') as file:
        content = file.read()
    
    particle_pattern = re.compile(
        r'Particle\s*{position:\s*Vector3D\s*{x:\s*(?P<px>[0-9.e+-]+),\s*y:\s*(?P<py>[0-9.e+-]+),\s*z:\s*(?P<pz>[0-9.e+-]+)\s*},\s*'
        r'velocity:\s*Vector3D\s*{x:\s*(?P<vx>[0-9.e+-]+),\s*y:\s*(?P<vy>[0-9.e+-]+),\s*z:\s*(?P<vz>[0-9.e+-]+)\s*},\s*'
        r'mass:\s*(?P<mass>[0-9.e+-]+)\s*\+\s*10.0\s*\*\*\s*20.0\s*},'
    )
    
    particles = []
    for match in particle_pattern.finditer(content):
        px, py, pz = float(match.group('px')), float(match.group('py')), float(match.group('pz'))
        vx, vy, vz = float(match.group('vx')), float(match.group('vy')), float(match.group('vz'))
        mass = float(match.group('mass')) + 10.0 ** 20.0
        position = Vector3D(px, py, pz)
        velocity = Vector3D(vx, vy, vz)
        particles.append(Particle(position, velocity, mass))
    
    return particles

def generate_python_code(particles):
    code = "particles = [\n"
    for p in particles:
        code += f"    Particle(Vector3D({p.position.x}, {p.position.y}, {p.position.z}), "
        code += f"Vector3D({p.velocity.x}, {p.velocity.y}, {p.velocity.z}), {p.mass}),\n"
    code += "]\n"
    return code

def generate_c_code(particles):
    code = "Particle particles[] = {\n"
    for p in particles:
        code += "    {"
        code += f"{{ {p.position.x}, {p.position.y}, {p.position.z} }}, "
        code += f"{{ {p.velocity.x}, {p.velocity.y}, {p.velocity.z} }}, "
        code += f"{p.mass}"
        code += "},\n"
    code += "};\n"
    return code

# Read particles from file and generate code
filename = 'particles.txt'
particles = parse_particles_from_file(filename)

python_code = generate_python_code(particles)
c_code = generate_c_code(particles)

print("Python Code:\n")
print(python_code)
print("\nC Code:\n")
print(c_code)

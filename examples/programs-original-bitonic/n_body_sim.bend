object Vector3D { x, y, z }

object Particle { position, velocity, mass }

def getG():
  return 6.67430 * ( 10.0 ** -11.0 )

def copy_list(list):
  fold list:
    case List/Nil:
      return List/Nil
    case List/Cons:
      return List/Cons {head: list.head, tail: list.tail}

# Calculates the gravitational force between two particles
def calculate_force(p1, p2):
  open Particle: p1
  open Particle: p2

  r = distance(p1.position, p2.position)
  if r == 0.0:
    return get_origin()
  else:
    force = (getG() * p1.mass * p2.mass) / (r * r)
    direction = normalize(subtract(p2.position, p1.position))
    return multiply(direction, force)

# Updates the position and velocity of a particle
def update_particle(particle, particles, timestep):
  fold particles:
    case List/Nil:
      total_force = get_origin()
    case List/Cons:
      total_force = add(calculate_force(particle, particles.head), particles.tail)

  open Particle: particle
  acceleration = divide(total_force, particle.mass)
  velocity = add(particle.velocity, multiply(acceleration, timestep))
  position = add(particle.position, multiply(particle.velocity, timestep))
  return Particle {position: position, velocity: velocity, mass: particle.mass}

def update_all_particles(particles, timestep):
  use particles_cp = copy_list(particles)
  fold particles:
    case List/Nil:
      return List/Nil
    case List/Cons:
      return List/Cons { head: update_particle(particles.head, particles_cp, timestep), tail: particles.tail }

# Simulates the N-body system
def simulate(particles, steps, timestep):
  if steps == 0:
    return particles
  else:
    final_particles = update_all_particles(particles, timestep)
    return simulate(final_particles, steps - 1, timestep)

# Example setup
def get_particles(num_particles):
  return [
  Particle {position: Vector3D {x: 0.497290, y: 0.966226, z: 0.428681 }, velocity: Vector3D {x: 0.198307, y: 0.361111, z: 0.689255 }, mass: 0.223625 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.964621, y: 0.821291, z: 0.419606 }, velocity: Vector3D {x: 0.662684, y: 0.587032, z: 0.163950 }, mass: 0.364583 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.020512, y: 0.015483, z: 0.220429 }, velocity: Vector3D {x: 0.340974, y: 0.021423, z: 0.830723 }, mass: 0.152234 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.967333, y: 0.542652, z: 0.476052 }, velocity: Vector3D {x: 0.267489, y: 0.542374, z: 0.945749 }, mass: 0.289386 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.129828, y: 0.036068, z: 0.901068 }, velocity: Vector3D {x: 0.341789, y: 0.620712, z: 0.605176 }, mass: 0.625194 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.360191, y: 0.230534, z: 0.795457 }, velocity: Vector3D {x: 0.645617, y: 0.484988, z: 0.961972 }, mass: 0.848607 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.966311, y: 0.593610, z: 0.141998 }, velocity: Vector3D {x: 0.677856, y: 0.129522, z: 0.422948 }, mass: 0.943829 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.973433, y: 0.263520, z: 0.962326 }, velocity: Vector3D {x: 0.091437, y: 0.564834, z: 0.232784 }, mass: 0.014364 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.859302, y: 0.903520, z: 0.468780 }, velocity: Vector3D {x: 0.864171, y: 0.291022, z: 0.077413 }, mass: 0.869917 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.913648, y: 0.644178, z: 0.668867 }, velocity: Vector3D {x: 0.971718, y: 0.821450, z: 0.852497 }, mass: 0.349954 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.474571, y: 0.435113, z: 0.346686 }, velocity: Vector3D {x: 0.269302, y: 0.337521, z: 0.651064 }, mass: 0.796140 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.635530, y: 0.514166, z: 0.194046 }, velocity: Vector3D {x: 0.113760, y: 0.185229, z: 0.999429 }, mass: 0.919270 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.337199, y: 0.552609, z: 0.062849 }, velocity: Vector3D {x: 0.621895, y: 0.387267, z: 0.261040 }, mass: 0.048229 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.268739, y: 0.022628, z: 0.088143 }, velocity: Vector3D {x: 0.554340, y: 0.054505, z: 0.166009 }, mass: 0.409120 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.291631, y: 0.828481, z: 0.267247 }, velocity: Vector3D {x: 0.076515, y: 0.904426, z: 0.104356 }, mass: 0.015877 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.657862, y: 0.096674, z: 0.989178 }, velocity: Vector3D {x: 0.400286, y: 0.670163, z: 0.033804 }, mass: 0.470778 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.491933, y: 0.595681, z: 0.490272 }, velocity: Vector3D {x: 0.644360, y: 0.026368, z: 0.001726 }, mass: 0.002896 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.149253, y: 0.463883, z: 0.148714 }, velocity: Vector3D {x: 0.610470, y: 0.813769, z: 0.900787 }, mass: 0.078512 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.325490, y: 0.353276, z: 0.896940 }, velocity: Vector3D {x: 0.392989, y: 0.360712, z: 0.840914 }, mass: 0.463844 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.805278, y: 0.805775, z: 0.246314 }, velocity: Vector3D {x: 0.292244, y: 0.344603, z: 0.303058 }, mass: 0.680860 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.222949, y: 0.752638, z: 0.470463 }, velocity: Vector3D {x: 0.666596, y: 0.909513, z: 0.414118 }, mass: 0.574204 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.082422, y: 0.101012, z: 0.154715 }, velocity: Vector3D {x: 0.333919, y: 0.390793, z: 0.708286 }, mass: 0.080979 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.729779, y: 0.444508, z: 0.653359 }, velocity: Vector3D {x: 0.815015, y: 0.170687, z: 0.436886 }, mass: 0.231924 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.586038, y: 0.624083, z: 0.582049 }, velocity: Vector3D {x: 0.779140, y: 0.298181, z: 0.798155 }, mass: 0.895967 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.588488, y: 0.368978, z: 0.486223 }, velocity: Vector3D {x: 0.773964, y: 0.105256, z: 0.967223 }, mass: 0.408190 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.031132, y: 0.474265, z: 0.898597 }, velocity: Vector3D {x: 0.352560, y: 0.539692, z: 0.372052 }, mass: 0.002006 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.691276, y: 0.304891, z: 0.422904 }, velocity: Vector3D {x: 0.784717, y: 0.086241, z: 0.490591 }, mass: 0.710890 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.998364, y: 0.722404, z: 0.780388 }, velocity: Vector3D {x: 0.826482, y: 0.959093, z: 0.705401 }, mass: 0.331968 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.704985, y: 0.058930, z: 0.183418 }, velocity: Vector3D {x: 0.181450, y: 0.522978, z: 0.910273 }, mass: 0.411002 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.285354, y: 0.744384, z: 0.623163 }, velocity: Vector3D {x: 0.368664, y: 0.102869, z: 0.106428 }, mass: 0.173812 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.273837, y: 0.929514, z: 0.655939 }, velocity: Vector3D {x: 0.576644, y: 0.165277, z: 0.992780 }, mass: 0.710961 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.273943, y: 0.826513, z: 0.286916 }, velocity: Vector3D {x: 0.647024, y: 0.857143, z: 0.634475 }, mass: 0.497806 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.742063, y: 0.209612, z: 0.200248 }, velocity: Vector3D {x: 0.519495, y: 0.591139, z: 0.018868 }, mass: 0.345373 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.417464, y: 0.271189, z: 0.349300 }, velocity: Vector3D {x: 0.440566, y: 0.021249, z: 0.807810 }, mass: 0.674682 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.389957, y: 0.401021, z: 0.296247 }, velocity: Vector3D {x: 0.208192, y: 0.596301, z: 0.533015 }, mass: 0.711031 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.834972, y: 0.376129, z: 0.965651 }, velocity: Vector3D {x: 0.597389, y: 0.317178, z: 0.968535 }, mass: 0.210416 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.579495, y: 0.308247, z: 0.870535 }, velocity: Vector3D {x: 0.011897, y: 0.544221, z: 0.849370 }, mass: 0.596947 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.746881, y: 0.138551, z: 0.243939 }, velocity: Vector3D {x: 0.017088, y: 0.325986, z: 0.366284 }, mass: 0.219374 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.575991, y: 0.228942, z: 0.173059 }, velocity: Vector3D {x: 0.699292, y: 0.464666, z: 0.976208 }, mass: 0.823440 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.590757, y: 0.027593, z: 0.535214 }, velocity: Vector3D {x: 0.980398, y: 0.923907, z: 0.919095 }, mass: 0.682879 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.430751, y: 0.671063, z: 0.108777 }, velocity: Vector3D {x: 0.950967, y: 0.190205, z: 0.208840 }, mass: 0.400387 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.230799, y: 0.144841, z: 0.944709 }, velocity: Vector3D {x: 0.493808, y: 0.117940, z: 0.036982 }, mass: 0.431302 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.568984, y: 0.473633, z: 0.860632 }, velocity: Vector3D {x: 0.568428, y: 0.585057, z: 0.216417 }, mass: 0.091283 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.715271, y: 0.386684, z: 0.277823 }, velocity: Vector3D {x: 0.443980, y: 0.161369, z: 0.894641 }, mass: 0.697677 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.604428, y: 0.324210, z: 0.670776 }, velocity: Vector3D {x: 0.338060, y: 0.118026, z: 0.448249 }, mass: 0.138536 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.063452, y: 0.997773, z: 0.464648 }, velocity: Vector3D {x: 0.108030, y: 0.470542, z: 0.259783 }, mass: 0.663704 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.580646, y: 0.182981, z: 0.507968 }, velocity: Vector3D {x: 0.648082, y: 0.490993, z: 0.633615 }, mass: 0.841093 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.552233, y: 0.466679, z: 0.898469 }, velocity: Vector3D {x: 0.371056, y: 0.515617, z: 0.868882 }, mass: 0.724681 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.527276, y: 0.082694, z: 0.746630 }, velocity: Vector3D {x: 0.145129, y: 0.955212, z: 0.658381 }, mass: 0.702732 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.289269, y: 0.376080, z: 0.601761 }, velocity: Vector3D {x: 0.178907, y: 0.154776, z: 0.364963 }, mass: 0.790325 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.425512, y: 0.859283, z: 0.997058 }, velocity: Vector3D {x: 0.622239, y: 0.847227, z: 0.727668 }, mass: 0.791062 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.690408, y: 0.492828, z: 0.103617 }, velocity: Vector3D {x: 0.411310, y: 0.409951, z: 0.520855 }, mass: 0.042805 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.881794, y: 0.736236, z: 0.025806 }, velocity: Vector3D {x: 0.018016, y: 0.434621, z: 0.877162 }, mass: 0.437092 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.925038, y: 0.890448, z: 0.537575 }, velocity: Vector3D {x: 0.395514, y: 0.230565, z: 0.024906 }, mass: 0.259771 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.789221, y: 0.205770, z: 0.668950 }, velocity: Vector3D {x: 0.082697, y: 0.399813, z: 0.624382 }, mass: 0.549612 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.839819, y: 0.914597, z: 0.813420 }, velocity: Vector3D {x: 0.136772, y: 0.047869, z: 0.714099 }, mass: 0.835358 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.657407, y: 0.892011, z: 0.289490 }, velocity: Vector3D {x: 0.585527, y: 0.489645, z: 0.294612 }, mass: 0.014840 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.778477, y: 0.440054, z: 0.998518 }, velocity: Vector3D {x: 0.752305, y: 0.565332, z: 0.881101 }, mass: 0.101043 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.846455, y: 0.213890, z: 0.086035 }, velocity: Vector3D {x: 0.413388, y: 0.389452, z: 0.021429 }, mass: 0.878426 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.834205, y: 0.528876, z: 0.665281 }, velocity: Vector3D {x: 0.926719, y: 0.499648, z: 0.226586 }, mass: 0.787147 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.544353, y: 0.153656, z: 0.763462 }, velocity: Vector3D {x: 0.108441, y: 0.447106, z: 0.490576 }, mass: 0.717662 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.671240, y: 0.366686, z: 0.971948 }, velocity: Vector3D {x: 0.470480, y: 0.688912, z: 0.290708 }, mass: 0.584550 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.376837, y: 0.806091, z: 0.758861 }, velocity: Vector3D {x: 0.908695, y: 0.008962, z: 0.291408 }, mass: 0.211482 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.660960, y: 0.722782, z: 0.575495 }, velocity: Vector3D {x: 0.497487, y: 0.006378, z: 0.755288 }, mass: 0.421319 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.165193, y: 0.264943, z: 0.386980 }, velocity: Vector3D {x: 0.067068, y: 0.605447, z: 0.905312 }, mass: 0.985455 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.408447, y: 0.444039, z: 0.574892 }, velocity: Vector3D {x: 0.566494, y: 0.095764, z: 0.481960 }, mass: 0.639119 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.270549, y: 0.415280, z: 0.198744 }, velocity: Vector3D {x: 0.797573, y: 0.193147, z: 0.527243 }, mass: 0.945411 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.414573, y: 0.554456, z: 0.650862 }, velocity: Vector3D {x: 0.839169, y: 0.686742, z: 0.773225 }, mass: 0.044844 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.336702, y: 0.571435, z: 0.756871 }, velocity: Vector3D {x: 0.497698, y: 0.792055, z: 0.045255 }, mass: 0.756968 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.020659, y: 0.123410, z: 0.464834 }, velocity: Vector3D {x: 0.614418, y: 0.645611, z: 0.091153 }, mass: 0.193424 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.688309, y: 0.611049, z: 0.560572 }, velocity: Vector3D {x: 0.614690, y: 0.799217, z: 0.727092 }, mass: 0.070670 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.713209, y: 0.494889, z: 0.118482 }, velocity: Vector3D {x: 0.015222, y: 0.623615, z: 0.501786 }, mass: 0.946769 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.631375, y: 0.064390, z: 0.348622 }, velocity: Vector3D {x: 0.678764, y: 0.947303, z: 0.290369 }, mass: 0.010278 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.363794, y: 0.545814, z: 0.760501 }, velocity: Vector3D {x: 0.153223, y: 0.401919, z: 0.377989 }, mass: 0.940453 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.395161, y: 0.470745, z: 0.263711 }, velocity: Vector3D {x: 0.472279, y: 0.714007, z: 0.835228 }, mass: 0.600726 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.132768, y: 0.345369, z: 0.016265 }, velocity: Vector3D {x: 0.736783, y: 0.721443, z: 0.592199 }, mass: 0.818555 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.698784, y: 0.108180, z: 0.638967 }, velocity: Vector3D {x: 0.331395, y: 0.991772, z: 0.773892 }, mass: 0.772197 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.703972, y: 0.200412, z: 0.658317 }, velocity: Vector3D {x: 0.546908, y: 0.606999, z: 0.364755 }, mass: 0.696553 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.160148, y: 0.746918, z: 0.452697 }, velocity: Vector3D {x: 0.401129, y: 0.634284, z: 0.261652 }, mass: 0.897762 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.686596, y: 0.521139, z: 0.056446 }, velocity: Vector3D {x: 0.960203, y: 0.719214, z: 0.592986 }, mass: 0.581591 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.222746, y: 0.689911, z: 0.396262 }, velocity: Vector3D {x: 0.030369, y: 0.711230, z: 0.041269 }, mass: 0.291669 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.400944, y: 0.542641, z: 0.774241 }, velocity: Vector3D {x: 0.424250, y: 0.208271, z: 0.937362 }, mass: 0.476964 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.539677, y: 0.348585, z: 0.858989 }, velocity: Vector3D {x: 0.628086, y: 0.734074, z: 0.284148 }, mass: 0.622283 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.267879, y: 0.128957, z: 0.974642 }, velocity: Vector3D {x: 0.987771, y: 0.271601, z: 0.816421 }, mass: 0.924703 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.747303, y: 0.282673, z: 0.480040 }, velocity: Vector3D {x: 0.912521, y: 0.581844, z: 0.682498 }, mass: 0.934749 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.797005, y: 0.627899, z: 0.644023 }, velocity: Vector3D {x: 0.035587, y: 0.887592, z: 0.895491 }, mass: 0.866751 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.300206, y: 0.415660, z: 0.791628 }, velocity: Vector3D {x: 0.914272, y: 0.423545, z: 0.562377 }, mass: 0.590205 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.017365, y: 0.259671, z: 0.703267 }, velocity: Vector3D {x: 0.512660, y: 0.809381, z: 0.385785 }, mass: 0.086100 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.626440, y: 0.183431, z: 0.280551 }, velocity: Vector3D {x: 0.190048, y: 0.862091, z: 0.115583 }, mass: 0.067989 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.751435, y: 0.740568, z: 0.466633 }, velocity: Vector3D {x: 0.323614, y: 0.885957, z: 0.554232 }, mass: 0.103825 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.738063, y: 0.456609, z: 0.010106 }, velocity: Vector3D {x: 0.224670, y: 0.308562, z: 0.138570 }, mass: 0.751196 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.148207, y: 0.813286, z: 0.329348 }, velocity: Vector3D {x: 0.453707, y: 0.416498, z: 0.066362 }, mass: 0.507709 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.632076, y: 0.091732, z: 0.456610 }, velocity: Vector3D {x: 0.127630, y: 0.084244, z: 0.675223 }, mass: 0.880682 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.767818, y: 0.602950, z: 0.099404 }, velocity: Vector3D {x: 0.137280, y: 0.575917, z: 0.136873 }, mass: 0.337856 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.536140, y: 0.189524, z: 0.046348 }, velocity: Vector3D {x: 0.126631, y: 0.516366, z: 0.896737 }, mass: 0.782429 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.568147, y: 0.570556, z: 0.157869 }, velocity: Vector3D {x: 0.390027, y: 0.420885, z: 0.707660 }, mass: 0.306746 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.490962, y: 0.044515, z: 0.488376 }, velocity: Vector3D {x: 0.037273, y: 0.887531, z: 0.977432 }, mass: 0.872845 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.758477, y: 0.697072, z: 0.603499 }, velocity: Vector3D {x: 0.383815, y: 0.556047, z: 0.028005 }, mass: 0.017788 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.790379, y: 0.404022, z: 0.454202 }, velocity: Vector3D {x: 0.157827, y: 0.768548, z: 0.293887 }, mass: 0.868716 + 10.0 ** 20.0 },
  Particle {position: Vector3D {x: 0.491631, y: 0.990048, z: 0.810397 }, velocity: Vector3D {x: 0.938405, y: 0.893660, z: 0.058849 }, mass: 0.415048 + 10.0 ** 20.0 },
  ]

def main:
  num_particles = 100
  particles = get_particles(num_particles)
  steps = 10
  timestep = 0.001
  final_particles = simulate(particles, steps, timestep)
  return (particles, final_particles)

# Helper functions
def distance(v1, v2):
  open Vector3D: v1
  open Vector3D: v2
  return ((v1.x - v2.x) ** 2.0 + (v1.y - v2.y) ** 2.0 + (v1.z - v2.z) ** 2.0) ** 0.5

def vector(x, y, z):
  return {x: x, y: y, z: z}

def add(v1, v2):
  open Vector3D: v1
  open Vector3D: v2
  return Vector3D { x: v1.x + v2.x, y: v1.y + v2.y, z: v1.z + v2.z }

def subtract(v1, v2):
  open Vector3D: v1
  open Vector3D: v2
  return Vector3D { x: v1.x - v2.x, y: v1.y - v2.y, z: v1.z - v2.z }

def multiply(v, scalar):
  open Vector3D: v
  return Vector3D { x: v.x * scalar, y: v.y * scalar, z: v.z * scalar }

def divide(v, scalar):
  open Vector3D: v
  return Vector3D { x: v.x / scalar, y: v.y / scalar, z: v.z / scalar }

def normalize(v):
  len = distance(get_origin(), v)
  return divide(v, len)

def xorshift(state):
  state = state ^ (state << 13)
  state = state ^ (state >> 17)
  state = state ^ (state << 5)
  return state

def random(seed):
  return xorshift(seed)

def get_origin():
  return Vector3D {x: 0.0, y: 0.0, z: 0.0}

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

typedef struct {
    double x, y, z;
} Vector3D;

typedef struct {
    Vector3D position;
    Vector3D velocity;
    double mass;
} Particle;

void compute_forces(Particle *particles, Vector3D *forces, int num_particles, double G) {
    int i, j;
    #pragma omp parallel for private(j)
    for (i = 0; i < num_particles; i++) {
        forces[i].x = forces[i].y = forces[i].z = 0.0;
        for (j = 0; j < num_particles; j++) {
            if (i != j) {
                double dx = particles[j].position.x - particles[i].position.x;
                double dy = particles[j].position.y - particles[i].position.y;
                double dz = particles[j].position.z - particles[i].position.z;
                double distance = sqrt(dx*dx + dy*dy + dz*dz);
                double force_magnitude = G * particles[i].mass * particles[j].mass / (distance * distance);
                double fx = force_magnitude * dx / distance;
                double fy = force_magnitude * dy / distance;
                double fz = force_magnitude * dz / distance;
                #pragma omp atomic
                forces[i].x += fx;
                #pragma omp atomic
                forces[i].y += fy;
                #pragma omp atomic
                forces[i].z += fz;
            }
        }
    }
}

void update_particles(Particle *particles, Vector3D *forces, int num_particles, double dt) {
    int i;
    #pragma omp parallel for
    for (i = 0; i < num_particles; i++) {
        particles[i].velocity.x += forces[i].x / particles[i].mass * dt;
        particles[i].velocity.y += forces[i].y / particles[i].mass * dt;
        particles[i].velocity.z += forces[i].z / particles[i].mass * dt;
        particles[i].position.x += particles[i].velocity.x * dt;
        particles[i].position.y += particles[i].velocity.y * dt;
        particles[i].position.z += particles[i].velocity.z * dt;
    }
}

void simulate(Particle *particles, int num_particles, int num_steps, double dt) {
    Vector3D *forces = (Vector3D *)malloc(num_particles * sizeof(Vector3D));
    double G = 6.67430e-11;
    for (int step = 0; step < num_steps; step++) {
        compute_forces(particles, forces, num_particles, G);
        update_particles(particles, forces, num_particles, dt);
    }
    free(forces);
}

int main() {
    int num_particles = 2;
    Particle particles[2] = {
        {{0.0, 0.0, 0.0}, {0.0, 0.0, 0.0}, 1.0e10},
        {{1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, 1.0e10}
    };

    simulate(particles, num_particles, 100, 0.01);

    for (int i = 0; i < num_particles; i++) {
        printf("Particle: position=(%f, %f, %f), velocity=(%f, %f, %f), mass=%f\n",
               particles[i].position.x, particles[i].position.y, particles[i].position.z,
               particles[i].velocity.x, particles[i].velocity.y, particles[i].velocity.z,
               particles[i].mass);
    }

    return 0;
}

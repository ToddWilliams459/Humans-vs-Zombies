//Vehicle class
//Specific autonomous agents will inherit from this class 
//Abstract since there is no need for an actual Vehicle object
//Implements the stuff that each auto agent needs: movement, steering force calculations, and display

abstract class Vehicle {

  //--------------------------------
  //Class fields
  //--------------------------------
  //vectors for moving a vehicle
  PVector vel, pos, accel, desiredVel, steeringForce;

  //no longer need direction vector - will utilize forward and right
  //these orientation vectors provide a local point of view for the vehicle
  PVector forward, right;

  //floats to describe vehicle movement and size
  float speed, maxSpeed, r, maxForce, mass, radius;


  //--------------------------------
  //Constructor
  //Vehicle(x position, y position, radius, max speed, max force)
  //--------------------------------
  Vehicle(float x, float y, float sr, float ms, float mf, float rad) {
    //Assign parameters to class fields
    pos = new PVector(x, y);
    desiredVel = new PVector(0, 0);
    forward = new PVector(0, 0);
    right = new PVector(0, 0);
    r = sr;
    maxSpeed = ms;
    maxForce = mf;
    mass = 1;
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
    radius = rad;
    steeringForce = new PVector(0, 0);
  }

  //--------------------------------
  //Abstract methods
  //--------------------------------
  //every sub-class Vehicle must use these functions
  void calcSteeringForces() {
    if (pos.x <= 103) {
      steeringForce.add(new PVector(1, 0));
    } else if (pos.x >= width - 197) {
      steeringForce.add(new PVector(-1, 0));
    }
    if (pos.y <= 103) {
      steeringForce.add(new PVector(0, 1));
    } else if (pos.y >= height - 197) {
      steeringForce.add(new PVector(0, -1));
    }
  }
  abstract void display();

  //--------------------------------@
  //Class methods
  //--------------------------------

  //Method: update()
  //Purpose: Calculates the overall steering force within calcSteeringForces()
  //         Applies movement "formula" to move the position of this vehicle
  //         Zeroes-out acceleration 
  void update() {
    //calculate steering forces by calling calcSteeringForces()
    calcSteeringForces();
    //add acceleration to velocity, limit the velocity, and add velocity to position
    vel.add(accel);
    vel.limit(maxSpeed);
    pos.add(vel);
    //calculate forward and right vectors
    forward = vel.normalize().copy();
    right = new PVector(forward.y, -forward.x);
    //reset acceleration
    accel.mult(0);
  }


  //Method: applyForce(force vector)
  //Purpose: Divides the incoming force by the mass of this vehicle
  //         Adds the force to the acceleration vector
  void applyForce(PVector force) {
    accel.add(PVector.div(force, mass));
  }


  //--------------------------------
  //Steering Methods
  //--------------------------------

  //Method: seek(target's position vector)
  //Purpose: Calculates the steering force toward a target's position
  PVector seek(PVector target) {
    desiredVel = PVector.sub(target, pos);
    desiredVel.normalize();
    desiredVel.mult(maxSpeed);
    PVector steeringForce = PVector.sub(desiredVel, vel);
    return steeringForce;
  }
  //max speed issue in seek 

  PVector avoidObstacle (Obstacle obst, float safeDistance)
  {
    PVector steer = new PVector(0, 0);

    PVector vecToCenter = PVector.sub(obst.pos, pos);

    float distance = PVector.dist(obst.pos, pos);

    //if obst is outside of the safe distance
    if (distance > safeDistance) return new PVector(0, 0); 

    //if obst is behind
    if (PVector.dot(vecToCenter, vel) < 0) return new PVector(0, 0); 

    //if radii dont overlap on the x axis
    if (abs(PVector.dot(vecToCenter, right)) > obst.r+r) return new PVector(0, 0); 

    //if obst to the right
    if (PVector.dot(vecToCenter, right) >= 0)
    {
      //steer left
      desiredVel = PVector.mult(right, -maxSpeed);
    } else //or obst to the left
    {
      //steer right
      desiredVel = PVector.mult(right, maxSpeed);
    }

    steer =  PVector.sub(desiredVel, vel);

    return steer;
  }

  // void(){

  //  }

  void debugLines() {
    //forward line
    translate(this.pos.x, this.pos.y);
    line(0, 0, this.forward.x * 50, this.forward.y * 50); 
    line(0, 0, -this.right.x * 50, - this.right.y * 50); 
    //noFill();
    //noStroke();
    ellipse(0, 0, radius*2, radius*2);
    translate(-this.pos.x, -this.pos.y);
  }
}
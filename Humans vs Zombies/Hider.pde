//Seeker class
//Creates an inherited Seeker object from the Vehicle class
//Due to the abstract nature of the vehicle class, the Seeker
//  must implement the following methods:  
//  calcSteeringForces() and display()

class Hider extends Vehicle {

  //---------------------------------------
  //Class fields
  //---------------------------------------

  //seeking target
  //set to null for now
  PVector target = null;

  //PShape to draw this seeker object
  PShape body;

  //overall steering force for this Seeker accumulates the steering forces
  //  of which this will be applied to the vehicle's acceleration
  // PVector steeringForce;

  int safeDistance = 100; 
  float fleeDistance = 200;

  //---------------------------------------
  //Constructor
  //Seeker(x position, y position, radius, max speed, max force)
  //---------------------------------------
  Hider(float x, float y, float sr, float ms, float mf, float rad) {

    //call the super class' constructor and pass in necessary arguments
    super(x, y, sr, ms, mf, rad);

    //instantiate steeringForce vector to (0, 0)

    //PShape initialization
    //draw the seeker "pointing" toward 0 degrees
    body = createShape();
    body.beginShape();
    body.fill(0);
    body.stroke(0);
    body.vertex(10, 0);
    body.vertex(-10, 5);
    body.vertex(-10, -5);
    body.endShape(CLOSE);
  }


  //--------------------------------
  //Abstract class methods
  //--------------------------------

  //Method: calcSteeringForces()
  //Purpose: Based upon the specific steering behaviors this Seeker uses
  //         Calculates all of the resulting steering forces
  //         Applies each steering force to the acceleration
  //         Resets the steering force
  void calcSteeringForces() {
    super.calcSteeringForces();
    //get the steering force returned from calling seek
    //This seeker's target (for now) is the mouse
    PVector seekForce = seek(new PVector(int(random(0, width)), int(random(0, height))));

    //add the above seeking force to this overall steering force
    steeringForce.add(seekForce);

    //limit this seeker's steering force to a maximum force
    steeringForce.limit(maxForce);

    //apply this steering force to the vehicle's acceleration
    accel.add(steeringForce);

    //reset the steering force to 0
    steeringForce.mult(0);
  }


  //Method: display()
  //Purpose: Finds the angle this seeker should be heading toward
  //Draws this seeker as a triangle pointing toward 0 degreed
  //All Vehicles must implement display
  void display() {

    //calculate the direction of the current velocity - this is done for you
    float angle = vel.heading();   

    //draw this vehicle's body PShape using proper translation and rotation
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    //shape(body, 0, 0);
    image(human, -15,-15 );

    popMatrix();
  }

  //--------------------------------
  //Class methods
  //--------------------------------
  void update(ArrayList<Obstacle> os, ArrayList<Seeker> se) {
    super.update();
    //avoidObstacle(os,safeDistance);
    for (int i = 0; i < os.size(); i++) {
      Obstacle Ob = os.get(i);
      PVector retVal = avoidObstacle(Ob, safeDistance);
      retVal.limit(maxForce);
      accel.add(retVal);
      //line(pos.x, pos.y, (pos.x+forward.x) * 1.5 , (pos.y+forward.y)*1.5);
      //   println(forward);
    }
    for (int i = 0; i < se.size(); i++) {
      Seeker s = se.get(i);
      if (collision(s)) {
        corrupt(this);
        s.target=null;
        break;
      }
      PVector fleeVal =flee(s);
      fleeVal.limit(10);
      accel.add(fleeVal);
    }
  }

  boolean collision(Seeker s) {
    return (sq((this.pos.x-s.pos.x)) + sq((this.pos.y-s.pos.y)) <= sq((this.radius+s.radius)));
  }


  PVector flee(Seeker s) {
    PVector fleeForce = new PVector(0, 0);

    PVector vecToCenter = PVector.sub(s.pos, pos);

    //milestone b add in
    PVector nextPos = PVector.add(s.pos, s.vel);

    float distance = PVector.dist(nextPos, pos);
    // if obst is outside of the safe distance
    if (distance > fleeDistance) return new PVector(0, 0);

    //if obst is behind
    if ( PVector.dot(vecToCenter, vel) < 0 ) return new PVector(0, 0);


    //if radii dont overlap on the x axis
    if (abs(PVector.dot(vecToCenter, right)) > s.r+r) return new PVector(0, 0); 


    //if obst to the right
    if (PVector.dot(vecToCenter, right) >= 0)
    {
      //steer left
      desiredVel = PVector.mult(right, -maxSpeed);
      println("steering left");
    } else //or obst to the left
    {
      //steer right
      desiredVel = PVector.mult(right, maxSpeed);
      println("steeringright");
    }

    fleeForce =  PVector.sub(desiredVel, vel);

    return fleeForce;
  }
}
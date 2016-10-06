//Seeker class
//Creates an inherited Seeker object from the Vehicle class
//Due to the abstract nature of the vehicle class, the Seeker
//  must implement the following methods:  
//  calcSteeringForces() and display()

class Seeker extends Vehicle {

  //---------------------------------------
  //Class fields
  //---------------------------------------

  //seeking target
  //set to null for now
  Hider target = null;
  float huntRange = 100f;
  //PShape to draw this seeker object
  PShape body;

  //overall steering force for this Seeker accumulates the steering forces
  //  of which this will be applied to the vehicle's acceleration
  //  PVector steeringForce;

  int safeDistance = 100; 


  //---------------------------------------
  //Constructor
  //Seeker(x position, y position, radius, max speed, max force)
  //---------------------------------------
  Seeker(float x, float y, float sr, float ms, float mf, float rad) {

    //call the super class' constructor and pass in necessary arguments
    super(x, y, sr, ms, mf, rad);

    //instantiate steeringForce vector to (0, 0)

    //PShape initialization
    //draw the seeker "pointing" toward 0 degrees
    body = createShape();
    body.beginShape();
    body.fill(255);
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
    PVector seekForce;
    //get the steering force returned from calling seek
    //This seeker's target (for now) is the mouse
    if (target == null) {
      seekForce = seek(new PVector(int(random(0, width)), int(random(0, height))));
    } else {
      //mile stone b change
      PVector pursuit = PVector.add(target.pos, target.vel);
      seekForce = seek(pursuit);
    }
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
    image(zombie, -9, -15);

    //noFill();
    //ellipse(0,0,15,15);
    popMatrix();
  }

  //--------------------------------
  //Class methods
  //--------------------------------
  void update(ArrayList<Obstacle> os) {
    super.update();
    //avoidObstacle(,safeDistance);
    for (int i = 0; i < os.size(); i++) {
      Obstacle Ob = os.get(i);
      PVector retVal = avoidObstacle(Ob, safeDistance);
      retVal.limit(maxForce);
      accel.add(retVal);
    }
    findTarget(hide);
  }

  void findTarget(ArrayList<Hider> hi) {
    if (target == null) {
      float minLength = 10000000000.0f;
      Hider minH = null;
      for (int i = 0; i < hi.size(); i++) {
        PVector tempVec = null;
        float tempMag = 0f;
        Hider tempH = hi.get(i);
        tempVec = PVector.sub(pos, tempH.pos);
        tempMag = tempVec.mag();

        if (minH == null || tempMag < minLength) {
          minH =  tempH;
          minLength = tempMag;
        }
      }

      if (minLength <= huntRange)
      {
        target = minH;
      }
    }
  }

  void debugLines() {
    super.debugLines();
    if (target != null) {
      // debug heads to targets future position
      line(pos.x, pos.y, target.pos.x + target.vel.x, target.pos.y + target.vel.y);
    }
  }

  void tag(Hider h) {
    if (target != null && target == h) {
      target = null;
    }
  }
}
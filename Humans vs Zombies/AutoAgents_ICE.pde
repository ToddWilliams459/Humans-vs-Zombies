//Beginning to code autonomous agents
//Will implement inheritance with a Vehicle class and a Seeker class
ArrayList<Obstacle> ob = new ArrayList<Obstacle>(10);
public ArrayList<Hider> hide = new ArrayList<Hider>(5);
public ArrayList<Seeker> seek = new ArrayList<Seeker>(10);

public boolean debug= false;
public boolean spawnHuman = true;
Obstacle o;
//Seeker s;
PVector ObsPos;

//images 
PImage zombie;
PImage human;
PImage tree;

void setup() {
  size(1000, 1000);
  zombie = loadImage("zombie.png");
  human = loadImage("human.png");
  tree = loadImage("tree.png");
  //ObsPos = new PVector(int(random(100, width-200)), int(random(100, height-200)));
  //  s = new Seeker(width/2, height/2, 6, 5, 0.1);
  o = new Obstacle( 50);

  for (int i = 0; i < 10; i++) {
    ob.add(new Obstacle( int(random(15, 75))));
    //  ob.add(new Obstacle(100));
    if (i<10) {
      hide.add(new Hider(110, height/2, 6, 6, .1, 10));
      seek.add(new Seeker(width/2, height/2, 6, 6, .1, 10));
    }
  }

  // for (int w = 0; w < 5; w++) {
  //   hide.add(new Hider(width/2, height/2, 6, 5, .1));
  // }
}

void draw() {
  background(255);
  boundary();
  fill(0, 255, 0);

  for (int i = 0; i < ob.size(); i++) {
    Obstacle obs = ob.get(i);
    obs.display();
  }
  for (int i = 0; i < hide.size(); i++) {
    Hider hid = hide.get(i);
    hid.update(ob, seek);
    hid.display();
    if (debug) {
      hid.debugLines();
    }
  }

  for (int i = 0; i < seek.size(); i++) {
    Seeker sek = seek.get(i);
    sek.update(ob);
    sek.display();
    if (debug) {
      sek.debugLines();
    }
  }

  //  for (int w = 0; w < 5; w++) {
  //   Hider hid = hide.get(w);
  //   hid.display();
  //   hid.update();
  // }

  // Draw an ellipse at the mouse location
  ellipse(mouseX, mouseY, 20, 20);

  //update the seeker - done for you
  //s.update(ob);
  //s.display();
  // o.display();

  //if (debug) {
  //s.debugLines();
  //}
}

void boundary() {
  fill(0, 255, 0, 50);
  rect(100, 100, width-200, height-200);
  noFill();
}

void keyReleased() {
  if (key == 'd') {
    debug = !debug;
  }
  if (key == 'f') {
    spawnHuman = !spawnHuman;
  }
}

void mousePressed() {
  if (spawnHuman) {
    hide.add(new Hider(mouseX, mouseY, 20, 20, .1, 10));
  } else {
    seek.add(new Seeker(mouseX, mouseY, 6, 6, .1, 10));
  }
}

public void corrupt(Hider h) {
  hide.remove(h);
  for (int i = 0; i < seek.size(); i++) {
    Seeker s = seek.get(i);
    s.tag(h);
  }
  seek.add(new Seeker(h.pos.x, h.pos.y, h.r, h.maxSpeed, h.maxForce, h.radius));
}
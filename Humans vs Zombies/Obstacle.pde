class Obstacle
{
  PVector pos;
  int r;
  Obstacle(int sr)
  {
    r = sr;
    pos = new PVector(int(random(150, width-200)), int(random(150, height-200)));
  }
  void display()
  {
    ellipse(pos.x, pos.y, r, r);
  }
}
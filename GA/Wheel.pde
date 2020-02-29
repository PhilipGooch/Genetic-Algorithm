class Wheel
{
  int ID;
  float x, y;
  float r;
  
  Body body;
  
  RevoluteJoint joint;
  
  Wheel(int ID_, float x_, float y_, float r_, int categoryBits, int maskBits)
  {
    ID = ID_;
    x = x_;
    y = y_;
    r = r_;
    
     // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    Vec2 center = new Vec2(x, y);
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(r / 2);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = circle;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 100;
    fd.restitution = 0.3;
    fd.filter.categoryBits = categoryBits;
    fd.filter.maskBits = maskBits;

    body.createFixture(fd);

  }
  
  void render(float scale)
  {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
    fill(177);
    stroke(0);
    strokeWeight(2);
    translate(pos.x, pos.y);
    rotate(-a);
    
    ellipse(0, 0, r, r);
    line(0, 0, 0, r/2);
    popMatrix();
    
  }
}

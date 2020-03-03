class Chassis
{
  int ID;
  float x, y;
  
  Body body;
  
  Vec2 pos = new Vec2();
  
  Vec2 pixelVertices[];
  Vec2 worldVertices[];
  
  float[] angleDNA;
  float[] distanceDNA;
  //float[][] sortedDNA;
  
  int categoryBits;
  int maskBits;
  
  Vec2 imagePixelVertices[];
  Vec2 iworldVertices[];
  
  Vec2 ipos = new Vec2();
  
  Chassis(int ID_, float x_, float y_, float[] angleDNA_, float[] distanceDNA_, int categoryBits_, int maskBits_)
  {
    ID = ID_;
    x = x_;
    y = y_;
    angleDNA = angleDNA_;
    distanceDNA = distanceDNA_;
    categoryBits = categoryBits_;
    maskBits = maskBits_;
    
    generatePixelVertices();
  }
  
  void createBody()
  {
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(x, y)));
    body = box2d.createBody(bd);
    
    PolygonShape ps = new PolygonShape();
    worldVertices = new Vec2[8];
    for(int i = 0; i < 8; i++)
    {
      worldVertices[i] = new Vec2(box2d.scalarPixelsToWorld(cos(angleDNA[i]) * distanceDNA[i]), box2d.scalarPixelsToWorld(sin(angleDNA[i]) * distanceDNA[i])); 
    }
    ps.set(worldVertices, 8);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.3;
    fd.filter.categoryBits = categoryBits;
    fd.filter.maskBits = maskBits;

    body.createFixture(fd);
  }
  
  void destroyBody()
  {
    box2d.world.destroyBody(body);
    body = null;
  }
  
  void generatePixelVertices()
  {
    pixelVertices = new Vec2[8];
    for(int i = 0; i < 8; i++)
    {
      pixelVertices[i] = new Vec2(cos(-angleDNA[i]) * distanceDNA[i], sin(-angleDNA[i]) * distanceDNA[i]); 
    }
  }
  
  void generateImageVertices(float scale)
  {
    imagePixelVertices = new Vec2[8];
    for(int i = 0; i < 8; i++)
    {
      imagePixelVertices[i] = new Vec2(cos(-angleDNA[i]) * distanceDNA[i] * scale, sin(-angleDNA[i]) * distanceDNA[i] * scale); 
    }
  }
  
  void renderImage()
  {
    
    pushMatrix();
    fill(177);
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
    
    beginShape();
    for (Vec2 v: imagePixelVertices) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    for (Vec2 v: imagePixelVertices) {
      line(0, 0, v.x, v.y);
    }
    popMatrix();
  }
  
  void render(float scale)
  {
    pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
    fill(177);
    stroke(0);
    strokeWeight(2);
    rectMode(CENTER);
    
    translate(pos.x, pos.y);
    rotate(-a);
    beginShape();
    for (Vec2 v: pixelVertices) {
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    for (Vec2 v: pixelVertices) {
      line(0, 0, v.x, v.y);
    }
    popMatrix();
  }
}

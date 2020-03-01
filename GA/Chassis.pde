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
  
  
  
  Vec2 imagePixelVertices[];
  Vec2 iworldVertices[];
  
  Vec2 ipos = new Vec2();
  
  Chassis(int ID_, float x_, float y_, float[] angleDNA_, float[] distanceDNA_, int categoryBits, int maskBits)
  {
    ID = ID_;
    x = x_;
    y = y_;
    angleDNA = angleDNA_;
    distanceDNA = distanceDNA_;
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    Vec2 center = new Vec2(x, y);
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    //sortedDNA = sortDNA(angleDNA, distanceDNA, 8);

    pixelVertices = new Vec2[8];
    for(int i = 0; i < 8; i++)
    {
      pixelVertices[i] = new Vec2(cos(-angleDNA[i]) * distanceDNA[i], sin(-angleDNA[i]) * distanceDNA[i]); 
      //pixelVertices[i] = new Vec2(cos(-sortedDNA[i][0]) * sortedDNA[i][1], sin(-sortedDNA[i][0]) * sortedDNA[i][1]); 
    }

    PolygonShape ps = new PolygonShape();
    worldVertices = new Vec2[8];
    for(int i = 0; i < 8; i++)
    {
      worldVertices[i] = new Vec2(box2d.scalarPixelsToWorld(cos(angleDNA[i]) * distanceDNA[i]), box2d.scalarPixelsToWorld(sin(angleDNA[i]) * distanceDNA[i])); 
      //worldVertices[i] = new Vec2(box2d.scalarPixelsToWorld(cos(sortedDNA[i][0]) * sortedDNA[i][1]), box2d.scalarPixelsToWorld(sin(sortedDNA[i][0]) * sortedDNA[i][1])); 
    }
    ps.set(worldVertices, 8);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = 0.3;
    fd.filter.categoryBits = categoryBits;
    fd.filter.maskBits = maskBits;

    body.createFixture(fd);
    
  }
  
  void generateImageVertices(float scale)
  {
    imagePixelVertices = new Vec2[8];
    for(int i = 0; i < 8; i++)
    {
      imagePixelVertices[i] = new Vec2(cos(-angleDNA[i]) * distanceDNA[i] * scale, sin(-angleDNA[i]) * distanceDNA[i] * scale); 
      //ipixelVertices[i] = new Vec2(cos(-sortedDNA[i][0]) * sortedDNA[i][1] * scale, sin(-sortedDNA[i][0]) * sortedDNA[i][1] * scale); 
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
    //Vec2 pos = new Vec2(x, y);
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
    
    // image body
    
    
  }
 
  //float[][] sortDNA(float angle[], float distance[], int n)  
  //{   
  //  // bubble sort
  //  for (int i = 0; i < n-1; i++) 
  //  {
  //    for (int j = 0; j < n-i-1; j++) 
  //    {
  //      if (angle[j] > angle[j+1])  
  //      {
  //          float angleTemp = angle[j];
  //          angle[j] = angle[j + 1];
  //          angle[j + 1] = angleTemp;
            
  //          float distanceTemp = distance[j];
  //          distance[j] = distance[j + 1];
  //          distance[j + 1] = distanceTemp;
  //      }
  //    }
  //  } 
    
  //  float[][] combined = new float[n][2];
  //  for(int i = 0; i < n; i++)
  //  {
  //    combined[i][0] = angle[i];
  //    combined[i][1] = distance[i];
  //  }
    
  //  return combined;
  //}  
}

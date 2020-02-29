class Terrain
{
  ArrayList<Vec2> surface;
  
  Body body;

  Terrain(int categoryBits, int maskBits) {
    surface = new ArrayList<Vec2>();
    // Here we keep track of the screen coordinates of the chain
    //surface.add(new Vec2(50, height/2));
    //surface.add(new Vec2(width/2, height/2+50));
    //surface.add(new Vec2(width - 50, height/2));
    
    int interval = 300;
    int count = 0;
    noiseSeed(300);
    for(float i = 0; i <= 100; i++)
    {
       surface.add(new Vec2(i * interval - interval, height/2 + (noise(count++) - 0.5) * 600));
    }

    // The edge chain is now a body!
    BodyDef bd = new BodyDef();
    body = box2d.world.createBody(bd);


    // This is what box2d uses to put the surface in its world
    ChainShape chain = new ChainShape();

    // We can add 3 vertices by making an array of 3 Vec2 objects
    Vec2[] vertices = new Vec2[surface.size()];
    for (int i = 0; i < vertices.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(surface.get(i));
    }

    chain.createChain(vertices, vertices.length);

   
    
    FixtureDef fd = new FixtureDef();
    fd.shape = chain;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 100;
    fd.restitution = 0.3;
    fd.filter.categoryBits = categoryBits;
    fd.filter.maskBits = maskBits;

    body.createFixture(fd);
  }

  // A simple function to just draw the edge chain as a series of vertex points
  void render() {
    strokeWeight(1);
    stroke(0);
    fill(0);
    beginShape();
    for (Vec2 v: surface) {
      vertex(v.x, v.y);
    }
    vertex(10000, height * 2);
    vertex(-3000, height * 2);
    endShape(CLOSE);
  }
}

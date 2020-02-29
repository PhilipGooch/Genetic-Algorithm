class Car
{
  int ID;
  float x, y;
  
  Wheel frontWheel;
  Wheel backWheel;
  Chassis chassis;
  
  float dna [];
  
  //DistanceJointDef djd;
  //DistanceJoint dj;
  
  RevoluteJoint frontWheelJoint;
  RevoluteJoint backWheelJoint;

  public Car(int ID_, float x_, float y_, float[] dna_)
  {
    ID = ID_;
    x = x_;
    y = y_;
    dna = dna_;
    
    // 0 - 7 : chassis angles
    // 8 - 15 : chassis distances
    // 16 : front wheel size
    // 17 : back wheel size
    
    float[] chassisAngleDNA = new float[8];
    chassisAngleDNA[0] = dna[0];
    chassisAngleDNA[1] = dna[1];
    chassisAngleDNA[2] = dna[2];
    chassisAngleDNA[3] = dna[3];
    chassisAngleDNA[4] = dna[4];
    chassisAngleDNA[5] = dna[5];
    chassisAngleDNA[6] = dna[6];
    chassisAngleDNA[7] = dna[7];
    
    float[] chassisDistanceDNA = new float[8];
    chassisDistanceDNA[0] = dna[8];
    chassisDistanceDNA[1] = dna[9];
    chassisDistanceDNA[2] = dna[10];
    chassisDistanceDNA[3] = dna[11];
    chassisDistanceDNA[4] = dna[12];
    chassisDistanceDNA[5] = dna[13];
    chassisDistanceDNA[6] = dna[14];
    chassisDistanceDNA[7] = dna[15];
    
    chassis = new Chassis(ID, x, y, chassisAngleDNA, chassisDistanceDNA, CAR, ENVIRONMENT);
    
    frontWheel = new Wheel(ID, x + chassis.pixelVertices[2].x, y + chassis.pixelVertices[2].y, dna[16], CAR, ENVIRONMENT);
    backWheel = new Wheel(ID, x + chassis.pixelVertices[5].x, y + chassis.pixelVertices[5].y, dna[17], CAR, ENVIRONMENT);
    
    
    
    
    RevoluteJointDef frontRJD = new RevoluteJointDef();
    frontRJD.initialize(frontWheel.body, chassis.body, frontWheel.body.getWorldCenter());
    frontRJD.motorSpeed = PI*4;       
    frontRJD.maxMotorTorque = 20000.0; 
    frontRJD.enableMotor = false;      
    frontWheelJoint = (RevoluteJoint) box2d.world.createJoint(frontRJD);
    
    
    
    
    RevoluteJointDef backRJD = new RevoluteJointDef();
    backRJD.initialize(backWheel.body, chassis.body, backWheel.body.getWorldCenter());
    backRJD.motorSpeed = PI*4;       
    backRJD.maxMotorTorque = 20000.0; 
    backRJD.enableMotor = false;      
    backWheelJoint = (RevoluteJoint) box2d.world.createJoint(backRJD);
  }
  
  void renderImage(float scale)
  {
    chassis.generateImageVertices(scale);
    chassis.renderImage();
    strokeWeight(1);
    ellipse(chassis.ipixelVertices[2].x, chassis.ipixelVertices[2].y, frontWheel.r * scale, frontWheel.r * scale);
    line(chassis.ipixelVertices[2].x, chassis.ipixelVertices[2].y, chassis.ipixelVertices[2].x, chassis.ipixelVertices[2].y + frontWheel.r / 2 * scale);
    ellipse(chassis.ipixelVertices[5].x, chassis.ipixelVertices[5].y, backWheel.r * scale, backWheel.r * scale);
    line(chassis.ipixelVertices[5].x, chassis.ipixelVertices[5].y, chassis.ipixelVertices[5].x, chassis.ipixelVertices[5].y + backWheel.r / 2 * scale);
  }
  
  void render(float scale)
  {
    
    chassis.render(scale);
    frontWheel.render(scale);
    backWheel.render(scale);
    
  }
  
}

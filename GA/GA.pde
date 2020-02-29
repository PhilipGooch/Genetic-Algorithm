import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

enum STATE
{
  POPULATION,
  RUNNING
} 

STATE state = STATE.POPULATION;

int ENVIRONMENT = 1;
int CAR = 2;

Box2DProcessing box2d;

ArrayList<Car> cars;
Terrain terrain;
Car leader;

PVector cameraPosition;
PVector cameraTarget;

boolean lastA = false;
boolean lastD = false;

int startTime;
int runTime = 12000;
float timeStep = 1.0f / 20;

GeneticAlgorithm ga;
int populationSize = 1024;
float mutationRate = 0.05f;
float[] lastGenerationEndPositions = new float[populationSize];

float scale = 0.14;


void setup()
{
  size(834, 834);
  //size(1604, 834);
  //size(640, 640);
  surface.setLocation(-4, 0);
  
  frameRate(60);
  
  ga = new GeneticAlgorithm(populationSize, 18, mutationRate);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  if(state == STATE.POPULATION)
  {
    ga.newGeneration();
    
    cars = new ArrayList<Car>();
    for(int i = 0; i < populationSize; i++)
    {
      cars.add(new Car(i, 400, height / 4, ga.population.get(i).genes));
    }
    
  }
  
  else if(state == STATE.RUNNING)
  {
    initialiseWorld();
  }
  
  
}



void initialiseWorld()
{
  ga.newGeneration();
  
  cars = new ArrayList<Car>();

  for(int i = 0; i < populationSize; i++)
  {
    cars.add(new Car(i, 400, height / 4, ga.population.get(i).genes));
  }
  
  terrain = new Terrain(ENVIRONMENT, CAR);
  
  cameraPosition = new PVector();
  cameraTarget = new PVector();
  
  leader = null;
  
  startTime = millis();
}




float fitnessFunction(int index)
{
  return lastGenerationEndPositions[index];
}




float getRandomGene(int i)
{
  if(i <= 7)
  {
    return random(TWO_PI);
  }
  else if(i <= 15)
  {
    return random(60) + 30;
  }
  else if(i <= 17)
  {
    return random(10) + 50;
  }
  return -1;
}



void keyPressed()
{
  if(key == 'a' && lastA == false)
  {
    timeStep -= 1f / 40;
    lastA = true;
    print(timeStep);
  }
  if(key == 'd' && lastD == false)
  {
    timeStep += 1f / 40;
    lastA = true;
  }
}




void keyReleased()
{
  if(key == 'a')
  {
    lastA = false;
    print("A");
  }
  if(key == 'd')
  {
    lastD = false;
  }
}




void reset()
{
  for(int i = 0; i < populationSize; i++)
  {
    lastGenerationEndPositions[i] = cars.get(i).chassis.pos.x;
  }
  for(Car car : cars)
  {
    box2d.world.destroyBody(car.chassis.body);
    box2d.world.destroyBody(car.frontWheel.body);
    box2d.world.destroyBody(car.backWheel.body);
  }
  box2d.world.destroyBody(terrain.body);
  initialiseWorld();
}




int leaderIndex()
{
  int index = 0;
  for(int i = 0; i < cars.size(); i++)
  {
    if(cars.get(i).chassis.pos.x > cars.get(index).chassis.pos.x + 50)
    {
      index = i;
    }
  }
  return index;
}




void update()
{
  if(state == STATE.POPULATION)
  {
    
  }
  
  else if(state == STATE.RUNNING)
  {
    if(millis() > startTime + runTime)
    {
      reset();
    }
    
    
    box2d.step(timeStep,10,8);
    
    leader = cars.get(leaderIndex());
    
    float leaderX = leader.chassis.pos.x;
    float leaderY = leader.chassis.pos.y;
    cameraTarget = new PVector(width / 2 - leaderX - 150, height / 2 - leaderY - 100);
    cameraPosition.lerp(cameraTarget, 0.05);
  }
}




void draw()
{
  update();
  
  if(state == STATE.POPULATION)
  {
    background(255);
    fill(0);
    textSize(18);
    text(frameRate,20,20);
    
    int rows = 32;
    int columns = 32;
    Vec2 offset = new Vec2(20, 20);
    for(int i = 0; i < cars.size(); i++)
    {
      pushMatrix();
      translate(offset.x + (width / columns) * (i % columns), offset.y + (height / rows) * (i / columns));
      cars.get(i).renderImage(scale);
      popMatrix();
    }
  }
  
  else if(state == STATE.RUNNING)
  {
    background(255);
    fill(0);
    textSize(18);
    text(frameRate,20,20);
    text(timeStep, 20, 50);
    
    
    translate(cameraPosition.x, cameraPosition.y);
    
    for(Car car : cars)
    {
        car.render(1);
    }
    terrain.render(); //<>//
  }
}

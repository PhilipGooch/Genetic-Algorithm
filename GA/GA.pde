import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.Comparator;
import java.util.Collections;

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
int runTime = 5000;
float timeStep = 1.0f / 60;

GeneticAlgorithm ga;
int populationSize = 256;
float mutationRate = 0.2f;
float[] lastGenerationEndPositions = new float[populationSize];
float averageFitness;

float scale = 0.2;

PVector selectionBoxSize;

Button buttonGenerate = new Button(1100, 100, 160, 40, "Generate");
Button buttonQuickSimulation = new Button(1100, 300, 160, 40, "Quick");
Button buttonSort = new Button(1100, 400, 160, 40, "Sort");

boolean hoveringSelectionBox = false;
int hoverIndex = -1;

void setup()
{
  size(1400, 834);
  //size(1604, 834);
  //size(640, 640);
  surface.setLocation(-4, 0);
  
  frameRate(60);
  
  selectionBoxSize = new PVector(834, 834);
  
  ga = new GeneticAlgorithm(populationSize, 18, mutationRate);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld(new Vec2(0, -20));

  if(state == STATE.POPULATION)
  {
    
    cars = new ArrayList<Car>();
    for(int i = 0; i < populationSize; i++)
    {
      cars.add(new Car(i, 0, height / 4, ga.population.get(i).genes));
    }
    
  }
  
  else if(state == STATE.RUNNING)
  {
    cars = new ArrayList<Car>();

    for(int i = 0; i < populationSize; i++)
    {
      cars.add(new Car(i, 0, height / 4, ga.population.get(i).genes));
    }
    
    terrain = new Terrain(ENVIRONMENT, CAR);
  
    cameraPosition = new PVector();
    cameraTarget = new PVector();
    
    leader = null;
    
    startTime = millis();
  }
  
  terrain = new Terrain(ENVIRONMENT, CAR);
  
  cameraPosition = new PVector();
  cameraTarget = new PVector();
  
  leader = null;
  
  startTime = millis();
}



//void initialiseWorld()
//{
//  ga.newGeneration();
  
//  cars = new ArrayList<Car>();

//  for(int i = 0; i < populationSize; i++)
//  {
//    cars.add(new Car(i, 400, height / 4, ga.population.get(i).genes));
//  }
  
//  terrain = new Terrain(ENVIRONMENT, CAR);
  
//  cameraPosition = new PVector();
//  cameraTarget = new PVector();
  
//  leader = null;
  
//  startTime = millis();
//}




float fitnessFunction(int index)
{
  return lastGenerationEndPositions[index];
}


// Picking above average DNA
int selectionFunction()
{
  ArrayList<Integer> remainingIndices = new ArrayList<Integer>();
  for(int i = 0; i < populationSize; i++)
  {
    remainingIndices.add(i);
  }
  int[] shuffled = new int[populationSize];
  for(int i = 0; i < populationSize; i++)
  {
    int rand = (int)random(remainingIndices.size());
    shuffled[i] = remainingIndices.get(rand);
    remainingIndices.remove(rand);
  }
  
  for(int i = 0; i < populationSize; i++)
  {
    if(ga.population.get(shuffled[i]).fitness > averageFitness)
    {
      return i;
    }
  }
  
  return (int)random(ga.population.size()); 
  
}


float getInitialRandomGene(int i)
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
    return random(50) + 50;
  }
  return -1;
}

// mutate
float getRandomGene(int i, float currentGene)
{
  if(i <= 7)
  {
    return currentGene + random(0.2) - 0.1;
  }
  else if(i <= 15)
  {
    return currentGene + random(6) + 3;
  }
  else if(i <= 17)
  {
    return currentGene + random(6) + 3;
  }
  return -1;
}



void mouseMoved()
{
  hoveringSelectionBox = mouseX < selectionBoxSize.x && mouseY < selectionBoxSize.y;
  
  if(hoveringSelectionBox)
  {
    
    
    hoverIndex = (int)  (mouseX / (selectionBoxSize.x / 16)) + 
                 (int)  (mouseY / (selectionBoxSize.y / 16)) * 16;
    
    println(hoverIndex);
  }
}


void mousePressed()
{
  if(mouseButton == LEFT)
  {
    if(state == STATE.POPULATION)
    {
      if(hoveringSelectionBox)
      {
        cars.get(hoverIndex).imageSelected = !cars.get(hoverIndex).imageSelected;
      }
       
      if(buttonGenerate.clicked())
      {
        ga = new GeneticAlgorithm(populationSize, 18, mutationRate);
      
        cars = new ArrayList<Car>();
        for(int i = 0; i < populationSize; i++)
        {
          cars.add(new Car(i, 0, height / 4, ga.population.get(i).genes));
        }
      }
      
      if(buttonQuickSimulation.clicked())
      {
        for(int i = 0; i < 100; i++)
        {
          box2d.step(timeStep, 10, 8);
          
        }
        reset();
        
        
      }
      
      if(buttonSort.clicked())
      {
        Collections.sort(cars, new AComparator());
      }
    }
  }
}



void keyPressed()
{
  if(key == 'a' && lastA == false)
  {
    //timeStep -= 1f / 40;
    //box2d.step(timeStep, 8, 6);
    lastA = true;
  }
  if(key == 'd' && lastD == false)
  {
    //timeStep += 1f / 40;
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





import java.util.Arrays;
import java.util.Comparator;
import java.util.Collections;
class AComparator implements Comparator<Car> {
 int compare(Car a, Car b) {
   return (int)b.fitness - (int)a.fitness;
 }
}

void reset()
{
  
  
  averageFitness = 0;
  for(int i = 0; i < populationSize; i++)
  {
    lastGenerationEndPositions[i] = box2d.getBodyPixelCoord(cars.get(i).chassis.body).x;
    
    averageFitness += lastGenerationEndPositions[i];
  }
  averageFitness /= populationSize;
  
  
  
  for(Car car : cars)
  {
    box2d.world.destroyBody(car.chassis.body);
    box2d.world.destroyBody(car.frontWheel.body);
    box2d.world.destroyBody(car.backWheel.body);
  }
  //box2d.world.destroyBody(terrain.body);
  
  ga.newGeneration();
  cars = new ArrayList<Car>();

  for(int i = 0; i < populationSize; i++)
  {
    cars.add(new Car(i, 0, height / 4, ga.population.get(i).genes));
    cars.get(i).fitness = lastGenerationEndPositions[i];
  }
  
  
  
  terrain = new Terrain(ENVIRONMENT, CAR);

  cameraPosition = new PVector();
  cameraTarget = new PVector();
  
  leader = null;
  
  startTime = millis();
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
    
    for(int i = 0; i < 1; i++)
    {
      box2d.step(timeStep,10,8);
    }
    
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
    
    int rows = 16;
    int columns = 16;
    Vec2 offset = new Vec2(25, 25);
    for(int i = 0; i < cars.size(); i++)
    {
      if(cars.get(i).imageSelected)
      {
        noFill();
        stroke(255, 0, 0);
        strokeWeight(2);
        rect(offset.x + (selectionBoxSize.x / columns) * (i % columns), offset.y + (selectionBoxSize.y / rows) * (i / columns), (selectionBoxSize.x / columns), (selectionBoxSize.y / rows));
      }
      pushMatrix();
      translate(offset.x + (selectionBoxSize.x / columns) * (i % columns), offset.y + (selectionBoxSize.y / rows) * (i / columns));
      cars.get(i).renderImage(scale);
      popMatrix();
    }
    
    if(hoveringSelectionBox && hoverIndex < cars.size())
    {
      
      pushMatrix();
      translate(1100, height / 2);
      cars.get(hoverIndex).renderImage(1);
      text(cars.get(hoverIndex).fitness, 0, 150);
      popMatrix();
    }
    
    buttonGenerate.render();
    buttonQuickSimulation.render();
    buttonSort.render();
    
    text(ga.generation, 900, 50);
    text(averageFitness, 900, 100);
    
    
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
    terrain.render();
  }
}

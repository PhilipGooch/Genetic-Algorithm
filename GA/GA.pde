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

Box2DProcessing box2d;

float timeStep = 1.0f / 60;
int steps = 1000;
int stepCount = 0;

GeneticAlgorithm ga;
int populationSize = 32;
int dnaSize = 18;
float mutationRate = 0.001f;

float averageFitness = 0;

ArrayList<Car> cars;
Terrain terrain;
Car leader = null;
int ENVIRONMENT = 1;
int CAR = 2;

PVector cameraPosition = new PVector();
PVector cameraTarget = new PVector();

boolean lastA = false;
boolean lastD = false;

PVector selectionBoxSize;

Button resetButton = new Button(1100, 50, 160, 40, "Reset", true);
Button quickButton = new Button(1100, 100, 160, 40, "Quick", true);
Button runButton = new Button(1100, 150, 160, 40, "Run", true);
Button sortButton = new Button(1100, 200, 160, 40, "Sort", false);
Button breedButton = new Button(1100, 250, 160, 40, "Breed", false);
Button playButton = new Button(1100, 300, 160, 40, "Play", false);

boolean hoveringSelectionBox = false;
int hoverIndex = -1;

int triggerQuickButton = 0;

// CONSTRUCTOR
////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup()
{
  size(1400, 834);
  surface.setLocation(-4, 0);
  
  frameRate(60);
  
  selectionBoxSize = new PVector(834, 834);
  
  ga = new GeneticAlgorithm(populationSize, dnaSize, mutationRate);
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld(new Vec2(0, -20));

  terrain = new Terrain(ENVIRONMENT, CAR);
  
  cars = new ArrayList<Car>();
  for(int i = 0; i < populationSize; i++)
  {
    cars.add(new Car(i, 0, height / 4, ga.population.get(i).genes));
  }
  
  
  if(state == STATE.POPULATION)
  {
    
  }
  
  else if(state == STATE.RUNNING)
  {
    
  }
}


// FITNESS FUNCTION
////////////////////////////////////////////////////////////////////////////////////////////////////////

float fitnessFunction(int index)
{
  return  cars.get(index).fitness;
}


// SELECTION FUNCTION
////////////////////////////////////////////////////////////////////////////////////////////////////////

int selectionFunction()
{
  // Picking above average DNA
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


// MUTATION FUNCTION
////////////////////////////////////////////////////////////////////////////////////////////////////////

float mutationFunction(int i, float currentGene)
{
  if(i <= 7)
  {
    return currentGene;// + (random(0.2) - 0.1);
  }
  else if(i <= 15)
  {
    return currentGene + (random(6) - 3);
  }
  else if(i <= 17)
  {
    return currentGene + (random(6) - 3);
  }
  return -1;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////
// HELPER FUNCTIONS
////////////////////////////////////////////////////////////////////////////////////////////////////////

void newPopulation()
{
  ga = new GeneticAlgorithm(populationSize, dnaSize, mutationRate);
  cars = new ArrayList<Car>();
  for(int i = 0; i < populationSize; i++)
  {
    cars.add(new Car(i, 0, height / 4, ga.population.get(i).genes));
  }
  averageFitness = 0;
  cameraPosition = new PVector();
  cameraTarget = new PVector();
  leader = null;
}

void quickRun()
{  
  for(int i = 0; i <= steps; i++)
  {
    box2d.step(timeStep, 10, 8);
  }
  calculateAverageFitness();
}

void sortCars()
{
  Collections.sort(cars, new AComparator());
}

void setCarFitnesses()
{
  for(int i = 0; i < populationSize; i++)
  {
    cars.get(i).fitness = box2d.getBodyPixelCoord(cars.get(i).chassis.body).x;
  }
}

void calculateAverageFitness()
{
  setCarFitnesses();
  averageFitness = 0;
  for(int i = 0; i < populationSize; i++)
  {
    averageFitness +=  cars.get(i).fitness;
  }
   averageFitness /= populationSize;
}

void destroyCars()
{
  for(Car car : cars)
  {
    box2d.world.destroyBody(car.chassis.body);
    box2d.world.destroyBody(car.frontWheel.body);
    box2d.world.destroyBody(car.backWheel.body);
  }
}

void breed()
{
  ga.newGeneration();
  cars = new ArrayList<Car>();
  for(int i = 0; i < populationSize; i++)
  {
    cars.add(new Car(i, 0, height / 4, ga.population.get(i).genes));
  }
  averageFitness = 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

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



// UPDATE
////////////////////////////////////////////////////////////////////////////////////////////////////////

void update()
{
  hoveringSelectionBox = mouseX < selectionBoxSize.x && mouseY < selectionBoxSize.y;
  if(hoveringSelectionBox)
  {
    hoverIndex = (int)  (mouseX / (selectionBoxSize.x / 16)) + 
                 (int)  (mouseY / (selectionBoxSize.y / 16)) * 16;
  }
  
  if(state == STATE.POPULATION)
  {
  }
  
  else if(state == STATE.RUNNING)
  {
    if(stepCount++ > steps)
    {
      calculateAverageFitness();
      //destroyCars();
      //breed();
      //averageFitness = 0;
      cameraPosition = new PVector();
      cameraTarget = new PVector();
      leader = null;
      state = STATE.POPULATION;
      runButton.valid = false;
      quickButton.valid = false;
      stepCount = 0;
    }
    
    box2d.step(timeStep,10,8);
    
    leader = cars.get(leaderIndex());
    
    float leaderX = leader.chassis.pos.x;
    float leaderY = leader.chassis.pos.y;
    cameraTarget = new PVector(width / 2 - leaderX - 150, height / 2 - leaderY - 100);
    cameraPosition.lerp(cameraTarget, 0.05);
  }
}


// RENDER
////////////////////////////////////////////////////////////////////////////////////////////////////////

void draw()
{
  update();
  
  // POPULATION
  /////////////////////////////////////////////////////
  if(state == STATE.POPULATION)
  {
    background(255);
    fill(0);
    
    int rows = 16;
    int columns = 16;
    Vec2 offset = new Vec2(28, 28);
    for(int i = 0; i < cars.size(); i++)
    {
      // IMAGE BORDER
      if(cars.get(i).imageSelected)
      {
        noFill();
        stroke(255, 0, 0);
        strokeWeight(2);
        rectMode(CENTER);
        rect(offset.x + (selectionBoxSize.x / columns) * (i % columns), offset.y + (selectionBoxSize.y / rows) * (i / columns), (selectionBoxSize.x / columns), (selectionBoxSize.y / rows));
      }
      // SMALL CAR IMAGES
      pushMatrix();
      translate(offset.x + (selectionBoxSize.x / columns) * (i % columns), offset.y + (selectionBoxSize.y / rows) * (i / columns));
      cars.get(i).renderImage(0.2);
      popMatrix();
    }
    
    // HOVER IMAGE
    if(hoveringSelectionBox && hoverIndex < cars.size())
    {
      pushMatrix();
      translate(1100, height / 8 * 5);
      cars.get(hoverIndex).renderImage(2);
      fill(0);
      if(cars.get(hoverIndex).fitness == 0)
      {
        text("?", 150, 250);
      }
      else
      {
        text(cars.get(hoverIndex).fitness, 150, 250);
      }
      popMatrix();
    }
    
    resetButton.render();
    quickButton.render();
    sortButton.render();
    runButton.render();
    breedButton.render();
    
    text(ga.generation, 900, 50);
    if(averageFitness == 0)
    {
      text("?", 900, 100); //<>//
    }
    else
    {
      text(averageFitness, 900, 100);
    }
    if(triggerQuickButton == 1)
    {
      triggerQuickButton++;
    }
    else if(triggerQuickButton == 2)
    {
      //rect(0, 0, 50, 50);
      quickRun();
      runButton.valid = false;
      sortButton.valid = true;
      breedButton.valid = true;
      quickButton.valid = false;
      
      triggerQuickButton = 0;
    }
  }
  
  // RUNNING
  /////////////////////////////////////////////////////
  else if(state == STATE.RUNNING)
  {
    background(255);
    fill(0);
    textSize(18);
    text(stepCount, 20, 50);
    text((int) frameRate, 20, 20);
    text(box2d.getBodyPixelCoord(cars.get(0).chassis.body).x, 20, 80);
    
    for(int i = 0; i < 8; i++)
    {
      text(cars.get(0).dna[i], 20, 110 + i * 20);
    }
    
    translate(cameraPosition.x, cameraPosition.y);
    
    for(Car car : cars)
    {
        car.render(1);
    }
    terrain.render();
   
  }
  
}

class GeneticAlgorithm
{
  int generation;
  float mutationRate;
  ArrayList<DNA> population;
  
  //should be called bestDNA...?
  float[] bestGenes;
  
  // used when selecting parents
  float fitnessSum;
  
  // used for checking when to stop the algorithm
  float bestFitness;
  
  GeneticAlgorithm(int populationSize, int dnaSize, float mutationRate_)
  {
    generation = 1;
    mutationRate = mutationRate_;
    
    // Storing the fittest set of genes
    bestGenes = new float[dnaSize];
    
    // Creating the population
    population = new ArrayList<DNA>();
    for(int i = 0; i < populationSize; i++)
    {
      population.add(new DNA(dnaSize, true));
    }
  }
  
  void newGeneration()
  {
    if(population.size() <= 0)
    {
      return;
    }
    
    calculateFitness();
     //<>//
    ArrayList<DNA> newPopulation = new ArrayList<DNA>();

    for(int i = 0; i < population.size(); i++)
    {
      DNA parent1 = population.get(ChooseParent());
      DNA parent2 = population.get(ChooseParent());

      DNA child = parent1.crossover(parent2);

      child.mutate(mutationRate);

      newPopulation.add(child);
    }

    population = newPopulation;

    generation++;
  }
  
  void calculateFitness()
  {
    // The fitnesses of all the population combined
    fitnessSum = 0;

    DNA best = population.get(0);

    //int bestDNAIndex = 0;
    
    for(int i = 0; i < population.size(); i++)
    {
      
      fitnessSum += population.get(i).calculateFitness(i);

      if(population.get(i).fitness > best.fitness)
      {
        best = population.get(i);
        //bestDNAIndex = i;
      }
    }

    bestFitness = best.fitness;
    
    bestGenes = best.genes;
    //bestGenes = population.get(bestDNAIndex).genes;
    //best.genes.CopyTo(bestGenes, 0);
  }
  
  // returns the index of the parent in the population array
  int ChooseParent()
  {
    //return selectionFunction();
    float randomNumber = random(1) * fitnessSum;
    
    // This algorithm has the effect of being more likely to choose fitter parents.
    for(int i = 0; i < population.size(); i++)
    {
      if(randomNumber < population.get(i).fitness)
      {
        return i;
      }
      randomNumber -= population.get(i).fitness;
    }
    return (int)random(population.size());   // possible bug here with out of range exception casting to int from picking highest number?
  }
  

}

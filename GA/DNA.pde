class DNA
{
  float[] genes;
  
  float fitness;
  
  DNA(int size, boolean shouldInitGenes)
  {
    genes = new float[size];

    if(shouldInitGenes)
    {
      for(int i = 0; i < genes.length; i++)
      {
        genes[i] = getRandomGene(i);
      }
    }
  } //<>//
  
  public DNA crossover(DNA otherParent)
  {
    DNA child = new DNA(genes.length, false);

    for(int i = 0; i < genes.length; i++)
    {
      child.genes[i] = random(1) < 0.5 ? genes[i] : otherParent.genes[i];
    }

    return child;
  }
  
  public void mutate(float mutationRate)
  {
    for(int i = 0; i < genes.length; i++)
    {
      if(random(1) < mutationRate)
      {
        genes[i] = getRandomGene(i);
      }
    }
  }
  
  // This is redundant in this implementation but if the fitness function was being passed in to the class then it could handle a range of fitness functions
  float calculateFitness(int index)
  {
    fitness = fitnessFunction(index);
    return fitness;
  }
}

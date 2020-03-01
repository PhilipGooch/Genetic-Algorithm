
class DNA 
{
  float[] genes;
  
  float fitness;
  
  DNA(int size, boolean shouldInitGenes)
  {
    genes = new float[size];
    
    fitness = 0;

    if(shouldInitGenes)
    {
      // 0 - 7 : chassis angles
      // 8 - 15 : chassis distances
      // 16 : front wheel size
      // 17 : back wheel size
      for(int i = 0; i < genes.length; i++)
      {
        //genes[0] = TWO_PI / 8 * 0;
        //genes[1] = TWO_PI / 8 * 1;
        //genes[2] = TWO_PI / 8 * 2;
        //genes[3] = TWO_PI / 8 * 3;
        //genes[4] = TWO_PI / 8 * 4;
        //genes[5] = TWO_PI / 8 * 5;
        //genes[6] = TWO_PI / 8 * 6;
        //genes[7] = TWO_PI / 8 * 7;
        
        
        //genes[8] = 30;
        //genes[9] = 30;
        //genes[10] = 30;
        //genes[11] = 30;
        //genes[12] = 30;
        //genes[13] = 30;
        //genes[14] = 30;
        //genes[15] = 30;
        
        //genes[16] = 40;
        //genes[17] = 40;
        
        //for(int j = 0; j < 5; j++)
        //{
        //  for(int k = 0; k < 16; k++)
        //  {
        //    //mutate(k);
        //  }
        //}
        
        if(i <= 7)
        {
          genes[i] = TWO_PI / 8 * i + random(TWO_PI / 8) - TWO_PI / 16;
        }
        else if(i <= 15)
        {
          genes[i] = random(60) + 30;
        }
        else if(i <= 17)
        {
          genes[i] = random(50) + 50;
        }
      }
    }
  }
  
    
 
  
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
        genes[i] = mutationFunction(i, genes[i]);
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

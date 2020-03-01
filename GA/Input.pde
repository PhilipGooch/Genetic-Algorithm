void mousePressed()
{
  if(mouseButton == LEFT)
  {
    if(state == STATE.POPULATION)
    {
      if(hoveringSelectionBox && hoverIndex < populationSize)
      {
        cars.get(hoverIndex).imageSelected = !cars.get(hoverIndex).imageSelected;
      }
      
      // RESET
      if(resetButton.hit() && resetButton.valid)
      {
        resetButton.pressed = true;
        newPopulation();
        quickButton.valid = true;
        sortButton.valid = false;
        breedButton.valid = false;
      }
      
      // QUICK
      if(quickButton.hit() && quickButton.valid)
      {
        quickButton.valid = false;
        quickButton.pressed = true;
        triggerQuickButton = 1;
        
      }
      
      // RUN
      if(runButton.hit() && runButton.valid)
      {
        runButton.pressed = true;
        breedButton.valid = true;
        quickButton.valid = false;
        sortButton.valid = true;
        state = STATE.RUNNING;
      }
      
      // SORT
      if(sortButton.hit() && sortButton.valid)
      {
        sortButton.pressed = true;
        sortCars();
        sortButton.valid = false;
      }
      
      // BREED
      if(breedButton.hit() && breedButton.valid)
      {
        breed();
        breedButton.pressed = true;
        breedButton.valid = false;
        sortButton.valid = false;
        quickButton.valid = true;
        runButton.valid = true;
      }
      
      // PLAY
      if(playButton.hit() && playButton.valid)
      {
        playButton.pressed = true;
      }
    }
  }
}

void mouseReleased()
{
  resetButton.pressed = false;
  sortButton.pressed = false;
  quickButton.pressed = false;
  runButton.pressed = false;
  breedButton.pressed = false;
  playButton.pressed = false;
}

void mouseDragged()
{
  // RESET
  if(resetButton.pressed && !resetButton.hit())
  {
    resetButton.pressed = false;
  }
  // SORT
  else if(sortButton.pressed && !sortButton.hit())
  {
    sortButton.pressed = false;
  }
  // QUICK
  else if(quickButton.pressed && !quickButton.hit())
  {
    quickButton.pressed = false;
  }
  // RUN
  else if(runButton.pressed )
  {
    print("x");
    if(!runButton.hit())
      runButton.pressed = false;
  }
  // BREED
  else if(breedButton.pressed && !breedButton.hit())
  {
    breedButton.pressed = false;
  }
  // PLAY
  else if(playButton.pressed && !playButton.hit())
  {
    playButton.pressed = false;
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

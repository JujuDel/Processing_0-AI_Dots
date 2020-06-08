class Population
{
  Dot[] dots;

  float fitnessSum = 0.0, bestFitness = 0.0;
  
  int gen = 1;

  int bestDot = 0;
  int minStep = 10000;

  Population(int size, boolean incremental, boolean obstacle, boolean jalon)
  {
    int startStep = 500;
    if (incremental)
    startStep = 100;
    
    dots = new Dot[size];
    for (int i = 0; i < size; i++)
    {
      dots[i] = new Dot(startStep, obstacle, jalon);
    }
  }

  void show(boolean alone)
  {
    if (!alone)
    {
      for (int i = 1; i < dots.length; i++)
      {
        dots[i].show();
      }
    }
    dots[0].show();
  }

  void update()
  {
    for (int i = 0; i < dots.length; i++)
    {
      if (dots[i].brain.step <= minStep)
      {
        dots[i].update();
      }
      else
      {
        dots[i].dead = true;
      }
    }
  }

  void initRewards(int nbJalon)
  {
    for (int i = 0; i < dots.length; i++)
    {
      dots[i].brain.initRewards(nbJalon);
    }
  }

  void computeFitness()
  {
    for (int i = 0; i < dots.length; i++)
    {
      dots[i].computeFitness();
    }
  }

  boolean allDotsDead()
  {
    for (int i = 0; i < dots.length; i++)
    {
      if (!dots[i].dead && !dots[i].reachedGoal )
      {
        return false;
      }
    }
    return true;
  }

  void naturalSelection()
  {
    Dot[] newDots = new Dot[dots.length];

    setBestDot();

    computeFitnessSum();

    newDots[0] = dots[bestDot].cloneGoodOne();
    newDots[0].isBest = true;

    for (int i = 1; i < newDots.length; i++)
    {
      Dot goodOne = selectParent();

      newDots[i] = goodOne.cloneGoodOne();
    }

    dots = newDots.clone();
    gen++;
  }

  void computeFitnessSum()
  {
    fitnessSum = 0;
    for (int i = 0; i < dots.length; i++)
    {
      fitnessSum += dots[i].fitness;
    }
  }

  Dot selectParent()
  {
    float rand = random(fitnessSum);

    float runningSum = 0;
    for (int i = 0; i < dots.length; i++)
    {
      runningSum += dots[i].fitness;
      if (runningSum > rand)
      {
        return dots[i];
      }
    }

    return null;
  }

  void mutateGoodOnes()
  {
    for (int i = 1; i < dots.length; i++)
    {
      dots[i].brain.mutate(dots[i].deathByObst, dots[i].deathAtStep);
      dots[i].deathByObst = false;
      dots[i].gen = gen;
    }
    
    dots[0].deathByObst = false;
    dots[0].gen = gen;
  }
  
  void setBestDot()
  {
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i < dots.length; i++)
    {
      if (dots[i].fitness > max)
      {
        max = dots[i].fitness;
        maxIndex = i;
      }
    }

    bestDot = maxIndex;

    if (max > bestFitness)
    {
      bestFitness = max;
    }

    //if this player reached the goal then reset the minimum number of steps it takes to get to the goal
    if (dots[bestDot].reachedGoal)
    {
      minStep = dots[bestDot].brain.step;
    }

    String textGen = "Gen " + gen;
    if (dots[bestDot].reachedGoal)
    {
      minStep = dots[bestDot].brain.step;
      println(textGen, ": best Step = ", minStep);
    }
    else
    {
      println(textGen, ": no reached goal");
    }
  }
  
  void increaseMoves(int inc)
  {
    for (int i = 0; i < dots.length; i++)
    {
      dots[i].brain.increaseMoves(inc);
    }
  }
}

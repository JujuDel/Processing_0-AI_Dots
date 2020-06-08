class Brain {
  PVector[] directions;
  int step = 0;
  int[] rewards;
  boolean jalon;
  
  Brain(int size, boolean isJalonUsed)
  {
    directions = new PVector[size];
    randomize();
    jalon = isJalonUsed;
  }

  void randomize()
  {
    for(int i = 0; i < directions.length; i++)
    {
      float randomAngle = random(2*PI);
      directions[i] = PVector.fromAngle(randomAngle);
    }
  }

  Brain clone()
  {
    Brain clone = new Brain(directions.length, jalon);

    for(int i = 0; i < directions.length; i++)
    {
      clone.directions[i] = directions[i].copy();
    }
    
    if (jalon)
    {
      clone.rewards = new int[rewards.length];
      for (int i = 0; i < rewards.length; i++)
      {
        clone.rewards[i] = 1000;
      }
    }
    
    return clone;
  }

  void mutate(boolean diedByObstacle, int deathStep)
  {
    float mutationRate = 0.01;
    
    for(int i = 0; i < directions.length; i++)
    {
      float rand = random(1);
      if (diedByObstacle && i > deathStep - 100)
      {
        rand = random(0.2);
      }
      
      if (rand < mutationRate)
      {
        directions[i] = PVector.fromAngle(random(2*PI));
      }
    }
  }
  
  void initRewards(int nbJalon)
  {
    rewards = new int[nbJalon];
    for (int i = 0; i < nbJalon; i++)
    {
      rewards[i] = 10000;
    }
  }
  
  void rewarding(int idJalon)
  {
    if (rewards[idJalon] > step)
    {
      rewards[idJalon] = step;
    }
  }
  
  void increaseMoves(int inc)
  {
    for (int i = 0; i < inc; i++)
    {
      PVector newVec = PVector.fromAngle(random(2*PI));
      directions = (PVector[])append(directions, newVec);
    }
  }
}

class Dot
{
  boolean dead = false;
  boolean reachedGoal = false;
  boolean isBest = false;
  boolean deathByObst = false;
  
  boolean isJalon1OK = false, isJalon2OK = false;
  
  int deathAtStep = 0;
  int gen = 1;
  
  PVector pos;
  PVector vel;
  PVector acc;
  
  boolean obstacle, jalon;

  Brain brain;

  float fitness = 0;

  Dot(int numberOfSteps, boolean isObstacleUsed, boolean isJalonUsed)
  {
    pos = new PVector(width/2, height - 4);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
    
    obstacle = isObstacleUsed;
    jalon = isJalonUsed;

    brain = new Brain(numberOfSteps, jalon);
  }

  void show()
  {
    if (isBest)
    {
      fill(0, 255, 0);
      ellipse(pos.x, pos.y, 8, 8);
    }
    else if (isJalon2OK)
    {
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, 4, 4); 
    }
    else if (isJalon1OK)
    {
      fill(0, 200, 0);
      ellipse(pos.x, pos.y, 4, 4); 
    }
    else
    {
      fill(0);
      ellipse(pos.x, pos.y, 4, 4);
    }
  }

  void move()
  {
    if (brain.directions.length > brain.step)
    {
      acc = brain.directions[brain.step];
      brain.step++;
    }
    else
    {
      dead = true;
    }

    vel.add(acc);
    vel.limit(5);
    pos.add(vel);
  }

  void update()
  {
    if (!dead && !reachedGoal)
    {
      move();
      
      if (dist(pos.x, pos.y, goal.x, goal.y) < 5)
      {
        reachedGoal = true;
      }
      else if (pos.x < 2 || pos.y < 2 || pos.x > width - 2 || pos.y > height -2)
      {
        dead = true;
        deathByObst = true;
        deathAtStep = brain.step;
      }
      else if (obstacle && ((pos.x > 0 && pos.x < 600 && pos.y > 300 && pos.y < 310) || (pos.x > 200 && pos.x < 800 && pos.y > 500 && pos.y < 510)) )
      {
        dead = true;
        deathByObst = true;
        deathAtStep = brain.step;
      }
      else if (jalon)
      {
        int idJalon = touchedJalon();
        if (idJalon > -1)
        {
          if (idJalon == 0)
            isJalon1OK = true;
          else if (idJalon == 1)
            isJalon2OK = true;
          brain.rewarding(idJalon);
        }
      }
    }
  }

  int touchedJalon()
  {
    if (pos.x > 100 && pos.x < 200 && pos.y > 503 && pos.y < 507)
    {
      return 0;
    }
    else if (pos.x > 600 && pos.x < 700 && pos.y > 303 && pos.y < 307)
    {
      return 1;
    }
    
    return -1;
  }
  
  void computeFitness()
  {
    fitness = 0;
    
    if (reachedGoal)
    {
      fitness = 1.0/16.0 + 10000.0 / (brain.step * brain.step);
    }
    else
    {
      float distanceToGoal = dist(pos.x, pos.y, goal.x, goal.y);
      fitness = 1.0 / (distanceToGoal * distanceToGoal);
    }
    
    if (isJalon1OK)
    {
      fitness += 1.0 / (brain.rewards[0] * brain.rewards[0]);
    }
    if (isJalon2OK)
    {
      fitness += 100.0 / (brain.rewards[1] * brain.rewards[1]);
    }
    
    fitness *= fitness;
  }

  Dot cloneGoodOne()
  {
    Dot goodOne = new Dot(brain.directions.length, obstacle, jalon);
    goodOne.brain = brain.clone();
    goodOne.deathByObst = deathByObst;
    goodOne.deathAtStep = deathAtStep;
    goodOne.gen = gen;
    return goodOne;
  }
}

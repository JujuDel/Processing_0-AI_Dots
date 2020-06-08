Population test;
PVector goal = new PVector(400, 10);
boolean obstacle = true, jalon = true, incremental = true;
int nbJalon = 2;

int incMovesBy = 100, incEvery = 5;
boolean alone = false;

void setup()
{
  size(800, 600);
  test = new Population(1000, incremental, obstacle, jalon);
  
  if (jalon)
    test.initRewards(nbJalon);
}

void draw()
{
  background(255);
  fill(255, 0, 0);
  ellipse(goal.x, goal.y, 10, 10);
  
  if (obstacle)
  { 
    fill(0, 0, 255);
    rect(200, 500, 600, 10);
    rect(0, 300, 600, 10);
  }
  
  if (jalon)
  {
    fill(0, 255, 0);
    rect(100, 503, 100, 4);
    rect(600, 303, 100, 4);
  }
  
  String textGen = "Gen " + test.gen;
  String textBestStep = "Best Steps: ";
  textSize(32);
  fill(0);
  text(textGen, 10, 60);
  if (test.minStep < 1000)
  {
    textBestStep += test.minStep;
  }
  else
  {
    textBestStep += "not achieved yet";
  }
  text(textBestStep, 10, 100);
  
  if (test.allDotsDead())
  {
    test.computeFitness();
    test.naturalSelection();
    test.mutateGoodOnes();
    
    if (incremental && test.gen % incEvery == 0)
    {
      test.increaseMoves(incMovesBy);
    }
  }
  else
  {
    test.update();
    test.show(alone);
  }
}

void keyPressed()
{
  final int k = keyCode;

  if (k == 'S')
  {
    if (looping)  noLoop();
    else          loop();
  }
  else if (k == ' ')
  {
    alone = !alone;
  }
}

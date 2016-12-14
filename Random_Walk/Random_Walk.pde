void setup() 
{
  size (800, 600);
  smooth();
  fill(walkColor);
  strokeWeight(0);
  frameRate(100000); 
}

// Settings
final int halfWidth = 400;
final int halfLength = 300;

final int radialColor = #6eaddd;
final int numAxes = 4;

int walkColor = #000000;
final boolean randomizeColor = false;

final boolean verbose = true;


int X = halfWidth;
int Y = halfLength;

void draw () 
{  
  
  X = randomWalk(X); 
  Y = randomWalk(Y);
  
  if (verbose && (frameCount % 300 == 0))  // Every 100 frames, and must have VERBOSE tag set to true
  {
    println("FPS: " + frameRate);
    float realDist = avg((abs(halfWidth-X)), (abs(halfLength-Y)));
    println(frameCount + " : " + round(sqrt(frameCount)) + " : " + round(realDist) + 
            " : " + abs(fixDec((abs(realDist - sqrt(frameCount)) / realDist), 2))*100 + "%");  
            
    fill(#ffffff);
    rect(3, 3, 155, 80);
    fill(0);
    text(("Framerate:    " + fixDec(frameRate, 0) + "\n" + 
          "Frame:          " + frameCount + "\n" + 
          "sqrt(t):           " + fixDec(sqrt(frameCount), 2) + "\n" + 
          "Distance:      " + fixDec(realDist, 2) + "\n" +
          "% Error:        " + abs(fixDec((abs(realDist - sqrt(frameCount)) / realDist), 2))*100 + "%"), 8, 20);
  }
  
  if (randomizeColor)
  {
    fill(random(100, 255), random(100, 255), random(100, 255));
    ellipse(X, Y, 1, 1);
    fill(0);
  }
  else
  {
    ellipse(X, Y, 1, 1);
  }
    
  
  stroke(radialColor);
  strokeWeight(3);
  
  pushMatrix();
  
  for (int i = 0; i < numAxes; i++)
  {
    translate(halfWidth, halfLength);
    rotate(i * (PI/(numAxes/2)));
    translate(-halfWidth, -halfLength);
    
    line(halfWidth, halfLength, halfWidth, (halfLength + sqrt(frameCount)));
  }
  
  popMatrix();
  
  strokeWeight(0);
  stroke(#000000);
}

boolean randomBool() { return random(1) > 0.5; }
float avg(float a, float b) { return (a+b)/2; }
float fixDec(float n, int d) { return Float.parseFloat(String.format("%." + d + "f", n)); }

int randomWalk(int value)
{
  float r = random(1);
  if (r > 0.66666666)                          value += 1;
  if ((r > 0.33333333) && (r <= 0.66666666))   value += 0;
  if (r <= 0.33333333)                         value -= 1;
  return value;
}
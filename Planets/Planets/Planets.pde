// Global Settings
final color BACKGROUND = #F2FBFF;
final color DEFAULT_COLOR = #000000;
final int TARGET_FRAMERATE = 60;
final float MASS_RADIUS_RATIO = 0.1;  // RADIUS = Mass * Ratio
final int MIN_RADIUS = 5;

// Constants
final double G = 1;  // TODO: Replace with actual constant;
                     //       see java.math.bigDecimal

void setup()
{
  size(800, 600);
  background(BACKGROUND);
  smooth();
  frameRate(TARGET_FRAMERATE);
  
  planets[0] = (new Planet(100, 50, #EDA507, new PVector(200, 200), new PVector(0, 0), new PVector(0, 0)));
}

Planet[] planets;

void draw()
{
  planets[0].render();
}

class Planet
{
  // Constructor
  Planet(float massIN, int radiusIN, color planetColorIN, PVector positionIN, PVector velocityIN, PVector accelerationIN)
  {
    mass = massIN;
    radius = radiusIN == 0 ? max(round(mass / MASS_RADIUS_RATIO), MIN_RADIUS) : radiusIN;  // Use radiusIN = 0 to specify auto-sizing
    planetColor = planetColorIN == 0 ? DEFAULT_COLOR : planetColorIN;  // Use color = 0 to specify auto-color
    position.set(positionIN.x, positionIN.y);
    velocity.set(velocityIN.y, velocityIN.y);
    acceleration.set(accelerationIN.x, accelerationIN.y);
  }
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  float mass;  
  int radius;
  color planetColor;
  
  // Draw the planet to the screen
  void render()
  {
    // Backup style
    new Style().pushStyle();
    
    fill(planetColor);
    // Darken the stroke color by 40 from the fill color (or bottom out at black)
    stroke(color(max(0, red(planetColor) - 40), max(0, green(planetColor) - 40), max(0, blue(planetColor) - 40)));
    strokeWeight(2);
    
    // Draw the planet
    ellipse(position.x, position.y, radius, radius);
    
    // Restore style
    new Style().popStyle();
}


// Implements utilities for rapid swapping of drawing style
public class Style
{
  public void Style()
  {
    // do nothing;
  }
  
  private static color tempFillColor;
  private static color tempStrokeColor;
  private static float tempStrokeWeight;
  
  public void pushStyle()  // Backup the current style
  {
    tempFillColor = g.fillColor;
    tempStrokeColor = g.strokeColor;
    tempStrokeWeight = g.strokeWeight;
  }
  
  public void popStyle()  // Restore the style from backup
  {
    fill(tempFillColor);
    stroke(tempStrokeColor);
    strokeWeight(tempStrokeWeight);
  }
}
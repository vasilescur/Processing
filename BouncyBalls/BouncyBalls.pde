void setup()
{
  size(500, 500);
  background(BACKGROUND);
  stroke(0);
  rectMode(CORNERS);  // !! Corners !!
  ellipseMode(CENTER);  // !! Center !!
  
  frameRate(144);
}

// Util methods

public void circle(float x, float y, int radius) 
{ 
  ellipse(x, y, radius, radius);
}
public float Distance(PVector a, PVector b) 
{ 
  return sqrt(pow((a.x - b.x), 2) + pow((a.y - b.y), 2));
}

color BACKGROUND = #eeeeee;

final float G = 9.81 / 70;      // Gravitational attraction / factor
final float FRICTION = 1.05;    // Coefficient of friction against the ground
final float BOUNCE_P = 1;       // How hard they bounce off each other
final float BOUNCE_F = 1.09;    // How hard they bounce off the floor - Smaller = bouncier
final float BOUNCE_W = 0.7;    // How hard they bounce off the walls

/*
 *  Make your settings here: arguments-- (number, centerX, centerY)
 */
ParticleSystem ps = new ParticleSystem(100, 100, 150);

void draw()
{  
  ps.erase();
  ps.tick();
  ps.render();
}

class ParticleSystem
{
  ParticleSystem(int num, float scx, float scy)
  {
    this.num = num;
    spawnCenter = new PVector(scx, scy);

    particles = new Particle[num];

    // Random particles
    for (int i = 0; i < num; i++)
    {
      float posx = random(scx-40, scx+40);
      float posy = random(scy-80, scy+80);

      float velx = random(-6, 6);
      float vely = random(-5, 3);

      int radius = round(random(13, 35) / 2);

      color fill = color(random(20, 180), random(20, 180), random(20, 180));

      particles[i] = new Particle(posx, posy, velx, vely, radius, fill);
    }
  }

  int num;
  PVector spawnCenter;

  Particle[] particles;

  public Particle[] enumerate()
  {
    return particles;
  }

  public void tick()
  {
    for (Particle p : particles)
    {
      p.tick();
    }
  }

  public void render()
  {
    for (Particle p : particles)
    {
      p.render();
    }
  }

  public void erase()
  {
    for (Particle p : particles)
    {
      p.erase();
    }
  }
}

class Particle
{
  Particle(float posx, float posy, float velx, float vely, int radius, color fill)
  {
    pos = new PVector(posx, posy);
    vel = new PVector(velx, vely);
    this.radius = radius;
    this.fill = fill;
  }

  public boolean Equals(Particle other)
  {
    return (this.radius == other.radius && 
      this.pos.x == other.pos.x && this.pos.y == other.pos.y && 
      this.vel.x == other.vel.x && this.vel.y == other.vel.y);
  }

  PVector pos;
  PVector vel;
  color fill;
  int radius;

  public void tick()
  {    
    // Gravity
    vel.y += G;

    // Floor
    if (pos.y >= height-radius)
    {
      vel.y = -(vel.y / BOUNCE_F);
      vel.x = vel.x / FRICTION;
      pos.y -= 2;
    }

    // Ceiling
    if (pos.y <= this.radius)
    {
      vel.y = -vel.y;
      vel.x = vel.x / FRICTION;
      pos.y++;
    }

    // Walls
    if (pos.x >= width-radius)
    {
      vel.x = -vel.x;
    }
    if (pos.x <= radius)
    {
      vel.x = -vel.x;
    }

    // Other particles
    
    /*  -- This is broken --
    // TODO: Actual physics would be nice, eh?
    for (Particle t : ps.enumerate())
    {
      if ((!this.Equals(t)) && (Distance(this.pos, t.pos) <= (this.radius + t.radius)))
      {       
        //if (abs(this.pos.y - t.pos.y))
        this.vel.x = - this.vel.x;
        t.vel.x = - t.vel.x;

        //this.vel.y = - this.vel.y;
        //t.vel.y = - t.vel.y;
        
        if (this.pos.x < t.pos.x)
        {
          this.pos.x -= (-Distance(this.pos, t.pos) + this.radius + t.radius);
        }
        else
        {
          this.pos.x += (-Distance(this.pos, t.pos) + this.radius + t.radius);
        }
      }
    }*/

    pos.add(new PVector(vel.x/(frameRate/40), vel.y/(frameRate/40)));
  }

  public void render()
  {
    fill(fill);
    stroke(0);
    circle(pos.x, pos.y, 2*radius);
    //rect(pos.x, pos.y, pos.x+radius, pos.y+radius);
  }

  public void erase()
  {
    fill(BACKGROUND);
    stroke(BACKGROUND);
    circle(pos.x, pos.y, 2*(radius+2));
    //rect(pos.x, pos.y, pos.x+radius, pos.y+radius);
  }
}
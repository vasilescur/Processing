void setup()
{
  size(1000, 800);
  frameRate(10000000);
  
  // Setup the image array
  image = new Pixel[SL][];
  for (int i = 0; i < SL; i++)
  {
    image[i] = new Pixel[SL];
  }
  
  // Set the color values all to black
  for (int y = 0; y < SL; y++)
  {
    for (int x = 0; x < SL; x++)
    {
      image[x][y] = new Pixel(#000000);
    }
  }  
  
  // Setup the targetImg array
  targetImg = new Pixel[SL][];
  for (int i = 0; i < SL; i++)
  {
    targetImg[i] = new Pixel[SL];
  }
  
  // Set the color values to the right target
  for (int y = 0; y < SL; y++)
  {
    for (int x = 0; x < SL; x++)
    {
      targetImg[x][y] = new Pixel((target[x][y] == 0 ? #ffffff : #000000));
    }
  }  
}

Pixel[][] image;
int [][] target = {  {  0, 0, 0, 0  },
                     {  0, 1, 1, 0  },
                     {  0, 1, 1, 0  },
                     {  0, 0, 0, 0  }   };
Pixel[][] targetImg;


final int SL = 4;    // Side length
final int BASE = 2;  // Number of possible colors
final int PS = 100;  // Pixel size

boolean running = true;

void draw()
{
  if (running == true)
  {
    // Cycle the pixels   
    for (int y = 0; y < SL; y++)
    {
      for (int x = 0; x < SL; x++)
      {
        if (((round(frameCount)) % max((pow(BASE, ((SL*y)+x))), 1)) == 0)
        {
          //image[x][y].col = image[x][y].col == #000000 ? #868686 : (image[x][y].col == #868686 ? #ffffff : #000000);
          image[x][y].col = image[x][y].col == #000000 ? #ffffff : #000000;
        }
      }
    }
    
    // Draw the pixels    
    for (int y = 0; y < SL; y++)
    {
      for (int x = 0; x < SL; x++)
      {
        fill(image[x][y].col);
        rect(x*PS, y*PS, PS-1, PS-1);
        
      }
    }
    
    // See if target image reached
    boolean match = true;
    for (int y = 0; y < SL; y++)
    {
      for (int x = 0; x < SL; x++)
      {
        if (targetImg[x][y].col == image[x][y].col)
        {
          match = false;
          break;
        }
      }
    }
    if (match == true)
    {
      running = false;
    }
  }
}

class Pixel
{  
  Pixel(color c)
  {
    col = c;
  }
  
  color col;
}
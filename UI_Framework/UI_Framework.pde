import java.lang.reflect.*;

void setup()
{
  size(400, 300);
  
  elements.put("button1", new Button("Text", new Runnable () {public void invoke() {println("a");} }, 20, 20, 60, 20));
  elements.put("button2", new Button("Other", new Runnable() {public void invoke() {TextBox.class.cast(elements.get("textBox1")).show();}}, 60, 60, 60, 20));
  elements.put("textBox1", new TextBox("Hello, world.", 200, 100));
  
  TextBox.class.cast(elements.get("textBox1")).hide();
  
  for (String name : elements.keySet())
  {
    elements.get(name).display();
  }
  
}

void draw()
{

}

HashMap<String, UIElement> elements = new HashMap<String, UIElement>();

public interface Runnable
{
  void invoke();
}

// Mouse click handling
void mousePressed()
{
  m_handler.handle(new MouseEvent(mouseX, mouseY));
}

void mouseReleased()
{
  m_handler.handle(new MouseEvent(mouseX, mouseY));
}

class MouseEventHandler
{
  boolean waitingForRelease = false;
  
  void handle(MouseEvent e)
  {
    for (String name : elements.keySet())
    {
      UIElement item = elements.get(name);
      if (((e.posx > item.posx) && (e.posx < item.w+item.posx)) && ((e.posy > item.posy) && (e.posy < item.posy+item.h)))
      {
        if (waitingForRelease)
        {
          item.onMouseUp();
          waitingForRelease = false;
        }
        else
        {
          item.onClick();
          waitingForRelease = true;
        }
      }
    }
  }
}

MouseEventHandler m_handler = new MouseEventHandler();

class MouseEvent
{
  MouseEvent(int xIN, int yIN)
  {
    posx = xIN;
    posy = yIN;
  }
  
  int posx;
  int posy;
}

// Generic UI Class
class UIElement
{
  UIElement(int xIN, int yIN, int wIN, int hIN)
  {
    posx = xIN;
    posy = yIN;
    w = wIN;
    h = hIN;
  }
  
  UIElement() {}
  
  void display() {}
  void onClick() {}
  void onMouseUp() { this.display(); }

  int posx;
  int posy;
  int h;
  int w;
}

// Button class
class Button extends UIElement
{
  Button(String textIN, Runnable clickIN, int xIN, int yIN, int wIN, int hIN)
  {
    posx = xIN;
    posy = yIN;
    w = wIN;
    h = hIN;
    text = textIN;
    click = clickIN;
  }
  
  String text;
  Runnable click;
  
  void onClick()
  {
    this.display();
    click.invoke();
  }
  
  void display()
  {
    if (mousePressed)
      fill(#B7B7B7);
    else
      fill(#DEDEDE);
      
    rect(posx, posy, w, h);
    
    fill(0);
    text(text, posx+3, (posy+h)-4);
  }
}

class TextBox extends UIElement
{
  TextBox(String textIN, int posxIN, int posyIN)
  {
    text = textIN;
    posx = posxIN;
    posy = posyIN;
  }
  
  String text;
  boolean hidden = false;
  
  void hide()
  {
    hidden = true;
  }
  
  void show()
  {
    hidden = false;
    display();
  }
  
  void display()
  {
    if (!hidden)
    {
      fill(0);
      text(text, posx, posy);
      
    }
  }
}
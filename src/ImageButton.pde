/****************************************************************************
*  WhackALois.pde
*  
*  By: Chris Jimenez
*
*  Button class 
****************************************************************************/
class ImageButton {
  int yPos;
  int xPos;
  int buttonWidth;
  int buttonHeight;

  PImage button;
  PImage buttonPressed;
  PImage currentButton;
  boolean pressed;

  /**
  *  CONSTRUCTOR
  *  buttonImage = 
  *  buttonImage = 
  */
  ImageButton(PImage buttonImage, PImage buttonPressedImage) {
    button = buttonImage;
    buttonPressed = buttonPressedImage;
    currentButton = button;
  }

  
  /**
  *  displays button at position x,y
  *  x = x-position of button
  *  y = y-position of button  
  */
  void display(int x, int y) {
    xPos = x;
    yPos = y;
    image(currentButton, x, y);
  }

  /**
  *  resize the button using given width(w) & height(h)
  *  w = width of button
  *  h = height of button
  */
  void resizeButton(int w, int h) { 
    buttonWidth = w;
    buttonHeight = h;
    button.resize(buttonWidth, buttonHeight);
    buttonPressed.resize(buttonWidth, buttonHeight);
  }

  /**
  *  determiness if button is pressed
  */
  boolean isPressed() {
    if (((mouseX >= xPos) && (mouseX <= xPos+buttonWidth)) &&
      ((mouseY >= yPos) && (mouseY <=yPos+buttonHeight))) {
      currentButton = buttonPressed;
      return true;
    } else {
      currentButton = button;
      return false;
    }
  }
  
}


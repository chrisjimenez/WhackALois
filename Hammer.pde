class Hammer {

  //position of the hammer
  float hammerX;
  float hammerY;

  int hammerState = 0;//by defult the hammer is up, 1 if the hammer is down

  PImage up;
  PImage down;


  Hammer(PImage u, PImage d) {
    up = u;
    up.resize(100, 75);
    down = d;
    down.resize(100, 75);
  }

  //=====================================================
  //Displays the hammer
  void display() {
    hammerState = 0;
    hammerX = mouseX;
    hammerY = mouseY;

    if (mousePressed) {
      image(down, hammerX - 45, hammerY- 45);
    }
    else {
      image(up, hammerX - 45, hammerY- 45);
    }
  }

  void mousePressed() {
    hammerState = 1;
  }
}


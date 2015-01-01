int LOIS_LIMIT = 5;// the number of lois's allowed at one time

class Mole {

  //position of the mole
  float yPos;
  float xPos;
  float moleWidth = 61;
  float moleHeight = 80;

  //by default the state is 0, which is down
  //when state = 1, mole is up
  //when state = 2, mole is evil
  //when state = 3, mole is gold

  AudioPlayer moleSound;
  AudioPlayer goldMoleSound;
  AudioPlayer evilMoleSound;

  PImage moleImage;
  PImage goldMoleImage;
  PImage evilMoleImage;

  float timer = 0;

  int state;


  //===============================================================
  Mole(float x, float y) {
    state = 0;
    xPos = x;
    yPos = y;
  }

  //==============================================================
  //this method displays the "mole" on to the screen at their pos.
  void display() {
    if (state == 1) {
      image(loisMole, xPos, yPos);
    }
    else if (state == 2) {
      image(bertramMole, xPos, yPos);
    }
    else if (state == 3) {
      image(brianMole, xPos, yPos);
    }
  }

  //=====================================================
  //determines if there has been a hit
  boolean detectHit() {
    if (((mouseX >= xPos) && (mouseX <= xPos+moleWidth)) &&
      ((mouseY >= yPos) && (mouseY <=yPos+moleHeight)) && mousePressed) {
      return true;
    }
    else {
      return false;
    }
  }
  //=====================================================
  //upload the images
  void uploadImage(PImage regular, PImage gold, PImage evil) {
    moleImage = regular;
    goldMoleImage = gold;
    evilMoleImage = evil;
  }
  //=====================================================
  //uploads the sounds
  void uploadSound(AudioPlayer regular, AudioPlayer gold, AudioPlayer evil) {
    moleSound = regular;
    goldMoleSound = gold;
    evilMoleSound = evil;
  }

  //=====================================================
  //updates the timer
  void updateTimer() {
    timer += 0.05;
  }

  //=====================================================
  //determines if timer is up
  boolean timerIsUp() {
    if (timer >= 4.0) {
      return true;
    }
    else {
      return false;
    }
  }

  //=====================================================
  //updates state of mole
  void updateState() {
    float chance = random(0, 1);

    if (timerIsUp()) {
      timer = 0;
      if (chance <= 0.1) {
        state = 3;
      }
      else if (chance > 0.1 && chance <= 0.2) {
        state = 2;
      }
      else if (chance > 0.2 && chance <= 0.4) {
        state = 1;
      }
      else {
        state = 0;
      }
    }
    else {
      updateTimer();
    }
  }

  //=====================================================
  //plays sound of mole
  void playSound() {
    if (state == 1) {
      moleSound.rewind();
      moleSound.play();
    }
    else if (state == 2) {
      evilMoleSound.rewind();
      evilMoleSound.play();
    }
    else if (state == 3) {
      goldMoleSound.rewind();
      goldMoleSound.play();
    }
    else if (state == 4) {
    }
  }
}


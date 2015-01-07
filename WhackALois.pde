/****************************************************************************
*  WhackALois.pde
*  
*  By: Chris Jimenez
*
*  Family Guy version of Whack-A-Mole where Lois is the mole.
****************************************************************************/

import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//  Define sound objects
Minim minim;
AudioPlayer themeSong;
AudioPlayer hitSound;
AudioPlayer peterSound;
AudioPlayer loisSound;
AudioPlayer brian;
AudioPlayer bertram;

//  variables to display time on to sketch
float startTime;
float currentTime;
float displayTime;
float timer = 30.0;

//  arrays for mole
Mole[] molesRow1;
Mole[] molesRow2;
Mole[] molesRow3;

//  menu bg and gameplay bg
PImage background;
PImage background2;

//  set up start button
PImage startButtonImage;
PImage startButtonPressedImage;
PImage playAgainButtonImage;
PImage playAgainButtonPressedImage;
ImageButton startButton;
ImageButton playAgainButton;

//  set up moles/characters
PImage loisMole;
PImage brianMole;
PImage bertramMole;

//  for the fading text
int count = 140;

//  set up hammer
Hammer hammer;
PImage hammerUp;
PImage hammerDown;

//x,y position of the top the left hole, which will be used to position moles
float topLeftHolX = 135;
float topLeftHolY = 135;

//  Keep track of score
int score = 0;

//  if gameState = 1, then the game is being played
int gameState = 0;

/**
*   setup() function 
*/
void setup() {
  size(600, 480);

  //set up background & title
  background = loadImage("startBackground.png");
  background2 = loadImage("gameBackground.png");


  //load hammer
  hammerDown = loadImage("hammerdown.png");
  hammerUp = loadImage("hammerup.png");
  hammer = new Hammer(hammerUp, hammerDown);

  //load moles/characters
  loisMole = loadImage("lois.png");
  brianMole = loadImage("brian.png");
  bertramMole = loadImage("bertram.png");

  // set up Minim & sound
  minim = new Minim(this);
  loisSound = minim.loadFile("lois.mp3");
  brian = minim.loadFile("brian.mp3");
  bertram = minim.loadFile("Bertram.mp3");
  themeSong = minim.loadFile("themesong.mp3");
  hitSound = minim.loadFile("hit.mp3");
  peterSound = minim.loadFile("peter2.mp3");

  molesRow1 = new Mole[3];//first row of  moles
  molesRow2 = new Mole[3];//first row of  moles
  molesRow3 = new Mole[3];//first row of  moles

  int yDist = 80;
  int xDist = 0;
  for (int i = 0; i < molesRow1.length; i++) {
    molesRow1[i] = new Mole(topLeftHolX + xDist, topLeftHolY);
    molesRow1[i].uploadImage(loisMole, brianMole, bertramMole);
    molesRow1[i].uploadSound(loisSound, brian, bertram);

    molesRow2[i] = new Mole(topLeftHolX + xDist, topLeftHolY + yDist);
    molesRow2[i].uploadImage(loisMole, brianMole, bertramMole);
    molesRow2[i].uploadSound(loisSound, brian, bertram);

    molesRow3[i] = new Mole(topLeftHolX + xDist, topLeftHolY + 2*yDist);
    molesRow3[i].uploadImage(loisMole, brianMole, bertramMole);
    molesRow3[i].uploadSound(loisSound, brian, bertram);

    xDist = xDist +126;
  }


  //button images
  startButtonImage = loadImage("startbutton.png");
  startButtonPressedImage = loadImage("startbutton-pressed.png");
  startButton = new ImageButton(startButtonImage, startButtonPressedImage);

  playAgainButtonImage = loadImage("playagainbutton.png");
  playAgainButtonPressedImage = loadImage("playagainbuttonpressed.png");
  playAgainButton = new ImageButton(playAgainButtonImage, playAgainButtonPressedImage);


  themeSong.rewind();
  themeSong.play();
}

void draw() {
  smooth();
  frameRate(30);

  if ( gameState == 0) {
    startGame();
  }
  else if (gameState == 1) {
    playGame();
  }
  else if ( gameState == 2) {
    endGame();
  }
}

/**
*  STARTS THE GAME WHEN CALLED.
*/
void startGame() {
  cursor();
  image(background, 0, 0);
  background.resize(600, 480);
  //display start button
  startButton.resizeButton(100, 50);
  startButton.display(440, 290); 

  if (startButton.isPressed() && mousePressed) {
    reset();
  }
}


/**
*  PLAYS THE GAME WHEN CALLED.
*/
void playGame() {
  noCursor();
  themeSong.rewind();
  //set up background & title
  image(background2, 0, 0);
  background2.resize(600, 480);

  checkTimer();


  //display the moles
  for (int i = 0; i < molesRow1.length; i++) {
    molesRow1[i].updateState();
    molesRow2[i].updateState();
    molesRow3[i].updateState();

    molesRow1[i].display();
    molesRow2[i].display();
    molesRow3[i].display();

    checkHit(molesRow1[i]);
    checkHit(molesRow2[i]);
    checkHit(molesRow3[i]);
  }

  hammer.display();

  displayFadingText("You got "+ timer+" seconds!", 150, 160);

  displayCommands(380, 450);

  displayTimeAndScore(10, 470);

  //  resets the game
  if (keyPressed && key =='r') {
    score= 0;
    reset();
    currentTime = 0;
  }

  //  quits the game
  if (keyPressed && key =='q') {
    gameState = 0;
  }

  //  resets the game
  if (keyPressed && key =='m') {
    themeSong.pause();
  }
}

/**
*  ENDS THE GAME WHEN CALLED
*/
void endGame() {
  cursor();
  image(background, 0, 0);
  background.resize(600, 480);

  textSize(20);//enlarge text
  if (score <= 5) {
    text("Your score: "+score, 400, 200);
    text("How?", 400, 220);
  }
  else if (score > 5 && score <=13) {
    text("Your score: "+score, 400, 200);
    text("Meh.", 400, 220);
  }
  else if (score > 13) {
    text("Your score: "+score, 400, 200);
    text("Not Bad!", 400, 220);
  }

  textSize(15);//return text size to normal

  peterSound.rewind();
  peterSound.play();

  //display start button
  playAgainButton.resizeButton(100, 50);
  playAgainButton.display(440, 290); 

  if (playAgainButton.isPressed() && mousePressed) {
    reset();
  }
}

//=================================================================
//resets the game
void reset() {
  gameState = 1;
  score =0;

  //reset start time
  startTime = (millis()/1000);
}

//=====================================================
//Displays the commands to reset or quit
void displayTimeAndScore(float x, float y) {
  fill(0);
  textSize(13);
  currentTime = (millis()/1000);
  displayTime = currentTime - startTime;
  text("TIME: " + displayTime, x, y);
  text("SCORE: " +score, x, y-20);
}



/**
*  Displays the commands on to the sketch at the given xy position.
*/
void displayCommands(float x, float y) {
  fill(0);
  textSize(13);
  text("TO GO BACK TO MENU, PRESS 'Q'", x, y);
  text("TO RESET GAME, PRESS 'R'", x, y+15);
}

//==============================================================
//display the fading text on the screen
void displayFadingText(String s, float x, float y) {
  fill(0, 0, 0, count--);
  textSize(25);//slightlty larger text size
  text(s, x, y);
}

//==============================================================
//check if there is a collision between the two characters
void checkHit(Mole m) {
  //when predator and prey collide
  if (m.detectHit() && m.state == 1) {
    hitSound.rewind();
    hitSound.play();
    m.playSound();
    m.state = 0;
    score++;
  }
  else if (m.detectHit() && m.state == 2) {
    hitSound.rewind();
    hitSound.play();
    m.playSound();
    m.state = 0;
    score--;
  }
  else if (m.detectHit() && m.state == 3) {
    hitSound.rewind();
    hitSound.play();
    m.playSound();
    m.state = 0;
    score = score +2;
  }
}

void checkTimer() {
  if (displayTime >= timer) {
    gameState = 2;
  }
}


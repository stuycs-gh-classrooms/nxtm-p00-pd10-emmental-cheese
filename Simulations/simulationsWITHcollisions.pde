//TO-DO
/**
 - Add mouse sensing
 - centripetal force?
 - cosmetic things?
 */

//GLOBAL VARIABLES
int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int DRAG_FORCE = 3;

int ORBIT = 0;
int SPRING = 1;
int DRAGSIM = 2;
int COLLISION = 3;
int COMBINATION = 4;

//SIMULATION TOGGLING
boolean[] toggles = new boolean[4];
String[] modes = {"Moving [SPACE]", "Bounce [B]", "Gravity [G]", "Drag [D]"};
boolean[] simulations = new boolean[5];
String[] types = {"Orbit [1]", "Spring [2]", "Drag [3]", "Collision [4]", "Combination [5]"};

//SIMULATION ORBS
PVector[] stars;
Orb[] slinky;
OrbList linkedChain;
FixedOrb earth;
FixedOrb[] sun;

//OTHER
color c;
boolean simi;

void setup() {
  c = (255);
  size(600, 600);

  //CREATE FIXED ORBS
  earth = new FixedOrb(width/2, height * 100, 1, 8000);

  sun = new FixedOrb[3];
  for (int i = 0; i < sun.length; i++) {
    //create fields of intensity 'around' sun
    sun[i] = new FixedOrb(width/2, height/2, MAX_SIZE + 60*i, MAX_MASS - 60*i);
    sun[i].c = color(82*(3-i), 80*(3-i), 23*(3-i));
    //251 - 3 = 248 / 3 = 82
    //255 - 13 = 242 / 3 = 80
    //134 - 64 = 70 / 3 = 23
  }
  stars = new PVector[132];

  simi = false;

  //CREATE MOVING ORBS
  linkedChain = new OrbList();
  linkedChain.populate(NUM_ORBS, true);
  createNewSlinky();
}//setup

void draw() {
  background(c);

  //REGULAR ORB MANIPULATION
  if (!simi) {
    for (int i = 0; i < slinky.length; i++) {
      slinky[i].display();
      if (toggles[MOVING]) {
        if (toggles[GRAVITY]) {
          slinky[i].applyForce(slinky[i].getGravity(earth, G_CONSTANT));
        }
        if (toggles[DRAGSIM]) {
          slinky[i].applyForce(slinky[i].getDragForce(D_COEF));
        }
        slinky[i].move(toggles[BOUNCE]);
      }
    }
  }

  //ORBIT SIMULATION
  if (simulations[ORBIT]) {
    c = color(3, 13, 64);
    for (int i = 0; i < stars.length - 1; i++) { //to-do for further cuteness -> generate for loop that regenerates random() every second
      fill(#FFFFFF);
      noStroke();
      circle(stars[i].x, stars[i].y, random(0.5, 1.5));
    }
    for (int i=sun.length - 1; i > -1; i--) {
      sun[i].display();
    }
    for (int i = 0; i < slinky.length; i++) {
      slinky[i].display();
      if (toggles[MOVING]) {
        for (int o = 0; o < sun.length; o++) {
          slinky[i].applyForce(slinky[i].getGravity(sun[o], G_CONSTANT));
        }
        slinky[i].move(toggles[BOUNCE]);
      }
    }
  }


  //> Springs
  if (simulations[SPRING]) {
    linkedChain.display();

    if (toggles[MOVING]) {
      linkedChain.applySprings(SPRING_LENGTH, SPRING_K);
      //print("gravity");
      linkedChain.applyGravity(earth, G_CONSTANT);

      linkedChain.run(toggles[BOUNCE]);
    }
  }



  //> Drag
  if (simulations[DRAGSIM]) {
    float COEF_1 = 1;
    float COEF_2 = 0.1;
    float COEF_3 = -0.05;
    fill(#405040);
    rect (0, 0, width, 1 * (height / 4)); //upper
    fill(#505050);
    rect (0, 3 * (height / 4), width, 3 * (height / 4)); //center
    fill(#F0F0F0);
    rect (0, height / 2, width, height / 4); //lower
    fill(0);
    text (COEF_1, 10, height / 6);
    text (COEF_2, 10, height / 2);
    text (COEF_3, 10, 3 * (height / 4) + 10);
    for (int i = 0; i < slinky.length; i++) {
      if (slinky[i].center.y < 1 * (height / 4)) { // upper. slows down orbs made bouncy by lower.
        slinky[i].applyForce(slinky[i].getDragForce(COEF_1));
      }
      if (slinky[i].center.y > 3 * (height / 4) && slinky[i].center.y < height / 2 ) { //center. does its job.
        slinky[i].applyForce(slinky[i].getDragForce(COEF_2));
      }
      if (slinky[i].center.y > height / 2) { //bottom. has negative drag for fun, and also keeps the simulation moving by not allowing them to collect at the bottom.
        slinky[i].applyForce(slinky[i].getDragForce(COEF_3));
      }

      slinky[i].display();
      if (toggles[MOVING]) {
        slinky[i].applyForce(slinky[i].getGravity(earth, G_CONSTANT));
        slinky[i].move(toggles[BOUNCE]);
      }
    }
  }

  //> Collision
  if (simulations[COLLISION]) {

    for (int t = 0; t < slinky.length; t++) {
      slinky[t].display();
      if (toggles[MOVING]) {

        for (int o = 0; o < slinky.length; o++) {
          if (t != o && slinky[t].collisionCheck(slinky[o])) {
            slinky[t].applyBounceForce(slinky[o]);
          }
        }
        
        slinky[t].applyForce(slinky[t].getDragForce(0.1));
        slinky[t].move(toggles[BOUNCE]);
      }
     }
  }


  //> Combination


  displayMode();
  fill(#F00FF0);
  rect (width - 190, 0, 200, 25);
  fill(0);
  text ("Toggle mode [ENTER]", width - 185, 5);
}//draw

void createNewSlinky() {
  slinky = new Orb [NUM_ORBS];
  for (int i = 0; i < slinky.length; i++) {
    int randomX = int (random(MAX_SIZE/2, width - MAX_SIZE/2));
    int randomY = int (random(MAX_SIZE/2, height - MAX_SIZE/2));
    int randomSize = int (random(MIN_SIZE, MAX_SIZE));
    int randomMass = int (random(MIN_MASS, MAX_MASS));
    slinky[i] = new Orb(randomX, randomY, randomSize, randomMass);
  }
}

void keyPressed() {
  if (keyCode == ENTER) {
    simSwitcher(simulations);
    simSwitcher(toggles);
    simi = !simi;
  }
  if (key == 'r' && !simi) {
    createNewSlinky();
  }
  if (key == ' ') {
    toggles[MOVING] = !toggles[MOVING];
  }
  if (key == 'b') {
    toggles[BOUNCE] = !toggles[BOUNCE];
  }

  if (!simi) {
    if (key == 'g') {
      toggles[GRAVITY] = !toggles[GRAVITY];
    }
    if (key == 'd') {
      toggles[DRAG_FORCE] = !toggles[DRAG_FORCE];
    }
  }
  if (simi) {
    if (key == '1') {
      createNewSlinky();
      simSwitcher(simulations);
      simulations[ORBIT] = !simulations[ORBIT];


      //stars
      for (int i = 0; i < 132; i++) {
        stars[i] = new PVector (random(width), random(height));
      }

      for (int i = 0; i < slinky.length; i++) {
        slinky[i].velocity.x = 10;
        slinky[i].velocity.y = 10;
      }
      //print("ORBIT");
    }
    if (key == '2') {
      //////////////////////////////////////////////////////////////////ADD A 'CREATE NEW LINKED LIST' PART HERE
      simSwitcher(simulations);
      simulations[SPRING] = !simulations[SPRING];
      //print("SPRING");
    }
    if (key == '3') {
      createNewSlinky();
      simSwitcher(simulations);
      simulations[DRAGSIM] = !simulations[DRAGSIM];
      //print("DRAG");
    }
    if (key == '4') {
      createNewSlinky();
      
      simSwitcher(simulations);
      simulations[COLLISION] = !simulations[COLLISION];
      
      for (int i = 0; i < slinky.length; i++) {
        slinky[i].velocity.x = random(-5,5);
        slinky[i].velocity.y = random(-5,5);
      }
    }
    if (key == '5') {
      createNewSlinky();
      simSwitcher(simulations);
      simulations[COMBINATION] = !simulations[COMBINATION];
    }
  }
}//keyPressed

void simSwitcher(boolean[] list) {
  for (int i = 0; i < list.length; i++) {
    list[i] = false;
    c = (255);
  }
}

void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  stroke (0);
  strokeWeight (2);
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (!simi || (simi && m < 2)) {
      if (toggles[m]) {
        fill(0, 255, 0);
      } else {
        fill(200, 0, 0);
      }
    }

    if (simi) {
      if (toggles[m] && m > 2) {
        //print(m);
        fill(0, 255, 0);
      }
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+10, 25);
    fill(0);
    text(modes[m], x+5, 5);
    x+= w+10;
  }

  x = 0;

  for (int n=0; n<simulations.length; n++) {
    //set box color
    if (simi) {
      if (simulations[n]) {
        fill(0, 255, 0);
      } else {
        fill(200, 0, 0);
      }
    } else {
      fill(#050505);
    }

    float w = textWidth(types[n]);
    rect(x, 25, w+10, 25);
    fill(0);
    text(types[n], x+5, 30);
    x+= w+10;
  }
}//display

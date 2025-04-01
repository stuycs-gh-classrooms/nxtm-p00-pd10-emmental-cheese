//planets orbit fixed orb, use array of orbs
//spring force with fixed orb, use linked lists
//drag force involves 2+ orbs moving thru 2+ areas w diff drag
//no limits on custom force


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
boolean[] toggles = new boolean[4];
String[] modes = {"Moving", "Bounce", "Gravity", "Drag"};

boolean[] simulations = new boolean[5];
String[] types = {"Orbit", "Spring", "Drag", "Collision", "Combination"};

//FixedOrb earth;

Orb[] slinky;
FixedOrb earth;

boolean simi;

void setup() {
  size(600, 600);
  earth = null; //new FixedOrb(width/2, height * 200, 1, 20000)
  simi = false;
  
  slinky = new Orb [5];
  for (int i = 0; i < slinky.length; i++){
    int randomX = int (random(width));
    int randomY = int (random(height));
    int randomSize = int (random(20,30));
    int randomMass = int (random(20,30));
    slinky[i] = new Orb(randomX, randomY, randomSize, randomMass);
  }
}//setup

void draw() {
  background(255);
  displayMode();
  if (toggles[MOVING]) {
    if (toggles[BOUNCE]) {
    }
  }
  if (!simi) {
    //normal gravity
  }

  //////////////////////////////////////////////SIMULATIONS
  //> Gravity


  //> Springs


  //> Drag
  if (simulations[DRAGSIM]) {
    fill(#505050);
    rect (0, 3 * (height / 4), width, 3 * (height / 4));
    //apply drag force 1
    fill(#F0F0F0);
    rect (0, height / 2, width, height / 4);
    //apply drag force 2
      for (int i = 0; i < slinky.length; i++){
    slinky[i].display();
  }
  }

  //> Collision


  //> Combination
}//draw

void keyPressed() {
  if (keyCode == ENTER) {
    simSwitcher(simulations);
    simSwitcher(toggles);
    simi = !simi;
  }
  if (key == ' ') {
      toggles[MOVING] = !toggles[MOVING];
      print("MOVINGGGG"); //print(toggles[MOVING]);
    }
    if (key == 'b') {
      toggles[BOUNCE] = !toggles[BOUNCE];
      print("BOUNCEEEEEE"); //print(toggles[BOUNCE]);
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
      simSwitcher(simulations);
      simulations[ORBIT] = !simulations[ORBIT];
      //print("ORBIT");
    }
    if (key == '2') {
      simSwitcher(simulations);
      simulations[SPRING] = !simulations[SPRING];
      //print("SPRING");
    }
    if (key == '3') {
      simSwitcher(simulations);
      simulations[DRAGSIM] = !simulations[DRAGSIM];
      //print("DRAG");
    }
    if (key == '4') {
      //print("COLLISIONS");
      simSwitcher(simulations);
      simulations[COLLISION] = !simulations[COLLISION];
    }
    if (key == '5') {
      simSwitcher(simulations);
      simulations[COMBINATION] = !simulations[COMBINATION];
      //print("COMBO");
    }
  }
}//keyPressed

void simSwitcher(boolean[] list) {
  for (int i = 0; i < list.length; i++) {
      list[i] = false;
  }
}

void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
 if (!simi || (simi && m < 2)) {
      if (toggles[m]) {
        print(m);
        fill(0, 255, 0);
      } 
      else {
        fill(200, 0, 0);
      }
    } 
    
    if (simi) {
      if (toggles[m] && m > 2) {
        print(m);
        fill(0, 255, 0);
      } 
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 0);
    x+= w+5;
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
    } 
    else {
      fill(#050505);
    }

    float w = textWidth(types[n]);
    rect(x, 20, w+5, 20);
    fill(0);
    text(types[n], x+2, 22);
    x+= w+5;
  }
}//display

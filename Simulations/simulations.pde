//planets orbit fixed orb, use array of orbs
//spring force with fixed orb, use linked lists
//drag force involves 2+ orbs moving thru 2+ areas w diff drag
//no limits on custom force


//TO-DO
/**
- Add mouse sensing
- centripetal force?
- cosmetic things?
*/

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
OrbList linkedChain;

FixedOrb earth;
FixedOrb sun;

boolean simi;

void setup() {
  size(600, 600);

  earth = new FixedOrb(width/2, height * 100, 1, 8000);
  sun = new FixedOrb(width/2, height/2, MAX_SIZE, MAX_MASS);

  simi = false;

  linkedChain = new OrbList();
  linkedChain.populate(NUM_ORBS, true);
  createNewSlinky();
}//setup

void draw() {
  background(255);

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

  //////////////////////////////////////////////SIMULATIONS
  //> Orbit
  if (simulations[ORBIT]) {
    sun.display();
    for (int i = 0; i < slinky.length; i++) {
      slinky[i].display();
      if (toggles[MOVING]) {
        slinky[i].applyForce(slinky[i].getGravity(sun, G_CONSTANT));
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
    text (COEF_3, 10,  3 * (height / 4) + 10);
    for (int i = 0; i < slinky.length; i++) {
            if (slinky[i].center.y < 1 * (height / 4)){ // upper. slows down orbs made bouncy by lower.
        slinky[i].applyForce(slinky[i].getDragForce(COEF_1));
      }
      if (slinky[i].center.y > 3 * (height / 4) && slinky[i].center.y < height / 2 ){ //center. does its job.
        slinky[i].applyForce(slinky[i].getDragForce(COEF_2));
      }
       if (slinky[i].center.y > height / 2){ //bottom. has negative drag for fun, and also keeps the simulation moving by not allowing them to collect at the bottom.
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
  //see getBounceForce for mess...
                 // if (i < 5 && (orblet[i].collisionCheck(orblet[i - 1]))){
    //  orblet[i].collisionDrive(orblet[i - 1]);
     // }
//ADD EDGE CASES / FLOOR CASES (stackin!!!)
    for (int i = 1; i < slinky.length; i++) {
      if (slinky[i - 1].collisionCheck(slinky[i])){
       println("boing");
       //slinky[i - 1].applyForce(slinky[i - 1].getBounceForce(slinky[i]));
        //slinky[i].applyForce((slinky[i].getBounceForce(slinky[i - 1])));
        
          println("init:" + slinky[i - 1].velocity + "/final: " + slinky[i - 1].getBounceForce(slinky[i]));
           PVector a = slinky[i].velocity.copy();
  PVector b = slinky[i - 1].velocity.copy();
  slinky[i - 1].velocity = b;
  slinky[i].velocity = a.mult(-1);
      }
      //add wind
      
      slinky[i - 1].display();
      if (toggles[MOVING]) {
        PVector flatGrav = new PVector(random(-0.1, 0.1), random(2, 15));/////////////////////
        slinky[i - 1].applyForce(flatGrav);
        slinky[i - 1].move(toggles[BOUNCE]);
      }
    }
    }

  //> Combination
  
  
    displayMode();
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
  if (key == 'r') {
   createNewSlinky(); 
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
      createNewSlinky();
      simSwitcher(simulations);
      simulations[ORBIT] = !simulations[ORBIT];

      for (int i = 0; i < slinky.length; i++) {
        slinky[i].velocity.x = 10;
        slinky[i].velocity.y = 10;
      }
      //print("ORBIT");
    }
    if (key == '2') {
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
      //print("COLLISIONS");
      //createNewSlinky();
      simSwitcher(simulations);
      simulations[COLLISION] = !simulations[COLLISION];
    }
    if (key == '5') {
      createNewSlinky();
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
        //print(m);
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
    } else {
      fill(#050505);
    }

    float w = textWidth(types[n]);
    rect(x, 20, w+5, 20);
    fill(0);
    text(types[n], x+2, 22);
    x+= w+5;
  }
}//display

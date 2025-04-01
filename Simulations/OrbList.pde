/*===========================
  OrbList (ALL WORK GOES HERE)

  Class to represent a Linked List of OrbNodes.

  Instance Variables:
    OrbNode front:
      The first element of the list.
      Initially, this will be null.

  Methods to work on:
    0. addFront
    1. populate
    2. display
    3. applySprings
    4. applyGravity
    5. run
    6. removeFront
    7. getSelected
    8. removeNode

  When working on these methods, make sure to
  account for null values appropraitely. When the program
  is run, no NullPointerExceptions should occur.
  =========================*/

class OrbList {

  OrbNode front;

  /*===========================
    Contructor
    Does very little.
    You do not need to modify this method.
    =========================*/
  OrbList() {
    front = null;
  }//constructor

  /*===========================
    addFront(OrbNode o)

    Insert o to the beginning of the list.
    =========================*/
  void addFront(OrbNode o) {
    if (front != null) {
    front.previous = o;
    o.next = front;
    front = o;
    }
  }//addFront


  /*===========================
    populate(int n, boolean ordered)

    Clear the list.
    Add n randomly generated  orbs to the list,
    using addFront.
    If ordered is true, the orbs should all
    have the same y coordinate and be spaced
    SPRING_LEGNTH apart horizontally.
    =========================*/
  void populate(int n, boolean ordered) {
    int x;
    int y;
    int size;
    int mass;
    
    for (int i = n; i >= 0; i--) {
      if (ordered) {
        y = height / 2;
        x = i*SPRING_LENGTH + SPRING_LENGTH; 
      } else {
        x = int(random(0, width));
        y = int(random(0,height));
      }
      
      size = int(random(MIN_SIZE, MAX_SIZE));
      mass = int(random(MIN_MASS, MAX_MASS));
      
      if (i == n) {
        front = new OrbNode(x, y, size, mass);
      } else {
      OrbNode newN = new OrbNode(x, y, size, mass);
      addFront(newN);
      }
    }
  }//populate

  /*===========================
    display(int springLength)

    Display all the nodes in the list using
    the display method defined in the OrbNode class.
    =========================*/
  void display() {
    OrbNode current = front;
    while (current != null) {
      current.display();
      current = current.next;
    }
  }//display

  /*===========================
    applySprings(int springLength, float springK)

    Use the applySprings method in OrbNode on each
    element in the list.
    =========================*/
  void applySprings(int springLength, float springK) {
    OrbNode current = front;
    while (current != null) {
      current.applySprings(springLength, springK);
      current = current.next;
    }
  }//applySprings

  /*===========================
    applyGravity(Orb other, float gConstant)

    Use the getGravity and applyForce methods
    to apply gravity crrectly.
    =========================*/
  void applyGravity(Orb other, float gConstant) {
     OrbNode current = front;
     while (current != null) {
      current.applyForce(current.getGravity(other, gConstant));
      current = current.next;
    }
  }//applySprings

  /*===========================
    run(boolean bounce)

    Call run on each node in the list.
    =========================*/
  void run(boolean bounce) {
    OrbNode current = front;
     while (current != null) {
       current.move(bounce);
       current = current.next;
    }
  }//applySprings

  /*===========================
    removeFront()

    Remove the element at the front of the list, i.e.
    after this method is run, the former second element
    should now be the first (and so on).
    =========================*/
  void removeFront() {
    if (front != null) {
    if (front.next == null) {
      front = null; 
       print("noList");
    } else {
    front = front.next;
    front.previous = null;
    }
    }
  }//removeFront


  /*===========================
    getSelected(float x, float y)

    If there is a node at (x, y), return
    a reference to that node.
    Otherwise, return null.

    See isSlected(float x, float y) in
    the Orb class (line 115).
    =========================*/
  OrbNode getSelected(int x, int y) {
    OrbNode current = front;
     while (current != null) {
       if (current.isSelected(x, y)) {
         return current;
       }
       current = current.next;
    }
    return null;
  }//getSelected

  /*===========================
    removeNode(OrbNode o)

    Removes o from the list. You can
    assume o is an OrbNode in the list.
    You cannot assume anything about the
    position of o in the list.
    =========================*/
  void removeNode(OrbNode o) {
    OrbNode current = front;
     while (current != null) {
       if (current == o) {
         if (current == front) {
           removeFront(); 
         }
         if (current.previous != null) {
         current.previous.next = current.next;
         }
         if (current.next != null) {
         current.next.previous = current.previous;
         }
       }
       current = current.next;
    }
  }
}//OrbList

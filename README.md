[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/gbHItYk9)
## Project 00
### NeXTCS
### Period: 10
## Name0: LUCIA MERCONE
## Name1: VERONIKA DUVANOVA
---

This project will be completed in phases. The first phase will be to work on this document. Use github-flavoured markdown. (For more markdown help [click here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) or [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) )

All projects will require the following:
- Researching new forces to implement.
- Method for each new force, returning a `PVector`  -- similar to `getGravity` and `getSpring` (using whatever parameters are necessary).
- A distinct demonstration for each individual force (including gravity and the spring force).
- A visual menu at the top providing information about which simulation is currently active and indicating whether movement is on or off.
- The ability to toggle movement on/off
- The ability to toggle bouncing on/off
- The user should be able to switch _between_ simluations using the number keys as follows:
  - `1`: Gravity
  - `2`: Spring Force
  - `3`: Drag
  - `4`: Custom Force
  - `5`: Combination


## Phase 0: Force Selection, Analysis & Plan
---------- 

#### Custom Force: Contact Force

### Forumla
V.this(contact) = V.this((m.this - m.other)/(m.this + m.other)) + V.other((2m.other)/(m.this + m.other)

YOUR ANSWER HERE

### Custom Force
- What information that is already present in the `Orb` or `OrbNode` classes does this force use?
  - orb mass
  - orb velocity

- Does this force require any new constants, if so what are they and what values will you try initially?
  - N/A

- Does this force require any new information to be added to the `Orb` class? If so, what is it and what data type will you use?
  - N/A

- Does this force interact with other `Orbs`, or is it applied based on the environment?
  - yes, it depends on collision between orbs

- In order to calculate this force, do you need to perform extra intermediary calculations? If so, what?
  - no, this solves for the velocity directly rather than solving for force and applying it

--- 

### Simulation 1: Gravity
We will create a fixed orb in the center, and randomly generate orbs around it. We can use the equation F = mv^2 / r where m is the mass of the orbiting object, v is it's velocity, and r is the distance between their centers.

--- 

### Simulation 2: Spring
It will create a fixed orb which will connect a string of other orbs, which will use the distance between the orbs to create a push/pull force depending on how streched out the springs are and the initial spring length.

--- 

### Simulation 3: Drag
It will apply the drag force depending on a drag coefficient in different areas where the areas will be visualized using colors.

--- 

### Simulation 4: Collision
We will apply all balls to have the collision force, which upon contact they will collide. We will also add a ball centered at the mouse so that other balls will collide with the user's mouse.

--- 

### Simulation 5: Combination
We will combine gravity, collision, and drag to create a scene where planets circulate around the sun, but you are able to push the planets around with your mouse, and the planets are able to collide with each other.

import java.util.ArrayList; 
//****state variables
int state=0;//state begins at starter screen
boolean hasBeenSetUp;//variable for whether the minigame has been setup, which is important for the draw function which will either setup minigame or run it


//images for loading certain screens
PImage img;
PImage emp; 
PImage store;
PImage farm;
PImage miniStore;


/*  STATES
 0=starter scren
 
 1= minigame
 
 2=empire
 
 3=stores
 
 4=single store
 
 5=store closed screen
 
 6=farm
 ...
 ****state variables*/

/**Actions
 10 = buy store
 2 = close store
 **/

/** Sizes
 Queue Bar = rect(36,87,676,83);
 
 **/


/*********EMPIRE VARIABLES************/
Empire empire;
int totalTime; //totalTime, in 1/60 of a second
int timeAction; //for each action in queue of actions

double storeCost=50000; //store cost, has multiplier
double storeSell=10000; //store selling

Store currStore; //currentStore when looking at them, for function ease
int currStoreNum; //for removing store (index in list)

int storeClosedScreenStartTime=0;//for big red screen that flashes for 1.5 seconds when a store is closed

/*********EMPIRE VARIABLES************/


void setup() {
  state = 0; //state is meant to be zero this is for testing purposes
  size(750, 750);
  //normally setup will only do the first line. we have the other ones for testing purposes
  if (state==0) {
    img = loadImage("hegemony splash art 2.png");
    image(img, 0, 0);
  } else if (state==1) {
    setupMinigame();
  } else if (state==2) {
    beginEmpire();
  } else if (state==3) {
    storesScreen();
  } /*else if (state==6) {
    beginEmpire();
    empire.accessNewFarm();
    empire.accessNewFarm();
    empire.accessNewFarm();
    empire.accessNewFarm();
    empire.accessNewFarm();
    empire.accessNewFarm();
    setupFarm();
  }*/
}

void draw() {
  if (state==2) {//if empire home screen
    runEmpire();
    printBudget();
  } else if (state==1 && !hasBeenSetUp) {//if minigame hasnt been set up, load it
    setupMinigame();
    hasBeenSetUp=true;
  } else if (state==1 && hasBeenSetUp) {//if minigame has been set up, run minigame
    drawMinigame();
  } else if (state==0) {//start screen
    drawMenu();
  } else if (state==3) {//screen with every store 
    runEmpire();
    updateStoresScreen();
  } else if (state==4) {//looking at individual store
    runEmpire();
    runIndividualStore(currStore);
  } else if (state==5) {//STORE CLOSED screen
    runEmpire();
    if (storeClosedScreenStartTime<120){
      storeClosed();
      empire.setBudget(empire.getBudget()+storeSell);
      storeSell*=1.1;
    }
    else {
      state=3;
      storeClosedScreenStartTime=0;
      currStore=null;
    }
  } else if (state==6) {//farm, to be implemented
    runEmpire();
    drawFarm();
  }
  totalTime++;
  //prints queue of actions, parameters bc queue bar in different places
  if (state==2) printQ(0);
  else if (state==3 || state==6) printQ(1);
}

//SAME METHOD FOR ALL
void mouseClicked() {
  if (state==1) {
    if (currOrder.size()<9) {
      buttons();
    }
    checkOrder();//checks if order done correctly
    if (overButton(35, 530, 135, 50)) {//if you win you can move on
      state=2;
      beginEmpire();
    }
  }

  //IF YOU CLICK PLAY BUTTON ON MENU
  if (state==0) {
    if (overButton(282, 369, 185, 105)) {
      state=1;
      setupMinigame();
    }
  }
  //END MENU PLAY
  if (state==2) {//empire screen
    if (overButton(111, 314, 154, 168)) {//go to managing stores screen
      state=3;
    } else if (overButton(111, 535, 154, 168)) {//go to farm
      state=6;
    }
  }
  if (state==3) {//individual stores
    if (overButton(253, 544, 246, 120)&&empire.size()<10) {//a new store
      if (empire.getBudget()-storeCost>0 && empire.retQ().size()<6){
        empire.queueBuyStore(storeCost);//1=buy store
        storeCost*=1.25;
      }
    } else if (overButton(314, 690, 122, 75)) {//go back
      state=2;
      emp = loadImage ("main.png"); 
      image (emp, 0, 0);
    } else {//check if you want to see an individual store
      checkStoreButtons();
    }
  }
  if (state==4) {
    if (overButton(10, 10, 90, 60)) {//go back
      state=3;
    } else if (overButton(10, 395, 240, 45)&&currStore.numEmployees()<6) {
      currStore.hire(new Employee("Eric"));
    }
    fireEmployeeButton(currStore);//check if you fired an employee
  }
  if (state==6) {
    farmButtons();
  }
}

//END MOUSE CLICK

// MENU STUFF

void drawMenu() {
  stroke(0);
  noFill();

  rect(282, 369, 185, 105);
}

/*for buttons
 boolean overButton1(int x, int y, int width, int height) {
 if (mouseX >= x && mouseX <= x+width && 
 mouseY >= y && mouseY <= y+height) {
 return true;
 } else {
 return false;
 }
 }*/
// END MENU STUFF


// for buttons
boolean overButton(int x, int y, int width, int height) {
  return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
}

//cheat code -- press a to end minigame
//cheat code -- press s for 100k
void keyPressed() {
  if (key==97) currOrdNum=11;
  if (key==115) empire.setBudget(100000);
}

//END MINIGAME


//EMPIRE STUFF

//instantiates new empire and gives you a store
void beginEmpire() {
  empire = new Empire();
  empire.buyStore(new Store(totalTime));//you begin with one store, cost $50k
  storeCost*=1.25;
  emp = loadImage ("main.png"); 
  image (emp, 0, 0);
  empire.accessNewFarm(); 
  empire.getFarm(0).toggleChosen();
  empire.setSelectedFarm(empire.getFarm(0));
}

//runs every 1/6 of a second
void runEmpire() {
  emp = loadImage ("main.png"); 
  image (emp, 0, 0);
  if (totalTime%10==0) {
    empire.runOperations(totalTime);
    //this runs the actionQueue
    if (!empire.isEmpty()) { 
      timeAction++;
      Integer action = empire.peekActions();
      //each if statement is for specific actions
      if (action == timeAction) {
        timeAction=0;
        empire.popActions();
        if (action==10) {
          empire.buyStore(new Store(totalTime));

          if (empire.numUnlockedFarms() < 6) { 
          empire.accessNewFarm(); 
          }
        } else if (action==2) {
          //System.out.println("yo");
          //currStore=null;
          empire.closeStore(currStoreNum);
          currStoreNum=0;
          //state=5;
        }
      }
    }
  }
}

//prints budget on main menu
void printBudget() {

  color c1 = #ffff00;
  noStroke();
  fill(c1);
  rect(340, 113, 141, 65);
  fill(0);
  textSize(23);
  strokeWeight(1);
  text(dollarToStr(empire.getBudget()), 340, 150);

  //clickable area
  stroke(255);
  noFill();
  rect(111, 314, 154, 168);
  rect(500, 314, 154, 168);
  rect(111, 535, 154, 168);
  rect(500, 535, 154, 168);
}

//loads screen for individual stores
void storesScreen() {
  store=loadImage("store.png");
  image(store, 0, 0);
}

//updates screen for individual stores
void updateStoresScreen() {
  int i=0;
  int xcor=57;//of size 100 w/ 25 spacing
  int ycor=225;
  storesScreen();
  textSize(20);
  while (i<10) {
    //fill(100);
    //rect(xcor, ycor, 100, 100);
    if (i<empire.size()) {
      fill(255);
      text(empire.getStore(i).getName()/*"Store "+(i+1)*/, xcor+10, ycor+40);
    }
    xcor+=133;
    if (i==4) {
      ycor=375;
      xcor=57;
    }
    i++;
  }
  textSize(30);
  //determines color on whether u have enough guap
  if (empire.getBudget()>=storeCost)
    fill(#00FF00);
  else
    fill(#FF0000);
  text(dollarToStr(storeCost), 280, 650);
  textSize(20);
  strokeWeight(1);
  fill(#0000FF);
  text(dollarToStr(empire.getBudget()).substring(1), 296, 80);
}


//END EMPIRE

//converts dollar double to string w $
public String dollarToStr(double d) {
  String s = ""+d;
  s=s.substring(0, s.indexOf(".")+2);
  if (s.length()-s.indexOf(".")==2) {
    s+="0";
  }
  return "$"+s;
}

//sets up screen for individual stores, employees, etc.
void setupIndividualStore(Store s) {
  background(#85C1E9);
  fill(#0000FF);
  textSize(28);
  text(s.getName(), 330, 34);
  textSize(24);
  fill(#FBFB70);
  rect(10, 10, 90, 60);//back rectangle
  rect(10, 190, 195, 60);//money rectangle
  rect(10, 260, 195, 120);//operations cost
  rect(36, 87, 676, 83);//actions queue
  fill(0);
  text("BACK", 15, 50);
  fill(#07145D);
  rect(0, 450, 750, 300);//big bottom rectangle
  fill(#C475EE);
  text("Employees:", 10, 475);
  fill(#0000FF);
  text("Daily", 15, 285);
  text("Operations Cost", 15, 315);
  fill(#00FF00);//lime, hire box
  rect(10, 395, 240, 45);//hire rectangle
  fill(0);
  text("Hire New Employee", 15, 430);
  int xcor=20;
  int i=0;
  textSize(20);
  while (xcor<744) {//prints employees
    fill(0);
    rect(xcor, 500, 100, 230);
    textSize(16);
    if (i<s.numEmployees()) {
      fill(#0000FF);
      Employee temp=s.getEmployee(i);
      text(temp.getName(), xcor+5, 520);
      fill(#01F7FF);
      text("Satisfaction", xcor+5, 545);
      fill(255);
      text(temp.getSatisfaction(), xcor+5, 565);
      fill(#FF0000);
      textSize(24);
      text("FIRE", xcor+5, 725);
      //rect:(xcor+5,700,100,25)
      i++;
    }
    xcor+=122;
  }
}
//checks if an employee needs to be fired
void fireEmployeeButton(Store s) {
  int x=20;
  while (x<744) {
    if (overButton(x+5, 700, 100, 25)) {
      if (((x-20)/122)<s.numEmployees()) {
        s.fire((x-20)/122);
        s.increaseStorePlace();
        return;
      }
    }
    x+=122;
  }
}
//running a store. if it has no employees it is closed
void runIndividualStore(Store s) {
  if (s==null)
    return;
  setupIndividualStore(s);
  fill(#030939);
  textSize(24);
  text(dollarToStr(empire.getBudget()), 20, 225);
  text(dollarToStr(s.getOperationsCost()), 20, 365);
  if (s.numEmployees()==0) {//if no employees, enqueue an action to actionlist to close it. can only close one store at a time
    empire.addAction(2);
    state=5;
    //timeAction=0;
    //currStore=null;
    //empire.closeStore(currStoreNum);
    //state=5;
  }
}

//checks all the buttons of individual stores
void checkStoreButtons() {
  int i=0;
  int xcor=57;//of size 100 w/ 25 spacing
  int ycor=225;
  textSize(20);
  while (i<empire.size()) {
    if (overButton(xcor, ycor, 106, 107)) {
      state=4;
      currStore=empire.getStore(i);
      currStoreNum=i;
      setupIndividualStore(currStore);
      return;
    }
    xcor+=133;
    if (i==4) {
      ycor=375;
      xcor=57;
    }
    i++;
  }
}

//closed store s creen
void storeClosed() {
  background(#FF0000);
  fill(255);
  textSize(64);
  text(currStore.getName()+"\nCLOSED", 120, 300);
  storeClosedScreenStartTime++;
}


//printing action queue
void printQ(int s) {
  int offset=0;
  int ycor;
  //  rect(36,199,676,83);
  // 87
  //0 = store
  if (s==0) ycor=199;
  else ycor=87;



  ALQueue<Integer> Q = empire.retQ();

  for (int i=0; i < Q.size(); i++) {
    int temp = Q.getN(i);
    if (temp==10) {
      miniStore = loadImage("miniStore.png");
      image(miniStore, 70+offset, ycor);   
      offset+=100;
    }
  }
}

//sets up farm screen
void setupFarm() {
  farm = loadImage("farm.png");
  image(farm, 0, 0);
  fill(#FF0000); 
  rect (170, 200, 250, 50); 
  rect (36, 200, 120, 50); 
  fill(0); 
  text("Buy patties", 40, 240); 
  text("Patties available: " + empire.getPatties(), 175, 240); 
  int xcor=60;
  int ycor=300;
  for (int i=0; i<6; i++) {
    fill(#12490C);
    rect(xcor, ycor, 160, 190);
    if (i<empire.numUnlockedFarms()) {
      textSize(18);
      if (empire.getFarm(i).isChosen())
        fill(#00FF00);
      else
        fill(#FF0000);
      text(empire.getFarm(i).getName(), xcor+10, ycor+18);
      fill(#FFFB00);
      text((int)(empire.getFarm(i).getPercentRealMeat()*100)+"% Real Meat", xcor+10, ycor+50);
      text("$"+empire.getFarm(i).getCostPerPatty()+" per patty", xcor+10, ycor+75);
      fill(#00FF00);
      text("SELECT FARM", xcor+10, ycor+170);
    }
    xcor+=240;
    if (i==2) {
      xcor=60;
      ycor=500;
    }
  }
  fill(#00FF00);
  textSize(20);
  rect(15,15,60,30);
  fill(#0000FF);
  text("BACK",20,40);
}

void drawFarm() {
  setupFarm();
  text(dollarToStr(empire.getBudget()).substring(1), 307, 76);
}

void farmButtons() {
  if (overButton(15,15,60,30)) {
    state=2;
    return;
  }
  if (overButton (36, 200, 120, 50)) { 
    empire.buyPatties (1000, empire.getSelectedFarm()); 
  }
  int xcor=60;
  int ycor=300;
  for (int i=0; i<6; i++) {
    if (i<empire.numUnlockedFarms()) {
      if (overButton(xcor, ycor+145, 160, 45)&&!empire.getFarm(i).isChosen()) {
        empire.getFarm(i).toggleChosen();
        empire.toggleAllOtherFarmsChosen(i);
        empire.setSelectedFarm (empire.getFarm(i)); 
        break;
      }
    }
    xcor+=240;
    if (i==2) {
      xcor=60;
      ycor=500;
    }
  }
}
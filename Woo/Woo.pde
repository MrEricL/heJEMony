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
PImage hire;
PImage fire;
PImage ecoli;
PImage strike;
PImage win;
PImage out;
PImage clean;
PImage adScreen;
PImage farmChange;
PImage addAd;
PImage noAd;

boolean ecoliState;//if you have ecoli

/*  STATES
 0=starter scren
 
 1= minigame
 
 2=empire
 
 3=stores
 
 4=single store
 
 5=store closed screen
 
 6=farm
 
 7=victory
 
 8=lose
 
 9=info
 
 10=ads
 ...
 ****state variables*/

/**Actions
 10 = buy store
 7 = close store
 5 = hire employee
 6=fix ecoli
 11=choose farm
 **/

/** Sizes
 Queue Bar = rect(36,87,676,83);
 
 **/


/*********EMPIRE VARIABLES************/
Empire empire;
int totalTime; //totalTime, in 1/60 of a second
int timeAction; //for each action in queue of actions

int farmToToggle;

double storeCost=50000; //store cost, has multiplier
double storeSell=10000; //store selling

Store currStore; //currentStore when looking at them, for function ease
int currStoreNum; //for removing store (index in list)

int storeClosedScreenStartTime=0;//for big red screen that flashes for 1.5 seconds when a store is closed

boolean playedMinigame;//if minigame played for the first time, function is for playing minigame while empire is running, too
boolean strikeBoo;//true if a strike happens
boolean changingFarm;//
/*********EMPIRE VARIABLES************/


void setup() {
  //load images, has to happen in setup
  img=loadImage("hegemony splash art 2.png");
  emp=loadImage("main.png");
  store=loadImage("store.png");
  farm=loadImage("farm.png");
  miniStore=loadImage("miniStore.png");
  hire=loadImage("hire.png");
  fire = loadImage("fire.png");
  ecoli = loadImage("ecoli.png");
  out = loadImage("out.png");
  strike=loadImage("strike.png");
  clean = loadImage("clean.png");
  adScreen=loadImage("ads2.png");
  farmChange=loadImage("farmchange.png");
  addAd = loadImage ("ad pic.png");
  noAd = loadImage ("noad.png");

  ecoliState=false;
  strikeBoo=false;
  changingFarm=false;
  farmToToggle=-1;
  state = 0; //state is meant to be zero this is for testing purposes
  size(750, 750);
  //normally setup will only do the first line. we have the other ones for testing purposes
  if (state==0) {
    //img = loadImage("hegemony splash art 2.png");
    image(img, 0, 0);
  } else if (state==1) {
    setupMinigame();
  } else if (state==2) {
    beginEmpire();
  } else if (state==3) {
    storesScreen();
  }
}

void draw() {

  //if (empire!=null)System.out.println(empire.getBudget());
  if (state==2) {//if empire home screen
    image(emp, 0, 0);
    runEmpire();
    printBudget();
  } else if (state==1 && !hasBeenSetUp) {//if minigame hasnt been set up, load it
    setupMinigame();
    hasBeenSetUp=true;
  } else if (state==1 && hasBeenSetUp && !playedMinigame) {//if minigame has been set up, run minigame
    drawMinigame();
  } else if (state==1 && hasBeenSetUp && playedMinigame) {//if minigame has's been played before
    runEmpire();
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
    if (storeClosedScreenStartTime<22) {//store closed screen runs for 22/6 seconds
      storeClosed();
      //empire.setBudget(storeSell);
      //storeSell*=1.1;
    } else {
      state=3;
      storeClosedScreenStartTime=0;
      currStore=null;
    }
  } else if (state==6) {//farm
    runEmpire();
    drawFarm();
  } else if (state==7) {//victory screen
    background(#00FF00);
    textSize(100);
    text("YOU\nWIN!", 300, 300);
  } else if (state==8) {//lose screen
    background(#FF0000);
    textSize(100);
    text("YOU\nLOSE :(", 300, 300);
  } else if (state == 9) { //info screen
    runEmpire();
    loadInfo();
  } else if (state==10) {//ads screen
    runEmpire();
    runAdScreen();
  }
  if (empire!=null) {//checking for victory/defeat
    if (empire.size()==10 && empire.getBudget()>=999999) {//victory
      state=7;
    }
    if (empire.size()==0 || empire.getBudget()<-100000) {//lose
      state=8;
    }
  }
  //PUT AN IMAGE for no patties left
  if (empire!= null && empire.getPatties()==0) {
    image(out, 680, 27);
  }
  totalTime++;
  //prints queue of actions, parameters bc queue bar in different places
  if (state==2) printQ(0);
  else if (state==3 || state==6 || state==4 || state==10 || state==9) printQ(1);

  if (ecoliState) {//if you have ecoli you lose cash and customer happiness and stuff
    ecoliRun();
  }
}



//SAME METHOD FOR ALL
void mouseClicked() {
  if (state==1) {//minigame
    if (currOrder.size()<9) {
      buttons();
    }
    checkOrder();//checks if order done correctly
    if (overButton(35, 530, 135, 50)) {//if you win you can move on
      state=2;
      if (!playedMinigame) {
        beginEmpire();
        playedMinigame=true;
      }
    }
  }

  //IF YOU CLICK PLAY BUTTON ON MENU
  else if (state==0) {//first screen
    if (overButton(282, 369, 185, 105)) {
      state=1;
      setupMinigame();
    }
  }
  //END MENU PLAY
  else if (state==2) {//empire screen
    if (overButton(111, 314, 154, 168)) {//go to managing stores screen
      state=3;
    } else if (overButton(111, 535, 154, 168)) {//go to farm
      state=6;
    }
    if (overButton(500, 535, 154, 168)&&!ecoliState) {
      state=1;
      setupMinigame();
      //   drawMinigame();
    } else if (overButton (500, 314, 154, 168)) { 
      state = 9;
    }
  } else if (state==3) {//all the stores
    if (overButton(253, 544, 246, 120)&&empire.size()<10) {//a new store
      if (empire.getBudget()-storeCost>0 && empire.retQ().size()<6) {
        empire.queueBuyStore(storeCost);//10=buy store
        System.out.println("queued store");
        storeCost*=1.25;
      }
    } else if (overButton(314, 690, 122, 75)) {//go back
      state=2;
      //emp = loadImage ("main.png"); 
      image (emp, 0, 0);
    } else {//check if you want to see an individual store
      checkStoreButtons();
    }
  } else if (state==4) {//individual store
    if (overButton(10, 10, 90, 60)) {//go back
      state=3;
    } else if (overButton(10, 395, 240, 45)&&currStore.numEmployees()<6) {//hire employee
      empire.addAction(5);
      currStore.hire(new Employee(currStore.personName()));
      //currStore.hire(new Employee("Eric"));
    } else if (overButton(580, 330, 140, 50)) {
      empire.addAction(7);//close store
      empire.closeStore(currStoreNum);
      //empire.queueStoreToClose(currStoreNum);
      state=5;
    } else if (overButton(530, 390, 190, 50)) {
      currStore.raise(4);//raise
    } else if (overButton(270, 390, 240, 50)&&empire.getHasAds()) {//ad screen
      state=10;
    }
    fireEmployeeButton(currStore);//check if you fired an employee
  } else if (state==6) {//farms
    farmButtons();
  } else if (state==9) {//info screen
    if (overButton(325, 700, 50, 40))//go back
      state=2;
  } else if (state==10) {//ads
    adButtons();
  }
  if (ecoliState) {//ecoli
    ecoliButton();
  }
}

//END MOUSE CLICK

// MENU STUFF

void drawMenu() {
  stroke(0);
  noFill();
  rect(282, 369, 185, 105);
}


// for buttons
boolean overButton(int x, int y, int width, int height) {
  return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
}

//cheat code -- press a to end minigame
//cheat code -- press s for 100k
void keyPressed() {
  if (key==97) currOrdNum=11;
  else if (key==115 && empire!=null) empire.setBudget(10000000);
  else if (key==116 && empire!=null) empire.setBudget(-10000000);
  else if (key==98) {
    ecoliState=true;
  }
}

//END MINIGAME


//EMPIRE STUFF

//instantiates new empire and gives you a store
void beginEmpire() {
  empire = new Empire();
  empire.buyStore(new Store(totalTime));//you begin with one store, cost $50k
  storeCost*=1.25;
  //emp = loadImage ("main.png"); 
  image (emp, 0, 0);
  empire.accessNewFarm(); 
  empire.getFarm(0).toggleChosen();
  empire.setSelectedFarm(empire.getFarm(0));
}

//runs every 1/6 of a second
void runEmpire() {
  //emp = loadImage ("main.png"); 
  //image (emp, 0, 0);
  if (totalTime%10==0) {
    empire.runOperations(totalTime);
    if (Math.random()>0.9999)
      ecoliState=true;
    /*if (empire.calculateTotalEmployeeSatisfaction()<1){
     strikeBoo=true;
     }*/
    //this runs the actionQueue
    if (!empire.isEmpty()) { 
      timeAction++;
      Integer action = empire.peekActions();
      //each if statement is for specific actions
      if (action == timeAction) {
        timeAction=0;
        empire.popActions();
        if (action==10) {//buy store
          empire.buyStore(new Store(totalTime));

          if (empire.numUnlockedFarms() < 6) { 
            empire.accessNewFarm();
          }
        } else if (action==7) {//close store

          empire.setBudget(storeSell);
          currStoreNum=0;
          storeSell*=1.1;
        } else if (action==5) {//hire employee
          //this is just here to maintain timing function of queue, explained more in depth in devlog bugs
        } else if (action==6) {//e coli
          empire.modifyBudget(-10000);//cost to get rid of e coli
          ecoliState=false;
        } else if (action==11) {//change farm
          empire.getFarm(farmToToggle).toggleChosen();
          empire.toggleAllOtherFarmsChosen(farmToToggle);
          empire.setSelectedFarm (empire.getFarm(farmToToggle));
          changingFarm=false;
          farmToToggle=-1;
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
  /*
  stroke(255);
   noFill();
   rect(111, 314, 154, 168);
   rect(500, 314, 154, 168);
   rect(111, 535, 154, 168);
   rect(500, 535, 154, 168);
   */
}

//loads screen for individual stores
void storesScreen() {
  //store=loadImage("store.png");
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
      if (empire.getStore(i).striking()) { 
        fill (#FF0000);
      } 
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
  if (d>9999999)
    return ("$"+d).substring(0,5)+"e"+(""+d).substring((""+d).length()-1);
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
  rect(530, 190, 190, 120);//customer satisfaction
  rect(580, 330, 140, 50);//close store
  rect(530, 390, 190, 50);//raise
  rect(36, 87, 676, 83);//actions queue
  fill(0);
  text("BACK", 15, 50);
  fill(#07145D);
  rect(0, 450, 750, 300);//big bottom rectangle
  fill(#C475EE);
  text("Employees:", 10, 475);
  fill(#FF0000);
  text("Close Store", 585, 365);
  fill(#0000FF);
  text("Daily", 15, 285);
  text("Operations Cost", 15, 315);
  text("Customer\nSatisfaction", 535, 220);
  text("$4 Raise", 575, 425);
  text(""+s.getCustomerSatisfaction(), 535, 300);
  fill(#00FF00);//lime, hire box
  rect(10, 395, 240, 45);//hire rectangle
  rect(270, 390, 240, 50);//ads
  fill(0);
  text("Hire New Employee", 15, 430);
  if (empire.size()>3)
    text("Buy Ads", 275, 430);
  else {
    textSize(20);
    text("Unlock Ads at 4 Stores", 275, 430);
    textSize(24);
  }
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
      text("Salary", xcor+5, 585);
      fill(255);
      text(temp.getSatisfaction(), xcor+5, 565);
      text("$"+temp.getSalary(), xcor+5, 605);
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
  if (s.striking()) {//if workers on strike
    image(strike, 100, 20);
  }
  fill(#030939);
  textSize(24);
  text(dollarToStr(empire.getBudget()), 20, 225);
  text(dollarToStr(s.getOperationsCost()), 20, 365);
  if (s.numEmployees()==0) {//if no employees, enqueue an action to actionlist to close it. can only close one store at a time
    empire.addAction(7);
    empire.closeStore(currStoreNum);
    state=5;
  }
}

//checks all the buttons of individual stores so you can see them
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
  text(currStore.getName()+"\nCLOSING", 120, 300);
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
      //miniStore = loadImage("miniStore.png");
      image(miniStore, 70+offset, ycor);
    } else if (temp==7) {
      // fire = loadImage("fire.png");
      image(fire, 70+offset, ycor);
    } else if (temp==5) {
      //hire = loadImage("hire.png");
      image(hire, 70+offset, ycor);
    } else if (temp==6) {
      image (clean, 70+ offset, ycor);
      /*fill(#00FF00);
       rect(70+offset, ycor, 90, 83);
       fill(255);
       textSize(16);
       text("Cleaning\nEcoli", 72+offset, ycor+20);
       textSize(20);*/
    } else if (temp==11) {
      image(farmChange, 70+offset, ycor);
      /*fill(#FF0000);
       rect(70+offset, ycor, 90, 83);
       fill(255);
       textSize(16);
       text("Changing\nFarm", 72+offset, ycor+20);
       textSize(20);*/
    } else if (temp==4) {
      image(addAd, 70+offset, ycor);
    } else if (temp==3) {
      image(noAd, 70+offset, ycor);
    }
    offset+=100;
  }
}

//sets up farm screen
void setupFarm() {
  textSize(18);
  //farm = loadImage("farm.png");
  image(farm, 0, 0);
  fill(#FF0000); 
  rect (170, 200, 250, 50); //num patties
  rect (36, 200, 120, 50); //buy patties
  fill(0); 
  text("Buy patties", 40, 240); 
  text("Patties available: " + empire.getPatties(), 175, 240); 
  int xcor=60;
  int ycor=300;
  /*
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
   }*/
  fill(#00FF00);
  textSize(20);
  rect(15, 15, 60, 30);
  fill(#0000FF);
  text("BACK", 20, 40);
}

void drawFarm() {
  setupFarm();
  int xcor=60;
  int ycor=300;
  for (int i=0; i<6; i++) {
    fill(#12490C);
    rect(xcor, ycor, 160, 190);
    if (i<empire.numUnlockedFarms()) {//if the i corresponds to a farm it will print that farm's info in the corresponding box
      textSize(18);
      if (empire.getFarm(i).isChosen())
        fill(#00FF00);
      else
        fill(#FF0000);
      text(empire.getFarm(i).getName(), xcor+10, ycor+18);
      fill(#FFFB00);
      text((int)(empire.getFarm(i).getPercentRealMeat()*100)+"% Real Meat", xcor+10, ycor+50);
      text(dollarToStr(empire.getFarm(i).getCostPerPatty())+" per patty", xcor+10, ycor+75);
      fill(#00FF00);
      text("SELECT FARM", xcor+10, ycor+170);
    }
    xcor+=240;
    if (i==2) {
      xcor=60;
      ycor=500;
    }
  }
  text(dollarToStr(empire.getBudget()).substring(1), 307, 76);
}

//checks farm buttons (toggling farms)
void farmButtons() {
  if (overButton(15, 15, 60, 30)) {
    state=2;
    return;
  } else if (overButton (36, 200, 120, 50)) { 
    empire.buyPatties (1000, empire.getSelectedFarm());
  }
  int xcor=60;
  int ycor=300;
  int i=0;
  while (i<empire.numUnlockedFarms()) {
    //changes the farm to this one
    if (overButton(xcor, ycor+145, 160, 45) && !changingFarm && !empire.getFarm(i).isChosen() ) {
      empire.addAction(11);
      farmToToggle=i;
      changingFarm=true;
      break;
    }
    i++;
    xcor+=240;

    if (i==3) {
      xcor=60;
      ycor=500;
    }
  }
}


void ecoliRun() {//runs ecoli image

  image(ecoli, 120, 150);
  image(ecoli, 120, 150);
  image(ecoli, 120, 150);

  if (ecoliState&& totalTime%30 == 0) {
    empire.ecoli(2);
  }
}

void ecoliButton() {//click on e coli image to fix it
  if (overButton(200, 200, 500, 500)) {
    empire.addAction(6);
  }
}
//info screen
void loadInfo() { 
  background(#00FF00);
  fill(#D4DD20);
  rect(36, 87, 676, 83);
  fill(225);
  textSize(60);
  text("Information", 160, 85);
  textSize (50); 
  text ("Money: " + dollarToStr(empire.getBudget()), 50, 220);
  text ("Patties: "+empire.getPatties(), 50, 320); 
  text ("Stores bought: "+ empire.size(), 50, 420); 
  text ("Farms available: "+ empire.getFarmNum(), 50, 520);
  fill(#FF0000);
  rect(325, 700, 50, 40);
  fill(255);
  textSize(20);
  text("Back", 327, 730);
}

/*
add coords
 top row: 58,241,631,87
 (631-102)/2 is width of each box, w 102 between them
 
 3 boxes
 32,425,686,163
 w=185
 */

//sets up screen for ads
void runAdScreen() {
  image(adScreen, 0, 0);
  textSize(24);
  fill(#0000FF);
  text(currStore.getCustomerSatisfaction(), 263, 295); 
  if (currStore.getAdType()==0)
    text("n/a", 590, 290);
  else
    text(dollarToStr(currStore.adSuccess(empire.getSelectedFarm())).substring(1)+"%", 590, 290);
  //box 1 xcor: 32, box2 xcor: 275 3: 533
  fill(0);
  if (currStore.getAdType()==0) fill(#14750A);
  text("No\nAds", 90, 506);
  fill(0);
  text("$20,000", 283, 480);
  if (currStore.getAdType()==1) fill(#14750A);
  text("Advertise\nPrice", 283, 506);
  fill(0);
  text("$20,000", 541, 480);
  if (currStore.getAdType()==2) fill(#14750A);
  text("Advertise\nMeat Quality", 541, 506);
  textSize(20);
  fill(#0000FF);
  text(dollarToStr(empire.getBudget()).substring(1), 296, 80);
}

void adButtons() {//checks three boxes and back button for if you want to buy ads
  int currAd = currStore.getAdType();
  if (overButton(32, 425, 185, 164)) {
    currStore.setAd(0);
    if (currAd!=0) empire.addAction(3);
  } else if (overButton(275, 425, 185, 164)) {
    currStore.setAd(1);
    empire.setBudget(-20000);
    if (currAd!=1) empire.addAction(4);
  } else if (overButton(533, 425, 185, 164)) {
    empire.setBudget(-20000); 
    currStore.setAd(2);
    if (currAd!=2) empire.addAction(4);
  } else if (overButton(314, 690, 122, 75)) 
    state=4;
}
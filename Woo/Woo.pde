import java.util.ArrayList; 
//****state variables
int state=0;
boolean hasBeenSetUp;

PImage img;
PImage emp; 
PImage store;
/* 
 0=starter scren
 
 1= minigame
 
 2=empire
 
 3=stores
 
 4=single store
 
 5=store closed screen
 ...
 ****state variables*/

/**Actions
 1 = buy store
 2 = close store
 **/

/** Sizes
 Queue Bar = rect(36,87,676,83);
 
 **/


/*********EMPIRE VARIABLES************/
Empire empire;
int totalTime;
int timeAction; //for each action

double storeCost=50000; //store cost * random multiplier

Store currStore;
int currStoreNum;

int storeClosedScreenStartTime=0;

/*********EMPIRE VARIABLES************/


void setup() {
  //state = 5; 
  size(750, 750);
  if (state==0) {
    img = loadImage("hegemony splash art 2.png");
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
  if (state==2) {
    runEmpire();
    printBudget();
  } else if (state==1 && !hasBeenSetUp) {
    setupMinigame();
    hasBeenSetUp=true;
  } else if (state==1 && hasBeenSetUp) {
    drawMinigame();
  } else if (state==0) {
    drawMenu();
  } else if (state==3) {
    runEmpire();
    updateStoresScreen();
  } else if (state==4) {
    runEmpire();
    runIndividualStore(currStore);
  } else if (state==5) {
    runEmpire();
    if (storeClosedScreenStartTime<120)
      storeClosed();
    else {
      state=3;
      storeClosedScreenStartTime=0;
      currStore=null;
    }
  }
  totalTime++;
  //timeAction=0;
}

//SAME METHOD FOR ALL
void mouseClicked() {
  if (state==1) {
    if (currOrder.size()<9) {
      buttons();
    }
    checkOrder();
    if (overButton1(35, 530, 135, 50)) {
      state=2;
      beginEmpire();
    }
  }

  //IF YOU CLICK PLAY BUTTON ON MENU
  if (state==0) {
    if (overButton1(282, 369, 185, 105)) {
      state=1;
      setupMinigame();
    }
  }
  //END MENU PLAY
  if (state==2) {
    if (overButton(111, 314, 154, 168)) {//go to managing stores screen
      state=3;
    }
  }
  if (state==3) {
    if (overButton(253, 544, 246, 120)&&empire.size()<10) {//buy new store
      if (empire.getBudget()-storeCost>0)
        empire.addAction(1);//1=buy store
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
    }
    else if (overButton(10,395,240,45)&&currStore.numEmployees()<6) {
      currStore.hire(new Employee("Eric"));
    }
    fireEmployeeButton(currStore);//check if you fired an employee
  }
}

//END MOUSE CLICK

// MENU STUFF

void drawMenu() {
  stroke(0);
  noFill();

  rect(282, 369, 185, 105);
}
boolean overButton1(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
// END MENU STUFF



boolean overButton(int x, int y, int width, int height) {
  return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
}

//cheat code -- press a
//cheat code -- press s
void keyPressed() {
  if (key==97) currOrdNum=11;
  if (key==115) empire.setBudget(100000);
}

//END MINIGAME


//EMPIRE STUFF

void beginEmpire() {
  empire = new Empire();
  empire.buyStore(new Store(totalTime), storeCost);//you begin with one store, cost $50k
  storeCost*=1.25;
  emp = loadImage ("main.png"); 
  image (emp, 0, 0);
}

void runEmpire() {
  if (totalTime%10==0) {
    empire.runOperations(totalTime);

    if (!empire.isEmpty()) { 
      timeAction++;
      Integer action = empire.peekActions();
      //System.out.println(action);
      if (action == timeAction) {
        timeAction=0;
        empire.popActions();
        if (action==1) {
          empire.buyStore(new Store(totalTime), storeCost);
          storeCost*=1.25;
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

void printBudget() {

  color c1 = #ffff00;
  noStroke();
  fill(c1);
  rect(340, 113, 141, 65);
  fill(0);
  textSize(27);
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

void storesScreen() {
  store=loadImage("store.png");
  image(store, 0, 0);
  /*
  background(255);
   fill(0);
   rect(0, 0, 750, 150);
   rect(0, 600, 750, 150);
   int i=0;
   int xcor=35;//of size 100 w/ 25 spacing
   int ycor=200;
   textSize(20);
   while (i<10) {
   fill(100);
   rect(xcor, ycor, 100, 100);
   xcor+=130;
   if (i==4) {
   ycor=350;
   xcor=35;
   }
   i++;
   }
   fill(100);
   //buy store rectangle
   rect(35, 650, 150, 75);
   //total money rectangle
   fill(#FFD700);
   rect(450, 50, 250, 75);
   rect(50, 50, 100, 75);
   textSize(20);
   fill(0);
   text("Buy Store", 45, 680);
   text("Back", 55, 85);
   //text("Store",35,555);
   */
}

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

public String dollarToStr(double d) {
  String s = ""+d;
  s=s.substring(0, s.indexOf(".")+2);
  if (s.length()-s.indexOf(".")==2) {
    s+="0";
  }
  return "$"+s;
}

void setupIndividualStore(Store s) {
  background(#85C1E9);
  fill(#0000FF);
  textSize(28);
  text(s.getName(), 330, 34);
  textSize(24);
  fill(#FBFB70);
  rect(10, 10, 90, 60);
  rect(10, 190, 195, 60);//money rectangle
  rect(10, 260, 195, 120);//operations cost
  rect(36, 87, 676, 83);
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
  rect(10,395,240,45);//hire rectangle
  fill(0);
  text("Hire New Employee",15,430);
  int xcor=20;
  int i=0;
  textSize(20);
  while (xcor<744) {
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

void runIndividualStore(Store s) {
  if (s==null)
    return;
  setupIndividualStore(s);
  fill(#030939);
  textSize(24);
  text(dollarToStr(empire.getBudget()), 20, 225);
  text(dollarToStr(s.getOperationsCost()), 20, 365);
  if (s.numEmployees()==0) {
    empire.addAction(2);
    state=5;
    //timeAction=0;
    //currStore=null;
    //empire.closeStore(currStoreNum);
    //state=5;
  }
}

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

void storeClosed() {
  background(#FF0000);
  fill(255);
  textSize(64);
  text(currStore.getName()+"\nCLOSED", 120, 300);
  storeClosedScreenStartTime++;
}
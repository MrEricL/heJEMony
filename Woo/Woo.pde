import java.util.ArrayList; 
//****state variables
int state=0;
boolean hasBeenSetUp;

PImage img;
PImage emp; 
/* 
 0=starter scren
 
 1= minigame
 
 2=empire
 
 3=stores
 
 4=single store
 ...
 ****state variables*/




/*********EMPIRE VARIABLES************/
Empire empire;
int totalTime;
int timeAction; //for each action

double storeCost=50000; //store cost * random multiplier

Store currStore;

/*********EMPIRE VARIABLES************/


void setup() {
  state = 0; 
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
  }
  totalTime++;
  timeAction=0;
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
    if (overButton(111, 314, 154, 168)) {
      state=3;
    }
  }
  if (state==3) {
    if (overButton(35, 650, 150, 75)) {
      if (empire.getBudget()-storeCost>0)
        empire.addAction(1);//1=buy store
    }
    else if (overButton(50, 50, 100, 75)) {
      state=2;
      emp = loadImage ("main.png"); 
      image (emp, 0, 0);
    }
    else {
      checkStoreButtons();
    }
  }
  if (state==4) {
    if (overButton(10,10,50,50)) {
      state=3;
    }
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
  empire.buyStore(new Store(), storeCost);//you begin with one store, cost $50k
  storeCost*=random(1)+1;
  emp = loadImage ("main.png"); 
  image (emp, 0, 0);
}

void runEmpire() {
  if (totalTime%10==0) {
    empire.runOperations();
  }
  timeAction++;
  if (!empire.isEmpty()) { 
    Integer action = empire.peekActions();
    if (action == timeAction) {
      timeAction=0;
      empire.popActions();
      if (action==1) {
        empire.buyStore(new Store(), storeCost);
        storeCost*=random(1)+1;
      }
    }
  }
}

void printBudget() {

  color c1 = #ffff00;
  noStroke();
  fill(c1);
  rect(340, 113, 139, 65);
  fill(0);
  textSize(30);
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
}

void updateStoresScreen() {
  //background(255);
  int i=0;
  int xcor=35;//of size 100 w/ 25 spacing
  int ycor=200;
  storesScreen();
  textSize(20);
  while (i<10) {
    //fill(100);
    //rect(xcor, ycor, 100, 100);
    if (i<empire.size()) {
      fill(255);
      text("Store "+(i+1), xcor+10, ycor+40);
    }
    xcor+=130;
    if (i==4) {
      ycor=350;
      xcor=35;
    }
    i++;
  }
  fill(#FF0000);
  text(dollarToStr(storeCost), 45, 700);
  textSize(30);
  strokeWeight(1);
  fill(#0000FF);
  text(dollarToStr(empire.getBudget()), 460, 95);
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
  textSize(20);
  fill(#00FF00);
  rect(10,10,70,50);
  fill(0);
  text("BACK",15,40);
  fill(#07145D);
  rect(0, 500, 750, 250);
  fill(#C475EE);
  text("Employees:", 10, 525);
  fill(#FBFB70);
  rect(600,10,140,50);//money rectangle
  int xcor=20;
  int i=0;
  while (xcor<744) {
    fill(0);
    rect(xcor, 550, 100, 180);
    textSize(16);
    if (i<s.numEmployees()) {
      fill(#FF0000);
      Employee temp=s.getEmployee(i);
      text(temp.getName(), xcor+5, 570);
      fill(#C0392B);
      text("Satisfaction", xcor+5, 595);
      fill(255);
      text(temp.getSatisfaction(), xcor+5, 615);
      i++;
    }
    xcor+=122;
  }
}

void runIndividualStore(Store s) {
  setupIndividualStore(s);
  fill(#030939);
  text(dollarToStr(empire.getBudget()), 610, 40);
}

void checkStoreButtons() {
  int i=0;
  int xcor=35;//of size 100 w/ 25 spacing
  int ycor=200;
  textSize(20);
  while (i<empire.size()) {
    if (overButton(xcor, ycor, 100, 100)) {
      state=4;
      currStore=empire.getStore(i);
      setupIndividualStore(currStore);
      return;
    }
    xcor+=130;
    if (i==4) {
      ycor=350;
      xcor=35;
    }
    i++;
  }
}
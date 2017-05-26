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
 
 3=empire
 ...
 ****state variables*/


//*****Minigame variables
ALDeque<Order> _orders=new ALDeque<Order>();
ArrayList<Integer> burgerTimes = new ArrayList <Integer>(); 
int miniTime=0;//time variable
int y=170;//for printing orders
Order currOrder = new Order();
int placeForFood=500;//where you add food to
int currOrdNum=1;//which order currently on
float cash=0;

boolean bunClick=false;

//printing time
int realTime=0;
int counterT=0;
//images
PImage tomato;
PImage lettuce;
PImage patty;
PImage bun;
PImage topbun;
PImage cheese;
//****Minigame variables

/*********EMPIRE VARIABLES************/
Empire empire;
int totalTime;
int timeAction; //for each action

double storeCost=50000; //store cost * random multiplier

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
    if (overButton(50,50,100,75)) {
      state=2;
      emp = loadImage ("main.png"); 
  image (emp, 0, 0);
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


//MINI GAME STUFF
void setupMinigame() {
  miniTime=0;
  background(150);
  fill(0);
  rect(0, 0, 750, 100);
  fill(255);
  textSize(32);
  text("Revenue:", 20, 40);
  rect(600, 100, 150, 650); 
  fill(0);
  text("Orders", 620, 150);
  drawButtons();

  //time
  fill(255);
  textSize(32);
  text("Time:", 620, 40);
}




void drawMinigame() {
  loadOrders();
  miniTime+=1;
  counterT+=1;

  if (counterT==60) {
    fill(0);
    rect(615, 48, 100, 40);
    counterT=0;
    realTime+=1;
    for (int i = 0; i < burgerTimes.size(); i ++ ) { 
      burgerTimes.set (i, burgerTimes.get (i) + 1);
    } 
    fill(255);
    textSize(28);    
    text(realTime, 620, 70);
  }
  if (miniTime % 11 == 0) {
    burgerTimes.add (0, new Integer (0));
  } 
  fill(0);
  rect(40, 50, 100, 40);
  fill(#00FF00);
  textSize(24);
  String cashStr=""+cash;
  cashStr=cashStr.substring(0, cashStr.indexOf(".")+2);
  if (cashStr.length()-cashStr.indexOf(".")==2) {
    cashStr+="0";
  }
  text("$"+cashStr, 45, 75);
  if (currOrdNum > 10) {
    fill(255);
    rect(35, 530, 135, 50);
    fill (0); 
    textSize(20); 
    text("Finish game", 45, 565);
  }
}


void buttons() {
  if (overButton(35, 365, 110, 50)) {

    //fill(#F4A460);
    //ellipse(375, placeForFood, 200, 65);

    if (bunClick==false){
          bun = loadImage("bun.png");
    image(bun, 300, placeForFood+20);    
    currOrder.add(new Bun());
    }
    else{
      ///FOR THE TOP BUN
    topbun = loadImage("topbun.png");
    image(topbun, 300, placeForFood+20); 
    }
    placeForFood-=50;
    bunClick=true;
  }
  if (overButton(35, 300, 110, 50)) {
    // fill(#8B5A2B);
    // ellipse(375, placeForFood, 200, 65);
    patty = loadImage("burger.png");
    image(patty, 300, placeForFood+35);   
    currOrder.add(new Patty());
    placeForFood-=25;
  }
  if (overButton(35, 235, 110, 50)) {
    // fill(#FFD700);
    //ellipse(375, placeForFood, 200, 65);
    cheese = loadImage("cheese.png");
    image(cheese, 300, placeForFood+55);
    currOrder.add(new Cheese());
    placeForFood-=10;
  }
  if (overButton(35, 170, 110, 50)) {
    //fill(#00FF00);
    //ellipse(375, placeForFood, 200, 65);
    lettuce = loadImage("lettuce.png");
    image(lettuce, 300, placeForFood+35);
    currOrder.add(new Lettuce());
    placeForFood-=20;
  }
  if (overButton(35, 105, 110, 50)) {
    //fill(#FF0000);
    //ellipse(375, placeForFood, 200, 65);
    tomato = loadImage("tomato.png");
    image(tomato, 300, placeForFood+35);    
    currOrder.add(new Tomato());
    placeForFood-=30;
  }
}

void loadOrders() {
  if (miniTime%600==0 && miniTime<6000) {
    //holds place in the substring
    fill(0);
    int place=0;
    _orders.addLast(new Order(4)); 
    textSize(12);
    //gets most recent order
    String currOrder=_orders.peekLast().toString();
    //text is added in subsets of 18 characters so it doesnt go off the screen
    text ((miniTime/600+1)+". "+currOrder.substring(place, place+18), 620, y);
    place+=18;
    y+=20;
    while (place<currOrder.length()-18) {
      text(currOrder.substring(place, place+18), 620, y);
      place+=18;
      y+=20;
    }
    text(currOrder.substring(place), 620, y);
    y+=20;
    if ((y-170)%60!=0) {
      y+=20;
    }
  }
}

void drawButtons() {
  textSize(26);
  fill(#F4A460);//sandybrown
  rect(35, 365, 110, 50);//subtract 65 for height of each one
  fill(#8B5A2B);//tan 4
  rect(35, 300, 110, 50);
  fill(#FFD700);//gold 1
  rect(35, 235, 110, 50);
  fill(#00FF00);//lime
  rect(35, 170, 110, 50);
  fill(#FF0000);//red 1
  rect(35, 105, 110, 50);
  fill(255);
  rect(35, 430, 110, 50);
  fill(0);
  text("Bun", 45, 400);
  text("Patty", 45, 335);
  text("Cheese", 45, 270);
  text("Lettuce", 45, 205);
  text("Tomato", 45, 140);
  text("Finish", 45, 465);
}

void checkOrder() {
  bunClick=false;
  if (!_orders.isEmpty()&&overButton(35, 430, 110, 50)) {
    if (_orders.peekFirst().equals(currOrder)) {
      if (burgerTimes.get(0) > 11) { 
        double decrease = (burgerTimes.get(0) - 11) * 0.1; 
        double realPrice = _orders.pollFirst().getPrice() - decrease; 
        if (realPrice < 0) { 
          realPrice = 0;
        } 
        cash += realPrice; 
        burgerTimes.remove(0);
      } else { 
        cash+=_orders.pollFirst().getPrice();
      }
      strokeWeight(1);
      //to cross out orders
      fill(0);
      text("-----------------", 620, 170+(currOrdNum-1)*60);
      text("-----------------", 620, 190+(currOrdNum-1)*60);
      text("-----------------", 620, 210+(currOrdNum-1)*60);
      currOrdNum+=1;
    }
    currOrder=new Order();
    placeForFood=500;
    fill(150);
    strokeWeight(0);
    rect(146, 101, 450, 650);
    strokeWeight(1);
  }
}

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
  text(""+dollarToStr(empire.getBudget()), 340, 150);

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
  rect(50,50,100,75);
  textSize(20);
  fill(0);
  text("Buy Store", 45, 680);
  text("Back",55,85);
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
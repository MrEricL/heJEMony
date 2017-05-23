import java.util.ArrayList; 
//****state variables
int state=0;
boolean hasBeenSetUp;

PImage img;
/* 0=starter scren
1= minigame

2=empire
...
****state variables*/


//*****Minigame variables
ALDeque<Order> _orders=new ALDeque<Order>();
ArrayList<Integer> burgerTimes = new ArrayList <Integer>(); 
int time=0;//time variable
int y=170;//for printing orders
Order currOrder = new Order();
int placeForFood=500;//where you add food to
int currOrdNum=1;//which order currently on
float cash=0;

//printing time
int realTime=0;
int counterT=0;
//images
PImage tomato;
PImage lettuce;
PImage patty;
PImage bun;
PImage cheese;
//****Minigame variables


void setup() {
  size(750,750);
  state=0;
  if (state==0) {
    img = loadImage("hegemony splash art.png");
    image(img,0,0);
  }
  else if (state==1) {
    setupMinigame();
  }
}

void draw() {
  if (state==1 && !hasBeenSetUp) {
    setupMinigame();
    hasBeenSetUp=true;
  }
  else if (state==1 && hasBeenSetUp) {
    drawMinigame();
  }
  else if (state==0) drawMenu();
}


// MENU STUFF

void drawMenu(){
  noStroke();
  noFill();
  rect(21,290,185,106); 
  rect(253,290,185,106);  
  rect(21,463,185,106);   
  rect(253,463,185,106);   
  
}
boolean overButton1(int x, int y, int width, int height){
   if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
  
  
}
// END MENU STUFF



void setupMinigame() {
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
  time+=1;
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
  if (time % 11 == 0){
    burgerTimes.add (new Integer (0)); 
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
}

void timeP() {
}

void mouseClicked() {
  if (state==1){
  if (currOrder.size()<9) {
    buttons();
  }
  checkOrder();
  }
  
  //IF YOU CLICK PLAY BUTTON ON MENU
  if (state==0){
      if (overButton1(21,290,185,106)) {
    setupMinigame();
    state=1;
  }
  }
  //END MENU PLAY
}

void buttons() {
  if (overButton(35, 365, 110, 50)) {
    //fill(#F4A460);
    //ellipse(375, placeForFood, 200, 65);
    bun = loadImage("bun.png");
    image(bun, 300, placeForFood+20);    
    currOrder.add(new Bun());
    placeForFood-=50;
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
  if (time%600==0 && time<6000) {
    //holds place in the substring
    fill(0);
    int place=0;
    _orders.addLast(new Order(4)); 
    textSize(12);
    //gets most recent order
    String currOrder=_orders.peekLast().toString();
    //text is added in subsets of 18 characters so it doesnt go off the screen
    text ((time/600+1)+". "+currOrder.substring(place, place+18), 620, y);
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
  if (!_orders.isEmpty()&&overButton(35, 430, 110, 50)) {
    if (_orders.peekFirst().equals(currOrder)) {
      if (burgerTimes.get(0) > 10*currOrdNum) { 
        double decrease = (burgerTimes.get(0) - 10*currOrdNum) * 0.1; 
        double realPrice = _orders.pollFirst().getPrice() - decrease; 
        if (realPrice < 0) { 
          realPrice = 0; 
        } 
        cash += realPrice; 
        burgerTimes.remove(0); 
      } 
      else { 
      cash+=_orders.pollFirst().getPrice();}
      /*fill(#00FF00);
       textSize(16);
       text(currOrdNum, 30+currOrdNum*8, 55);*/
      /*else {
       fill(#FF0000);
       textSize(16);
       text(currOrdNum, 30+currOrdNum*8, 55);
       }*/
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
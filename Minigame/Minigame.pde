ALDeque<Order> _orders=new ALDeque<Order>();
int time=0;//time variable
int y=170;//for printing orders
Order currOrder = new Order();
int placeForFood=500;//where you add food to
int currOrdNum=1;//which order currently on

//printing time
int realTime=0;
int counterT=0;


//images
PImage tomato;
PImage lettuce;
PImage patty;
PImage bun;
PImage cheese;


void setup() {
  size(750, 750);
  background(150);
  fill(0);
  rect(0, 0, 750, 100);
  fill(255);
  textSize(32);
  text("Correct:", 20, 40);
  rect(600, 100, 150, 650); 
  fill(0);
  text("Orders", 620, 150);
  drawButtons();
  
  //time
    fill(255);
  textSize(32);
  text("Time:", 620, 40);

}


void draw() {
  loadOrders();
  time+=1;
  counterT+=1;
  if (counterT==60){
    fill(0);
    rect(615,50,100,40);
    counterT=0;
    realTime+=1;
    fill(255);
  textSize(28);    
    text(realTime,620,70);
  }

}

void timeP(){

  
}

void mouseClicked() {
  if (currOrder.size()<9) {
  buttons(); }
  checkOrder();
}

void buttons() {
  if (overButton(35, 365, 110, 50)) {
    //fill(#F4A460);
    //ellipse(375, placeForFood, 200, 65);
    bun = loadImage("bun.png");
    image(bun,300,placeForFood+10);    
    currOrder.add(new Bun());
    placeForFood-=65;
  }
  if (overButton(35, 300, 110, 50)) {
   // fill(#8B5A2B);
   // ellipse(375, placeForFood, 200, 65);
    patty = loadImage("burger.png");
    image(patty,300,placeForFood+35);   
    currOrder.add(new Patty());
    placeForFood-=25;
  }
  if (overButton(35, 235, 110, 50)) {
   // fill(#FFD700);
    //ellipse(375, placeForFood, 200, 65);
        cheese = loadImage("cheese.png");
    image(cheese,300,placeForFood+55);
    currOrder.add(new Cheese());
    placeForFood-=10;
  }
  if (overButton(35, 170, 110, 50)) {
    //fill(#00FF00);
    //ellipse(375, placeForFood, 200, 65);
    lettuce = loadImage("lettuce.png");
    image(lettuce,300,placeForFood+35);
    currOrder.add(new Lettuce());
    placeForFood-=20;
  }
  if (overButton(35, 105, 110, 50)) {
    //fill(#FF0000);
    //ellipse(375, placeForFood, 200, 65);
    tomato = loadImage("tomato.png");
    image(tomato,300,placeForFood+30);    
    currOrder.add(new Tomato());
    placeForFood-=35;
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
    if (_orders.pollFirst().equals(currOrder)) {
      fill(#00FF00);
      textSize(16);
      text(currOrdNum, 30+currOrdNum*8, 55);
    } else {
      fill(#FF0000);
      textSize(16);
      text(currOrdNum, 30+currOrdNum*8, 55);
    }
    currOrder=new Order();
    placeForFood=700;
    fill(150);
    strokeWeight(0);
    rect(146, 101, 450, 650);
    strokeWeight(1);
    //to cross out orders
    fill(0);
    text("-----------------", 620, 170+(currOrdNum-1)*60);
    text("-----------------", 620, 190+(currOrdNum-1)*60);
    text("-----------------", 620, 210+(currOrdNum-1)*60);
    currOrdNum+=1;
  }
}

boolean overButton(int x, int y, int width, int height) {
  return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
}
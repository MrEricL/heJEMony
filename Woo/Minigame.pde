//*****Minigame variables
ALDeque<Order> _orders;//=new ALDeque<Order>();
ArrayList<Integer> burgerTimes; //list of times so that if you take over 11 seconds to make an order you make less $
int miniTime;//time variable
int y;//for printing orders
Order currOrder;//current order to be built up
int placeForFood;//where you add food to
int currOrdNum;//which order currently on
float cash;//total money

int bunClick;//used for deciding b/w top and bottom bun image
boolean played=false;

//printing time
int realTime=0;
int counterT=0;
//images
PImage tomato;
PImage lettuce;
PImage patty;
PImage XYZ;//bottom bun
PImage ABC;//top bun
PImage cheese;
//****Minigame variables

//MINI GAME STUFF
void setupMinigame() {
  cash=0;
  placeForFood=500;
  bunClick=0;
  _orders=new ALDeque<Order>();
  burgerTimes = new ArrayList <Integer>(); 
  currOrder=new Order();
  y=185;
  miniTime=0;

  strokeWeight(0);
  XYZ = loadImage("bun.png");
  ABC = loadImage("topbun.png");
  patty = loadImage("burger.png");

  cheese = loadImage("cheese.png");
  lettuce = loadImage("lettuce.png");
  tomato = loadImage("tomato.png");
  currOrdNum=1;
  realTime=0;
  counterT=0;
  y=185;
  miniTime=0;
  background(150);
  fill(0);
  rect(0, 0, 750, 100);
  fill(255);
  textSize(32);
  text("Revenue:", 20, 40);
  rect(550, 100, 200, 750); 
  fill(0);
  text("Orders", 570, 150);
  drawButtons();

  //time
  fill(255);
  textSize(32);
  text("Time:", 620, 40);
}



//various chunks of code that update your total money, the time, etc.
void drawMinigame() {

  loadOrders();
  miniTime+=1;
  counterT+=1;

  if (counterT==60) {
    fill(0);
    rect(615, 48, 100, 40);//rectangle for timer
    counterT=0;
    realTime+=1;
    for (int i = 0; i < burgerTimes.size(); i ++ ) { 
      burgerTimes.set (i, burgerTimes.get (i) + 1);
    } 
    //System.out.println(burgerTimes);
    fill(255);
    textSize(28);    
    text(realTime, 620, 70);//prints time
  }
  fill(0);
  rect(40, 50, 100, 40);//total cash rectangle
  rect(160, 50, 300, 40);//burger price rectangle
  fill(#00FF00);
  textSize(24);

  //**prints price of current order
  double realPrice=0;
  if (_orders.size()>0&&burgerTimes.get(0) > 11) { 
    double decrease = (burgerTimes.get(0) - 11) * 0.1; 
    realPrice = _orders.peekFirst().getPrice() - decrease; 
    if (realPrice < 0) { 
      realPrice = 0;
    }
    text("Burger Price: "+dollarToStr(realPrice), 165, 75);
  } else if (_orders.size()>0)
    text("Burger Price: "+dollarToStr(_orders.peekFirst().getPrice()), 165, 75);
  //**end of code printing price of current order


  String cashStr=""+cash;
  cashStr=cashStr.substring(0, cashStr.indexOf(".")+2);
  if (cashStr.length()-cashStr.indexOf(".")==2) {
    cashStr+="0";
  }
  text("$"+cashStr, 45, 75);
  if (currOrdNum > 10 || played) {
    fill(255);
    rect(35, 530, 135, 50);
    fill (0); 
    textSize(20); 
    text("Finish game", 45, 565);
    played=true;
  }
}


void buttons() {
  if (overButton(35, 365, 110, 50)) {

    //fill(#F4A460);
    //ellipse(375, placeForFood, 200, 65);

    if (bunClick==0) {
      //System.out.println(bunClick);
      image(XYZ, 245, placeForFood+20);    
      currOrder.add(new Bun());
    } else {
      ///FOR THE TOP BUN

      image(ABC, 245, placeForFood+20); 
      currOrder.add(new Bun());
    }
    placeForFood-=50;
    bunClick=1;
    //System.out.println(bunClick);
  }
  if (overButton(35, 300, 110, 50)) {
    // fill(#8B5A2B);
    // ellipse(375, placeForFood, 200, 65);

    image(patty, 245, placeForFood+35);   
    currOrder.add(new Patty());
    placeForFood-=25;
  }
  if (overButton(35, 235, 110, 50)) {
    // fill(#FFD700);
    //ellipse(375, placeForFood, 200, 65);

    image(cheese, 245, placeForFood+55);
    currOrder.add(new Cheese());
    placeForFood-=10;
  }
  if (overButton(35, 170, 110, 50)) {
    //fill(#00FF00);
    //ellipse(375, placeForFood, 200, 65);

    image(lettuce, 245, placeForFood+35);
    currOrder.add(new Lettuce());
    placeForFood-=20;
  }
  if (overButton(35, 105, 110, 50)) {
    //fill(#FF0000);
    //ellipse(375, placeForFood, 200, 65);

    image(tomato, 245, placeForFood+35);    
    currOrder.add(new Tomato());
    placeForFood-=30;
  }
}


//prints orders on side
void printOrders(int linelength) {
  // len 22 
  // number + period + space
  // len 19

  String currOrder=_orders.peekLast().toString();
  String ret="";
  int index=0;
  while (index < currOrder.length()) {
    if (currOrder.substring(index, index+1).equals(" "));
    else ret+=currOrder.substring(index, index+1);
    index+=1;
  }
  //ret = ret.substring (0,1)+ret.substring(2,ret.length());
  String[] retA = ret.split(",");
  index=0;
  int linespacing=0; //how many
  ret="";//resets the thing
  ret+=(miniTime/600+1)+". ";
  textSize(15);

  while (index < retA.length) {
    int len = retA[index].length()+2; //length plus comma and space
    if (linespacing+len+2 > linelength) {
      text(ret, 565, y);
      linespacing=0;
      y+=25;
      ret="";
    }
    ret+=retA[index];
    ret+=", ";
    linespacing+=len;
    index++;
  }
  ret=ret.substring(0, ret.length()-2);
  text(ret, 565, y);//last time
  y+=30;
}

//generates new orders
void loadOrders() {
  if (miniTime%600==0 && miniTime<6000) {
    //holds place in the substring
    fill(0);
    int place=0;
    _orders.addLast(new Order(4));
    burgerTimes.add (new Integer (0));//burger time corresponding to new order
    printOrders(25);
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
  //bunClick=0;
  if (!_orders.isEmpty()&&overButton(35, 430, 110, 50)) {//if over finish button
    bunClick=0;
    if (_orders.peekFirst().equals(currOrder)) {//if order is correct
      if (burgerTimes.get(0) > 11) { //if you took too long the money you make decreases
        double decrease = (burgerTimes.get(0) - 11) * 0.1; 
        double realPrice = _orders.pollFirst().getPrice() - decrease; 
        if (realPrice < 0) { 
          realPrice = 0;
        } 
        cash += realPrice;
      } else { 
        cash+=_orders.pollFirst().getPrice();
      }
      burgerTimes.remove(0);
      //strokeWeight(1);
      //to cross out orders
      System.out.println(186+(currOrdNum-1)*55);
      fill(0);
      text("-----------------", 575, 186+(currOrdNum-1)*55);
      text("-----------------", 575, 213+(currOrdNum-1)*55);

      currOrdNum+=1;
      //System.out.println(currOrdNum);

    }
    currOrder=new Order();
    placeForFood=500;
    fill(150);
    strokeWeight(0);
    rect(146, 101, 400, 650);
    //strokeWeight(1);
  }
}
//*****Minigame variables
ALDeque<Order> _orders=new ALDeque<Order>();
ArrayList<Integer> burgerTimes = new ArrayList <Integer>(); 
int miniTime=0;//time variable
int y=185;//for printing orders
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

//MINI GAME STUFF
void setupMinigame() {
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
    image(bun, 245, placeForFood+20);    
    currOrder.add(new Bun());
    }
    else{
      ///FOR THE TOP BUN
    topbun = loadImage("topbun.png");
    image(topbun, 245, placeForFood+20); 
    }
    placeForFood-=50;
    bunClick=true;
  }
  if (overButton(35, 300, 110, 50)) {
    // fill(#8B5A2B);
    // ellipse(375, placeForFood, 200, 65);
    patty = loadImage("burger.png");
    image(patty, 245, placeForFood+35);   
    currOrder.add(new Patty());
    placeForFood-=25;
  }
  if (overButton(35, 235, 110, 50)) {
    // fill(#FFD700);
    //ellipse(375, placeForFood, 200, 65);
    cheese = loadImage("cheese.png");
    image(cheese, 245, placeForFood+55);
    currOrder.add(new Cheese());
    placeForFood-=10;
  }
  if (overButton(35, 170, 110, 50)) {
    //fill(#00FF00);
    //ellipse(375, placeForFood, 200, 65);
    lettuce = loadImage("lettuce.png");
    image(lettuce, 245, placeForFood+35);
    currOrder.add(new Lettuce());
    placeForFood-=20;
  }
  if (overButton(35, 105, 110, 50)) {
    //fill(#FF0000);
    //ellipse(375, placeForFood, 200, 65);
    tomato = loadImage("tomato.png");
    image(tomato, 245, placeForFood+35);    
    currOrder.add(new Tomato());
    placeForFood-=30;
  }
}


//used for managing the thing
void printOrders(int linelength){
  // len 22 
  // number + period + space
  // len 19

  String currOrder=_orders.peekLast().toString();
  String ret="";
  int index=0;
  while (index < currOrder.length()){
    if (currOrder.substring(index,index+1).equals(" "));
    else ret+=currOrder.substring(index,index+1);
    index+=1;
  }
  //ret = ret.substring (0,1)+ret.substring(2,ret.length());
  String[] retA = ret.split(",");
  index=0;
  int linespacing=0; //how many
  ret="";//resets the thing
  ret+=(miniTime/600+1)+". ";
  textSize(15);

  while (index < retA.length){
    int len = retA[index].length()+2; //length plus comma and space
    if (linespacing+len+2 > linelength){
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
  ret=ret.substring(0,ret.length()-2);
      text(ret, 565, y);//last time
      y+=30;

}

///

void loadOrders() {
  if (miniTime%600==0 && miniTime<6000) {
    //holds place in the substring
    fill(0);
    int place=0;
    _orders.addLast(new Order(4)); 
    printOrders(25);
/*
    textSize(13);
    //gets most recent order
    String currOrder=_orders.peekLast().toString();
    //text is added in subsets of 18 characters so it doesnt go off the screen
    text ((miniTime/600+1)+". "+currOrder.substring(place, place+18), 565, y);
    place+=18;
    y+=20;
    System.out.println(currOrder);
    while (place<currOrder.length()-18) {
      text(currOrder.substring(place, place+18), 620, y);
      place+=18;
      y+=20;
    }
    text(currOrder.substring(place), 620, y);
    y+=20;
    if ((y-170)%60!=0) {
      y+=20;
    }*/
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
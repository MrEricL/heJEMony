ALDeque<Order> _orders=new ALDeque<Order>();
int time=0;//time variable
int y=170;//for printing orders
Order currOrder = new Order();
int placeForFood=700;

void setup() {
  size(750, 750);
  background(150);
  fill(0);
  rect(0, 0, 750, 100);
  fill(255);
  rect(600, 100, 150, 650); 
  textSize(32);
  fill(0);
  text("Orders", 620, 150);
  drawButtons();
}


void draw() {
  loadOrders();
  time+=1;
}

void mouseClicked() {
  if (overButton(35, 365, 110, 50)) {
    fill(#F4A460);
    ellipse(375, placeForFood, 200, 65);
    currOrder.add(new Bun());
    placeForFood-=65;
  }
  if (overButton(35, 300, 110, 50)) {
    fill(#8B5A2B);
    ellipse(375, placeForFood, 200, 65);
    currOrder.add(new Patty());
    placeForFood-=65;
  }
  if (overButton(35, 235, 110, 50)) {
    fill(#FFD700);
    ellipse(375, placeForFood, 200, 65);
    currOrder.add(new Cheese());
    placeForFood-=65;
  }
  if (overButton(35, 170, 110, 50)) {
    fill(#00FF00);
    ellipse(375, placeForFood, 200, 65);
    currOrder.add(new Lettuce());
    placeForFood-=65;
  }
  if (overButton(35, 105, 110, 50)) {
    fill(#FF0000);
    ellipse(375, placeForFood, 200, 65);
    currOrder.add(new Tomato());
    placeForFood-=65;
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
  fill(0);
  text("Bun", 45, 400);
  text("Patty", 45, 335);
  text("Cheese", 45, 270);
  text("Lettuce", 45, 205);
  text("Tomato", 45, 140);
}

boolean overButton(int x, int y, int width, int height) {
  return (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height);
}
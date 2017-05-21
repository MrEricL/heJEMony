ALDeque<Order> _orders=new ALDeque<Order>();
int time=0;//time variable
int y=170;//for printing orders

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
}


void draw() {
  loadScreen();
  time+=1;
}

void loadScreen() {
    if (time%600==0 && time<6000) {
    //holds place in the substring
    int place=0;
    _orders.addLast(new Order(4));
    textSize(12);
    //gets most recent order
    String currOrder=_orders.peekLast().toString();
    //text is added in subsets of 18 characters so it doesnt go off the screen
    text ((time/600+1)+". "+currOrder.substring(place,place+18), 620, y);
    place+=18;
    y+=20;
    while (place<currOrder.length()-18) {
      text(currOrder.substring(place,place+18),620,y);
      place+=18;
      y+=20;
    }
    text(currOrder.substring(place),620,y);
    y+=20;
  }
  
}
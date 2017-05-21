ALDeque<Order> _orders=new ALDeque<Order>();
int time=0;
int y=170;

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
  if (time%600==0 && time<6000) {
    int place=0;
    _orders.addLast(new Order(4));
    textSize(12);
    String currOrder=_orders.peekLast().toString();
    text ((time/600+1)+". "+currOrder.substring(place,place+19), 620, y);
    place+=19;
    y+=20;
    while (place<currOrder.length()-19) {
      text(currOrder.substring(place,place+19),620,y);
      place+=19;
      y+=20;
    }
    text(currOrder.substring(place),620,y);
    y+=20;
  }
  time+=1;
}
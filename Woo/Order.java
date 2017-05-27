public class Order {
  private ALQueue<Food> _order;
  private double price;

  public Order() {
    _order=new ALQueue<Food>();
  }

  public int size() {
    return _order.size();
  }
  public void add(Food f) {
    _order.enqueue(f);
  }
  
  public double getPrice() {
    return price;
  }
  public Order (int items) {
    _order=new ALQueue<Food>();
    _order.enqueue (new Bun());
    for (int i = 0; i < items; i ++ ) {
      Food f = randomFood();
      price+=f.getCost();
      _order.enqueue (f);
    }
    price+=3;
    _order.enqueue (new Bun());
  } 

  private static Food randomFood () {
    int number = (int) (Math.random () * 4 + 1); 
    if (number == 1) {
      return new Patty();
    } else if (number == 2) {
      return new Cheese();
    } else if (number == 3) {
      return new Lettuce();
    } else {
      return new Tomato();
    }
  }

  public String toString () {
    String ret = _order.toString();
    return ret.substring (8, ret.length() -6);
  } 

  public boolean equals(Object c) {
    Order o=(Order) c;
    return this.toString().equals(o.toString());
  }
  
  
} 
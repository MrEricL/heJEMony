public class Order {
  private ALQueue<Food> _order;

  public Order() {
    _order=new ALQueue<Food>();
  }

  void add(Food f) {
    _order.enqueue(f);
  }
  public Order (int items) {
    _order=new ALQueue<Food>();
    _order.enqueue (new Bun());
    for (int i = 0; i < items; i ++ ) {
      _order.enqueue (randomFood());
    }
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
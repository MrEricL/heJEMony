public abstract class Food {

    protected String _name;
    protected int _num;
    protected double _cost;

    public int num() {
	return _num;
    }
    public String name() {
	return _name;
    }

    public String toString() {
	return _name;
    }
    
    public double getCost() {
      return _cost;
    }
}
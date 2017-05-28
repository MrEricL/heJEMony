public class Employee {
  private String _name;
  private int _satisfaction;

  public Employee(String s) {
    _name=s;
    _satisfaction=5;
  }

  public String getName() {
    return _name;
  }

  public int getSatisfaction() {
    return _satisfaction;
  }
}
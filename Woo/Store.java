import java.util.ArrayList;

public class Store {
  private ArrayList<Employee> _employees;
  private int _customerSatisfaction;//represents number of customers per day
  private int _employeeSatisfaction;//if too low strikes (extra feature)
  private double _salary;//maybe, maybe not
  private double _priceBurger;
  private double _dailyRevenue;//for ease of calculations
  private double _operationsCost;//cost of operations per cycle
  private String _name;
  private int _timeCreation;
  private static final String[] STORENAMES = {"Burger \nPalace", "Burger\nJoint", "Best\nBurger", "Speedy\nBurgers", "Top\nBurger", "Burger\nVillage", "Burger\nQueen", "Mc-\n-Dlanod", "Still\nCondo", "Blue\nCastle"};
  private static int storePlace=9;

  public Store(int time) {
    _employees=new ArrayList<Employee>();
    hire(new Employee("Bob"));
    _customerSatisfaction=10;
    _salary=10.75;
    _priceBurger=7.50;
    _operationsCost=65;
    int i=(int)(Math.random()*storePlace);
    _name=STORENAMES[i];
    String temp=STORENAMES[i];
    STORENAMES[i]=STORENAMES[storePlace];
    STORENAMES[storePlace]=temp;
    _timeCreation=time;
    storePlace--;
  }

  public void increaseStorePlace() {
    storePlace++;
  }

  public String getName() {
    return _name;
  }

  public Employee getEmployee(int i) {
    return _employees.get(i);
  }

  public int numEmployees() {
    return _employees.size();
  }

  public void modCustomerSatisfaction(int i) {
    _customerSatisfaction+=i;
  }

  public void modEmployeeSatisfaction(int i) {
    _employeeSatisfaction+=i;
  }

  public void setDailyRevenue() {
    _dailyRevenue= 4*numEmployees()*(_customerSatisfaction*_priceBurger-numEmployees()*_salary-_operationsCost);
  }

  public double getDailyRevenue() {
    return _dailyRevenue;
  }

  public void hire(Employee e) {
    _employees.add(e);
  }

  public void fire(int i) {
    _employees.remove(i);
  }


  public void setSalary(double s) {
    _salary=s;
  }

  public double getSalary() {
    return _salary;
  }

  public void setPrice (double s) {
    _priceBurger=s;
  }

  public double getPrice() {
    return _priceBurger;
  }

  public boolean areCustomersHappy() {
    return ((double)_employees.size()/_customerSatisfaction)>=(1.0/20);
  }

  public void increaseOperationsCost() {
    _operationsCost+=.2;
  }
  
  public double getOperationsCost() {
    return _operationsCost;
  }
  
  public int getCreationTime() {
    return _timeCreation;
  }
  
  public void lowerEmployeeSatisfaction() {
    for (Employee e:_employees) {
      e.decreaseSatisfaction();
    }
  }
}
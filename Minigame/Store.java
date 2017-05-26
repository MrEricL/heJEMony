import java.util.ArrayList;

public class Store {
  private ArrayList<Employee> _employees;
  private int _customerSatisfaction;//represents number of customers per day
  private int _employeeSatisfaction;//if too low strikes (extra feature)
  private double _salary;//maybe, maybe not
  private double _priceBurger;
  private double _dailyRevenue;//for ease of calculations

  public Store() {
    _employees=new ArrayList<Employee>();
    hire(new Employee("Bob"));
    _customerSatisfaction=3;
    _salary=10.75;
    _priceBurger=7.50;
  }

  public void setDailyRevenue() {
    _dailyRevenue= 20*(_customerSatisfaction*_priceBurger-_employees.size()*_salary);
  }

  public double getDailyRevenue() {
    return _dailyRevenue;
  }

  public void hire(Employee e) {
    _employees.add(e);
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
}
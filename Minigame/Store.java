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
	_customerSatisfaction=10;
	_salary=8.75;
	_priceBurger=7.50;
    }

    public void setDailyRevenue() {
	_dailyRevenue= _customerSatisfaction*10*_priceBurger-_employees.size()*_salary;
    }
    
    public double getDailyRevenue() {
	return _dailyRevenue;
    }

    public void hire(Employee e) {
	_employees.add(e);
    }


}

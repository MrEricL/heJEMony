public class Employee {
    private String _name;
    private int _satisfaction;
    private double _salary;

    public Employee(String s) {
	_name=s;
	_satisfaction=6;
	_salary=10.75;
    }

    public String getName() {
	return _name;
    }

    public int getSatisfaction() {
	return _satisfaction;
    }
  
    public void decreaseSatisfaction() {
	_satisfaction--;
    }
  
    public void modSatisfaction(int i) {
	_satisfaction+=i;
    }

    public double getSalary() {
	return _salary;
    }

    public void modSalary(double d) {
	_salary+=d;
    }
}

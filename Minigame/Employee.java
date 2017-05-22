public class Employee {
    private String _name;
    private int _satisfaction;

    public Employee(String s) {
	_name=s;
    }

    public String getName() {
	return _name;
    }

    public String getSatisfaction() {
	return _satisfaction;
    }
}
import java.util.ArrayList;

public class Store {
    private ArrayList<Employee> _employees;
    private int _customerSatisfaction;//represents number of customers per day
    private int _employeeSatisfaction;//if too low strikes (extra feature)
    private double _salary;//maybe, maybe not
    private double _priceBurger;//ended up not using
    private double _dailyRevenue;//for ease of calculations
    private double _operationsCost;//cost of operations per cycle
    private String _name;//name of store
    private int _timeCreation;//time of creation, for timing functions like lowering satisfaction
    private boolean _strike;//if on strike or not
    private static final String[] EMPLOYEENAMES={"Eric", "Jenny", "Matteo", "Topher", "Brian", "Kevin", "Donald", "John", "Matthew", "Chris", "Carl", "Jonas"};
    private static final String[] STORENAMES = {"Burger \nPalace", "Burger\nJoint", "Best\nBurger", "Speedy\nBurgers", "Top\nBurger", "Burger\nVillage", "Burger\nQueen", "Mc-\n-Dlanod", "Still\nCondo", "Blue\nCastle"};
    private static int storePlace=9;//last index of STORENAMES
    private int adType;//0=no ad, 1=price, 2=patty quality

    public Store(int time) {
	_employees=new ArrayList<Employee>();
	adType=0;
	_strike=false;
	hire(new Employee("Bob"));//first employee
	_customerSatisfaction=10;
	_salary=10.75;
	_priceBurger=7.50;
	_operationsCost=65;
	//get random name for store
	int i=(int)(Math.random()*storePlace);
	_name=STORENAMES[i];
    
    }

    public void increaseStorePlace() {
	storePlace++;
    }

    //access name
    public String getName() {
	return _name;
    }
    //access specific employee
    public Employee getEmployee(int i) {
	return _employees.get(i);
    }

    public int numEmployees() {
	return _employees.size();
    }

    //average employee satisfaction
    public int getEmployeeSatisfaction() {
	int r=0;
	for (Employee e : _employees) {
	    r+=e.getSatisfaction();
	}
	if (_employees.size() == 0){ //check against division by zero
	    return 0; 
	} 
	return r/_employees.size();
    }

    //turn on strike
    public void onStrike() {
	_strike=true;
    }

    public void endStrike() {
	_strike=false;
    }

    //give employees a raise
    public void raise(double d) {
	for (Employee e : _employees)
	    e.modSalary(d);
	increaseEmployeeSatisfaction(3);
    }

    public void modCustomerSatisfaction(int i) {
	_customerSatisfaction+=i;
    }

    public int getCustomerSatisfaction () { 
	return _customerSatisfaction;
    } 

    public void modEmployeeSatisfaction(int i) {
	_employeeSatisfaction+=i;
    }

    public void setDailyRevenue(Farm f) {//arbitrary mathemtical formula that seems to work for making cash
	if (striking())
	    _dailyRevenue=-(getSalary());
	else
	    _dailyRevenue= (f.getCostPerPatty()*7)*numEmployees()*(_customerSatisfaction*_priceBurger-getSalary()-_operationsCost);
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
	double ret=0;
	for (Employee e : _employees)
	    ret+=e.getSalary();
	return ret;
    }

    public void setPrice (double s) {
	_priceBurger=s;
    }

    public double getPrice() {
	return _priceBurger;
    }

    public boolean areCustomersHappy() {
	if (_customerSatisfaction>0) {
	    return ((double)_employees.size()/_customerSatisfaction)>=(1.0/20);
	} else
	    return true;//ratio is true
    }

    public void increaseOperationsCost() {
	_operationsCost+=.01;
    }

    public double getOperationsCost() {
	return _operationsCost+numEmployees()*_salary;
    }

    public int getCreationTime() {
	return _timeCreation;
    }

    public boolean striking() {
	return _strike;
    }

    public void lowerEmployeeSatisfaction() {//employees get less happy function
	for (Employee e : _employees) {
	    e.decreaseSatisfaction();
	}
    }

    public void increaseEmployeeSatisfaction(int i) {
	for (Employee e : _employees) {
	    e.modSatisfaction(i);
	}
    }

    public void setAd(int i) {
	adType=i;
    }

    public int getAdType() {
	return adType;
    }

    //math to determine if ads r successful
    public double adSuccess(Farm f) {//will take currentFarm from empire
	if (adType==1) {//advertising price
	    return (int)(9/(f.getPercentRealMeat()-.4));//lower percent real meat = lower price
	} else if (adType==2) {
	    return (f.getPercentRealMeat()-.5)*200;
	} else
	    return -1;
    }

    //random name of employee
    public String personName() {
	return EMPLOYEENAMES[(int)(Math.random()*12)];
    }
}

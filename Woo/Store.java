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
    private boolean _strike;
    private static final String[] STORENAMES = {"Burger \nPalace", "Burger\nJoint", "Best\nBurger", "Speedy\nBurgers", "Top\nBurger", "Burger\nVillage", "Burger\nQueen", "Mc-\n-Dlanod", "Still\nCondo", "Blue\nCastle"};
    private static int storePlace=9;
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
	//get random name
	int i=(int)(Math.random()*storePlace);
	_name=STORENAMES[i];
	String temp=STORENAMES[i];
	STORENAMES[i]=STORENAMES[storePlace]; //broken
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
  
    public int getEmployeeSatisfaction() {
	int r=0;
	for (Employee e:_employees) {
	    r+=e.getSatisfaction();
	}
	return r/_employees.size();
    }
  
    public void onStrike() {
	_strike=true;
    }
  
    public void raise(double d) {
	for (Employee e:_employees)
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
	for (Employee e: _employees)
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
	for (Employee e: _employees) {
	    e.modSatisfaction(i);
	}
    }

    public void setAd(int i) {
	adType=i;
    }

    public double adSuccess(Farm f) {//will take currentFarm from empire
	if (adType==1) {//advertising price
	    return (int)(10/f.getPercentRealMeat())*5;//lower percent real meat = lower price
	}
	else if (adType==2) {
	    return (f.getPercentRealMeat()-.4)*20;
	}
	else
	    return -1;
    }
}

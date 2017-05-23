import java.util.ArrayList;

public class Empire {
    private ArrayList<Store> _stores;
    private int _employeeSalary;
    private double _budget;
    private int _totalEmployeeSatisfaction;
    private int _totalCustomerSatisfaction;
    private int _percentMeat;
    private ALQueue<String> _actionsList;
    private Deque<String> _milestones;//will be used as a stack

    public Empire() {
	_stores=new ArrayList<Store>();
    }

    public void buyStore(Store s, double d) {
	_stores.add(s);
	_budget-=d;
    }



}
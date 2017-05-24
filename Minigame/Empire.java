import java.util.ArrayList;

public class Empire {
    private ArrayList<Store> _stores;
    private int _employeeSalary;
    private double _budget;
    private int _totalEmployeeSatisfaction;
    private int _totalCustomerSatisfaction;
    private int _percentMeat;
    private ALQueue<int> _actionsList; //better to have codes + modifiers for different actions 
    //buy store = 1
    private Deque<String> _milestones;//will be used as a stack
    
   

    public Empire() {
	_stores=new ArrayList<Store>(0); 
	_budget=100000;

    }

    public void buyStore(Store s, double d) {
	_stores.add(s);
	_budget-=d;
    }
    //adds to action list
    public void queueBuyStore(){
      _actionsList.get(1);
    }
    
    public int peekActions(){
       return _actionsList.get(0);
      
    }
    
  public int popActions(){
       _actionsList.remove(0);
      
    }

    public double getBudget() {
	return _budget;
    }

    public void modifyBudget(double d) {
	_budget+=d;
    }

    public void runOperations() {
	for (Store s: _stores) {
	    modifyBudget(s.getDailyRevenue());
	}
    }


}
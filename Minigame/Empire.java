import java.util.ArrayList;

public class Empire {
  private ArrayList<Store> _stores;
  private int _employeeSalary;
  private double _budget;
  private int _totalEmployeeSatisfaction;
  private int _totalCustomerSatisfaction;
  private int _percentMeat;
  private ALQueue<Integer> _actionsList; //better to have codes + modifiers for different actions 
  //buy store = 1
  private Deque<String> _milestones;//will be used as a stack



  public Empire() {
    _stores=new ArrayList<Store>(0); 
    _budget=100000;
    _actionsList = new ALQueue <Integer> ();
  }

  public int getTotalEmployeeSatisfaction() {
    return _totalEmployeeSatisfaction;
  }
  
  public int getTotalCustomerSatisfaction() {
    return _totalCustomerSatisfaction;
  }
  
  public void modTotalEmployeeSatisfaction(int i) {
    _totalEmployeeSatisfaction+=i;
  }
  
  public void modTotalCustomerSatisfaction(int i) {
    _totalCustomerSatisfaction+=i;
  }

  public void buyStore(Store s, double d) {
    _stores.add(s);
    _budget-=d;
  }
  //adds to action list
  public void queueBuyStore() {
    _actionsList.enqueue(1);
  }

  public Integer peekActions() {
    return _actionsList.peekFront();
  }

  public int popActions() {
    return _actionsList.dequeue();
  }

  public double getBudget() {
    return _budget;
  }

  public boolean isEmpty() { 
    return _actionsList.isEmpty();
  } 

  public void modifyBudget(double d) {
    _budget+=d;
  }

  public void runOperations() {
    for (Store s : _stores) {
      s.setDailyRevenue();
      modifyBudget(s.getDailyRevenue());
      s.increaseOperationsCost();
      if (s.areCustomersHappy()) {
        s.modCustomerSatisfaction(1);
      }
      else {
        s.modCustomerSatisfaction(-2);
      }
    }
  }

  public int size() {
    return _stores.size();
  }

  public void addAction(int i) {
    _actionsList.enqueue(i);
  }


  public void setBudget(double s) {
    _budget+=s;
  }
}
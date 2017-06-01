import java.util.ArrayList;

public class Empire {
  private ArrayList<Store> _stores;//list of stores
  private int _employeeSalary;//not currently being used
  private double _budget;
  private int _totalEmployeeSatisfaction;//determines strikes
  private int _totalCustomerSatisfaction;//determines revenue
  private ALQueue<Integer> _actionsList; //better to have codes + modifiers for different actions 
  //buy store = 1
  private Deque<String> _milestones;//will be used as a stack
  private int _patties;
  private int[] _pattiesArray; //0=.5, 1=.6,2=.7,3=.8,4=.9,5=1.0
  private ALHeap<Farm> _farmHeap;
  private ArrayList<Farm> _availableFarms;
  private Farm selectedFarm; 


  //constructor, starts you with 100k
  public Empire() {
    _stores=new ArrayList<Store>(0); 
    _budget=100000;
    _actionsList = new ALQueue <Integer> ();
    _availableFarms=new ArrayList<Farm>();
    buildFarmHeap();
    _patties=1000;
    _pattiesArray=new int[6];
    _pattiesArray[0]=1000;
  }

  //takes int of store in list to access
  public Store getStore(int i) {
    return _stores.get(i);
  }
  //takes int of store in list to close
  public void closeStore(int i) {
    _stores.remove(i);
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

  public void buyStore(Store s) {
    _stores.add(s);
  }
  //adds to action list
  public void queueBuyStore(double d) {
    _actionsList.enqueue(10);
    _budget-=d;
  }

  //use action queue begins
  public Integer peekActions() {
    return _actionsList.peekFront();
  }

  public int popActions() {
    return _actionsList.dequeue();
  }
  //use action queue ends

  public double getBudget() {
    return _budget;
  }

  public boolean isEmpty() { 
    return _actionsList.isEmpty();
  } 

  public void modifyBudget(double d) {
    _budget+=d;
  }

  //runs operations, uses time to determine whether employees should get less happy
  public void runOperations(int tNow) {
    for (Store s : _stores) {
      if (_patties==0)
        return;
      s.setDailyRevenue(selectedFarm);
      modifyBudget(s.getDailyRevenue());
      s.increaseOperationsCost();
      if (s.areCustomersHappy()) {
        s.modCustomerSatisfaction(1);
      } else {
        s.modCustomerSatisfaction(-2);
      }
      //System.out.println(tNow-s.getCreationTime());
      if ((tNow-s.getCreationTime())%1800<10) {
        s.lowerEmployeeSatisfaction();
      }
      usePatties(s);
      //patties - customerSatisfaction
    }
  }

  //num stores
  public int size() {
    return _stores.size();
  }

  public void addAction(int i) {
    _actionsList.enqueue(i);
  }


  public void setBudget(double s) {
    _budget+=s;
  }
  //goes through cheapest to most expensive stores and uses patties               
  public void usePatties(Store s) {
    int p=s.getCustomerSatisfaction();
    int i=0;
    while (p>0&&i<6) {//traverse _pattiesArray                                       
      if (_pattiesArray[i]>=p) {
        _pattiesArray[i]-=p;
        _patties-=p;
        p=0;
      } else {
        p-=_pattiesArray[i];
        _patties-=_pattiesArray[i];
        _pattiesArray[i]=0;
      }
      i++;
    }
  }

  public boolean buyPatties (int numPatty, Farm farm) {
    double cost = numPatty * farm.getCostPerPatty ();
    if (_budget >= cost) {
      _budget -= cost;
      _patties += numPatty;
      _pattiesArray[(int)((farm.getPercentRealMeat()-.5)*10)]+=numPatty;
      return true;
    }
    return false;
  } 

  public int getPatties () { 
    return _patties;
  } 



  public ALQueue<Integer> retQ() {
    return _actionsList;
  }

  //builds a farm heap, will use heapsort so you can access them one at a time starting w the least quality
  private void buildFarmHeap() {
    _farmHeap=new ALHeap<Farm>();
    _farmHeap.add(new Farm(.5, "Steroid Patties"));
    _farmHeap.add(new Farm(.6, "Happy Patties"));
    _farmHeap.add(new Farm(.7, "Sunshine Farms"));
    _farmHeap.add(new Farm(.8, "Organic Patties"));
    _farmHeap.add(new Farm(.9, "Grass-fed Cows"));
    _farmHeap.add(new Farm(1, "Freerange Cattle"));
  }
  //basically heapsort granting you access to a new farm
  public void accessNewFarm() {
    _availableFarms.add(_farmHeap.removeMin());
  }

  public int numUnlockedFarms() {
    return _availableFarms.size();
  }

  public Farm getFarm(int i) {
    return _availableFarms.get(i);
  }

  public void toggleAllOtherFarmsChosen(int i) {
    for (int j=0; j<_availableFarms.size(); j++) {
      if (j==i)
        continue;
      else if (_availableFarms.get(j).isChosen())
        _availableFarms.get(j).toggleChosen();
    }
  }
  public void setSelectedFarm(Farm farm) { 
    selectedFarm = farm;
  } 

  public Farm getSelectedFarm () { 
    return selectedFarm;
  }
}
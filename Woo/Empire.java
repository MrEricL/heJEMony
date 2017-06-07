import java.util.ArrayList;

public class Empire {
    private ArrayList<Store> _stores;//list of stores
    private int _employeeSalary;//not currently being used
    private double _budget;
    private double _totalEmployeeSatisfaction;//determines strikes
    private int _totalCustomerSatisfaction;//determines revenue
    private ALQueue<Integer> _actionsList; //better to have codes + modifiers for different actions 
    //buy store = 1
    private int _patties;
    private int[] _pattiesArray; //0=.5, 1=.6,2=.7,3=.8,4=.9,5=1.0
    private ALHeap<Farm> _farmHeap;
    private ArrayList<Farm> _availableFarms;
    private Farm selectedFarm; 
    private boolean hasAds;




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
	hasAds=false;
    }

    //takes int of store in list to access
    public Store getStore(int i) {
	return _stores.get(i);
    }

    //hasAds accessor
    public boolean getHasAds() {
	return hasAds;
    }

    //hasAds mutator
    public void modHasAds(boolean b) {
	hasAds=b;
    }
    //takes int of store in list to close
    public void closeStore(int i) {
	_stores.remove(i);
    }

    public double getTotalEmployeeSatisfaction() {
	return _totalEmployeeSatisfaction;
    }

    public int getTotalCustomerSatisfaction() {
	return _totalCustomerSatisfaction;
    }

    public void modTotalEmployeeSatisfaction(double i) {
	_totalEmployeeSatisfaction+=i;
    }

    public double calculateTotalEmployeeSatisfaction() {
	double r=0;
	for (Store s : _stores) {
	    r+=s.getEmployeeSatisfaction();
	}
	_totalEmployeeSatisfaction= r/_stores.size();
	return r;
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

    //removes and returns next action
    public int popActions() {
	return _actionsList.dequeue();
    }
    //use action queue ends

    //access budget
    public double getBudget() {
	return _budget;
    }

    public boolean isEmpty() { 
	return _actionsList.isEmpty();
    } 

    //mutate budget
    public void modifyBudget(double d) {
	_budget+=d;
    }

    //runs operations, uses time to determine whether employees should get less happy
    public void runOperations(int tNow) {
	for (Store s : _stores) {//loops through stores
	    if ((tNow-s.getCreationTime())%600<10) {//once every 10 seconds
		s.lowerEmployeeSatisfaction();//employee satisfaction goes down no matter what
		if (_patties==0)//no patties=unhappy customers
		    s.modCustomerSatisfaction(-1);
	    }
	    if (s.getEmployeeSatisfaction()<=1&&!s.striking()) {//floored so basically <1
		s.onStrike();
	    } else if (s.getEmployeeSatisfaction()>2&&s.striking())//end strike if happy enough
		s.endStrike();
	    if (_stores.size()>=4) //gain access to  adds
		modHasAds(true);
	    else
		modHasAds(false);
	    if (_patties==0) {//lose money
		setBudget(-s.getOperationsCost());
		continue;
	    }
	    /*if (s.striking())
	      continue;*/
	    //takes care of budget
	    s.setDailyRevenue(selectedFarm);
	    modifyBudget(s.getDailyRevenue());
	    s.increaseOperationsCost();
	    //checks if customers are happy and modifies their happiness
	    if ((tNow-s.getCreationTime())%60<10) {
		if (s.areCustomersHappy()) {
		    s.modCustomerSatisfaction(1);
		} else {
		    s.modCustomerSatisfaction(-2);
		}
	    }
	    if ((tNow-s.getCreationTime())%660<10) {//every 11 seconds

		if (selectedFarm.getPercentRealMeat()<.7) {
		    s.modCustomerSatisfaction(-1);
		}

		if (s.adSuccess(selectedFarm)==-1) {
		} else if (s.adSuccess(selectedFarm)<20) {//ads dont work
		    s.modCustomerSatisfaction(-3);
		} else if (s.adSuccess(selectedFarm)<45) {
		    s.modCustomerSatisfaction(-1);
		}
		else if (s.adSuccess(selectedFarm)>50) {
		    s.modCustomerSatisfaction(1);//ads work
		}
		else if (s.adSuccess(selectedFarm)>70) {
		    s.modCustomerSatisfaction(2);
		}
		//System.out.println(tNow-s.getCreationTime());
	    }
	    usePatties(s);
	}
    }


    //if has ecoli
    public void ecoli(int dec) {
	for (Store s : _stores) {
	    s.modCustomerSatisfaction(-dec);
	}
    }
    //num stores
    public int size() {
	return _stores.size();
    }

    //enqueue action
    public void addAction(int i) {
	if (_actionsList.size() < 6) _actionsList.enqueue(i);
    }


    public void setBudget(double s) {
	_budget+=s;
    }
    //goes through cheapest to most expensive stores and uses patties

    //use patties, different indexes correspond to different qualifies of patty
    public void usePatties(Store s) {
	int p=s.getCustomerSatisfaction();
	if (p<0) p=10;
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

    //buy patties, farm required for index
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

    //makes all other farms, other than i, false
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
    public int getFarmNum() { 
	return _availableFarms.size();
    }
}
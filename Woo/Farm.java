public class Farm implements Comparable{
    
    private double percentRealMeat;
    private String _name;
    private boolean chosen;

    public Farm () {
	percentRealMeat=.8;
	_name="generic farm";
    }

    public Farm (double percent,String name) {
	percentRealMeat = percent;
	_name=name;
    } 

    public double getPercentRealMeat () {
	return percentRealMeat;
    }

    public double getCostPerPatty() {
<<<<<<< HEAD
	return percentRealMeat * .5;
=======
	return percentRealMeat * .7;
>>>>>>> 5c2e51dfb50ea99d27efc407c3e9152772d4f156
    }

    public String getName() {
	return _name;
    }

    public int compareTo(Object o) {
	Farm f = (Farm) o;
	if (getPercentRealMeat()<f.getPercentRealMeat())
	    return -1;
	else if (getPercentRealMeat()==f.getPercentRealMeat())
	    return 0;
	else
	    return 1;
    }
    
    public void toggleChosen() {
      chosen=!chosen;
    }
    
    public boolean isChosen() {
      return chosen;
    }
}

    

    

    
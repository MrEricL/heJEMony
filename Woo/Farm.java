public class Farm implements Comparable{
    
    private double percentRealMeat;
    private String _name;

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
	return percentRealMeat * .5;
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
}

    

    

    

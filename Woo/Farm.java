public class Farm {
    
    private double percentRealMeat;

    public Farm () {
	percentRealMeat=.8;
    }

    public Farm (double percent) {
	percentRealMeat = percent;
    } 

    public double getPercentRealMeat () {
	return percentRealMeat;
    }

    public double getCostPerPatty() {
	return percentRealMeat * .5;
    }
}

    

    

    

# heJEMony
#### Eric Li, Matteo Wong, Jenny Han

## Burger Hegemony

![Image of burger](https://github.com/MrEricL/heJEMony/blob/master/Woo/data/hegemony%20splash%20art%202.png)

### Project User Description
Burger Hegemony is a diner dash game in which you pretend to work at, and eventually manage, a fast food burger chain. You start as a cook, making burgers, and work your way up to a manager. Then you will be able to buy stores and have to manage things like operations costs, customer happiness, and employee happiness, to establish a burger hegemony. You win when you have 10 stores and at least $10 million. You lose if you have 0 stores or below -$100,000.

### Internal Workings
#### Part I: Service Mini-game
When you begin, you will simply be manning the grill and making burgers. Random orders will be generated with ingredients such as: bun, patty, lettuce, tomato, pickle, etc. These orders will be stored in a queue. With Processing, there will be different “buttons” on the screen that you have to click to cook patties and assemble the burger. When a burger is finished, it will be dequeued, and you will move on to the next one. Each ingredient (patty, lettuce, etc.) will extend Food.java (so Patty is-a Food, Lettuce is-a Food, etc.). They will all have different visual representations, which is why we want all the different classes. The burgers will be stored as a queue of the different types of food (a Stack seems more intuitive but since you build burgers from the bottom up and we would construct the order in the same way, FIFO seems better than FILO).

We will use draw() and keep a counter, since draw() runs 60 times per second. The orders will need to be completed in a certain number of seconds to keep customers happy. The game will end after you have served 10 customers successfully.

The mini-game will always be available to play, but in the beginning it will be all you are allowed to do.  Once you have served 10 customers, you will be promoted to a manager position, and then phase 2 of the game will begin.
 
#### Part II: Building Your Empire
When you first become a manager, you are able to buy a new store. We will have a class Store.java. We will use draw() again as a timing mechanism to make you earn money as time progresses. The class Empire.java will store everything (it will be your empire). It will have instance variables int _employeeHappiness, int _customerSatisfaction, ArrayList<Store> _stores, double _budget, int _salary, etc. As you have more customer satisfaction, more customers will come and you can make more money. But you will also need more employees to handle them all, and need to buy more meat, etc. If customers aren’t served in a timely manner (ie. the ratio of employees to customers is off) you will start to lose customer satisfaction and make less money.

Once you make a certain amount of money, you will be able to purchase more stores (which will be added to the ArrayList of stores). You can also buy advertisements. Ads work like this: if you have cheap patties and bad quality meat, you should advertise your prices. If you have high quality meat and expensive patties, advertise meat quality. Doing the wrong combination will hurt you. Ads cost $20k.

There is a heap of available farms that we use a heapsort on by getting the minimum and adding it to an arraylist to increase the number of available farms.

Every time you do something it will be added to a queue and take a certain amount of time to complete.


### Launching Instructions
#### Launch from terminal
1. install processing-java from the processing "tools" tab
2. move into whatever directory you'd like
3. `$ git clone git@github.com:MrEricL/heJEMony.git`
4. `$ processing-java --sketch=pwd/heJEMony/Woo --run`
5. Press the arrow to play.

#### Launch from Processing
1. `>$ cd Woo`
2. `>$ processing Woo.pde`
3. Press the arrow to play. 

### Gameplay Instructions
0. Press play
1. Build burgers as per the Orders list on the side screen by pressing appropriate buttons and pressing "Finish" button when they are complete
2. When you have completed all 10 orders, press "Finish Game" and you will be brought to the Empire!
3. Click on the store, the top left button, where you can buy new stores, or click on a store to see more detailed information about it.
4. You can click on the farm, the bottom left, to choose between farms. Better farms are unlocked as you buy new stores. You need to remember to keep stocking patties. A red triangle will appear when you are out of patties and you will lose money
5. You can click on the burger to replay the minigame
6. The question mark is a general info tab
7. From an individual store you can buy advertisements after you have 4 or more stores. These ads should be targeted based on whether you are choosing cheap patties or high quality patties.
8. Random events like e coli might derail you, and workers might go on strike. Be careful! 

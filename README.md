# heJEMony
#### Eric Li, Matteo Wong, Jenny Han

## Burger Hegemony

### Project User Description
Burger Hegemony is a diner dash game in which you pretend to work at, and eventually manage, a fast food burger chain. You start as a cook, making burgers, and work your way up to a manager. Then you will be able to buy stores and have to manage things like operations costs, customer happiness, and employee happiness, to establish a burger hegemony.

### Internal Workings
#### Part I: Service Mini-game
     When you begin, you will simply be manning the grill and making burgers. Random orders will be generated with ingredients such as: bun, patty, lettuce, tomato, pickle, etc. These orders will be stored in a queue. With Processing, there will be different “buttons” on the screen that you have to click to cook patties and assemble the burger. When a burger is finished, it will be dequeued, and you will move on to the next one. Each ingredient (patty, lettuce, etc.) will extend Food.java (so Patty is-a Food, Lettuce is-a Food, etc.). They will all have different visual representations, which is why we want all the different classes. The burgers will be stored as a queue of the different types of food (a Stack seems more intuitive but since you build burgers from the bottom up and we would construct the order in the same way, FIFO seems better than FILO).
     We will use draw() and keep a counter, since draw() runs 60 times per second. The orders will need to be completed in a certain number of seconds to keep customers happy. The game will end after you have served X customers successfully or after you have failed X number of times (failure constitutes building the wrong burger).
     The mini-game will always be available to play, but in the beginning it will be all you are allowed to do. Serving enough customers will increase customer satisfaction and increase profits. Once you have served enough customers, you will be promoted to a manager position, and then phase 2 of the game will begin.
 
#### Part II: Building Your Empire
     When you first become a manager, you are able to buy a new store. We will have a class Store.java. We will use draw() again as a timing mechanism to make you earn money as time progresses. The class Empire.java will store everything (it will be your empire). It will have instance variables int _employeeHappiness, int _customerSatisfaction, ArrayList<Store> _stores, double _budget, int _salary, etc. As you have more customer satisfaction, more customers will come and you can make more money. But you will also need more employees to handle them all, and need to buy more meat, etc. If customers aren’t served in a timely manner (ie. the ratio of employees to customers is off) you will start to lose customer satisfaction and make less money.
     Once you make a certain amount of money, you will be able to purchase more stores (which will be added to the ArrayList of stores). We will add on other features if we are able to, like buying advertisements or happy meals.
     Every time you do something it will be added to a queue and take a certain amount of time to complete. An optional method might be to make it a priorityQueue and allow the user to decide what should take priority in the queue (stopping an e coli outbreak might matter more than launching a new ad, for instance).


### Instructions
1. Open Woo.pde
2. Launch Woo.pde
3. Press play. Build burgers as per the Orders list on the side screen by pressing appropriate buttons and pressing "Finish" button when they are complete
4. When you have completed all 10 orders, press "Finish Game" and you will be brought to the Empire!

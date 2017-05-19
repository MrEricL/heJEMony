
PImage img;
boolean state=false;

void setup() {
  size(750,750); //
  // Images must be in the "data" directory to load correctly
  img = loadImage("hegemony splash art.png");
}

void draw() {
  if (state)     background(51); //change color
  else {
    image(img,0,0);
  }
  stroke(255);
  strokeWeight(2);
  noFill();
  rect(21,290,185,106); 
  rect(253,290,185,106);  
  rect(21,463,185,106);   
  rect(253,463,185,106);   
}

void mousePressed(){
  if (overButton1(21,290,185,106)) {
    state=true;
  }

}


boolean overButton1(int x, int y, int width, int height){
   if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  } 
  
  
}
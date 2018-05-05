import ddf.minim.*;

boolean shiftPressed, showHelpText;
Minim minim;
TrackSequencer sequencer;
int previousMouseButton;
GUIElement testElement;

final int TYPE_TOP         = 0;
final int TYPE_BOTTOM      = 1;
final int TYPE_LEFT        = 2;
final int TYPE_RIGHT       = 3;
final int TYPE_TOPLEFT     = 4;
final int TYPE_TOPRIGHT    = 5;
final int TYPE_BOTTOMLEFT  = 6;
final int TYPE_BOTTOMRIGHT = 8;

boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;

String[] helpText = {
  "  Help text WIP",
  "  Esc: Exit",
  "",
  "Hide / Show",
  "  Tab: This guide"};

void setup(){
  size(1280, 720);
  noSmooth();
  stroke(0);
  background(0);
  
  shiftPressed = false;
  showHelpText = true;
  
  // This needs to be in the main class
  minim = new Minim(this);
  
  int seqOffsetY = 200;
  sequencer = new TrackSequencer(0, height, width, -height, minim);
  
  testElement = new GUIElement(0, 100, 100, -100);
}

void draw(){
  // Redraw background
  background(#AAAAAA);
  
  stroke(0,0,0);
  // Draw help text
  if(showHelpText){
    textSize(12);
    fill(0);
    text("GUIDE", 10, 15);
    
    int helpIndex = 0;
    int helpIndexSpacing = 20;
    for(String s : helpText){
      ++helpIndex;
      text(s, 10, 15 + helpIndex * helpIndexSpacing);
    }
  }
  
  getCurrentType();
  
  sequencer.display();
  
  fill(0);
  stroke(0x55000000);
  
  int gridDisplaySize = 30;
  int gridYPos = 0;
  for(int i = 0; i < 1000; ++i){
    gridYPos = -i * gridDisplaySize + height;
    
    if(i % 4 == 0)
      strokeWeight(2);
    else
      strokeWeight(1);
    line(0, gridYPos, width, gridYPos);
  }
  
  fill(0);
  stroke(0);
  rect(0, 0, width, 50);
}

void mousePressed(){
  // Processing doesn't store what button was released,
  // so I have to do this
  previousMouseButton = mouseButton;  
}

void mouseReleased(){
  sequencer.checkClickedTrack(mouseX, mouseY, previousMouseButton);
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = true;
    }
  }
  
  int dir = 8;
  if(key == 'w'){
    up = true;
    dir = TYPE_TOP;
  }if(key == 's'){
    down = true;
    dir = TYPE_BOTTOM;
  }if(key == 'a'){
    left = true;
    dir = TYPE_LEFT;
  }if(key == 'd'){
    right = true;
    dir = TYPE_RIGHT;
  }
}

void keyReleased(){
  if(key == 'w'){
    println("Released W");
    up = false;
  }if(key == 's'){
    down = false;
  }if(key == 'a'){
    left = false;
  }if(key == 'd'){
    right = false;
  }
  
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = false;
    }
  }
  
  switch(key){
    case TAB:
      if(showHelpText)
        showHelpText = false;
      else
        showHelpText = true;
      break;
    default:
      break;
  }
}

void getCurrentType(){
  if(up && left)
    dir = TYPE_TOPLEFT;
  else if(up && right)
    dir = TYPE_TOPRIGHT;
  else if(down && left)
    dir = TYPE_BOTTOMLEFT;
  else if(down && right)
    dir = TYPE_BOTTOMRIGHT;

  sequencer.setCutDirection(dir); 
}

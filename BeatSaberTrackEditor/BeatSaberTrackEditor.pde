import ddf.minim.*;

boolean shiftPressed, showHelpText;
Minim minim;
TrackSequencer sequencer;
int previousMouseButton;
GUIElement testElement;

final int DIR_TOP         = 0;
final int DIR_BOTTOM      = 1;
final int DIR_LEFT        = 2;
final int DIR_RIGHT       = 3;
final int DIR_TOPLEFT     = 4;
final int DIR_TOPRIGHT    = 5;
final int DIR_BOTTOMLEFT  = 6;
final int DIR_BOTTOMRIGHT = 7;

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
  
  sequencer.setCutDirection(getNewCutDirection());
  
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
  
  if(key == 'w'){
    up = true;
  }if(key == 's'){
    down = true;
  }if(key == 'a'){
    left = true;
  }if(key == 'd'){
    right = true;
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

public int getNewCutDirection(){
  int dir = 8;
  if(up)
    dir = DIR_TOP;
  if(down)
    dir = DIR_BOTTOM;
  if(left)
    dir = DIR_LEFT;
  if(right)
    dir = DIR_RIGHT;
    
  if(up && left)
    dir = DIR_TOPLEFT;
  else if(up && right)
    dir = DIR_TOPRIGHT;
  else if(down && left)
    dir = DIR_BOTTOMLEFT;
  else if(down && right)
    dir = DIR_BOTTOMRIGHT;

  return dir; 
}

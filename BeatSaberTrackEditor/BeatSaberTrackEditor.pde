import ddf.minim.*;

boolean shiftPressed, showHelpText;
Minim minim;
TrackSequencer sequencer;
int previousMouseButton;
GUIElement testElement;
GUIElement testElement2;
GUIElement testElement3;
GUIElement testElement4;

final int TYPE_RED  = 0;
final int TYPE_BLUE = 1;
final int TYPE_MINE = 3;

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

boolean playing = false;

String soundfilePath = "data\\90BPM_Stereo_ClickTrack.wav";

int type = 0;

String[] helpText = {
  "  SPACE:        Play / Stop", 
  "  LEFT CLICK:   Place notes",
  "  RIGHT CLICK:  Delete notes",
  "  Number key 1: RED",
  "  Number key 2: BLUE",
  "  Number key 3: MINE",
  "",
  "  SCROLL WHEEL: Scroll Up / Down",
  "",
  "  Directional arrows:",
  "  W: Up",
  "  S: Down",
  "  A: Left",
  "  D: Right",
  "",
  "  Tab: Hide / show guide",
  "",
  "  To exit, click the square stop button",
  "  in processing."};

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
  
  sequencer.loadSoundFile(soundfilePath);
}

void draw(){
  // Redraw background
  background(#111111);
  
  sequencer.setCutDirection(getNewCutDirection());
  sequencer.setType(type);
  
  sequencer.display();
  
  fill(0);
  stroke(0);
  rect(0, 0, width, 50);
  
  stroke(0,0,0);
  // Draw help text
  if(showHelpText){
    
    int helpboxX = width - 250;
    
    rect(helpboxX, 0, 250, height);
    
    textSize(12);
    fill(#ffffff);
    text("GUIDE", helpboxX + 10, 15);
    
    int helpIndex = 0;
    int helpIndexSpacing = 20;
    for(String s : helpText){
      ++helpIndex;
      text(s, helpboxX + 10, 15 + helpIndex * helpIndexSpacing);
    }
  }
}

void mousePressed(){
  sequencer.checkClickedTrack(mouseX, mouseY, mouseButton);
  
  // Processing doesn't store what button was released,
  // so I have to do this
  previousMouseButton = mouseButton;  
}

void mouseReleased(){
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  sequencer.scrollY(-e);
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = true;
    }
  }
  
  if(key == ' '){
    if(sequencer.getPlaying())
      sequencer.setPlaying(false);
    else
      sequencer.setPlaying(true);
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
  
  if(key == '1')
    type = TYPE_RED;
  if(key == '2')
    type = TYPE_BLUE;
  if(key == '3')
    type = TYPE_MINE;
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

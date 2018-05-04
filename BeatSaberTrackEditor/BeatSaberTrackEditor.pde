boolean shiftPressed, showHelpText;
TrackSequencer sequencer;
int previousMouseButton;

String[] helpText = {
  "  Left Click: Select box",
  "  Right Click: Place box",
  "  Backspace / Delete: Delete selected box",
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
  
  int seqOffsetY = 200;
  sequencer = new TrackSequencer(0, height, width, -height);
}

void draw(){
  // Redraw background
  background(255);
  
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
  
  sequencer.display();
  
  fill(0);
  rect(0, 0, width, 50);
}

void mousePressed(){
  // Processing doesn't store what button was released,
  // so I have to do this
  previousMouseButton = mouseButton;  
}

void mouseReleased(){
  
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = true;
    }
  }
}

void keyReleased(){
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

import g4p_controls.*;

import ddf.minim.*;

boolean shiftPressed, showHelpText;
Minim minim;
TrackSequencer sequencer;
JSONManager jsonManager;

int previousMouseButton;

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

String soundfilePath = "data\\60BPM_Stereo_ClickTrack.wav";
float bpm = 120;

int type = 0;
    
int helpboxX, helpboxY, helpboxSize;

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

GTextField bpmTextField;

// Controls used for file dialog GUI 
GButton btnFolder, btnOpenSong, btnInput, btnOutput;
GLabel lblFile;

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
  sequencer.setBPM(bpm);
  
  jsonManager = new JSONManager(sequencer);
  
  helpboxSize = 350;
  helpboxX = width - 350;
  helpboxY = 150;
  
  createFileSystemGUI(width - 350, 0, 350, 130, 6);
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
    
    rect(helpboxX, 0, helpboxSize, height);
    
    textSize(12);
    fill(#ffffff);
    text("GUIDE", helpboxX + 10, 15);
    
    int helpIndex = 0;
    int helpIndexSpacing = 20;
    for(String s : helpText){
      ++helpIndex;
      text(s, helpboxX + 10, helpboxY + 15 + helpIndex * helpIndexSpacing);
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

public void displayEvent(String name, GEvent event) {
  String extra = " event fired at " + millis() / 1000.0 + "s";
  print(name + "   ");
  switch(event) {
  case CHANGED:
    println("CHANGED " + extra);
    break;
  case SELECTION_CHANGED:
    println("SELECTION_CHANGED " + extra);
    break;
  case LOST_FOCUS:
    println("LOST_FOCUS " + extra);
    break;
  case GETS_FOCUS:
    println("GETS_FOCUS " + extra);
    break;
  case ENTERED:
    println("ENTERED " + extra);  
    break;
  default:
    println("UNKNOWN " + extra);
  }
}

public void handleTextEvents(GEditableTextControl textControl, GEvent event) { 
  displayEvent(textControl.tag, event);
  
  if (textControl.tag.equals(bpmTextField.tag)){
  switch(event) {
    case ENTERED:
        sequencer.setBPM(float(bpmTextField.getText()));
      break;
    }
  }
}

public void handleButtonEvents(GButton button, GEvent event) { 
  // Folder selection
  if (button == btnOpenSong || button == btnInput || button == btnOutput)
    handleFileDialog(button);
}

// G4P code for folder and file dialogs
public void handleFileDialog(GButton button) {
  String fname;
  // File input selection
  if (button == btnOpenSong) {
    // Use file filter if possible
    fname = G4P.selectInput("Input Dialog", "wav,mp3,aiff", "Sound files");
    lblFile.setText(fname);
    sequencer.loadSoundFile(fname);
  }
  // File output selection
  else if (button == btnOutput) {
    fname = G4P.selectOutput("Output Dialog");
    lblFile.setText(fname);
    jsonManager.saveTrack(fname);
  }
}


public void createFileSystemGUI(int x, int y, int w, int h, int border) {
  // Set inner frame position
  x += border; 
  y += border;
  w -= 2*border;
  h -= 2*border;
  GLabel title = new GLabel(this, x, y, w, 20);
  title.setText("Beat Saber Unofficial Track Editor", GAlign.LEFT, GAlign.MIDDLE);
  title.setOpaque(true);
  title.setTextBold();
  // Create buttons
  int bgap = 8;
  int bw = round((w - 2 * bgap) / 4.0f);
  int bs = bgap + bw;
  btnOpenSong = new GButton(this, x, y+30, bw, 20, "Load Audio");
  btnInput = new GButton(this, x+bs, y+30, bw, 20, "Load Track");
  btnOutput = new GButton(this, x+2*bs, y+30, bw, 20, "Save Track");
  
  bpmTextField = new GTextField(this, x+3*bs, y+30, bw - 10, 20);
  bpmTextField.tag = "bpmText";
  bpmTextField.setPromptText("BPM");
  
  lblFile = new GLabel(this, x, y+60, w, 60);
  lblFile.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  lblFile.setOpaque(true);
  lblFile.setLocalColorScheme(G4P.BLUE_SCHEME);
}

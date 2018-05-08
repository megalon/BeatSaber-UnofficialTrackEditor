/*
  Beat Saber 2D Unofficial Track Editor by Megalon
*/

import g4p_controls.*;
import ddf.minim.*;
import java.awt.*;

String versionText = "Megalon v0.0.12";

boolean debug = true;

Minim minim;
TrackSequencer sequencer;
JSONManager jsonManager;

int sequencerYOffset = -100;
int previousMouseButton;

// Keypresses
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean shiftPressed, controlPressed, altPressed, snapToggle;
boolean showHelpText;

boolean playing = false;

String soundfilePath = "data\\120BPM_Electro_Test.wav";
String tempPath = "data\\tmp\\tmp-track-";
int tempTrackIndex = 0;
float timeCounter = 0;
int numTmpFiles = 5;
float bpm = 120;

int type = 0;
    
int helpboxX, helpboxY, helpboxSize;



String[] instructionsText = { 
  "  1. Load an audio file using the LOAD AUDIO button",
  "  2. Set the BPM using the BPM textbox",
  "  3. Start editing, or load a track json file with LOAD TRACK",
  "  4. Save the track file with SAVE TRACK when finished",
  "",
};

String[] controlsText = { 
  "  SPACE:                 Play / Pause",
  "  SHIFT+SPACE:  Jump to start",
  "",
  "  Notes:", 
  "      Place RED note : Left click", 
  "      Place BLUE note: Right click     or     Control + Left Click",
  "      Place MINE : Middle click     or     Alt + Left Click",
  "      Delete note: Shift + Left Click",
  "      Grid snap toggle: G",
  "      Change snap resolution: Number keys 1 and 2",
  "",
  "  Direction arrows: ",
  "  Click while holding down a key:",
  "          W: Up",
  "          S: Down",
  "          A: Left",
  "          D: Right",
  "  For diagonals, combine buttons.",
  "      W+A = UP LEFT, W+D = UP RIGHT, etc",
  "",
  "  Scrolling: ",
  "      SCROLL WHEEL     or     UP / DOWN arrow keys",
  "      Hold SHIFT to scroll faster",
  ""
};

GTextField bpmTextField;
GTextField audioOffsetTextField;

// Controls used for file dialog GUI 
GButton btnOpenSong, btnInput, btnOutput;
GLabel lblFile;

void setup(){
  size(1280, 720);
  noSmooth();
  stroke(0);
  background(0);
  
  shiftPressed = false;
  controlPressed = false;
  altPressed = false;
  showHelpText = true;
  
  // This needs to be in the main class
  minim = new Minim(this);
  
  sequencer = new TrackSequencer(0, height + sequencerYOffset, width, -(height + sequencerYOffset), minim);
  
  sequencer.loadSoundFile(soundfilePath);
  sequencer.setBPM(bpm);
  
  jsonManager = new JSONManager(sequencer);
  
  helpboxSize = 350;
  helpboxX = width - 350;
  helpboxY = 120;
  
  createFileSystemGUI(width - 350, 0, 350, 130, 6);
}

void resetKeys(){
  up = false;
  down = false;
  left = false;
  right = false;
  
  altPressed = false;
  controlPressed = false;
  shiftPressed = false;
  snapToggle = false;
}


void draw(){
  if (!focused){
    resetKeys();
  }
  
  timeCounter++;
  // Autosave
  // Save every 30 seconds at 60fps
  if(timeCounter % (30 * 60) == 0){
    jsonManager.saveTrack(tempPath + getDateFormatted() + "-" + tempTrackIndex + ".json");
    if(tempTrackIndex == numTmpFiles)
      tempTrackIndex = 0;
    else
      tempTrackIndex++;
  }
  
  
  // Redraw background
  background(#111111);
  
  sequencer.setCutDirection(getNewCutDirection());
  
  sequencer.display();
  drawGrid();
  
  
  fill(0);
  stroke(0);
  
  // Draw box below sequencer
  rect(0, height + sequencerYOffset, width, -sequencerYOffset);
  
  fill(#FFFFFF);
  int seqTextY = height + sequencerYOffset + 25;
  textSize(18);
  text("Events\nWIP",       sequencer.multiTracks.get(0).getX(), seqTextY);
  text("Bottom Notes", sequencer.multiTracks.get(1).getX(), seqTextY);
  text("Middle Notes", sequencer.multiTracks.get(2).getX(), seqTextY);
  text("Top Notes",    sequencer.multiTracks.get(3).getX(), seqTextY);
  text("Obstacles\n(Edit WIP)",    sequencer.multiTracks.get(4).getX(), seqTextY);
  
  text("---------------------\n---------------------\n-----EVENTS WIP------\n---------------------\n---------------------\n", sequencer.multiTracks.get(0).getX(), 400 + (sequencer.getY() - sequencer.startYPosition));
  
  // Draw help text
  if(showHelpText){
    
    fill(#000000);
    rect(helpboxX, 0, helpboxSize, height);
    
    fill(#ffffff);
    textSize(18);
    text("INSTRUCTIONS", helpboxX + 10, helpboxY + 28);
    
    textSize(12);
    int textIndex = 0;
    int helpIndexSpacing = 20;
    for(String s : instructionsText){
      ++textIndex;
      text(s, helpboxX + 10, helpboxY + 30 + textIndex * helpIndexSpacing);
    }
    
    ++textIndex;
    textSize(18);
    text("CONTROLS", helpboxX + 10, helpboxY + 28 + textIndex * helpIndexSpacing);
    textSize(12);
    for(String s : controlsText){
      ++textIndex;
      text(s, helpboxX + 10, helpboxY + 30 + textIndex * helpIndexSpacing);
    }
    
    if(debug){
      text("mouseX: " + mouseX, 0, 10);
      text("mouseY: " + mouseY, 0, 20);
    }
  }
  textSize(12);
  fill(#ffffff);
  text(versionText, width - 100 , height - 10);
}

void mousePressed(){
  checkClick();
}

void mouseDragged(){
  // Only allow drag painting notes if we are snapped to the grid,
  // or if we are deleting notes using rightclick
  if(sequencer.getSnapToggle()){
    checkClick();
  }
}

void mouseReleased(){
  
}

void checkClick(){
  int type = 0;
  
  if(shiftPressed){
    type = -1;
  }else if(mouseButton == LEFT){
    // For the left mouse, we need to allow the hotkey + mouse controls
    if(controlPressed)
      type = Note.TYPE_BLUE;
    else if(altPressed)
      type = Note.TYPE_MINE;
    else
      type = Note.TYPE_RED;
  }else{
    type = sequencer.getTypeFromMouseButton(mouseButton);
  }
  sequencer.checkClickedTrack(mouseX, mouseY, type);
  
  // Processing doesn't store what button was released,
  // so I have to do this
  previousMouseButton = mouseButton;
  
  if(!sequencer.getPlaying()){
    sequencer.setTrackerPosition(mouseY);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(controlPressed){
    //sequencer.
  }else{
    if(shiftPressed){
      sequencer.scrollY(-e * 10);
    }else{
      sequencer.scrollY(-e);
    }
  }
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = true;
    }
    if (keyCode == CONTROL) {
      controlPressed = true;
    }
    if (keyCode == ALT) {
      altPressed = true;
    }
  }
  
  if (keyCode == UP){
    if(shiftPressed){
      sequencer.scrollY(10);
    }else{
      sequencer.scrollY(1);
    }
  }
  
  if (keyCode == DOWN && sequencer.getY() >= 0){
    if (controlPressed){
      sequencer.resetView();
    }else{
      if(shiftPressed && sequencer.getY() >= 10){
        sequencer.scrollY(-10);  
      }else{
        sequencer.scrollY(-1);
      }
    }
  }

  if(key == ' '){
    if(shiftPressed){
      sequencer.stop();
      sequencer.resetView();
    }else{
      if(sequencer.getPlaying())
        sequencer.setPlaying(false);
      else
        sequencer.setPlaying(true);
    }
  }
  
  if(key == 'g'){
    if(!snapToggle){
      if(sequencer.getSnapToggle()){
        sequencer.setSnapToggle(false);
      }else{
        sequencer.setSnapToggle(true);
      }
      snapToggle = true;
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
  
  if(key == '1' && sequencer.getGridResolution() < TrackSequencer.MIN_GRID_RESOLUTION){
    sequencer.setGridResolution(sequencer.getGridResolution() * 2);
    sequencer.setBeatsPerBar((int)(sequencer.getBeatsPerBar() / 2));
    //sequencer.setBeatsPerBar(sequencer.getBeatsPerBar() + 1);
    println("Increasing beats per bar to: " + sequencer.getBeatsPerBar());
  }
  if(key == '2' && sequencer.getGridResolution() > TrackSequencer.MAX_GRID_RESOLUTION){
    sequencer.setGridResolution(sequencer.getGridResolution() / 2);
    sequencer.setBeatsPerBar(sequencer.getBeatsPerBar() * 2);
    //sequencer.setBeatsPerBar(sequencer.getBeatsPerBar() - 1);
    println("Decreasing beats per bar to: " + sequencer.getBeatsPerBar());
  }
  
  if(key == 'w'){
    up = false;
  }if(key == 's'){
    down = false;
  }if(key == 'a'){
    left = false;
  }if(key == 'd'){
    right = false;
  }
  
  if(key == 'g'){
    snapToggle = false;
  }
  
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftPressed = false;
    }
    if (keyCode == CONTROL) {
      controlPressed = false;
    }
    if (keyCode == ALT) {
      altPressed = false;
    }
  }
  /*
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
  */
}

public int getNewCutDirection(){
  int dir = 8;
  if(up)
    dir = Note.DIR_BOTTOM;
  if(down)
    dir = Note.DIR_TOP;
  if(left)
    dir = Note.DIR_RIGHT;
  if(right)
    dir = Note.DIR_LEFT;
    
  if(up && left)
    dir = Note.DIR_BOTTOMRIGHT;
  else if(up && right)
    dir = Note.DIR_BOTTOMLEFT;
  else if(down && left)
    dir = Note.DIR_TOPRIGHT;
  else if(down && right)
    dir = Note.DIR_TOPLEFT;

  return dir; 
}

public void drawGrid(){
  int amountScrolled = sequencer.getAmountScrolled();
  int gridYPos = 0;
  int colorTrackerNum = 0;
  
  float gridSpacing = (sequencer.getGridHeight() * sequencer.getGridResolution());
  
  fill(0);
  stroke(0x55000000);
  
  for(int i = 0; i < 250; ++i){
    gridYPos = (int)(height - (i * gridSpacing) + sequencerYOffset);
    
    colorTrackerNum = i + amountScrolled;
    
    if(colorTrackerNum % 8 == 0)
      strokeWeight(4);
    else if(colorTrackerNum % 4 == 0)
      strokeWeight(2);
    else
      strokeWeight(1);
    line(0, gridYPos, width, gridYPos);
  }
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
      // Check for invalid input
      if(!Float.isNaN(float(bpmTextField.getText()))){
        sequencer.setBPM(float(bpmTextField.getText()));
      }
      break;
    }
  }else if(textControl.tag.equals(audioOffsetTextField.tag)){
    switch(event) {
      case ENTERED:
        // Check for invalid input
        if(!Float.isNaN(float(audioOffsetTextField.getText()))){
          println("Audio offset entered!");
        }
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
  else if (button == btnInput) {
    fname = G4P.selectInput("Input Dialog");
    lblFile.setText(fname);
    
    if(fname != null){
      jsonManager.loadTrack(fname);
    }
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
  int bw = round((w - 3 * bgap) / 4.0f);
  int bh = 30;
  int bs = bgap + bw;
  btnOpenSong = new GButton(this, x, y+30, bw, bh, "Load Audio");
  btnInput = new GButton(this, x+2*bs, y+30, bw, bh, "Load Track");
  btnOutput = new GButton(this, x+3*bs, y+30, bw, bh, "Save Track");
  
  bpmTextField = new GTextField(this, x+bs, y+30, bw, 30);
  bpmTextField.tag = "bpmText";
  bpmTextField.setPromptText("BPM");
  bpmTextField.setFont(new Font("Arial", Font.PLAIN, 25));
  
  audioOffsetTextField = new GTextField(this, bgap, height + sequencerYOffset + bgap, bw, 25);
  audioOffsetTextField.tag = "audioOffsetText";
  audioOffsetTextField.setPromptText("OFFSET");
  audioOffsetTextField.setFont(new Font("Arial", Font.PLAIN, 18));
  
  lblFile = new GLabel(this, x, y+70, w, 50);
  lblFile.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  lblFile.setOpaque(true);
  lblFile.setLocalColorScheme(G4P.BLUE_SCHEME);
}

// Format a date string for the temp file
public String getDateFormatted(){
  return "" + (year() + "-" + month() + "-" + day() + "--" + hour() + "-" + minute() + "-" + second() + "-" + millis());
}

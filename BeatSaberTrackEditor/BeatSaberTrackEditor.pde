/*
  Beat Saber 2D Unofficial Track Editor by Megalon
*/

import g4p_controls.*;
import ddf.minim.*;
import java.awt.*;

String versionText = "Megalon v0.0.19";

boolean debug = false;

private static final int THEME_COLOR_0 = #ffffff; 

Minim minim;
TrackSequencer sequencer;
JSONManager jsonManager;

int sequencerYOffset = -24*4;
int previousMouseButton;

// Keypresses
boolean up = false;
boolean down = false;
boolean left = false;
boolean right = false;
boolean shiftPressed, controlPressed, altPressed, snapToggle;
boolean showHelpText;

boolean playing = false;

PImage eventLabels;

String eventLabelsImagePath = "eventlabels.png";
String soundfilePath = "data\\120BPM_Electro_Test.wav";
String tempPath = "data\\tmp\\tmp-track-";
int tempTrackIndex = 0;
float timeCounter = 0;
int numTmpFiles = 5;
String inputTrackPath;
String outputTrackPath;
float bpm = 120;

int type = 0;

int helpboxX, helpboxY, helpboxSize;


String[] currentHelpText = TextArrays.defaultControlsText;

//GTextField bpmTextField;
//GTextField audioOffsetTextField;

// Controls used for file dialog GUI
GButton btnOpenSong, btnInput, btnOutput;
GLabel lblConsole;

boolean fullScreen = true;

void setup(){
  size(1280, 720);
  noSmooth();
  stroke(0);
  background(0);

  shiftPressed = false;
  controlPressed = false;
  altPressed = false;
  showHelpText = true;

  // Minim must be declared in the main class!
  minim = new Minim(this);
  
  eventLabels = loadImage(eventLabelsImagePath);
  int gridSize = 0;
  if(fullScreen){
    // Calculate grid size. Initially get multiple of 24, then make sure it's divisble evenly by 4
    gridSize = floor((displayHeight / 720) * 24 / 4) * 4;
  }else{
    gridSize = 24;
  }
  
  sequencer = new TrackSequencer(0, height + sequencerYOffset, width, -(height + sequencerYOffset), minim, gridSize);

  sequencer.loadSoundFile(soundfilePath);
  sequencer.setBPM(bpm);
  
  helpboxSize = 400;
  helpboxX = width - helpboxSize;
  helpboxY = 120;

  // To set the global colour scheme use 
  G4P.setGlobalColorScheme(6);

  createFileSystemGUI(width - helpboxSize, 0, helpboxSize, 130, 6);
  jsonManager = new JSONManager(sequencer, lblConsole);

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
  
  // Check if any of the multitracks are hovered over
  currentHelpText = TextArrays.defaultControlsText;
  for(int i = 0; i < sequencer.multiTracks.size(); ++i){
    if(sequencer.multiTracks.get(i).checkClicked(mouseX, mouseY)){
      sequencer.multiTracks.get(i).setHighlighted(true);
      switch(i){
        case(0):
          currentHelpText = TextArrays.eventControlsText;
          break;
        case(1):
        case(2):
        case(3):
          currentHelpText = TextArrays.noteControlsText;
          break;
        case(4):
          currentHelpText = TextArrays.obstacleControlsText;
          break;
      }
    }else{
      sequencer.multiTracks.get(i).setHighlighted(false);
    }
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
  
  // sick toothpaste blue #a7dbdb
  fill(BeatSaberTrackEditor.THEME_COLOR_0);
  int seqTextY = height + sequencerYOffset + 25;
  textSize(18);
  //text("Events",        sequencer.multiTracks.get(0).getX(), height - 10);
  text("Bottom\nNotes", sequencer.multiTracks.get(1).getX(), seqTextY);
  text("Middle\nNotes", sequencer.multiTracks.get(2).getX(), seqTextY);
  text("Top\nNotes",    sequencer.multiTracks.get(3).getX(), seqTextY);
  text("Obstacles",    sequencer.multiTracks.get(4).getX(), seqTextY);
  
  textSize(12);
  image(eventLabels, sequencer.multiTracks.get(0).getX() - 65, height + sequencerYOffset);
  
  text("FPS: " + (int)frameRate,0, height);
  
  // Draw help text
  if(showHelpText){

    fill(#000000);
    rect(helpboxX, 0, helpboxSize, height);

    fill(BeatSaberTrackEditor.THEME_COLOR_0);
    textSize(18);
    text("INSTRUCTIONS", helpboxX + 10, helpboxY + 28);

    textSize(12);
    int textIndex = 0;
    int helpIndexSpacing = 20;
    for(String s : TextArrays.instructionsText){
      ++textIndex;
      text(s, helpboxX + 10, helpboxY + 30 + textIndex * helpIndexSpacing);
    }

    ++textIndex;
    textSize(18);
    text("CONTROLS", helpboxX + 10, helpboxY + 28 + textIndex * helpIndexSpacing);
    textSize(12);
    for(String s : currentHelpText){
      ++textIndex;
      text(s, helpboxX + 10, helpboxY + 30 + textIndex * helpIndexSpacing);
    }

    if(debug){
      text("mouseX: " + mouseX, 0, 10);
      text("mouseY: " + mouseY, 0, 20);
    }
  }
  textSize(12);
  fill(BeatSaberTrackEditor.THEME_COLOR_0);
  text(versionText, width - 115 , 148);
  
  
  text("FPS: " + (int)frameRate,width - 45, height);
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
  sequencer.stopCreateSelection(mouseX, mouseY, getType());
}

int getType(){
  
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
  
  return type;
}

void checkClick(){
  sequencer.checkClickedTrack(mouseX, mouseY, getType());

  // Processing doesn't store what button was released,
  // so I have to do this
  previousMouseButton = mouseButton;

  if(!sequencer.getPlaying()){
    sequencer.setTrackerPositionPixels(mouseY);
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(controlPressed){
    //sequencer.
  }else{
    if(shiftPressed){
      //println("shift scrolling");
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
  
  if(key == ESC){
    key = 0;
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
  if (keyCode == 83){
    if(controlPressed){
      String fname = outputTrackPath;//lblConsole.getText();
      if(fname != null){
        fname = fname.trim();
        if (fname.isEmpty() || fname.equals("")){
          fname = G4P.selectOutput("Output Dialog");
          lblConsole.setText(fname);
          jsonManager.saveTrack(fname);
        } else {
          jsonManager.saveTrack(fname);
        }
      }
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

  if(key == '[' && sequencer.getGridResolution() < TrackSequencer.MIN_GRID_RESOLUTION){
    sequencer.setGridResolution(sequencer.getGridResolution() * 2);
    sequencer.setBeatsPerBar((int)(sequencer.getBeatsPerBar() / 2));
    //sequencer.setBeatsPerBar(sequencer.getBeatsPerBar() + 1);
    println("Increasing beats per bar to: " + sequencer.getBeatsPerBar());
  }
  if(key == ']' && sequencer.getGridResolution() > TrackSequencer.MAX_GRID_RESOLUTION){
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
  textSize(16);
  
  float thickLineSpacing = 0;

  for(int i = 0; i < 250; ++i){
  
    gridYPos = (int)(height - (i * gridSpacing) + sequencerYOffset);
    
    colorTrackerNum = (i + amountScrolled);
    thickLineSpacing = 8 / sequencer.getGridResolution();
    if(colorTrackerNum % thickLineSpacing == 0){
      strokeWeight(4);
      fill(BeatSaberTrackEditor.THEME_COLOR_0);
      textSize(18);
      text((int)(colorTrackerNum / thickLineSpacing), sequencer.multiTracks.get(4).getX() + sequencer.multiTracks.get(4).tracks.size() * sequencer.getGridWidth() + 2, gridYPos - 4); 
      fill(0);
    }else if(colorTrackerNum % 4 == 0)
      strokeWeight(2);
    else
      strokeWeight(1);
    line(0, gridYPos, width, gridYPos);
  }
}
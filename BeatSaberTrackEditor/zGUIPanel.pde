
//
// G4P GUI objects
//
GLabel infoTitle;

GTextField bpmTextField;
GTextField audioOffsetTextField;
GTextField songNameField;
GTextField songSubNameField;
GTextField authorNameField;
GTextField previewStartTimeField;
GTextField previewDurationField;
GTextField coverImagePathField;
GTextField difficultyRankField;

GDropList environmentName;
GDropList difficulty;

GTextField audioPathTextField;
GTextField jsonPathTextField;

//Labels
GLabel audioOffsetTextLabel;
GLabel songNameLabel;
GLabel songSubNameLabel;
GLabel authorNameLabel;
GLabel previewStartTimeLabel;
GLabel previewDurationLabel;
GLabel coverImagePathLabel;
GLabel difficultyRankLabel;

GLabel environmentNameLabel;
GLabel difficultyLabel;

GLabel audioPathTextLabel;
GLabel jsonPathTextLabel;

// Settings tab
GLabel settingsTitle;
GCheckbox noteClickToggle;
GCheckbox keyboardRecordToggle;
GLabel noteClickToggleLabel;
GLabel keyboardRecordToggleLabel;

PImage gridLayoutImage;
String gridLayoutImagePath = "gridlayouthelp.png";

// Underneath waveform
GTextField playbackSpeedField;


ArrayList<GAbstractControl> infoFields;
ArrayList<GAbstractControl> infoLabels;
ArrayList<GAbstractControl> settingsFields;
ArrayList<GAbstractControl> settingsLabels;
float infoPanelX;
float xInfoFieldOffset = 150;
float xInfoLabelOffset = 25;
int fieldHeight = 25;

int yOffset = 150;
int ySpacing = 30;

TrackSequencer seq;

public void createFileSystemGUI(int x, int y, int w, int h, int border, TrackSequencer seq) {
  
  this.seq = seq;
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

  lblConsole = new GLabel(this, x, y+70, w, 50);
  lblConsole.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  lblConsole.setOpaque(true);
  lblConsole.setText("Loaded default audio file: " + soundfilePath);
}


// This function sets up the info GUI. I did not implement this GUI
public void createInfoGUI(int x, int y, int w, int h, int border){
    // Set inner frame position
  x += border;
  y += border;
  w -= 2*border;
  h -= 2*border;
  
  infoPanelX = x;
  
  infoTitle = new GLabel(this, x, y + yOffset, w, 20);
  infoTitle.setText("Info Editor", GAlign.LEFT, GAlign.MIDDLE);
  infoTitle.setOpaque(true);
  infoTitle.setTextBold();
  // Create buttons
  int bgap = 8;
  int bw = round((w - 3 * bgap) / 4.0f);
  int bh = 30;
  int bs = bgap + bw;
  
  int xInfoFieldWidth = (int)(w - xInfoFieldOffset) - border;
  int xInfoLabelWidth = xInfoFieldWidth / 2;
  
  infoFields = new ArrayList<GAbstractControl>();
  infoLabels = new ArrayList<GAbstractControl>();
  
  songNameField          = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  songSubNameField       = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  authorNameField        = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  previewStartTimeField  = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  previewDurationField   = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  coverImagePathField    = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  audioPathTextField     = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  jsonPathTextField      = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  difficultyRankField    = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  
  environmentName        = new GDropList(this, x, y, xInfoFieldWidth, fieldHeight*5);
  difficulty             = new GDropList(this, x, y, xInfoFieldWidth, fieldHeight*5);
  
  infoFields.add(songNameField);
  infoFields.add(songSubNameField);
  infoFields.add(authorNameField);
  infoFields.add(previewStartTimeField);
  infoFields.add(previewDurationField);
  infoFields.add(coverImagePathField);
  infoFields.add(audioPathTextField);
  infoFields.add(jsonPathTextField);
  infoFields.add(difficultyRankField);
  infoFields.add(environmentName);
  infoFields.add(difficulty);
  
  songNameLabel          = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  songSubNameLabel       = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  authorNameLabel        = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  previewStartTimeLabel  = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  previewDurationLabel   = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  coverImagePathLabel    = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  audioPathTextLabel     = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  jsonPathTextLabel      = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  difficultyRankLabel    = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  
  environmentNameLabel   = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  difficultyLabel        = new GLabel(this, x, y, xInfoLabelWidth, fieldHeight);
  
  infoLabels.add(songNameLabel);
  infoLabels.add(songSubNameLabel);
  infoLabels.add(authorNameLabel);
  infoLabels.add(previewStartTimeLabel);
  infoLabels.add(previewDurationLabel);
  infoLabels.add(coverImagePathLabel);
  infoLabels.add(audioPathTextLabel);
  infoLabels.add(jsonPathTextLabel);
  infoLabels.add(difficultyRankLabel);
  infoLabels.add(environmentNameLabel);
  infoLabels.add(difficultyLabel);
  
 
  for(int i = 0; i < infoFields.size(); ++i){
    infoFields.get(i).moveTo(x + xInfoFieldOffset, y + ySpacing * (i + 1) + yOffset);
  }
  
  Font labelFont = new Font("Arial", Font.PLAIN, 25);
  for(int i = 0; i < infoLabels.size(); ++i){
    infoLabels.get(i).moveTo(xInfoLabelOffset, y + ySpacing * (i + 1) + yOffset);
    infoLabels.get(i).setOpaque(false);
    infoLabels.get(i).setLocalColorScheme(14);
  }
  
  Font font = new Font("Arial", Font.PLAIN, 18);
  
  songNameField.tag = "songNameText";
  songNameField.setPromptText("Song Name");
  songNameField.setFont(font);
  
  songSubNameField.tag = "songSubNameText";
  songSubNameField.setPromptText("SubName");
  songSubNameField.setFont(font);
  
  authorNameField.tag = "authorNameText";
  authorNameField.setPromptText("Artist");
  authorNameField.setFont(font);
  
  previewStartTimeField.tag = "previewStartTimeText";
  previewStartTimeField.setPromptText("0");
  previewStartTimeField.setFont(font);
  
  previewDurationField.tag = "previewDurationText";
  previewDurationField.setPromptText("0");
  previewDurationField.setFont(font);
  
  coverImagePathField.tag = "coverImagePathText";
  coverImagePathField.setPromptText("cover.png");
  coverImagePathField.setFont(font);
  
  audioPathTextField.tag = "audioPathText";
  audioPathTextField.setPromptText("sound.wav");
  audioPathTextField.setFont(font);
  
  jsonPathTextField.tag = "jsonPathText";
  jsonPathTextField.setPromptText("song.json");
  jsonPathTextField.setFont(font);
  
  environmentName.tag = "enviromentNameDropdown";
  environmentName.setFont(font);
  environmentName.setItems(loadStrings("environmentStrings"), 0);
  //environmentName.addEventHandler(this, "drpColorSelect");
  
  difficulty.tag = "difficultyDropdown";
  difficulty.setFont(font);
  difficulty.setItems(new String[]{"Easy","Normal","Hard","Expert"}, 0);
  //environmentName.addEventHandler(this, "drpColorSelect");
  
  difficultyRankField.tag = "difficultyRankText";
  difficultyRankField.setPromptText("4");
  difficultyRankField.setFont(font);
  
  songNameLabel.setText("Song name", GAlign.RIGHT, GAlign.MIDDLE);
  songSubNameLabel.setText("Subname", GAlign.RIGHT, GAlign.MIDDLE);
  authorNameLabel.setText("Artist", GAlign.RIGHT, GAlign.MIDDLE);
  previewStartTimeLabel.setText("Preview start time", GAlign.RIGHT, GAlign.MIDDLE);
  previewDurationLabel.setText("Preview duration", GAlign.RIGHT, GAlign.MIDDLE);
  coverImagePathLabel.setText("Cover image", GAlign.RIGHT, GAlign.MIDDLE);
  audioPathTextLabel.setText("Audio file", GAlign.RIGHT, GAlign.MIDDLE);
  jsonPathTextLabel.setText("JSON output file", GAlign.RIGHT, GAlign.MIDDLE);
  environmentNameLabel.setText("Environment name", GAlign.RIGHT, GAlign.MIDDLE);
  difficultyLabel.setText("Difficulty", GAlign.RIGHT, GAlign.MIDDLE);
  difficultyRankLabel.setText("Difficulty rank", GAlign.RIGHT, GAlign.MIDDLE);

}

public void createSettingsGUI(int x, int y, int w, int border){
  
  settingsTitle = new GLabel(this, x, y + yOffset, w, 20);
  settingsTitle.setText("Settings", GAlign.LEFT, GAlign.MIDDLE);
  settingsTitle.setOpaque(true);
  settingsTitle.setTextBold();
  
  noteClickToggle      = new GCheckbox(this, x, y + yOffset, fieldHeight, fieldHeight);
  keyboardRecordToggle = new GCheckbox(this, x, y + yOffset, fieldHeight, fieldHeight);
  
  noteClickToggleLabel      = new GLabel(this, x, y + yOffset, 100, fieldHeight);
  keyboardRecordToggleLabel = new GLabel(this, x, y + yOffset, 100, fieldHeight);
  
  // Set default value
  noteClickToggle.setSelected(seq.getPlayHitSound());
  keyboardRecordToggle.setSelected(seq.getKeyboardRecordMode());
  
  // Set text
  noteClickToggleLabel.setText("Note Click Sound", GAlign.RIGHT, GAlign.MIDDLE);
  keyboardRecordToggleLabel.setText("Keyboard grid note record", GAlign.RIGHT, GAlign.MIDDLE);
  
  
  settingsFields = new ArrayList<GAbstractControl>();
  settingsLabels = new ArrayList<GAbstractControl>();
  
  
  settingsFields.add(noteClickToggle);
  settingsFields.add(keyboardRecordToggle);
  
  settingsLabels.add(noteClickToggleLabel);
  settingsLabels.add(keyboardRecordToggleLabel);
  
  // Move the buttons / fields 
  for(int i = 0; i < settingsFields.size(); ++i){
    settingsFields.get(i).moveTo(x + xInfoFieldOffset, y + ySpacing * (i + 1) + yOffset);
  }
  
  // Move the labels and set their color
  for(int i = 0; i < settingsLabels.size(); ++i){
    settingsLabels.get(i).moveTo(xInfoLabelOffset, y + ySpacing * (i + 1) + yOffset);
    settingsLabels.get(i).setOpaque(false);
    settingsLabels.get(i).setLocalColorScheme(14);
  }
  
  gridLayoutImage = loadImage(gridLayoutImagePath);
}

public void createWaveSettingsGUI(int x, int y){
  playbackSpeedField = new GTextField(this, x, y, 100, 25);
}

public void showSettingsPanel(){
  settingsTitle.moveTo(infoPanelX, infoTitle.getY());
  for(int i = 0; i < settingsFields.size(); ++i){
    settingsFields.get(i).moveTo(infoPanelX + xInfoFieldOffset, settingsFields.get(i).getY());
  }
  for(int i = 0; i < settingsLabels.size(); ++i){
    settingsLabels.get(i).moveTo(infoPanelX + xInfoLabelOffset, settingsLabels.get(i).getY());
  }
  
  image(gridLayoutImage, infoPanelX + xInfoLabelOffset, settingsLabels.get(settingsLabels.size() - 1).getY() + 100);
}

public void hideSettingsPanel(){
  settingsTitle.moveTo(width, infoTitle.getY());
  for(int i = 0; i < settingsFields.size(); ++i){
    settingsFields.get(i).moveTo(width, settingsFields.get(i).getY());
  }
  for(int i = 0; i < settingsLabels.size(); ++i){
    settingsLabels.get(i).moveTo(width, settingsLabels.get(i).getY());
  }
}

public void showInfoPanel(){
  infoTitle.moveTo(infoPanelX, infoTitle.getY());
  for(int i = 0; i < infoFields.size(); ++i){
    infoFields.get(i).moveTo(infoPanelX + xInfoFieldOffset, infoFields.get(i).getY());
  }
  for(int i = 0; i < infoLabels.size(); ++i){
    infoLabels.get(i).moveTo(infoPanelX + xInfoLabelOffset, infoLabels.get(i).getY());
  }
}

public void hideInfoPanel(){
  infoTitle.moveTo(width, infoTitle.getY());
  for(int i = 0; i < infoFields.size(); ++i){
    infoFields.get(i).moveTo(width, infoFields.get(i).getY());
  }
  for(int i = 0; i < infoLabels.size(); ++i){
    infoLabels.get(i).moveTo(width, infoLabels.get(i).getY());
  }
}



public void handleToggleControlEvents(GToggleControl option, GEvent event) {
  if (option == noteClickToggle) {
    if(seq.getPlayHitSound()){
      seq.setPlayHitSound(false);
    }else{
      seq.setPlayHitSound(true);
    }
  }else if(option == keyboardRecordToggle){
    if(seq.getKeyboardRecordMode()){
      seq.setKeyboardRecordMode(false);
    }else{
      seq.setKeyboardRecordMode(true);
    }
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
    
    /*
    String infopath = G4P.selectInput("Select info.json", "json", "Info files");
    jsonManager.loadInfo(infopath);
    */
    
    // Use file filter if possible
    soundfilePath = G4P.selectInput("Input Dialog", "wav,mp3,aiff", "Sound files");
    switch(validSoundFile(soundfilePath)){
      case(TrackSequencer.SOUND_FILE_VALID):
        lblConsole.setText("Opening audio file: " + soundfilePath);
        sequencer.loadSoundFile(soundfilePath);
        lblConsole.setText("++++ Audio file opened! ++++\n" + soundfilePath);
        break;
      case(TrackSequencer.SOUND_FILE_OGG):
        lblConsole.setText("---- ERROR! ----\n.ogg filetype not supported by this editor!\nProcessing doesn't have a way to load .ogg files!");

        showErrorMessage(".ogg files not supported!\nTry a stereo WAV file");
        break;
      default:
        showErrorMessage("Filetype not supported!\nPlease select a stereo WAV, AIFF, or MP3");
    }
  }
  // File output selection
  else if (button == btnInput) {
    inputTrackPath = G4P.selectInput("Input Dialog");
    jsonManager.loadTrack(inputTrackPath);
    bpmTextField.setPromptText("" + sequencer.getBPM());
  }
  // File output selection
  else if (button == btnOutput) {
    outputTrackPath = G4P.selectOutput("Output Dialog");
    jsonManager.saveTrack(outputTrackPath);
  }
}


// G4P code for message dialogs
public void showErrorMessage(String message) {
  String title = "Error";
  G4P.showMessage(this, message, title, G4P.ERROR);
}


// Format a date string for the temp file
public String getDateFormatted(){
  return "" + (year() + "-" + month() + "-" + day() + "--" + hour() + "-" + minute() + "-" + second() + "-" + millis());
}

public int validSoundFile(String soundfilePath){
  if(soundfilePath.length() > 4){
    String soundfileFileExtension = soundfilePath.substring(soundfilePath.length()-4, soundfilePath.length());
    
    println("soundfileFileExtension", soundfileFileExtension);
    
    if(soundfileFileExtension.equals(".wav") || soundfileFileExtension.equals(".mp3") || soundfileFileExtension.equals("aiff")){
      return TrackSequencer.SOUND_FILE_VALID;
    }else if(soundfileFileExtension.equals(".ogg")){
      return TrackSequencer.SOUND_FILE_OGG;
    }
  }
  return TrackSequencer.SOUND_FILE_INVALID;
}
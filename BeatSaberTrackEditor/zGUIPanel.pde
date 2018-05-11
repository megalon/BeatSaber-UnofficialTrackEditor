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

ArrayList<GAbstractControl> infoFields;
float infoPanelX;
float xInfoFieldOffset = 150;

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

  lblConsole = new GLabel(this, x, y+70, w, 50);
  lblConsole.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  lblConsole.setOpaque(true);
  lblConsole.setText("Loaded default audio file: " + soundfilePath);
}

public void createInfoGUI(int x, int y, int w, int h, int border){
    // Set inner frame position
  x += border;
  y += border;
  w -= 2*border;
  h -= 2*border;
  
  int yOffset = 150;
  int ySpacing = 30;
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
  int fieldHeight = 25;
  
  infoFields = new ArrayList<GAbstractControl>();
  
  songNameField          = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  songSubNameField       = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  authorNameField        = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  previewStartTimeField  = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  previewDurationField   = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  coverImagePathField    = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  audioPathTextField     = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  jsonPathTextField      = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  difficultyRankField    = new GTextField(this, x, y, xInfoFieldWidth, fieldHeight);
  
  environmentName        = new GDropList(this, x, y, xInfoFieldWidth, fieldHeight);
  difficulty             = new GDropList(this, x, y, xInfoFieldWidth, fieldHeight);
  
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
  
  for(int i = 0; i < infoFields.size(); ++i){
    infoFields.get(i).moveTo(x + xInfoFieldOffset, y + ySpacing * (i + 1) + yOffset);
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
  
}

public void showInfoPanel(){
  infoTitle.moveTo(infoPanelX, infoTitle.getY());
  for(int i = 0; i < infoFields.size(); ++i){
    infoFields.get(i).moveTo(infoPanelX + xInfoFieldOffset, infoFields.get(i).getY());
  }
}

public void hideInfoPanel(){
  infoTitle.moveTo(width, infoTitle.getY());
  for(int i = 0; i < infoFields.size(); ++i){
    infoFields.get(i).moveTo(width, infoFields.get(i).getY());
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
    soundfilePath = G4P.selectInput("Input Dialog", "wav,mp3,aiff", "Sound files");
    switch(validSoundFile(soundfilePath)){
      case(TrackSequencer.SOUND_FILE_VALID):
        lblConsole.setText("Opening audio file: " + soundfilePath);
        sequencer.loadSoundFile(soundfilePath);
        lblConsole.setText("++++ Audio file opened! ++++\n" + soundfilePath);
        break;
      case(TrackSequencer.SOUND_FILE_OGG):
        lblConsole.setText("---- ERROR! ----\n.ogg filetype not supported!");
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
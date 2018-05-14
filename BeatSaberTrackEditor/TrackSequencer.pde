// The collection of all tracks.

class TrackSequencer extends GUIElement{

  private static final int SOUND_FILE_VALID = 0;
  private static final int SOUND_FILE_OGG = 1;
  private static final int SOUND_FILE_INVALID = 2;
  
  private static final float MAX_GRID_RESOLUTION = 0.25;
  private static final float MIN_GRID_RESOLUTION = 1;
  
  private static final int TOOL_DRAW = 0;      // Default tool
  private static final int TOOL_SELECT = 1;    // Selection tool for copy / paste 
  
  Minim minim; 
  AudioSample soundClick; 
  AudioPlayer soundPlayer;
  
  private int gridWidth = 24;
  private int gridHeight = 24;
  private int defaultGridHeight = 24;
  private int numtracksPerMulti = 4;
  private int numEventTracks = 9;
  private int trackGroupSpacing = gridWidth / 2;
  private int tracksXOffset = 170;
  private Waveform waveform;
  private MultiTrack bottomTracks, middleTracks, topTracks, obstaclesTracks, eventsTracks;
  private int startYPosition = 0;
  private int amountScrolled = 0;
  private int seqWindowBottom = 0;
  private boolean snapToggle = true;
  private String clickPath = "data\\noteClickSFX.wav";
  private boolean playNoteHitSound = true;
  private boolean keyboardRecordMode = false;
  
  private int clickPosX = 0;
  private int clickPosY = 0;
  private int currentTool = TOOL_DRAW;
  private boolean drawSelectBox = false;
  private int mouseButtonIndex = LEFT;
  
  private int trackSamplesOffset = 0;
  private float bpm = 120;
  private float beatsPerMS = bpm / 60 / 1000;
  private float prevBeat = 0;      // Used for checking to play click sound
  private float currentBeat = 0;   // Used for checking to play click sound
  private boolean playing = false;
  private int defaultBeatsPerBar = 8;
  private int beatsPerBar = 8;
  private float gridResolution = 1.0;
  private int currentCutDirection = 8;
  
  public ArrayList<MultiTrack> multiTracks;
  
  TrackSequencer(int x, int y, int w, int h, Minim minim, int gridSize){
    super(x, y, w, h);
    startYPosition = y;
    this.seqWindowBottom = -h;
    this.setFillColor(color(#111111));
    
    this.setGridWidth(gridSize);
    this.setGridHeight(gridSize);
    
    waveform = new Waveform(this, 0, 0, gridHeight, minim, startYPosition);
    
    eventsTracks    = new MultiTrack(this, numEventTracks,    gridWidth, gridHeight, beatsPerBar, "Events");
    bottomTracks    = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Bottom Notes");
    middleTracks    = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Middle Notes");
    topTracks       = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Top Notes");
    obstaclesTracks = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Obstacles");
    
    // Move the track groups
    eventsTracks.setX(   (tracksXOffset + trackGroupSpacing));
    bottomTracks.setX(   (tracksXOffset + trackGroupSpacing * 2) + numEventTracks * gridWidth);
    middleTracks.setX(   (tracksXOffset + numtracksPerMulti * gridWidth    ) + trackGroupSpacing * 3 + numEventTracks * gridWidth);
    topTracks.setX(      (tracksXOffset + numtracksPerMulti * gridWidth * 2) + trackGroupSpacing * 4 + numEventTracks * gridWidth);
    obstaclesTracks.setX((tracksXOffset + numtracksPerMulti * gridWidth * 3) + trackGroupSpacing * 5 + numEventTracks * gridWidth);
    
    multiTracks = new ArrayList<MultiTrack>();
    
    multiTracks.add(eventsTracks);
    multiTracks.add(bottomTracks);
    multiTracks.add(middleTracks);
    multiTracks.add(topTracks);
    multiTracks.add(obstaclesTracks);
    
  
    soundClick = minim.loadSample(clickPath, 1024);
    soundPlayer = minim.loadFile(clickPath);
    
  }
  
  // Clear the entire sequence
  public void clearSeq(){
    for(MultiTrack mt : multiTracks){
      for(Track t : mt.tracks){
        t.gridBlocks.clear();
      }
    }
  }
  
  public int getTypeFromMouseButton(int mb){
    int type = 0;
    switch(mb){
      case(RIGHT):
        type = Note.TYPE_BLUE;
        break;
      case(CENTER):
        type = Note.TYPE_MINE;
        break;
      default:
        type = Note.TYPE_RED;
    }
    return type;
  }
  
  public boolean getKeyboardRecordMode(){
    return keyboardRecordMode;
  }
  
  public void setKeyboardRecordMode(boolean rec){
    this.keyboardRecordMode = rec;
  }
  
  public void checkRemoveNote(int mx, int my){
    checkClickedTrack(mx, my, -1);
  }
  
  public void checkClickedTrack(int mx, int my, int type){
    
    this.mouseButtonIndex = type;
    
    //println("checkClickedTrack:" + mx + " " + my);
    for (MultiTrack m : multiTracks){
      
      if(!drawSelectBox){
        switch(currentTool){
          case TOOL_SELECT:
                startCreateSelection(mx, my);
            break;
          default:
            if(my < seqWindowBottom){
              if(m.getElementName().equals("Events")){
                  //println("Setting type based on events track!");
                  //println("Checking click at inside TrackSequencer:" + mx + " " + my);
                  //println("this.getY() - startYPosition:" + (this.getY() - startYPosition));
                  m.checkTrackClickedEvents(mx, my, this.getY() - startYPosition, currentCutDirection, 0, this.mouseButtonIndex);
              }else if(m.getElementName().equals("Obstacles")){
                if(m.checkClicked(mx, my)){
                  
                  startCreateSelection(mx, my);
                }
              }else{
                m.checkTrackClicked(mx, my, this.getY() - startYPosition, type, currentCutDirection, 0);
              }
            }
          }
      }
    }
  }
  
  public void loadSoundFile(String path){
    waveform.loadSoundFile(path);
    setBPM(this.bpm);
  }  
  
  public void setPlaying(boolean playing){
    if(this.playing == playing)
      return;
     
    this.playing = playing;
    
    if(playing)
      waveform.play();
    else
      waveform.pause();
  }    
  
  public void stop(){
    this.playing = false;
    
    waveform.stopPlaying();
  }
  
  public boolean getPlaying(){
    return playing;
  }
  
  public void setCutDirection(int cutDirection){
    this.currentCutDirection = cutDirection;
  }
  
  public int getCutDirection(){
    return currentCutDirection;
  }
  
  public int getGridHeight(){
    return gridHeight;
  }
  
  public int getGridWidth(){
    return gridWidth;
  }
  
  public void setGridWidth(int gridWidth){
    this.gridWidth = gridWidth;
  }
  
  public void setGridHeight(int gridHeight){
    this.gridHeight = gridHeight;
  }
  
  public int timeToGrid(float time){
    return (int)(time * (gridHeight / (beatsPerBar/2)));
  }
  
  public void resetView(){
    this.setY(startYPosition);
  }
  
  public void scrollY(float scroll){
    //println("scrollY:" + scroll);
    if(scroll > 0){
      this.setY((int)(this.getY() + scroll * gridHeight));
    }else{ 
      //println("startYPosition:" + startYPosition);
      //println("this.getY() - (int)scroll - 1 :" + (this.getY() - (int)scroll - 1 ));
      if(this.getY() + (int)(scroll * gridHeight) - 1 > startYPosition )
        this.setY((int)(this.getY() + scroll * gridHeight));
      else
        this.setY(startYPosition);
    } 
  }
  
  public float getBPM(){
    return this.bpm;
  }
  
  public void setBPM(float bpm){
    this.bpm = bpm;
    this.beatsPerMS = this.bpm / 60 / 1000;
    waveform.setBPM(bpm);
    
    for(MultiTrack mt : multiTracks){
      mt.setBPM(bpm);
    }
    
    waveform.setBeatsPerBar(beatsPerBar);
  }
  
  public void setBeatsPerBar(int beats){
    this.beatsPerBar = beats;
    
    for(MultiTrack mt : multiTracks){
      mt.setBeatsPerBar(beats);
    }
  }
  
  public int getBeatsPerBar(){
    return beatsPerBar;
  }
  
  public void setGridResolution(float resolution){
    this.gridResolution = resolution;
    
    for(MultiTrack mt : multiTracks){
      mt.setGridResolution(resolution);
    }
  }
  
  public float getGridResolution(){
    return gridResolution;
  }
  
  public void setTrackerPositionSamples(int pos){
    waveform.setTrackerPositionSamples(pos); 
  }
  
  public void setTrackerPositionPixels(int pos){
    waveform.setTrackerPositionPixels((this.getY()) - pos); 
  }
  
  public int getTrackerPositionMS(){
    return waveform.getSongPosition(); 
  }
  
  public boolean getSnapToggle(){
    return snapToggle;
  }
  
  public void setSnapToggle(boolean snap){
    snapToggle = snap;
    for(MultiTrack m : multiTracks){
      for(Track t : m.tracks){
        t.setSnapToGrid(snap);
      }
    }
  }
  
  public int getAmountScrolled(){
    return amountScrolled = (this.getY() - startYPosition) / defaultGridHeight;
  }
  
  public void setTool(int tool){
    this.currentTool = tool;
  }
  
  public int getTool(){
    return this.currentTool;
  }
  
  public void pasteAll(int my){
    for(MultiTrack m : multiTracks){
      m.selectPaste(my);
    }
    
    println("Size of track in trackseq: " + multiTracks.get(1).tracks.get(1).gridBlocks.size());
  }
  
  public void updateSelection(int mx, int my){
    for(MultiTrack m : multiTracks){
      m.updateCopyDrawing(mx, my, clickPosX, clickPosY);
    }
  }
  
  public void startCreateSelection(int mx, int my){
    clickPosX = mx;
    clickPosY = my;
    drawSelectBox = true;
  }
  
  public void stopCreateSelection(int mx, int my, int type){
    if(drawSelectBox){
      int minX = min(mx, clickPosX);
      int minY = min(my, clickPosY);
      
      int maxX = max(mx, clickPosX);
      int maxY = max(my, clickPosY);
      
      int selectionHeight = (maxY - minY);
      int selectionWidth  = (maxX - minX);
      
      /*
      println("minX:" + minX);
      println("maxX:" + maxX);
      
      println("minY:" + minY);
      println("maxY:" + maxY);
      
      println("selectionHeight:" + selectionHeight);
      println("selectionWidth:" + selectionWidth);
      */
      
      if(this.getTool() == TOOL_SELECT){
        
        // Only check for left click to select
        if(type == Note.TYPE_RED){
          for(MultiTrack m : multiTracks){
            // For now, only check for obstacle multitrack
            m.selectCopy(maxY, selectionHeight);
          }
        }
      }else if(this.getTool() == TOOL_DRAW){
        for(MultiTrack m : multiTracks){
          if(m.getElementName().equals("Events")){
            
          }else if(m.getElementName().equals("Obstacles")){
            m.checkTrackClickedObstacle(minX, maxY, this.startYPosition, selectionWidth, selectionHeight, type);
          }else{
            m.checkTrackClickedNotes(minX, maxY, this.startYPosition, selectionWidth, selectionHeight, type); 
          }
        }
      }
      drawSelectBox = false;
    }
  }
  
  public void addNote(long startMillis, long millis, long delay, int lineIndex, int lineLayer){
    
    //float time = ((0.06)*(float)(millis-startMillis-delay)/(this.getBPM())) * this.getBeatsPerBar() / 2 - 0.1;
    float time = ((float)(millis - startMillis - delay) * (this.getBPM() / 60000)) - 0.1;
    println("ms: " + (millis-startMillis-delay) + " to time: " + time);
    
    Track t = multiTracks.get(lineLayer + 1).tracks.get(lineIndex);
    
    if(snapToggle){
      t.addGridBlock(GridBlock.GB_TYPE_NOTE, t.mouseCordToTime(t.calculateGridYPos(time)), Note.TYPE_RED, this.getCutDirection(), 0);
    }else{
      t.addGridBlock(GridBlock.GB_TYPE_NOTE, time, Note.TYPE_RED, this.getCutDirection(), 0);
    }
  }
  
  public void setStretchSpectrogram(boolean stretch){
    this.waveform.setStretchSpectrogram(stretch);
  }
  
  public boolean getStretchSpectrogram(){
    return this.waveform.getStretchSpectrogram();
  }
  
  // Used in separate thread called from main class BeatSaberTrackEditor
  public void checkPlaySoundWrapper(){
    while(true){
      checkPlaySoundHit();
    }
  }
  
  private void checkPlaySoundHit(){
    // Formula:
    // (time in ms) * (beats per ms) = current beat
    
    // Current Beat
    currentBeat = this.waveform.getSongPosition() * beatsPerMS;
    
    boolean hit = false;
    
    //println("prevBeat: " + prevBeat + " currentBeat: " + currentBeat);
    
    // Loop through all notes to check for clicks
    for(MultiTrack m : multiTracks){
      // Check only for notes tracks
      if(!(m.getElementName().equals("Events") || m.getElementName().equals("Obstacles"))){
        for(Track t : m.tracks){
          if(t.checkBlockInTimePeriod(prevBeat, currentBeat))
            hit = true;
        }
      }
    }
    
    if(hit && playing && playNoteHitSound){
      playHitSound();
    }
    
    prevBeat = currentBeat;
  }
  
  private void playHitSound(){
      soundPlayer.rewind();
      soundPlayer.play();
  }
  
  public void setPlayHitSound(boolean hit){
    playNoteHitSound = hit;
  }
  
  public boolean getPlayHitSound(){
    return this.playNoteHitSound;
  }
    
  public void display(){
    
    strokeWeight(2);
    
    waveform.display();
    
    for(MultiTrack mt : multiTracks){
      mt.setTranslucent(this.getStretchSpectrogram());
      mt.display();
    }
    if(playing){
      if(!waveform.getPlaying())
        playing = false;
    }
    
    // Autoscroll
    // Scroll if the tracker is off screen
    if(playing){
      if(seqWindowBottom - waveform.getTrackerPosition() + (this.getY()+this.getHeight()) < 0){
        println("seqWindowBottom: " + seqWindowBottom);
        println("this.getY(): " + this.getY());
        this.setY(this.getY() + seqWindowBottom);
        println("this.getY() + seqWindowBottom: " + this.getY());
        println();
      }else if(waveform.getTrackerPosition() < (this.getY()+this.getHeight())){
        this.setY(this.getY() - seqWindowBottom);
      }
    }
    
    if(!snapToggle){
      noFill();
      strokeWeight(1);
      stroke(#ffffff);
      float widthHalf = gridWidth/2;
      float heightHalf = gridHeight/2;
      line(0, mouseY+widthHalf, width, mouseY+heightHalf);
      line(0, mouseY-widthHalf, width, mouseY-heightHalf);
    }
    
    if(drawSelectBox && mouseButtonIndex >= 0){
      switch(mouseButtonIndex){
        case(1):
          // RightClick
          fill(0x550000ff);
          stroke(#0000ff);
          break;
        default:
          // Left Click
          fill(0x55ff0000);
          stroke(#ff0000);
      }
      
      if(this.getTool() == TOOL_SELECT){
        // If we are selecting, only draw the selection box when left click is pressed
        if(this.mouseButtonIndex == 0)
          rect(0, clickPosY, width, mouseY - clickPosY);
      }else{
        rect(clickPosX, clickPosY, mouseX - clickPosX, mouseY - clickPosY); 
      }
    }
  }
}
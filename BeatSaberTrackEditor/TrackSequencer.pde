// The collection of all tracks.

class TrackSequencer extends GUIElement{

  private static final int SOUND_FILE_VALID = 0;
  private static final int SOUND_FILE_OGG = 1;
  private static final int SOUND_FILE_INVALID = 2;
  
  private static final float MAX_GRID_RESOLUTION = 0.5;
  private static final float MIN_GRID_RESOLUTION = 1;
  
  Minim minim; 
  AudioSample sound; 
  AudioPlayer soundbis;
  private int gridWidth = 24;
  private int gridHeight = 24;
  private int defaultGridHeight = 24;
  private int numtracksPerMulti = 4;
  private int numEventTracks = 9;
  private int trackGroupSpacing = gridWidth / 2;
  private int tracksXOffset = 150;
  private Waveform waveform;
  private MultiTrack bottomTracks, middleTracks, topTracks, obstaclesTracks, eventsTracks;
  private int startYPosition = 0;
  private int amountScrolled = 0;
  private int seqWindowBottom = 0;
  private boolean snapToggle = true;
  private String clickPath = "data\\noteClickSFX.wav";
  
  private float bpm = 90;
  
  private boolean playing = false;
  
  private int currentCutDirection = 8;
  
  private int defaultBeatsPerBar = 8;
  private int beatsPerBar = 8;
  private float gridResolution = 1.0;
  
  public ArrayList<MultiTrack> multiTracks;
  
  TrackSequencer(int x, int y, int w, int h, Minim minim){
    super(x, y, w, h);
    startYPosition = y;
    this.seqWindowBottom = -h;
    this.setFillColor(color(#111111));
    
    waveform = new Waveform(this, 0, 0, gridHeight, minim);
    
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
    
  
    sound = minim.loadSample(clickPath, 1024);
    soundbis = minim.loadFile(clickPath);
    
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
  
  public void checkRemoveNote(int mx, int my){
    checkClickedTrack(mx, my, -1);
  }
  
  public void checkClickedTrack(int mx, int my, int type){
    //println("checkClickedTrack:" + mx + " " + my);
    for (MultiTrack m : multiTracks){
      
      if(m.getElementName().equals("Events")){
        if(my < seqWindowBottom){
          
          //
          //
          // NOTE:
          //      In this case "TYPE" refers to the track! "VALUE" refers to what is happening
          //      Thus "type" is unused here, becuase we already are in the track we want!
          //
          //
          
          int lightEvent = 0;
          //println("currentCutDirection: " + currentCutDirection);
          if(type == -1){
            lightEvent = -1;
          }else if(type == Note.TYPE_MINE){
            lightEvent = Event.VALUE_OFF;
          }else{
            switch(currentCutDirection){
                  case(Note.DIR_BOTTOM):
                    // Arrow points UP
                    lightEvent = Event.VALUE_OFF;
                    break;
                  case(Note.DIR_RIGHT):
                    // Arrow points RIGHT
                    if(type == Note.TYPE_RED)
                      lightEvent = Event.VALUE_RED_FLASH;
                    else
                      lightEvent = Event.VALUE_BLUE_FLASH;
                    break;
                  case(Note.DIR_LEFT):
                    // Arrow points LEFT
                    if(type == Note.TYPE_RED)
                      lightEvent = Event.VALUE_RED_FADE;
                    else
                      lightEvent = Event.VALUE_BLUE_FADE;
                    break;
                  default:
                    // Circle
                    if(type == Note.TYPE_RED)
                      lightEvent = Event.VALUE_RED_LIGHT;
                    else
                      lightEvent = Event.VALUE_BLUE_LIGHT;
                    break;
            }
          }
          //println("Setting type based on events track!");
          //println("Checking click at inside TrackSequencer:" + mx + " " + my);
          //println("this.getY() - startYPosition:" + (this.getY() - startYPosition));
          m.checkTrackClickedEvents(mx, my, this.getY() - startYPosition, lightEvent, 0);
        }else{
          println("Not clicking in sequencer!");
        }
      }else if(m.getElementName().equals("Obstacles")){
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        //       skipping obstacles for now!
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        // ------------------------------------------
        //println("mx, my : " + mx + ", " + my);
        //println("getX, getY      : " + m.getX() + ", " + m.getY());
        //println("+width, +height : " + (m.getX() + m.getWidth()) + ", " + (m.getY() + m.getHeight()));
        //println("Check if multitrack clicked: " + m.checkClicked(mx, my));
      }else{
        if(my < seqWindowBottom){ //
          m.checkTrackClicked(mx, my, this.getY() - startYPosition, type, currentCutDirection, 0);
        }else{
          println("Not clicking in sequencer!");
        }
        //println("checkTrackClicked(" + mx + ", " + (my - seqWindowBottom) + ", " + type);
        //m.checkTrackClicked(mx, my, currentType, currentCutDirection, mb);
      }
    }
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
  
  public void loadSoundFile(String path){
    waveform.loadSoundFile(path);
    setBPM(this.bpm);
  }
  
  public void setTrackerPosition(int pos){
    waveform.setTrackerPosition((this.getY()) - pos); 
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
  
  public void display(){
    
    strokeWeight(2);
    
    for(MultiTrack mt : multiTracks){
      mt.display();
    }
    
    waveform.display();
    
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
  }
}

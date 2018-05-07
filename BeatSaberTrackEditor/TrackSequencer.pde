// The collection of all tracks.

class TrackSequencer extends GUIElement{
  
  Minim minim; 
  AudioSample sound; 
  AudioPlayer soundbis;
  private int gridWidth = 30;
  private int gridHeight = 30;
  private int numtracksPerMulti = 4;
  private int numEventTracks = 7;
  private int trackGroupSpacing = gridWidth / 2;
  private int tracksXOffset = 150;
  private Waveform waveform;
  private MultiTrack bottomTracks, middleTracks, topTracks, obstaclesTracks, eventsTracks;
  private int startYPosition = 0;
  private int amountScrolled = 0;
  private boolean snapToggle = true;
  private String clickPath = "data\\noteClickSFX.wav";
  
  private float bpm = 90;
  
  private boolean playing = false;
  
  private int currentCutDirection = 8;
  
  private int defaultBeatsPerBar = 8;
  private int beatsPerBar = 8;
  private float gridResolution = 1;
  
  public ArrayList<MultiTrack> multiTracks;
  
  TrackSequencer(int x, int y, int w, int h, Minim minim){
    super(x, y, w, h);
    startYPosition = y;
    
    this.setFillColor(color(#111111));
    
    waveform = new Waveform(this, 0, 0, gridHeight, minim);
    waveform.setBeatsPerBar(beatsPerBar);
    
    //eventsTracks    = new MultiTrack(this, numEventTracks,    gridWidth, gridHeight, beatsPerBar, "Events");
    bottomTracks    = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Bottom Notes");
    middleTracks    = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Middle Notes");
    topTracks       = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Top Notes");
    //obstaclesTracks = new MultiTrack(this, numtracksPerMulti, gridWidth, gridHeight, beatsPerBar, "Obstacles");
    
    // Move the track groups
    //eventsTracks.setX(   (tracksXOffset + trackGroupSpacing));
    bottomTracks.setX(   (tracksXOffset + trackGroupSpacing * 2) + numEventTracks * gridWidth);
    middleTracks.setX(   (tracksXOffset + numtracksPerMulti * gridWidth    ) + trackGroupSpacing * 3 + numEventTracks * gridWidth);
    topTracks.setX(      (tracksXOffset + numtracksPerMulti * gridWidth * 2) + trackGroupSpacing * 4 + numEventTracks * gridWidth);
    //obstaclesTracks.setX((tracksXOffset + numtracksPerMulti * gridWidth * 3) + trackGroupSpacing * 5 + numEventTracks * gridWidth);
    
    multiTracks = new ArrayList<MultiTrack>();
    
    //multiTracks.add(eventsTracks);
    multiTracks.add(bottomTracks);
    multiTracks.add(middleTracks);
    multiTracks.add(topTracks);
    //multiTracks.add(obstaclesTracks);
    
  
    sound = minim.loadSample(clickPath, 1024);
    soundbis = minim.loadFile(clickPath);
    
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
    //println("Checking track click at:" + mx + " " + my);
    for (MultiTrack m : multiTracks){
        println("TESTING HERE! CHANGE THIS FUNCTION");
        m.checkTrackClicked(mx, my, type, currentCutDirection, 0);
        //m.checkTrackClicked(mx, my, currentType, currentCutDirection, mb);
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
    if(scroll > 0){
      this.setY((int)(this.getY() + scroll * gridHeight));
    }else{
      if(this.getY() > startYPosition)
        this.setY((int)(this.getY() + scroll * gridHeight));
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
    
    //waveform.setBeatsPerBar(beatsPerBar);
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
    
    // Scroll if the tracker is off screen
    if(playing){
      if(height - waveform.getTrackerPosition() + (this.getY()+this.getHeight()) < 0){
        this.setY(this.getY() + height);
      }else if(waveform.getTrackerPosition() < (this.getY()+this.getHeight())){
        this.setY(this.getY() - height);
      }
    }
    
    fill(0);
    stroke(0x55000000);
    
    int gridYPos = 0;
    
    for(int i = 0; i < 5000; ++i){
      //gridYPos = (int)((startYPosition + (this.getY() % height )) -i * this.gridSize - 200);
      gridYPos = (int)(this.getY() -i * this.gridHeight * gridResolution);
      
      if(i % 8 == 0)
        strokeWeight(4);
      else if(i % 4 == 0)
        strokeWeight(2);
      else
        strokeWeight(1);
      line(0, gridYPos, width, gridYPos);
    }
    
    if(!snapToggle){
      noFill();
      stroke(#ffffff);
      float widthHalf = gridWidth/2;
      float heightHalf = gridHeight/2;
      line(0, mouseY+widthHalf, width, mouseY+heightHalf);
      line(0, mouseY-widthHalf, width, mouseY-heightHalf);
      
    }
  }
}

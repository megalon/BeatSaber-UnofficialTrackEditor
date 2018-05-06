// The collection of all tracks.

class TrackSequencer extends GUIElement{
  
  Minim minim; 
  AudioSample sound; 
  AudioPlayer soundbis;
  private int gridSize = 30;
  private int trackSize = 100;
  private int numtracksPerMulti = 4;
  private int numEventTracks = 8;
  private int trackGroupSpacing = gridSize / 2;
  private int tracksXOffset = 200;
  private Waveform waveform;
  private MultiTrack bottomTracks, middleTracks, topTracks, obstaclesTracks, eventsTracks;
  private int startYPosition = 0;
  private int amountScrolled = 0;
  private boolean snapToggle = true;
  private String clickPath = "data\\noteClickSFX.wav";
  
  private float bpm = 90;
  
  private boolean playing = false;
  
  private int currentCutDirection = 8;
  
  int beatsPerBar = 8;
  
  public ArrayList<MultiTrack> multiTracks;
  
  TrackSequencer(int x, int y, int w, int h, Minim minim){
    super(x, y, w, h);
    startYPosition = y;
    
    this.setFillColor(color(#111111));
    
    waveform = new Waveform(this, 0, 0, gridSize, minim);
    
    //eventsTracks    = new MultiTrack(this, numEventTracks,    gridSize, trackSize, "Events");
    bottomTracks    = new MultiTrack(this, numtracksPerMulti, gridSize, beatsPerBar, "Bottom Notes");
    middleTracks    = new MultiTrack(this, numtracksPerMulti, gridSize, beatsPerBar, "Middle Notes");
    topTracks       = new MultiTrack(this, numtracksPerMulti, gridSize, beatsPerBar, "Top Notes");
    //obstaclesTracks = new MultiTrack(this, numtracksPerMulti, gridSize, trackSize, "Obstacles");
    
    // Move the track groups
    //eventsTracks.setX(   (tracksXOffset + trackGroupSpacing));
    bottomTracks.setX(   (tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 2) + trackGroupSpacing * 2);
    middleTracks.setX(   (tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 3) + trackGroupSpacing * 3);
    topTracks.setX(      (tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 4) + trackGroupSpacing * 4);
    //obstaclesTracks.setX((tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 5) + trackGroupSpacing * 5);
    
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
        m.checkTrackClicked(mx, my, type, currentCutDirection);
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
  
  public int getGridSize(){
    return gridSize;
  }
  
  public int timeToGrid(float time){
    return (int)(time * (gridSize / (beatsPerBar/2)));
  }
  
  public void resetView(){
    this.setY(startYPosition);
  }
  
  public void scrollY(float scroll){
    if(scroll > 0){
      this.setY((int)(this.getY() + scroll * gridSize));
    }else{
      if(this.getY() > startYPosition)
        this.setY((int)(this.getY() + scroll * gridSize));
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
    
    //int numBeats = ceil(this.getBPM() * (waveform.getLength() / 60000.0)) * beatsPerBar;
    
    //println("minutes: " + waveform.getLength() / 60000.0);
    //println("Numbeats:" + numBeats);
    //println("Samples per beat: " + (44100 * 60 / this.getBPM()));
  }
  
  public void loadSoundFile(String path){
    waveform.loadSoundFile(path);
    setBPM(this.bpm);
  }
  
  public int getTrackSize(){
    return trackSize;
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
    //eventsTracks.display();
    bottomTracks.display();
    middleTracks.display();
    topTracks.display();
    //obstaclesTracks.display();
    
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
      gridYPos = (int)(this.getY() -i * this.gridSize);
      
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
      float gridHalf = gridSize/2;
      line(0, mouseY+gridHalf, width, mouseY+gridHalf);
      line(0, mouseY-gridHalf, width, mouseY-gridHalf);
      
    }
  }
}

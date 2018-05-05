// The collection of all tracks.
// Each 
class TrackSequencer extends GUIElement{
  
  private int gridSize = 30;
  private int trackSize = 100;
  private int numtracksPerMulti = 4;
  private int numEventTracks = 8;
  private int trackGroupSpacing = gridSize / 2;
  private int tracksXOffset = 200;
  private Waveform waveform;
  private MultiTrack bottomTracks, middleTracks, topTracks, obstaclesTracks, eventsTracks;
  
  private int currentType = 0;
  private int currentCutDirection = 8;
  
  private ArrayList<MultiTrack> multiTracks;
  
  TrackSequencer(int x, int y, int w, int h, Minim minim){
    super(x, y, w, h);
    this.setFillColor(color(#111111));
    
    waveform = new Waveform(this, this.getX(), this.getY(), gridSize, minim);
    
    eventsTracks    = new MultiTrack(this, numEventTracks,    gridSize, trackSize, "Events");
    bottomTracks    = new MultiTrack(this, numtracksPerMulti, gridSize, trackSize, "Bottom Notes");
    middleTracks    = new MultiTrack(this, numtracksPerMulti, gridSize, trackSize, "Middle Notes");
    topTracks       = new MultiTrack(this, numtracksPerMulti, gridSize, trackSize, "Top Notes");
    obstaclesTracks = new MultiTrack(this, numtracksPerMulti, gridSize, trackSize, "Obstacles");
    
    // Move the track groups
    eventsTracks.setX(   (tracksXOffset + trackGroupSpacing));
    bottomTracks.setX(   (tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 2) + trackGroupSpacing * 2);
    middleTracks.setX(   (tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 3) + trackGroupSpacing * 3);
    topTracks.setX(      (tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 4) + trackGroupSpacing * 4);
    obstaclesTracks.setX((tracksXOffset + numEventTracks + numtracksPerMulti * gridSize * 5) + trackGroupSpacing * 5);
    
    multiTracks = new ArrayList<MultiTrack>();
    
    multiTracks.add(eventsTracks);
    multiTracks.add(bottomTracks);
    multiTracks.add(middleTracks);
    multiTracks.add(topTracks);
    multiTracks.add(obstaclesTracks);
  }
  
  public void checkClickedTrack(int mx, int my, int mb){
    println("Checking track click at:" + mx + " " + my);
    for (MultiTrack m : multiTracks){
        m.checkTrackClicked(mx, my, currentType, currentCutDirection, mb);
    }
  }
  
  public void setType(int type){
    this.currentType = type;
  }
  
  public int getType(){
    return currentType;
  }
  
  public void setCutDirection(int cutDirection){
    this.currentCutDirection = cutDirection;
  }
  
  public int getCutDirection(){
    return currentCutDirection;
  }
  
  public void display(){
    super.display();
    
    //eventsTracks.display();
    bottomTracks.display();
    middleTracks.display();
    topTracks.display();
    //obstaclesTracks.display();
    
    waveform.display();
    /*
    
    stroke(#999999);
    int y1 = this.getY();
    int w1 = this.getWidth();
    int h1 = y1 + tracksPerMulti * gridSize * 3 + trackGroupSpacing * 3;
    
    for(int x1 = 0; x1 < w1; x1 += gridSize){
      line(x1, y1, x1, h1);
    }
    
    fill(#000000);
    rect(this.getX(), y1 + tracksPerMulti * gridSize, this.getWidth(), trackGroupSpacing);
    rect(this.getX(), y1 + tracksPerMulti * gridSize * 2 + trackGroupSpacing,     this.getWidth(), trackGroupSpacing);
    rect(this.getX(), y1 + tracksPerMulti * gridSize * 3 + trackGroupSpacing * 2, this.getWidth(), trackGroupSpacing);
    */
  }
}
// The collection of all tracks.
// Each 
class TrackSequencer extends GUIElement{
  
  private int gridSize = 30;
  private int numtracksPerMulti = 4;
  private int numEventTracks = 8;
  private int trackGroupSpacing = gridSize / 2;
  private Waveform waveform;
  private MultiTrack bottomTracks, middleTracks, topTracks, obstaclesTracks, eventsTracks;
  
  
  TrackSequencer(int x, int y, int w, int h){
    super(x, y, w, h);
    this.setFillColor(color(#000000));
    
    waveform = new Waveform(this, this.getX(), this.getY(), gridSize);
    
    eventsTracks    = new MultiTrack(this, numEventTracks,    gridSize, "Events");
    bottomTracks    = new MultiTrack(this, numtracksPerMulti, gridSize, "Bottom Notes");
    middleTracks    = new MultiTrack(this, numtracksPerMulti, gridSize, "Middle Notes");
    topTracks       = new MultiTrack(this, numtracksPerMulti, gridSize, "Top Notes");
    obstaclesTracks = new MultiTrack(this, numtracksPerMulti, gridSize, "Obstacles");
    
    // Move the track groups
    eventsTracks.setX(   (trackGroupSpacing));
    bottomTracks.setX(   (numEventTracks + numtracksPerMulti * gridSize * 2) + trackGroupSpacing * 2);
    middleTracks.setX(   (numEventTracks + numtracksPerMulti * gridSize * 3) + trackGroupSpacing * 3);
    topTracks.setX(      (numEventTracks + numtracksPerMulti * gridSize * 4) + trackGroupSpacing * 4);
    obstaclesTracks.setX((numEventTracks + numtracksPerMulti * gridSize * 5) + trackGroupSpacing * 5);
  }
  
  public void display(){
    super.display();
    
    eventsTracks.display();
    bottomTracks.display();
    middleTracks.display();
    topTracks.display();
    obstaclesTracks.display();
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

// The collection of all tracks.
// Each 
class MultiTrack extends GUIElement{
  
  PFont f;
  
  public ArrayList<Track> tracks;
  
  MultiTrack(GUIElement parent, int numTracks, int gridWidth, int gridHeight, int beatsPerBar, String name){
    this.setParent(parent);
    this.setElementName(name);
    
    tracks = new ArrayList<Track>();
    
    for(int i = 0; i < numTracks; ++i){
      
      int trackType = Track.TRACK_TYPE_NOTES;
      
      if(name.equals("Events")){
        trackType = Track.TRACK_TYPE_EVENTS;
      }else if(name.equals("Obstacles")){
        trackType = Track.TRACK_TYPE_OBSTACLES;
      }
      
      Track t = new Track(this, gridWidth, gridHeight, beatsPerBar, trackType);
      t.setX(gridWidth * i);
      tracks.add(t);
    }
    
    // Arial 16 point, with anti-aliasing 
    f = createFont("Arial", 16, true);
    
  }
  
  public void checkTrackClicked(int mx, int my, int type, int val0, int val1){
    //println("Checking click at:" + mx + " " + my);
    //println("Multitrack xy: " + this.getX() + " " + this.getY());
    for (Track t : tracks){
      //println("TrackPosition: " + t.getX() + " " + t.getY());
      if(t.checkClicked(mx, my)){
        //println("Track clicked!");
        if(type == -1)
          t.removeGridBLockMouseClick(mx, my);
        else
          t.addGridBlockMouseClick(mx, my, type, val0, val1);
      }
    }
  }
  
  public void setBeatsPerBar(int beats){
    for(Track t : tracks){
      t.setBeatsPerBar(beats);
    }
  }
  
  public void setGridResolution(float resolution){
    for(Track t : tracks){
      t.setGridResolution(resolution);
    }
  }
  
  public void setBPM(float bpm){
    for(Track t : tracks){
      t.setBPM(bpm);
    }
  }
  
  public void display(){
    super.display();
    
    for (Track t : tracks){
       t.display();
    }
    
    /*
    fill(#ffffff);
    textFont(f, 18);
    text(this.getElementName(), this.getX() + 10, this.getY() - 15);
    */
  }
}

// The collection of all tracks.
// Each 
class MultiTrack extends GUIElement{
  
  PFont f;
  
  public ArrayList<Track> tracks;
  
  MultiTrack(GUIElement parent, int numTracks, int gridWidth, int gridHeight, int beatsPerBar, String name){
    this.setParent(parent);
    this.setElementName(name);
    this.setHeight(Integer.MAX_VALUE/2);
    this.setWidth(gridWidth * numTracks);
    this.setY(-this.getHeight());
    
    
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
      t.setHeight(this.getHeight());
      tracks.add(t);
    }
    
    // Arial 16 point, with anti-aliasing 
    f = createFont("Arial", 16, true);
    
  }
  
  // This is a replacement for checkTrackClicked designed only for events.
  // This is needed because event "types" are based off of the track that they are on
  // Unlike not tracks where each track can have notes of any type or value
  // Events tracks can only have events of ONE type, but different values
  // Thus we need to use the track as the type
  public void checkTrackClickedEvents(int mx, int my, int seqYOffset, int val0, float val1){
    int trackCount = 0;
    for (Track t : tracks){
      if(t.checkClicked(mx, my)){
        
        //println("type should be :" + trackCount);
        
        if(val0 == -1)
          t.removeGridBlockMouseClick(mx, my);
        else
          t.addGridBlockMouseClick(mx, my, trackCount, val0, val1);
      }
      ++trackCount;
    }
  }
  
  public void checkTrackClicked(int mx, int my, int seqYOffset, int type, int val0, float val1){
    //println("Checking click inside MultiTrack:" + mx + " " + my);
    //println("Multitrack xy: " + this.getX() + " " + this.getY());
    for (Track t : tracks){
      //println("TrackPosition: " + t.getX() + " " + t.getY());
      if(t.checkClicked(mx, my)){
        //println("++++++++++Track clicked!");
        //println("seqYOffset: " + seqYOffset);
        //println(" my - (seqYOffset): " + (my - (seqYOffset)));
        if(type == -1)
          t.removeGridBlockMouseClick(mx, my);
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
  }
}

// The collection of all tracks.
// Each 
class MultiTrack extends GUIElement{
  
  PFont f;
  
  public ArrayList<Track> tracks;
  
  MultiTrack(GUIElement parent, int numTracks, int gridSize, int trackSize, String name){
    this.setParent(parent);
    this.setElementName(name);
    
    tracks = new ArrayList<Track>();
    
    for(int i = 0; i < numTracks; ++i){
      Track t = new Track(this, gridSize, trackSize);
      t.setX(gridSize * i);
      tracks.add(t);
    }
    
    // Arial 16 point, with anti-aliasing 
    f = createFont("Arial", 16, true);
    
  }
  
  public void checkTrackClicked(int mx, int my, int type, int cutDirection, int mb){
    //println("Checking click at:" + mx + " " + my);
    //println("Multitrack xy: " + this.getX() + " " + this.getY());
    for (Track t : tracks){
      //println("TrackPosition: " + t.getX() + " " + t.getY());
      if(t.checkClicked(mx, my)){
        println("Track clicked!");
        if(mb == LEFT)
          t.addNoteMouseClick(mx, my, type, cutDirection);
        else
          t.removeNoteMouseClick(mx, my);
      }
    }
  }
  
  public void display(){
    super.display();
    
    for (Track t : tracks){
       t.display();
    }
    
    textFont(f, 18);
    text(this.getElementName(), this.getX(), this.getY() - 25);
  }
}

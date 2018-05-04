// The collection of all tracks.
// Each 
class MultiTrack extends GUIElement{
  
  PFont f;
  
  public ArrayList<Track> tracks;
  
  MultiTrack(GUIElement parent, int numTracks, int gridSize, String name){
    this.setParent(parent);
    
    this.setElementName(name);
    
    tracks = new ArrayList<Track>();
    
    for(int i = 0; i < numTracks; ++i){
      Track t = new Track(this, gridSize);
      t.setX(gridSize * i);
      tracks.add(t);
    }
    
    // Arial 16 point, with anti-aliasing 
    f = createFont("Arial", 16, true);
    
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

class Track extends GUIElement{
  GridBlock gridBlocks[];
  int gridSize = 0;
  int trackSize = 100;
  
  Track(GUIElement parent, int gridSize, int trackSize){
    this.setParent(parent);
    
    this.setFillColor(color(#333333));
    this.setStrokeColor(color(#555555));
    this.setWidth(gridSize);
    this.trackSize = trackSize;
    this.setY(-trackSize * gridSize);     // Move track up 
    this.setHeight(trackSize * gridSize); // Then set the height so it reaches the starting point
    
    gridBlocks = new GridBlock[trackSize];
    
    this.gridSize = gridSize;
    
    for(int i = 1; i < trackSize; ++i){
      if((int)random(5) == 0){
        addNote(0, i, (int)random(2), (int)random(9));
      }
    }
  }
  
  // Convert X, Y cordinates (such as mouse click) to grid cordinates
  public int cordToGrid(int x){
     return (int)((height - x) / gridSize) + 1;
  }
  
  public void addNoteMouseClick(int mx, int my, int type, int cutDirection){
    this.addNote(0, cordToGrid(my), type, cutDirection);
  }
  
  public void addNote(int gridX, int gridY, int type, int cutDirection){
    println("Adding note at grid: " + gridX + ", " + gridY + " type: " + type + " cutDirection: " + cutDirection);
    gridBlocks[gridY] = new Note(this, gridX, trackSize - gridY, gridSize, type, cutDirection);  
  }
  
  public void removeNoteMouseClick(int mx, int my){
    this.removeNote(cordToGrid(my));
  }
  
  public void removeNote(int gridY){
    gridBlocks[gridY] = null;
  }
  
  public void display(){
    super.display();    
    
    for (int i = 0; i < gridBlocks.length; ++ i){
      if(gridBlocks[i] != null){
        gridBlocks[i].display(); 
      }
    }
  }
  
}

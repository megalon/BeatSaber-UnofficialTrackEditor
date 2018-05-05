class Track extends GUIElement{
  GridBlock gridBlocks[];
  int gridSize = 0;
  int trackSize = 100;
  
  int yStartingPosition = 0;
  
  Track(GUIElement parent, int gridSize, int trackSize){
    this.setParent(parent);
    
    this.gridSize = gridSize;
    
    this.setFillColor(color(#333333));
    this.setStrokeColor(color(#555555));
    this.setWidth(gridSize);
    this.resizeTrack(trackSize);
    
    for(int i = 1; i < trackSize; ++i){
      if((int)random(5) == 0){
        //addNote(0, i, (int)random(2), (int)random(9));
      }
    }
    
    yStartingPosition = this.getY();
  }
  
  // Convert X, Y cordinates (such as mouse click) to grid cordinates
  public int cordToGrid(int val){
     return (int)((height - val) / gridSize);
  }
  
  public void addNoteMouseClick(int mx, int my, int type, int cutDirection){
    //println("startingPosition: " + yStartingPosition);
    //println("getY(): " + this.getY());
    this.addNote(0, cordToGrid(my + yStartingPosition - this.getY()), type, cutDirection);
  }
  
  public void addNote(int gridX, int gridY, int type, int cutDirection){
    println("Adding note at grid: " + gridX + ", " + gridY + " type: " + type + " cutDirection: " + cutDirection);
    println();
    // Add the note to the correct position in the list, but flip it's Y position so that it displays correctly on the grid
    if(gridY < gridBlocks.length && gridY >= 0)
      gridBlocks[gridY] = new Note(this, gridX, trackSize - gridY - 1, gridSize, type, cutDirection);
    else
      println("Error: gridY out of bounds!");
  }
  
  public void removeNoteMouseClick(int mx, int my){
    this.removeNote(cordToGrid(my + yStartingPosition - this.getY()));
  }
  
  public void removeNote(int gridY){
    gridBlocks[gridY] = null;
  }
  
  public void resizeTrack(int trackSize){
    if(gridBlocks != null){
        GridBlock tempGridBlocks[] = new GridBlock[gridBlocks.length];
        
        for(int i = 0; i < gridBlocks.length; ++i){
          tempGridBlocks[i] = gridBlocks[i];
        }
        
        gridBlocks = new GridBlock[trackSize];
        
        // Copy all of the data that will fit into the new array
        for(int i = 0; i < min(tempGridBlocks.length, gridBlocks.length); ++i){
          gridBlocks[i] = tempGridBlocks[i];
        }
    }else{
      gridBlocks = new GridBlock[trackSize];
    }
    
    this.trackSize = trackSize;
    this.setY(-this.trackSize * gridSize);     // Move track up 
    this.setHeight(this.trackSize * gridSize); // Then set the height so it reaches the starting point
    yStartingPosition = this.getY();
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

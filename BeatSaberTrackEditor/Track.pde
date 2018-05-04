class Track extends GUIElement{
  ArrayList<GridBlock> gridBlocks;
  int gridSize = 0;
  int trackSize = 100;
  
  Track(GUIElement parent, int gridSize){
    this.setParent(parent);
    
    this.setFillColor(color(#333333));
    this.setStrokeColor(color(#555555));
    this.setWidth(gridSize);
    this.setHeight(-trackSize * gridSize);
    
    gridBlocks = new ArrayList<GridBlock>();
    
    this.gridSize = gridSize;
    
    for(int i = 1; i < 100; ++i){
      if((int)random(10) == 0){
        addNote(0, -i, (int)random(2), (int)random(5));
      }
    }
  }
  
  public void addNote(int gridX, int gridY, int type, int cutDirection){
    gridBlocks.add(new Note(this, gridX, gridY, gridSize, type, cutDirection));  
  }
  
  public void removeGridBlock(int gridX, int gridY){
    println("removeGridBlock NOT IMPLEMENTED!");
  }
  
  public void display(){
    super.display();    
    
    for (GridBlock b : gridBlocks){
      b.display(); 
    }
  }
  
}

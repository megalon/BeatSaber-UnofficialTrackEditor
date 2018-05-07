class Track extends GUIElement{
  // These are used to dermine how to handle notes places on the tracks
  private static final int TRACK_TYPE_NOTES = 0;
  private static final int TRACK_TYPE_EVENTS = 1;
  private static final int TRACK_TYPE_OBSTACLES = 2;
  
  HashMap<Float, GridBlock> gridBlocks;
  private int gridWidth = 0;
  private int gridHeight = 0;
  private int defaultGridHeight = 0;
  private int beatsPerBar = 8;
  private float gridResolution = 1.0;
  private float bpm = 0;
  private boolean snapToGrid = true;
  private boolean trackDebug = false;
  private int trackType;
  
  int yStartingPosition = 0;
  
  Track(GUIElement parent, int gridWidth, int gridHeight, int beatsPerBar, int trackType){
    this.setParent(parent);
    println("track gridWidth: " + gridWidth);
    
    gridBlocks = new HashMap<Float, GridBlock>();
    this.gridWidth = gridWidth;
    this.gridHeight = gridHeight;
    this.defaultGridHeight = gridHeight;
    this.beatsPerBar = beatsPerBar;
    this.trackType = trackType;
    
    this.setFillColor(color(#333333));
    this.setStrokeColor(color(#555555));
    this.setWidth(gridWidth);
    this.setHeight(Integer.MAX_VALUE);
    this.setY(-this.getHeight());
    
    yStartingPosition = this.getY();
  }
  
  // Convert X, Y cordinates (such as mouse click) to grid cordinates
  public float mouseCordToTime(int cordY){
    float cy                  = (float)cordY;
    float gridScale           = (gridHeight * beatsPerBar);
    float beatsOverResolution = beatsPerBar ;//  / gridResolution;
    
    float val = 0;
    
    if(trackDebug) println("gridScale: " + gridScale);
    
    if(snapToGrid){
      val = ((cy) / gridScale);
      if(trackDebug) println("before snap time: " + val);
      int temp = floor(val * beatsOverResolution);
      val = ((float)temp) / (beatsOverResolution);
      if(trackDebug) println("after snap time: " + val);
    }else{
      val = ((cy - gridHeight/2) / gridScale);
    }
    if(trackDebug) println("mouseCordToTime. cord: " + cordY + " = time: " + val);
    
    return val;
    
    //int cY = cordY;
    //return (height - cY) / gridSize;
    
    // time = (height - cordY) / beatsPerBar / bpm
    // time * bpm * beatsPerBar = (height - cordY)
    // time * bpm * beatsPerBar - height = -(cordY)
    // -((time * bpm * beatsPerBar) - height) = cordY
  }
  
  public int timeToCord(float time){
    int val = (int)(time * gridHeight * beatsPerBar);
    
    if(trackDebug) println("timeToCord. time: " + time + " = cord: " + val);
    return val;
  }
  
  public int calculateGridYPos(float time){
    return this.getHeight() - timeToCord(time) - gridHeight;
  }
  
  public void addGridBlockMouseClick(int mx, int my, int type, int val0, int val1){
    if(trackDebug) println();
    if(trackDebug) println("startingPosition: " + yStartingPosition);
    if(trackDebug) println("getY(): " + this.getY());
    
    float t = mouseCordToTime(height - my - (yStartingPosition - this.getY()));
    
    if(trackDebug) println("mouseCordToTime: " + t);
    
    // Add the correct GridBlock based on the track type
    this.addGridBlock(trackType, t, type, val0, val1);
  }
  
  // Generic function to add a new gridblock depending on type of object to add
  public void addGridBlock(int gridBlockType, float time, int type, int val0, int val1){
    
    int yPos = calculateGridYPos(time);
    
    switch(gridBlockType){
      case(GridBlock.GB_TYPE_NOTE):
        Note n = new Note(this, yPos, gridWidth, gridHeight, type, val0, time);
        gridBlocks.put(time, n);
        break;
      case(GridBlock.GB_TYPE_EVENT):
        Event e = new Event(this, yPos, gridWidth, gridHeight, type, val0, time);
        gridBlocks.put(time, e);
        break;
      case(GridBlock.GB_TYPE_OBSTACLE):
        Obstacle w = new Obstacle(this, yPos, gridWidth, gridHeight, type, val0, time, val1);
        gridBlocks.put(time, w);
        break;
      default:
        println("Error: Invalid grid block type!");
    }
    
    /*
    if(trackDebug) println("Attempting to add note at time: " + time + ", type: " + type + ", cutDirection: " + cutDirection);
    if(trackDebug) println();
    if(trackDebug) println("Adding note at Y position : " + n.getLocalY() + ", time " + n.getTime());
    if(trackDebug) println("gridBlocks.size(): " + gridBlocks.size());
    */
  }
  
  public void removeGridBLockMouseClick(int mx, int my){
    // Loop through the notes in this track and check for mouseclicks
    float key = Float.NaN;
    for (Float f: gridBlocks.keySet()) {
      GridBlock block = gridBlocks.get(f);
      if(trackDebug) println("Checking block " + block + " at position " + block.getX() + ", " + block.getY());
      if(block.checkClicked(mx, my)){
        key = f;
        break;
      }
    }
    
    // Check if the key was found. If it was, delete the value at that key
    if(trackDebug) println("Deleting key :" + key);
    if(!Float.isNaN(key)){
      this.removeGridBlock(key);
    }
  }
  
  public void removeGridBlock(float time){
    gridBlocks.remove(time);
  }
  
  public void updateGridblockHeights(){
    
    this.gridHeight = (int)(defaultGridHeight * gridResolution);
    
    for (Float f: gridBlocks.keySet()) {
      GridBlock block = gridBlocks.get(f);
      
      float t = block.getTime();
      println("t = block.getTime() : " + t);
      int gpy = calculateGridYPos(t);
      println("calculateGridYPos(t) : " + gpy);
      block.setY(gpy);
    }
  }
  
  public void setBPM(float bpm){
    this.bpm = bpm;
  }
  
  public void setBeatsPerBar(int beatsPerBar){
    this.beatsPerBar = beatsPerBar;
  }
  
  public void setSnapToGrid(boolean snap){
    this.snapToGrid = snap;
  }
  
  public void setGridResolution(float resolution){
    this.gridResolution = resolution;
    updateGridblockHeights();
  }
  
  public float getGridResolution(){
    return gridResolution;
  }
  
  public void display(){
    super.display();
    
    for (Float f: gridBlocks.keySet()) {
      
      switch(trackType){
        case(GridBlock.GB_TYPE_NOTE):
          Note note = (Note)gridBlocks.get(f);
          note.display();
          break;
        case(GridBlock.GB_TYPE_EVENT):
          Event event = (Event)gridBlocks.get(f);
          event.display();
          break;
        case(GridBlock.GB_TYPE_OBSTACLE):
          Obstacle obstacle = (Obstacle)gridBlocks.get(f);
          obstacle.display();
          break;
        default:
          println("Error: Invalid grid block type!");
      }
    }
  }
}

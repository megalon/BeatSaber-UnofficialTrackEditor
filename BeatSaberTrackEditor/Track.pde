class Track extends GUIElement{
  // These are used to dermine how to handle notes places on the tracks
  private static final int TRACK_TYPE_NOTES = 0;
  private static final int TRACK_TYPE_EVENTS = 1;
  private static final int TRACK_TYPE_OBSTACLES = 3;
  
  HashMap<Float, GridBlock> gridBlocks;
  HashMap<Float, GridBlock> gridBlocksCopy; // Used for copy buffer
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
    gridBlocksCopy = new HashMap<Float, GridBlock>();
    this.gridWidth = gridWidth;
    this.gridHeight = gridHeight;
    this.defaultGridHeight = gridHeight;
    this.beatsPerBar = beatsPerBar;
    this.trackType = trackType;
    
    this.setFillColor(color(#333333));
    this.setStrokeColor(color(#555555));
    this.setWidth(gridWidth);
    
    yStartingPosition = this.getY();
  }
  
  // Convert Y cordinates (such as mouse click) to grid cordinates
  public float mouseCordToTime(int cordY){
    cordY = this.getHeight() - cordY;
    float gridScale           = (gridHeight * beatsPerBar);
    float beatsFloat = beatsPerBar;
    
    float val = 0;
    
    if(trackDebug) println("gridScale: " + gridScale);
    
    if(snapToGrid){
      val = ((float)cordY) / gridScale;
      if(trackDebug) println("before snap time: " + val);
      int temp = floor(val * beatsFloat);
      val = (temp) / (beatsFloat);
      if(trackDebug) println("after snap time: " + val);
    }else{
      val = (cordY - gridHeight/2) / gridScale;
    }
    if(trackDebug) println("mouseCordToTime. cord: " + cordY + " = time: " + val);
    
    return val;
  }
  
  // Convert time value to Y coordinate
  public int timeToCord(float time){
    int val = this.getHeight() - (int)(time * gridHeight * beatsPerBar) - gridHeight;
    
    if(trackDebug) println("timeToCord. time: " + time + " = cord: " + val);
    return val;
  }
  
  // Time to coord
  public int calculateGridYPos(float time){
    return timeToCord(time);
  }
  
  public void addGridBlockMouseClick(int mx, int my, int type, int val0, float val1){
    if(trackDebug) println("addGridBlockMouseClick(" + mx + ", " + my + ", " + type + ", " + val0 + ", " + val1);  
    if(trackDebug) println();
    if(trackDebug) println("startingPosition: " + yStartingPosition);
    if(trackDebug) println("getY(): " + this.getY());
    if(trackDebug) println("this.getY() - my: " + (this.getY() - my));
    
    float t = mouseCordToTime(my - this.getY());
    
    if(trackDebug) println("mouseCordToTime: " + t);
    
    // Add the correct GridBlock based on the track type
    this.addGridBlock(trackType, t, type, val0, val1);
  }
  // Generic function to add a new gridblock depending on type of object to add
  public void addGridBlock(int gridBlockType, float time, int type, int val0, float val1){
    
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
        println("gridBlockType in Track class: " + gridBlockType);
        println("Error: Invalid grid block type!");
    }
    
    /*
    if(trackDebug) println("Attempting to add note at time: " + time + ", type: " + type + ", cutDirection: " + cutDirection);
    if(trackDebug) println();
    if(trackDebug) println("Adding note at Y position : " + n.getLocalY() + ", time " + n.getTime());
    if(trackDebug) println("gridBlocks.size(): " + gridBlocks.size());
    */
  }
  
  public void removeGridBlockMouseClick(int mx, int my){
    // Shouldn't have to do this equation, but so be it!
    if(trackDebug) println("removeGridBLockMouseClick(" + mx + ", " + (my) + ", this.getY()+my: " + (this.getHeight() + this.getY()+my));
    // Loop through the notes in this track and check for mouseclicks
    float k = Float.NaN;
    for (Float f: gridBlocks.keySet()) {
      GridBlock block = gridBlocks.get(f);
      if(trackDebug){ println("Checking block " + block + " at position " 
        + block.getX() + ", " + block.getY() + 
        " with dimensions: " + block.getWidth() + ", " + block.getHeight() +
        " | Clicked? : " + block.checkClicked(mx, my));
      }
      if(block.checkClicked(mx, my)){
        k = f;
        break;
      }
    }
    
    // Check if the key was found. If it was, delete the value at that key
    if(trackDebug) println("Deleting key :" + k);
    if(!Float.isNaN(k)){
      this.removeGridBlock(k);
    }
  }
  
  public void removeGridBlock(float time){
    gridBlocks.remove(time);
  }
  
  public void updateGridblockHeights(){
    
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
  
  public int getBeatsPerBar(){
    return beatsPerBar;
  }
  
  public void setSnapToGrid(boolean snap){
    this.snapToGrid = snap;
  }
  
  public void setGridResolution(float resolution){
    this.gridResolution = resolution;
    this.gridHeight = (int)(defaultGridHeight * gridResolution);
    //updateGridblockHeights();
  }
  
  public float getGridResolution(){
    return gridResolution;
  }
  
  public int getGridHeight(){
    return gridHeight;
  }
  
  public int getTrackType(){
    return trackType;
  }
  
  // Check if a gridblock is within a time period
  public boolean checkBlockInTimePeriod(float prevTime, float currentTime){
    float time = 0;
    
    try{
      for (Float f: gridBlocks.keySet()) {
        GridBlock block = gridBlocks.get(f);
        time = block.getTime();
        
        if(time > prevTime && time <= currentTime){
          
          return true;
        }
      }
    }catch(Exception e){
      println(e.toString());
    }
    return false; 
  }
  
  public void display(){
    
    // Don't call super because it would cause the tracks to draw on top of boxes with width greater than 1
    //super.display();
    
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
          println("gridBlockType in Track display function: " + trackType);
          println("Error: Invalid grid block type!");
      }
    }
    
    for (Float f: gridBlocksCopy.keySet()) {
      switch(trackType){
        case(GridBlock.GB_TYPE_NOTE):
          Note note = (Note)gridBlocksCopy.get(f);
          note.display();
          break;
        case(GridBlock.GB_TYPE_EVENT):
          Event event = (Event)gridBlocksCopy.get(f);
          event.display();
          break;
        case(GridBlock.GB_TYPE_OBSTACLE):
          Obstacle obstacle = (Obstacle)gridBlocksCopy.get(f);
          obstacle.display();
          break;
        default:
          println("gridBlockType in Track display function: " + trackType);
          println("Error: Invalid grid block type!");
      }
    }
  }
}
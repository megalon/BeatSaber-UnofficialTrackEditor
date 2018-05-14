// Grid blocks make up the track grid.
// A grid block might be a note, an event, or an obstacle.

// {"_lineIndex":0,"_type":1,"_duration":2,"_time":209,"_width":4}],

class GridBlock extends ClickableBox{
  
  // These are only used internally, these numbers are NOT relevant to the JSON data
  private static final int GB_TYPE_NOTE = 0;
  private static final int GB_TYPE_EVENT = 1;
  private static final int GB_TYPE_OBSTACLE = 3;
  
  private int type;
  private float time;
  
  private int gridWidth;
  private int gridHeight;
  
  GridBlock(GUIElement parent, int gridX, int gridY, int gridWidth, int gridHeight, int type, float time){
    super(parent, gridX, gridY, gridWidth, gridHeight); 
    
    this.setType(type);
    this.setTime(time);
    this.setgridWidth(gridWidth);
    this.setgridHeight(gridHeight);
  }
  
  public void setType(int type){
    this.type = type;
  }
  
  public void setTime(float time){
    this.time = time;
  }
  
  public float getTime(){
    return time;
  }
  
  public int getType(){
    return type;
  }
  
  public void setgridWidth(int gw){
    this.gridWidth = gw;
  }
  
  public void setgridHeight(int gh){
    this.gridHeight = gh;
  }
  
  public int getGridWidth(){
    return this.gridWidth;
  }
  
  public int getGridHeight(){
    return this.gridHeight;
  }
  
  public void display(){
    super.display();
  }
}

// Wall obstacle
class Obstacle extends GridBlock {
  
  public static final int TYPE_WALL    = 0;
  public static final int TYPE_CEILING = 1;
  
  private float duration = 0;
  private int wallWidth = 0;
  private color wallColor = color(0x55ff0000);
  private color ceilingColor = color(0x550000ff);
  
  Obstacle(GUIElement parent, int yPos, int gridWidth, int gridHeight, int type, int wallWidth, float time, float duration){
    super(parent, 0, yPos, gridWidth, gridHeight, type, time);
    
    this.setY(this.getLocalY() + gridHeight);
    this.setWidth(this.getWidth() * wallWidth);
    //this.setX(this.getLocalX() - this.getWidth() + gridWidth);
    
    println("This.getY(): " + this.getY());
    println("wallWidth: " + wallWidth);
    println();
    
    // Note the magic number 8 is due to the grid size being 1/8th of a beat
    this.setHeight((int)(this.getHeight() * -duration * 8));
    
    this.setDuration(duration);
    this.setWallWidth(wallWidth);
    
    println("Created wall at : " + yPos + " type: " + type + " duration: " + duration + " width: " + wallWidth);
    
    switch(type){
      case(TYPE_WALL): this.unSelectedColor = wallColor;
        break;
      case(TYPE_CEILING): this.unSelectedColor = ceilingColor;
        break;
      default: println("Error! Invalid type" + type + " for gridblock " + this + " !!");
    }
  }
  
  public void setDuration(float duration){
    this.duration = duration;
  }
  
  public float getDuration(){
    return duration;
  }
  
  public void setWallWidth(int wallWidth){
    this.wallWidth = wallWidth;
  }
  
  public int getWallWidth(){
    return wallWidth;
  }
  
  public void display(){
    super.display();
    
    switch(this.getType()){
      case(TYPE_WALL):
        stroke(#ff3333);
        break;
      case(TYPE_CEILING):
        stroke(#3333ff);
        break;
    }
    strokeWeight(4);
    strokeCap(SQUARE);
    
    // Draw X marks the spot
    line(this.getX() + 2,
         this.getY() + this.getHeight() + 2,
         this.getX() + this.getGridWidth() - 2,
         this.getY() + this.getHeight() + this.getGridHeight() - 2);
         
    line(this.getX() + 2,
         this.getY() + this.getHeight() + this.getGridHeight() - 2,
         this.getX() + this.getGridWidth() - 2,
         this.getY() + this.getHeight() + 2);
         /*
    line(this.getX(),
         this.getY() + (this.getGridWidth() / 2) + this.getHeight(),
         this.getX() + this.getGridWidth(),
         this.getY() + (this.getGridWidth() / 2) + this.getHeight());
         
    line(this.getX() + (this.getGridHeight() / 2),
         this.getY() + this.getHeight(),
         this.getX() + (this.getGridHeight() / 2),
         this.getY() + this.getHeight() + this.getGridHeight());
         */
         /*
    rect(this.getX() + (this.getGridWidth()/4),
         this.getY() + this.getHeight() + (this.getGridHeight()/4),
         this.getGridWidth() / 2,
         this.getGridHeight() / 2);
         */
         
    strokeWeight(1);
  }
  
}

class Event extends GridBlock {
  
  /*
  In short 0 is null
  1-3 is blue light, blue flash, and blue fade out
  4 null
  5-7 is red light, red flash, and red fade out
  
  Event type 0 is the 'X' in the backdrop
  Event type 1 is the overhead and understage backdrop lighting
  Event type 2 is left stage lighting
  Event type 3 is right stage lighting.
  
  Types of events
  0-4:Light effects
  5-7: unused
  8: Turning of large object in the middle
  9: UNKNOWN. it may be the pulse effect? if someone could figure this out and get back to me please do.
  10-11: unused
  12: Makes light 2 move.
  13: makes light 3 move.
*/
  
  public static final int TYPE_BACK_TOP_LIGHTS         = 0;
  public static final int TYPE_NEON_RINGS              = 1;
  public static final int TYPE_LEFT_LASERS             = 2;
  public static final int TYPE_RIGHT_LASERS            = 3;
  public static final int TYPE_BOTTOM_BACK_SIDE_LASERS = 4;
  // -----------------------------------------         = 5 - 7     unused
  public static final int TYPE_ALL_TRACK_RINGS         = 8;
  public static final int TYPE_SMALL_TRACK_RINGS       = 9;
  // -----------------------------------------         = 10 - 11   unused
  public static final int TYPE_MOVE_LEFT_LASERS        = 12;
  public static final int TYPE_MOVE_RIGHT_LASERS       = 13;
  
  public static final int VALUE_OFF        = 0;
  public static final int VALUE_BLUE_LIGHT = 1;
  public static final int VALUE_BLUE_FLASH = 2;
  public static final int VALUE_BLUE_FADE  = 3;
  public static final int VALUE_OFF2       = 4;  // <- null like type 0
  public static final int VALUE_RED_LIGHT  = 5;
  public static final int VALUE_RED_FLASH  = 6;
  public static final int VALUE_RED_FADE   = 7;
  
  
  private color offColor  = color(#000000);
  private color redColor  = color(#ff0000);
  private color blueColor = color(#0000ff);
  
  int colorFadeValue = 0;
  int minColorFadeValue = 0;
  int maxColorFadeValue = 255;
  
  int flashValue = 10;
  int slowFadeValue = 2;
  
  private int value = 0;
  
  //{"_type":4,"_value":6,"_time":0},
  Event(GUIElement parent, int yPos, int gridWidth, int gridHeight, int type, int value, float time){
    super(parent, 0, yPos, gridWidth, gridHeight, type, time);
    
    //
    //
    // NOTE:
    //      In this case "TYPE" refers to the track! "VALUE" refers to what is happening
    //      Thus "type" is unused here!
    //
    //
    
    this.setValue(value);
    
  }
  
  public void setValue(int value){
    this.value = value;
  }
  
  public int getValue(){
    return value;
  }
  
  public void display(){
    /*
    public static final int VALUE_OFF        = 0;
    public static final int VALUE_BLUE_LIGHT = 1;
    public static final int VALUE_BLUE_FLASH = 2;
    public static final int VALUE_BLUE_FADE  = 3;
    public static final int VALUE_OFF2       = 4;  // <- null like type 0
    public static final int VALUE_RED_LIGHT  = 5;
    public static final int VALUE_RED_FLASH  = 6;
    public static final int VALUE_RED_FADE   = 7;
    */
    
    //println("GridBlock type: " + this.getType());
    
    if(this.getType() <= TYPE_BOTTOM_BACK_SIDE_LASERS){
      if(value == VALUE_BLUE_FLASH ||
         value == VALUE_RED_FLASH){
       if(colorFadeValue > 0){
          colorFadeValue -= flashValue;
        }else{
          colorFadeValue = maxColorFadeValue;
        }
      }else if(value == VALUE_BLUE_FADE ||
               value == VALUE_RED_FADE){
        if(colorFadeValue > 0){
          colorFadeValue -= slowFadeValue;
        }else{
          colorFadeValue = maxColorFadeValue;
        }
      }
      
      switch(this.getValue()){
        case(VALUE_BLUE_LIGHT):
          this.setFillColor(blueColor);
          break;
        case(VALUE_BLUE_FLASH):
        case(VALUE_BLUE_FADE):
          this.setFillColor(color(0, 0, (int)(colorFadeValue)));
          break;
        case(VALUE_RED_LIGHT):
          this.setFillColor(redColor);
          break;
        case(VALUE_RED_FLASH):
        case(VALUE_RED_FADE):
          this.setFillColor(color((int)colorFadeValue, 0, 0));
          break;
        default: this.setFillColor(offColor);
      }
    
      // Draw colored box based on fade color
      fill(this.getFillColor());
      strokeWeight(1);
      rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    }else{
      
      //println("Drawing rotation block");
      // Draw box with number to show rotation speed
      fill(this.getFillColor());
      strokeWeight(0);
      rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
      fill(255);
      textSize(18);
      text(value, this.getX(), this.getY() + (this.getHeight()/2) + 4);
    }
    
    // println("value: " + value);
    // println("colorFadeValue: " + colorFadeValue);
    // println("fillColor: " + this.getFillColor());
    // println();
  }
}

// Note gridblock
class Note extends GridBlock {

  public static final int TYPE_RED  = 0;
  public static final int TYPE_BLUE = 1;
  public static final int TYPE_MINE = 3;
  
  public static final int DIR_TOP         = 0;
  public static final int DIR_BOTTOM      = 1;
  public static final int DIR_LEFT        = 2;
  public static final int DIR_RIGHT       = 3;
  public static final int DIR_TOPLEFT     = 4;
  public static final int DIR_TOPRIGHT    = 5;
  public static final int DIR_BOTTOMLEFT  = 6;
  public static final int DIR_BOTTOMRIGHT = 7;
  
  private int cutDirection;
  private color redColor = color(#ff0000);
  private color blueColor = color(#0000ff);
  private color mineColor = color(#727272);
  private PImage mineImage = loadImage("data\\mine.png");
  
  Note(GUIElement parent, int yPos, int gridWidth, int gridHeight, int type, int cutDirection, float time){
    super(parent, 0, yPos, gridWidth, gridHeight, type, time);    
    this.setType(type);
    this.cutDirection = cutDirection;
    this.setTime(time);
    
    if(this.getType() == TYPE_MINE){
      mineImage.resize(this.getWidth(), this.getHeight());
    }
    
    switch(type){
      case(TYPE_RED): this.unSelectedColor = redColor;
        break;
      case(TYPE_BLUE): this.unSelectedColor = blueColor;
        break;
      case(TYPE_MINE): this.unSelectedColor = mineColor;
        break;
      default: println("Error! Invalid type" + type + " for gridblock " + this + " !!");
    }
  }
  
  public int getCutDirection(){
    return cutDirection;
  }
  
  public void printString(){
    println("note " + this + " .getX():" + this.getX());
    println("note " + this + " .getY():" + this.getY());
    println("note " + this + " .getWidth():" + this.getWidth());
    println("note " + this + " .getHeight():" + this.getHeight());
    println("note " + this + " .getCutDirection():" + this.getCutDirection());
    println("note " + this + " .getTime():" + this.getTime());
  }
  
  public void display(){
    super.display();
    
    fill(#FFFFFF);
    noStroke();
    // Purely visual, the cut direction is still set in the json.
    if (this.getType() == 3){
      image(mineImage, this.getX(), this.getY());
      this.cutDirection = 8;
    }else{
      switch(cutDirection){
      case(DIR_BOTTOM):
        // Arrow points DOWN
        triangle(
        this.getX(), 
        this.getY(), 
        this.getX() + this.getWidth(),
        this.getY(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(DIR_TOP):
        // Arrow points UP
        triangle(
        this.getX() + this.getWidth(), 
        this.getY() + this.getHeight(),
        this.getX(),
        this.getY() + this.getHeight(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(DIR_RIGHT):
        // Arrow points RIGHT
        triangle(
        this.getX(), 
        this.getY(),
        this.getX(),
        this.getY() + this.getHeight(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(DIR_LEFT):
        // Arrow points LEFT
        triangle(
        this.getX() + this.getWidth(), 
        this.getY(), 
        this.getX() + this.getWidth(),
        this.getY() + this.getHeight(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(DIR_BOTTOMRIGHT):
        // Arrow points to BOTTOM RIGHT
        triangle(
        this.getX(), 
        this.getY() + this.getHeight() * 0.5, 
        this.getX() + this.getWidth() * 0.5,
        this.getY(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(DIR_BOTTOMLEFT):
        // Arrow points to BOTTOM LEFT
        triangle( 
        this.getX() + this.getWidth() * 0.5,
        this.getY(),
        this.getX() + this.getWidth(), 
        this.getY() + this.getHeight() * 0.5,
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(DIR_TOPRIGHT):
        // Arrow points to TOP RIGHT
        triangle(
        this.getX(), 
        this.getY() + this.getHeight() * 0.5, 
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5,
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight());
        break;
      case(DIR_TOPLEFT):
        // Arrow points to TOP LEFT
        triangle( 
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5,
        this.getX() + this.getWidth(), 
        this.getY() + this.getHeight() * 0.5,
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight());
        break;
      case(8):
        // Circle
        //ellipse(this.getX() + this.getWidth() * 0.5, this.getY() + this.getHeight() * 0.5, this.getWidth() * 0.5, this.getHeight() * 0.5);
        ellipse(this.getX() + this.getWidth() * 0.5, this.getY() + this.getHeight() * 0.5, this.getWidth() * 0.5, this.getWidth() * 0.5);
        break;
      }
    }
  }
}
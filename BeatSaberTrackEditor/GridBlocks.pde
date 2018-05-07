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
  
  GridBlock(GUIElement parent, int gridX, int gridY, int gridWidth, int gridHeight, int type, float time){
    super(parent, gridX, gridY, gridWidth, gridHeight); 
    
    this.setType(type);
    this.setTime(time);
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
  
  public void display(){
    super.display();
  }
}

// Wall obstacle
class Obstacle extends GridBlock {
  
  public static final int TYPE_WALL    = 0;
  public static final int TYPE_CEILING = 1;
  
  private int duration = 0;
  private int wallWidth = 0;

  Obstacle(GUIElement parent, int yPos, int gridWidth, int gridHeight, int type, int duration, float time, int wallWidth){
    super(parent, 0, yPos, gridWidth, gridHeight, type, time);
    
    this.setDuration(duration);
    this.setWallWidth(wallWidth);
    
    println("Created wall at : " + yPos + " type: " + type + " duration: " + duration + " width: " + wallWidth);
  }
  
  public void setDuration(int duration){
    this.duration = duration;
  }
  
  public int getDuration(){
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
  
  public static final int TYPE_X_LIGHTS        = 0;
  public static final int TYPE_OVERHEAD_LIGHTS = 1;
  public static final int TYPE_LEFT_LIGHTS     = 2;
  public static final int TYPE_RIGHT_LIGHTS    = 3;
  // ----------------------------------------- = 5 - 7     <- unused?
  public static final int TYPE_TURN_OBJECT     = 8;
  // ----------------------------------------- = 10 - 11   <- unused?
  public static final int TYPE_MOVE_LIGHT2     = 12;
  public static final int TYPE_MOVE_LIGHT3     = 13;
  
  public static final int VALUE_OFF        = 0;
  public static final int VALUE_BLUE_LIGHT = 1;
  public static final int VALUE_BLUE_FLASH = 2;
  public static final int VALUE_BLUE_FADE  = 3;
  // --------------------------------------- 4   <- null like type 0
  public static final int VALUE_RED_LIGHT  = 5;
  public static final int VALUE_RED_FLASH  = 6;
  public static final int VALUE_RED_FADE   = 7;
  
  private int value = 0;
  
  //{"_type":4,"_value":6,"_time":0},
  Event(GUIElement parent, int yPos, int gridWidth, int gridHeight, int type, int value, float time){
    super(parent, 0, yPos, gridWidth, gridHeight, type, time);
    
    this.setValue(value);
  }
  
  public void setValue(int value){
    this.value = value;
  }
  
  public int getValue(){
    return value;
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

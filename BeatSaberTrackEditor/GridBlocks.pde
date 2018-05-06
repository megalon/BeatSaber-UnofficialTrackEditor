// Grid blocks make up the track grid.
// A grid block might be a note, an event, or an obstacle.

class GridBlock extends ClickableBox{
  
  GridBlock(GUIElement parent, int gridX, int gridY, int gridSize){
    super(parent, gridX, gridY, gridSize); 
  }
  
  public void display(){
    super.display();
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
  
  private int type, cutDirection;
  private color redColor = color(#ff0000);
  private color blueColor = color(#0000ff);
  private color mineColor = color(#727272);
  private PImage mineImage = loadImage("data\\mine.png");
  private float time;
  
  Note(GUIElement parent, int yPos, int gridSize, int type, int cutDirection, float time){
    super(parent, 0, yPos, gridSize);
    this.type = type;
    this.cutDirection = cutDirection;
    this.time = time;
    
    switch(type){
      case(0): this.unSelectedColor = redColor;
        break;
      case(1): this.unSelectedColor = blueColor;
        break;
      case(3): this.unSelectedColor = mineColor;
        break;
      default: println("Error! Invalid type" + type + " for gridblock " + this + " !!");
    }
  }
  
  public float getTime(){
    return time;
  }
  
  public int getType(){
    return type;
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
        ellipse(this.getX() + this.getWidth() * 0.5, this.getY() + this.getHeight() * 0.5, this.getWidth() * 0.5, this.getHeight() * 0.5);
        break;
      }
    }
  }
}

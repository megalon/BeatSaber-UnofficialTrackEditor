// Grid blocks make up the track grid.
// A grid block might be a note, an event, or an obstacle.

class GridBlock extends ClickableBox{
  
  GridBlock(GUIElement parent, int gridX, int gridY, int gridSize){
    super(parent, gridX * gridSize, gridY * gridSize, gridSize); 
  }
  
  public void display(){
    super.display();
  }
}

// Not gridblock
class Note extends GridBlock {
  private int type, cutDirection;
  private color redColor = color(#ff0000);
  private color blueColor = color(#0000ff);
  
  
  Note(GUIElement parent, int gridX, int gridY, int gridSize, int type, int cutDirection){
    super(parent, gridX, gridY, gridSize);
    println("type: " + type);
    this.type = type;
    this.cutDirection = cutDirection;
    
    switch(type){
      case(0): this.unSelectedColor = redColor;
        break;
      case(1): this.unSelectedColor = blueColor;
        break;
      default: println("Error! Invalid type" + type + " for gridblock " + this + " !!");
    }
  }
  
  public void display(){
    super.display();
    
    fill(#FFFFFF);
    noStroke();
    switch(cutDirection){
      case(0):
        ellipse(this.getX() + this.getWidth() * 0.5, this.getY() + this.getHeight() * 0.5, this.getWidth() * 0.5, this.getHeight() * 0.5);
        break;
      case(1):
        triangle(this.getX(), 
        this.getY(), 
        this.getX() + this.getWidth(),
        this.getY(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(2):
        triangle(this.getX() + this.getWidth(), 
        this.getY(), 
        this.getX() + this.getWidth(),
        this.getY() + this.getHeight(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(3):
        triangle(this.getX() + this.getWidth(), 
        this.getY() + this.getHeight(),
        this.getX(),
        this.getY() + this.getHeight(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
      case(4):
        triangle(this.getX(), 
        this.getY(),
        this.getX(),
        this.getY() + this.getHeight(),
        this.getX() + this.getWidth() * 0.5,
        this.getY() + this.getHeight() * 0.5);
        break;
    }
  }
}

class GUIElement{
  private int x, y, w, h = 0;
  private float halfWidth, halfHeight = 0;
  private GUIElement parent;
  private color fillColor   = #555555;
  private color strokeColor = #000000;
  
  private String name = null;
  
  GUIElement(){
    parent = null;
  }
  
  GUIElement(int x, int y, int w, int h){
    this.parent = new GUIElement();
    this.setX(x);
    this.setY(y);
    this.setWidth(w);
    this.setHeight(h);
  }
  
  GUIElement(GUIElement parent, int x, int y, int w, int h){
    this.parent = parent;
    this.setX(x);
    this.setY(y);
    this.setWidth(w);
    this.setHeight(h);
  }
  
  public boolean checkClicked(int mx, int my){
    /*
    println("this.getX() " + this.getX());
    println("this.getX() + this.getWidth() " + (this.getX() + this.getWidth()));
    println("this.getY() " + this.getY());
    println("this.getY() + this.getHeight() " + (this.getY() + this.getHeight()));
    println("");
    */
    // Need to take min and max to account for possible negative height or width
    int minX = min(this.getX(), this.getX() + this.getWidth());
    int maxX = max(this.getX(), this.getX() + this.getWidth());
    
    int minY = min(this.getY(), this.getY() + this.getHeight());
    int maxY = max(this.getY(), this.getY() + this.getHeight());
    
    if((minX <= mx && maxX  >= mx) && (minY <= my && maxY >= my))
      return true; 
    return false;
  }
  
  // Getters
  public int getX(){
    if(parent == null)
      return x;
    return x + this.parent.getX();
  }
  
  public int getY(){
    if(parent == null)
      return y;
    return y + parent.getY(); 
  }
  
  public int getLocalX(){
    return x; 
  }
  
  public int getLocalY(){
    return y; 
  }
  
  public int getWidth(){
    return w; 
  }
  
  public int getHeight(){
    return h; 
  }
  
  public float getHalfWidth(){
    return halfWidth;
  }
  
  public float getHalfHeight(){
    return halfHeight;
  }
  
  public color getFillColor(){
    return fillColor;
  }
  
  public color getStrokeColor(){
    return strokeColor;
  }
  
  public String getElementName(){
    return name;
  }
  
  // Setters
  public void setX(int x){
    this.x = x;
  }
  
  public void setY(int y){
    this.y = y;
  }
  
  public void setWidth(int w){
    this.w = w;
    this.halfWidth = w/2;
  }
  
  public void setHeight(int h){
    this.h = h;
    this.halfHeight = h/2;
  }
  
  public void setParent(GUIElement parent){
    this.parent = parent; 
  }
  
  public GUIElement getParent(){
    return this.parent;
  }
  
  public void setFillColor(color fillColor){
    this.fillColor = fillColor;
  }
  
  public void setStrokeColor(color strokeColor){
    this.strokeColor = strokeColor;
  }
  
  // setName() is already a function in processing
  public void setElementName(String name){
    this.name = name;
  }
  
  public void display(){
    this.display(false);
  }
  
  public void display(boolean debug){
    
    debug = false;
    
    fill(this.getFillColor());
    stroke(strokeColor);
    strokeWeight(1);
    rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    
    if(debug){
      fill(#ffffff);
      textSize(10);
      text("x: " + this.getX(), this.getX() - this.getWidth(), this.getY());
      text("y: " + this.getY(), this.getX() - this.getWidth(), this.getY() + 10);
      
      noFill();
      stroke(#ffff00);
      rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    }
  }
}

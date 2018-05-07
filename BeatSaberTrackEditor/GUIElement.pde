class GUIElement{
  private int x, y, w, h = 0;
  private GUIElement parent;
  private color fillColor   = #555555;
  private color strokeColor = #000000;
  
  private String name = null;
  
  
  
  GUIElement(){
    parent = null;
  }
  
  GUIElement(int x, int y, int w, int h){
    this.parent = new GUIElement();
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  GUIElement(GUIElement parent, int x, int y, int w, int h){
    this.parent = parent;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public boolean checkClicked(int mx, int my){
    if((this.getX() <= mx && this.getX() + this.getWidth() >= mx) &&
    (this.getY() <= my && this.getY() + this.getHeight() >= my))
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
  }
  
  public void setHeight(int h){
    this.h = h;
  }
  
  public void setParent(GUIElement parent){
    this.parent = parent; 
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
    fill(fillColor);
    stroke(strokeColor);
    strokeWeight(1);
    rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    
    if(debug){
      fill(#ffffff);
      textSize(10);
      text("x: " + this.getX(), this.getX() - this.getWidth(), this.getY());
      text("y: " + this.getY(), this.getX() - this.getWidth(), this.getY() + 10);
    }
  }
}

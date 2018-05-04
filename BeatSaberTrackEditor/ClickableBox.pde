class ClickableBox extends GUIElement{

  boolean selected = false;
  color unSelectedColor = color(#DDDDDD);
  color selectedColor = color(#FFFF00);
  
  ClickableBox(GUIElement parent, int x, int y, int size) {
    super(parent, x, y, size, size);
  }
  
  boolean checkClicked(int mx, int my){
    if((this.getX() - this.getWidth() <= mx && this.getX() + this.getWidth() >= mx) &&
    (this.getY() - this.getHeight() <= my && this.getY() + this.getHeight() >= my))
      return true; 
    return false;
  }
  
  public void display(){
    if(selected){
      this.setFillColor(selectedColor);
    }else{
      this.setFillColor(unSelectedColor);
    }
    super.display();
  }
}

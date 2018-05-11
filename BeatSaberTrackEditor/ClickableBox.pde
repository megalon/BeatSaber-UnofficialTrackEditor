class ClickableBox extends GUIElement{

  boolean selected = false;
  color unSelectedColor = color(#DDDDDD);
  color selectedColor = color(#FFFF00);
  
  ClickableBox(GUIElement parent, int x, int y, int w, int h) {
    super(parent, x, y, w, h);
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

class Tab extends ClickableBox{
  
  String text;
  
  Tab(GUIElement parent, int x, int y, int w, int h, String text){
    super(parent, x, y, w, h);
    
    this.text = text;
  }
  
  public void display(){
    super.display();
    
    fill(#000000);
    text(text, this.getX() + 5, this.getY() + 18);
  }
  
}
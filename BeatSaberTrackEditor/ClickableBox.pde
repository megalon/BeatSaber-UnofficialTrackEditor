class ClickableBox extends GUIElement{

  boolean selected = false;
  color unSelectedColor = color(#DDDDDD);
  color selectedColor = color(#FFFF00);
  
  ClickableBox(GUIElement parent, int x, int y, int size) {
    super(parent, x, y, size, size);
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

class NumberBox extends GUIElement{
  
  private String name = "NO NAME";
  private float value = 0;
    
  private int fontSize = 12;
  
  NumberBox(int x, int y, int w, int h, String name){
    super(x, y, w, h);
    this.name = name;
  }
  
  NumberBox(GUIElement parent, int x, int y, int w, int h, String name){
    super(parent, x, y, w, h);
    this.name = name;
  }
  
  public float getValue(){
    return value;
  }
  
  // Set value from string
  public void setValue(String value){
    this.value = float(value);
  }
  
  public void setValue(float value){
    this.value = value;
  }
  
  public boolean checkEditing(int mx, int my){
    boolean clicked = super.checkClicked(mx, my);
    
    return clicked;
  }
  
  public void display(){
    
    fill(#555555);
    super.display();
    
    textSize(fontSize);
    fill(#ffffff);
    text(name, this.getX(), this.getY());
    text(value, this.getX(), this.getY() + fontSize + 4);
  }
}

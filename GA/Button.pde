class Button
{
  int x, y;
  int w, h;
  String string;
  
  Button(int x_, int y_, int w_, int h_, String string_)
  {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    string = string_;
  }
  
  boolean clicked()
  {
    return (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h);
  }
  
  void render()
  {
    rectMode(CORNER);
    pushMatrix();
    translate(x, y);
    stroke(0);
    strokeWeight(2);
    fill(177);
    rect(0, 0, w, h);
    textSize(26);
    fill(0);
    text(string, 10, h - 10);
    popMatrix();
  }
}

import processing.net.*;

Client client;
String input;
int data[];
int ID;

SnakeBody s, s2;
Apple a;
int mode;
float maxPlaneX, minPlaneX, maxPlaneY, minPlaneY;
Button b;
color c;

void setup() {

  size(500, 500, P3D);
  background(0);
  c =  color(100+155*sin(ID), 100+155*cos(ID), 100+155*tan(ID));
  s = new SnakeBody((int)(width/40)*20, (int)(height/40)*20, 0, 20, c);
  s2 = new SnakeBody((int)(width/30)*20, (int)(height/30)*20, 0, 20, c);
  a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20); 
  b = new Button("PLAY", width/4, height/4, width/2, height/2);
  mode = 1;
}

public void openingScreen() {
  background(0);
  b.display();
  if (b.isClicked()) {
    client = new Client(this, "192.168.1.8", 1234);
    String joinRequest = client.readString();
    ID = int(joinRequest.substring(0, joinRequest.indexOf("join")));
    client.write("" + ID + "join");
    println(client.readString());
    mode = 2;
  }
}
void draw() {

  if (mode == 1) {
    openingScreen();
  }

  if (mode == 2) {
    lights();
    checkKeys();
    if (frameCount%4==0) {

      textSize(15);
      text(s.segments.size(), 15, 15);
      background(0);

      s2.move();
      s.move();
      s2.display();
      s.display();

      if (s.ate(a) || s2.ate(a)) {
        a.move(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0); 
        s.grow();
        s2.grow();
      }
      a.display();
    }
    if (!inBounds()) {
      client.write("" + ID + "score"+ (s.segments.size()-5));
      mode = 3;
    }
    if (s.isDead) {
      client.write("" + ID + "score"+ (s.segments.size()-5));
      mode = 3;
    }
  }
  if (mode == 3) {
    background(0);
    fill(255, 0, 0);
    textSize(width/8);
    textAlign(CENTER, CENTER);
    text("YOU LOSE", width/2, height/3);
    textSize(25);
    text("Score: " + (s.segments.size()-5), width/2, height/2);
    b = new Button("Play Again", width/4, 3 * height/4, width/2, height/8);
    b.display();
    if (b.isClicked()) {
      resetBoard();
    }
  }
}

public void resetBoard() {
  mode = 2;
  s = new SnakeBody((int)(width/40)*20, (int)(height/40)*20, 0, 20, c);
  s2 = new SnakeBody((int)(width/30)*20, (int)(height/30)*20, 0, 20, c);
  a = new Apple(((int)random((width/20)-1))*20+20, ((int)random((height/20)-1))*20+20, 0, 20);
}

boolean inBounds() {
  return s.getPosition()[0] - 20 >= 0 && s.getPosition()[0] + 20<= width && s.getPosition()[1] -20 >= 0 && s.getPosition()[1] +20 <= height;
}

void checkKeys() {
  if (keyPressed) {
    if (key == 'w' && s.dy!= 1) {
      //s.turnUp();
      client.write(""+ID+"up"+"\n");
    }
    if (key == 'a' && s.dx != 1) {
      //s.turnLeft();
      client.write(""+ID+"left"+"\n");
    }
    if (key == 's' && s.dy != -1) {
      //s.turnDown();
      client.write(""+ID+"down"+"\n");
    }
    if (key == 'd' && s.dx != -1) {
      //s.turnRight();
      client.write(""+ID+"right"+"\n");
    }

    String command = client.readString();
    if (command!=null) {
      println(command);
      if (command.indexOf("up")>0) {
        println("GOING UP");
        s.turnUp();
        s2.turnUp();
      }
      if (command.indexOf("left")>0) {
        println("GOING LEFT");
        s.turnLeft();
        s2.turnLeft();
      }
      if (command.indexOf("down")>0) {
        println("GOING DOWN");
        s.turnDown();
        s2.turnDown();
      }
      if (command.indexOf("right")>0) {
        println("GOING RIGHT");
        s.turnRight();
        s2.turnRight();
      }
    }
  }
}
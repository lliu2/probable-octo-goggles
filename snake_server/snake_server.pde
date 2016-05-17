import processing.net.*;

Server s;
int connectedClients;

void setup() {
  size(200, 200);
  s = new Server(this, 1234);
  textAlign(CENTER, CENTER);
  textSize(width/4);
  connectedClients=0;
}

void draw() {
  background(0);
  Client thisClient = s.available();
  if (thisClient!=null) {
    String data = thisClient.readString();
    if (data!=null) {
      fill(255);
      text(data, width/2, height/2);
      s.write(data);
    }
    
  }
}

void serverEvent(Server someserver, Client aclient) {
  println("New client joined with IP: " + aclient.ip());
  connectedClients++;
  someserver.write("" + connectedClients + "join");
  //s.write(joinRequest);
}

void disconnectEvent(Client aclient){
  connectedClients--;
  println("Client disconnect\nConnected clients: " + connectedClients);
}
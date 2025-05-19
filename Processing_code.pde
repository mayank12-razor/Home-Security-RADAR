import processing.serial.*;

Serial myPort;
String data;
int iAngle = 0;
int iDistance = 0;

void setup() {
  size(800, 600);
  myPort = new Serial(this, "COM8", 9600); // Change to your COM port
  myPort.bufferUntil('.');
  smooth();
  textFont(createFont("Arial", 20));
}

void draw() {
  background(0);

  // Draw title
  fill(0, 255, 0);
  textAlign(CENTER);
  textSize(28);
  text("Home Security RADAR", width / 2, 40);

  translate(width / 2, height - 20); // Place radar origin at bottom center
  drawRadarGrid();
  drawSweepLine();
  drawObjectDot(iAngle, iDistance);
}

void serialEvent(Serial p) {
  data = p.readStringUntil('.');
  if (data != null) {
    data = trim(data);
    String[] parts = split(data, ',');
    if (parts.length == 2) {
      iAngle = int(parts[0]);
      iDistance = int(parts[1]);
    }
  }
}

void drawRadarGrid() {
  stroke(0, 255, 0);
  noFill();

  // Draw semicircular arcs for 10–40 cm
  for (int i = 1; i <= 4; i++) {
    float radius = i * 100;  // each 100 pixels = 10 cm
    arc(0, 0, radius * 2, radius * 2, PI, TWO_PI);
  }

  // Draw angle lines (every 30 degrees)
  for (int angle = 0; angle <= 180; angle += 30) {
    float x = cos(radians(angle)) * 400;
    float y = sin(radians(angle)) * 400;
    line(0, 0, x, -y);
  }

  // Draw distance labels
  fill(0, 255, 0);
  textSize(12);
  textAlign(CENTER);
  for (int i = 1; i <= 4; i++) {
    text(i * 10 + " cm", 0, -i * 100 + 15);
  }
}

void drawSweepLine() {
  stroke(0, 255, 0);
  strokeWeight(2);
  float x = cos(radians(iAngle)) * 400;
  float y = sin(radians(iAngle)) * 400;
  line(0, 0, x, -y);
}

void drawObjectDot(int angle, int distance) {
  if (distance > 0 && distance <= 40) {
    float r = map(distance, 0, 40, 0, 400);
    float x = cos(radians(angle)) * r;
    float y = sin(radians(angle)) * r;

    // Color based on distance
    if (distance <= 10) {
      fill(255, 0, 0); // Red
    } else if (distance <= 20) {
      fill(255, 50, 50); // Light Red
    } else if (distance <= 30) {
      fill(0, 255, 0); // Green
    } else {
      fill(0, 0, 255); // Blue
    }

    noStroke();
    ellipse(x, -y, 10, 10);
  }
}

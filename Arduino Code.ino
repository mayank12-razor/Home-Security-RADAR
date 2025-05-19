#include <Servo.h>

const int trigPin = 9;
const int echoPin = 10;
const int redLED = 2;
const int greenLED = 3;
const int blueLED = 4;
const int buzzer = 5;

Servo myServo;

long duration;
int distance;

void setup() {
  Serial.begin(9600);
  myServo.attach(6);
  
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  
  pinMode(redLED, OUTPUT);
  pinMode(greenLED, OUTPUT);
  pinMode(blueLED, OUTPUT);
  pinMode(buzzer, OUTPUT);
}

void loop() {
  for (int angle = 0; angle <= 180; angle++) {
    myServo.write(angle);
    delay(15);
    distance = getDistance();
    sendData(angle, distance);
    updateAlerts(distance);
  }

  for (int angle = 180; angle >= 0; angle--) {
    myServo.write(angle);
    delay(15);
    distance = getDistance();
    sendData(angle, distance);
    updateAlerts(distance);
  }
}

int getDistance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);
  return duration * 0.034 / 2;
}

void sendData(int angle, int distance) {
  Serial.print(angle);
  Serial.print(",");
  Serial.print(distance);
  Serial.println(".");
}

void updateAlerts(int dist) {
  // Turn off everything
  digitalWrite(redLED, LOW);
  digitalWrite(greenLED, LOW);
  digitalWrite(blueLED, LOW);
  digitalWrite(buzzer, LOW);

  if (dist <= 10) {
    digitalWrite(buzzer, HIGH);
    digitalWrite(redLED, HIGH);
  } else if (dist <= 20) {
    digitalWrite(redLED, HIGH);
  } else if (dist <= 30) {
    digitalWrite(greenLED, HIGH);
  } else if (dist <= 40) {
    digitalWrite(blueLED, HIGH);
  }
}



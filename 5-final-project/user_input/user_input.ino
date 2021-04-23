int xyzPins[] = {27, 26, 25};

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  pinMode(xyzPins[2], INPUT_PULLUP);
  pinMode(18, INPUT_PULLUP);
}

void loop() {
  // put your main code here, to run repeatedly:
  int xVal = analogRead(xyzPins[0]);
  int yVal = analogRead(xyzPins[1]);
  int zVal = digitalRead(xyzPins[2]);
  int buttonVal = digitalRead(18);
  Serial.printf("%d,%d,%d,%d\n", xVal, yVal, zVal, buttonVal);
  delay(500);
}

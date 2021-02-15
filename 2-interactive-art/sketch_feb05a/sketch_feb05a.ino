int xyzPins[] = {13, 12, 14};

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(xyzPins[2], INPUT_PULLUP);
  pinMode(25, INPUT_PULLUP);
  pinMode(27, INPUT_PULLUP);
  pinMode(33, INPUT_PULLUP);
}

void loop() {
  // put your main code here, to run repeatedly:
  int xVal = analogRead(xyzPins[0]);
  int yVal = analogRead(xyzPins[1]);
  int zVal = digitalRead(xyzPins[2]);
  int buttonVal1 = digitalRead(25);
  int buttonVal2 = digitalRead(33);
  int switchVal = digitalRead(27);
  Serial.printf("%d,%d,%d,%d,%d,%d\n", xVal, yVal, zVal, buttonVal1, buttonVal2, switchVal);
  delay(200);
}

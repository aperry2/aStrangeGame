import processing.serial.*;

boolean debugMode = false;
boolean emuMode = false; // pull data from an emulated board
boolean displayReady = false; // is the image ready to be projected?
boolean noise = false; // use noise to fill emulated board
boolean quarterBoard = false;
boolean progression = false;
boolean drawBoard = false;
boolean drawBg = true;

int numOfImages = 64;
int squares = 64;
int cols = 8;
int rows = 8;

long waitTime = 100;
long lastCheckTime = 0;

Serial myPort;        // The serial port
float inByte = 0;
int counter = 0;
int coveredSquareCounter = 0;
int clicker = 0;
int threshold = 20;
int[] data = new int[squares];
int[] stateA = new int[squares];
int[] stateB = new int[squares];

PImage[] icon = new PImage[numOfImages];

PGraphics pg;
PImage pattern;
PImage maskImg;
  
PFont f;
float xOff = 0.0;
float yOff = 0.0;

int opacity = 255;
int value = 255;
int lineColor = color(value, opacity);

void setup () {
  if (quarterBoard) {
    squares = 16;
    cols = 4;
    rows = 4;
  }
  // font stuff
  f = loadFont("ModeSeven-40.vlw");
  if (!emuMode) {
    // serial communication stuff
    myPort = new Serial(this, Serial.list()[0], 9600);
    myPort.clear();
    //// don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');
  } else {
    displayReady = true;
  }
  
  // sketch stuff
  // size(1000, 800, P3D);
  fullScreen(P3D, 2);
  noStroke();
  
  // state initialization
  for (int i = 0; i < stateA.length; i++) {
    stateA[i] = 0;
    stateB[i] = 0;
  }
   
  imageInitialization();
}

void draw () {
  updateStates();
  if (drawBg) {
    background(pg);
  } else {
    background(0);
  }
  coveredSquareCounter = 0;
  for (int i = 0; i < squares; i++) {
    if (data[i] < threshold) {
      coveredSquareCounter++;
    }
  }
  if (counter >= numOfImages) {
    counter = 0;
  }
  if (clicker >= numOfImages) {
    clicker = 0;
  }
  //checkEmuStatus();
  if (drawBoard) {
    drawBoard();
  }
  if (debugMode) {
    //drawSensorStatus();
    drawStateStatus();
  }
  counter++;
  checkDisplayReady();
  checkImage();
}

void checkDisplayReady() {
  if (displayReady == false) {
    background(0);
    textFont(f, 20);
    textAlign(CENTER);
    fill(0, 255, 0);
    text("press 1 to start, 0 to end", width/2, height/2);
  }
}

void checkImage() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int a = stateA[i * cols + j];
      int b = stateB[i * cols + j];
      if (a < threshold && b > threshold) {
        if (i * cols + j < numOfImages) {
          bufferBackground(i * cols + j);
        }
      }
    }
  }
}

void updateStates() {
  long now = millis();
  if (now - lastCheckTime > waitTime) {
    lastCheckTime = now;
    for (int i = 0; i < data.length; i++) {
      stateB[i] = stateA[i];
      stateA[i] = data[i];
    }  
  }
}

void drawStateStatus() {
  noStroke();
  textFont(f, 10);
  textAlign(LEFT);
  
  // draw live feed of sensor data input
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int num = data[j * rows + i];
      fill(color(num));
      rect(10 + i * 50, 10 + j * 50, 45, 45);
      fill(color(255, 0, 0));
      text(num, 10 + i * 50, 10 + j * 50 + 20);
      text((j * rows + i), 10 + i * 50, 10 + j * 50 + 30);
    }
  }
  
  // draw state change flags
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) { // 350 + j
      int a = stateA[j * rows + i];
      int b = stateB[j * rows + i];
      if (a < threshold && b > threshold) {
        fill(color(255, 0, 0));
        rect(450 + i * 50, 10 + j * 50, 45, 45);
        fill(color(0, 255, 0));
        text("X", 450 + i * 50, 1 + j * 50 + 20);
        text((j * rows + i), 450 + i * 50, 10 + j * 50 + 30);
      }
    }
  }
  println(clicker);
  
  /*
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) { // 350 + i
      int num = stateA[i * 4 + j];
      fill(color(num));
      rect(450 + i * 50, 200 + j * 50, 45, 45);
      fill(color(255, 0, 0));
      text(num, 450 + i * 50, 200 + j * 50 + 20);
      text((i * 4 + j), 450 + i * 50, 200 + j * 50 + 30);
    }
  }
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) { // 350 + i, 350 + j
      int num = stateB[i * 4 + j];
      fill(color(num));
      rect(450 + i * 50, 450 + j * 50, 45, 45);
      fill(color(255, 0, 0));
      text(num, 450 + i * 50, 450 + j * 50 + 20);
      text((i * 4 + j), 450 + i * 50, 450 + j * 50 + 30);
    }
  }
  */
}

void drawSensorStatus() {
  noStroke();
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int traversalNum = i * cols + j;
      color c = color(data[traversalNum]);
      fill(c);
      rect(i * 50, j * 50, 50, 50);
      textFont(f, 10);
      textAlign(LEFT);
      fill(255, 0, 0);
      text(data[traversalNum], i * 50, (j * 50) + 20);
      print("data["+ traversalNum + "]: " + data[traversalNum] + "  ");
    }
    println();
    println("covered squares: " + coveredSquareCounter);
  } 
}
 //<>//
void keyPressed() {
  if (key == '1') {
    establishContact();
  }
  if (key == '0') {
    myPort.write('0');
    displayReady = false;
    println("communication ended");
  }
  if (key == 'h') {
    debugMode = true;
  }
  if (key == 'j') {
    debugMode = false;
  }
  if (key == 's') {
    save("screenshot" + millis() + ".jpg");
  }
  if (key == 'd') {
    drawBoard = true;
  }
  if (key == 'f') {
    drawBoard = false;
  }
  if (key == 'x') {
    drawBg = false;
  }
  if (key == 'c') {
    drawBg = true;
  }
  if (key == ',') {
    value = 0;
    lineColor = color(value, opacity);
  }
  if (key == '.') {
    value = 255;
    lineColor = color(value, opacity);
  }
  if (key == '-') {
    opacity = 255;
    lineColor = color(value, opacity);
  }
  if (key == '=') {
    opacity = 127;
    lineColor = color(value, opacity);
  }
}

void mousePressed() {
  clicker++;
}
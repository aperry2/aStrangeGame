// Alan Perry
// 10/25/17
// program that takes data in from an arduino with 16 photoresistors and displays that information
// as a representation of piece positions on a chess board.

import processing.serial.*;

boolean debugMode = false;
boolean emuMode = false; // pull data from an emulated board
boolean displayReady = false; // is the image ready to be projected?
boolean noise = true; // use noise to fill emulated board

Serial myPort;        // The serial port
float inByte = 0;
int counter = 0;
int coveredSquareCounter = 0;
int[] data = new int[16];
int clicker = 0;
int threshold = 20;

PImage imgMask;
PImage placeImage;
int numOfImages = 16;
PFont f;
float xOff = 0.0;
float yOff = 0.0;
int cols = 4;
int rows = 4;

void setup () {
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
  //size(500, 400);
  fullScreen(P3D, 1);
  background(0);
  noStroke();
  frameRate(32);
}

void draw () {
  coveredSquareCounter = 0;
  for (int i = 0; i < numOfImages; i++) {
    if (data[i] < threshold) {
      coveredSquareCounter++;
    }
  }
  if (counter >= 16) {
    counter = 0;
  }
  if (clicker >= 16) {
    clicker = 0;
  }
  if (emuMode) {
    if (noise) {
      if (millis() % 10 == 0) {
        refreshData();
      }
    } else {
      data[0] = 0;
      data[1] = 0;
      data[2] = 255;
      data[3] = 255;
      data[4] = 255;
      data[5] = 255;
      data[6] = 255;
      data[7] = 255;
      data[8] = 255;
      data[9] = 255;
      data[10] = 255;
      data[11] = 255;
      data[12] = 255;
      data[13] = 255;
      data[14] = 255;
      data[15] = 255;
    }
  }
  drawBoard();
  if (debugMode) {
    drawSensorStatus();
    println("covered squares: " + coveredSquareCounter);
    println(millis());
  }
  counter++;
  if (displayReady == false) {
    background(0);
  }
}

// debug information on sensor data
void drawSensorStatus() {
  noStroke();
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      int traversalNum = i * 4 + j;
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
  } 
}

// keypress functions
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
}

// not used
void mousePressed() {
  clicker++;
}

void drawBoard() {
  background(0);
  pushMatrix();
  translate(width/2 - 150, height/2, 0);
  rotateX(radians(60));
  stroke(184, 115, 51);
  strokeWeight(5);
  noFill();
  drawRows();
  drawCols();
  popMatrix();
}

void drawRows() {
  for (int y = 0; y < cols; y++) {
    beginShape();
    for (int x = 0; x < rows; x++) {
      int traversalNum = x * 4 + y;
      vertex(x * 100, y * 100, (255 - data[traversalNum]) * .75);
    }
    endShape();
  }
}

void drawCols() {
  for(int x = 0; x < rows; x++){
    beginShape();
    for(int y = 0; y < cols; y++){
      int traversalNum = x * 4 + y;
      vertex(x * 100, y * 100, (255 - data[traversalNum]) * .75);
    }
    endShape();
  }
}
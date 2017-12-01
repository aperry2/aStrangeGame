void drawBoard() {
  pushMatrix();
  if (!quarterBoard) {
    translate(width/2 - 350, height/2 - 200, -400);
  } else {
    translate(width/2 - 150, height/2 + 50, 0);  
  }
  rotateX(radians(60));
  stroke(lineColor);
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
      int traversalNum = x * cols + y;
      vertex(x * 100, y * 100, (255 - data[traversalNum]) * .75);
    }
    endShape();
  }
}

void drawCols() {
  for(int x = 0; x < rows; x++){
    beginShape();
    for(int y = 0; y < cols; y++){
      int traversalNum = x * rows + y;
      vertex(x * 100, y * 100, (255 - data[traversalNum]) * .75);
    }
    endShape();
  }
}
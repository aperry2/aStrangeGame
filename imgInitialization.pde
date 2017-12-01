void imageInitialization() {  
  for (int i = 0; i < icon.length; i++) {
    icon[i] = loadImage("img/" + i + ".jpg");
  }

  pattern = loadImage("img/pattern.jpg");
  maskImg = loadImage("img/mask.jpg");

  pg = createGraphics(width, height);
  pattern.resize(width, height);
  maskImg.resize(height, 0);
  
  //for (int i = 0; i < icon.length; i++) {
  //  icon[i].resize(height, 0);
  //  icon[i].mask(maskImg);
  //}
  pg.beginDraw();
  pg.image(pattern, 0, 0);
  pg.fill(0);
  pg.textFont(f, 20);
  pg.textAlign(CENTER);
  pg.text("A strange game.\nThe only winning move is not to play.\nHow about a nice game of chess?", width/2, height/2);
  pg.endDraw();
}

void bufferBackground(int imgNum) {
  PImage img = loadImage("img/" + imgNum + ".jpg");
  img.resize(height, 0);
  img.mask(maskImg);
  pg.beginDraw();
  pg.image(pattern, 0, 0);
  pg.image(img, (width - height) / 2, 0);
  pg.endDraw();
}
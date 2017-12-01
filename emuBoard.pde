void refreshData() {
  for (int i = 0; i < data.length; i++) {
    data[i] = int(noise(xOff, yOff) * 255);
    xOff = xOff + .2;
    yOff = yOff + .2;
  }
}

void checkEmuStatus() {
  if (emuMode) {
    refreshData();
    if (!noise) {
      if (!progression) {
        if (!quarterBoard) { // if full board
          for (int i = 0; i < 16; i++) {
            data[i] = 0;
          }
          for (int i = 16; i < 48; i++) {
            data[i] = 255;
          }
          for (int i = 48; i < 64; i++) {
            data[i] = 0;
          }
        } else { // if quarter board
          for (int i = 0; i < 4; i++) {
            data[i] = 0;
          }
          for (int i = 4; i < 12; i++) {
            data[i] = 255;
          }
          for (int i = 12; i < 16; i++) {
            data[i] = 0;
          }
        }
      } else {
        for (int i = 0; i < 64; i++) {
          data[i] = 255;
        }
        //data[int(random(0, 63))] = 0;
      }
    }
  }
}
void refreshData() {
  for (int i = 0; i < data.length; i++) {
    data[i] = int(noise(xOff, yOff) * 255);
    xOff = xOff + .5;
    yOff = yOff + .5;
  }
}
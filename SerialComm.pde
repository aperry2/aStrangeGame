void serialEvent (Serial myPort) {
  // get the ASCII string:
  if (myPort.available() > 0) {
    String inString = myPort.readStringUntil('\n');
    
    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      String newString[] = split(inString, ',');
      for (int i = 0; i < 64; i++) { // 64 is the current working number of sensors
        data[i] = int(newString[i]);
        //data[i] = data[i] / 4;
      }
    }
    myPort.clear();
  }
}

void establishContact() {
  myPort.write('1');
  println("data sent");
  displayReady = true;
}
void serialEvent (Serial myPort) {
  // get the ASCII string:
  if (myPort.available() > 0) {
    String inString = myPort.readStringUntil('\n');
    
    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      String newString[] = split(inString, '\t');
      for (int i = 0; i < 16; i++) {
        data[i] = int(newString[i]);
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
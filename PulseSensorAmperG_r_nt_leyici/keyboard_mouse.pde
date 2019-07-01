
void mousePressed(){
  scaleBar.press(mouseX, mouseY);
  if(!serialPortFound){
    for(int i=0; i<button.length; i++){
      if(button[i].pressRadio(mouseX,mouseY)){
        try{
          port = new Serial(this, Serial.list()[i], 115200);  // arduino ile seri haberleşme bant hızı ayarlanıyor
          delay(1000);
          println(port.read());
          port.clear();            
          port.bufferUntil('\n');  
          serialPortFound = true;
        }
        catch(Exception e){
          println("Couldn't open port " + Serial.list()[i]);
        }
      }
    }
  }
}

void mouseReleased(){
  scaleBar.release();
}

void keyPressed(){

 switch(key){
   case 's':    
   case 'S':
     saveFrame("heartLight-####.jpg");    //S ye basıldıgında resim alıyor 
     break;

   default:
     break;
 }
}

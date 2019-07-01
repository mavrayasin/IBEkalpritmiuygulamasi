
void serialOutput(){   // seri çıkış kontrolü
 if (serialVisual == true){  
     arduinoSerialMonitorVisual('-', Signal);   // seri ekrana ne gösterilecek ayarlamaları
 } else{
      sendDataToSerial('S', Signal);     
 }        
}
//  bpm ıbı verileri nasıl gösterilecek
void serialOutputWhenBeatHappens(){    
 if (serialVisual == true){           
    Serial.print("*** Heart-Beat Happened *** "); 
    Serial.print("BPM: ");
    Serial.print(BPM);
    Serial.print("  ");
 } else{
        sendDataToSerial('B',BPM);   // bpm in başına b gelecek
        sendDataToSerial('Q',IBI);   // ıbı nin basşına da q gelecek 
 }   
}
//  verileri processing programına gönderme kısmı
void sendDataToSerial(char symbol, int data ){
    Serial.print(symbol);
    Serial.println(data);                
  }
void arduinoSerialMonitorVisual(char symbol, int data ){    
  const int sensorMin = 0;     
  const int sensorMax = 1024;   
  int sensorReading = data;
  int range = map(sensorReading, sensorMin, sensorMax, 0, 11);
  switch (range) {
  case 0:     
    Serial.println("");    
    break;
  case 1:   
    Serial.println("---");
    break;
  case 2:    
    Serial.println("------");
    break;
  case 3:    
    Serial.println("---------");
    break;
  case 4:   
    Serial.println("------------");
    break;
  case 5:   
    Serial.println("--------------|-");
    break;
  case 6:   
    Serial.println("--------------|---");
    break;
  case 7:   
    Serial.println("--------------|-------");
    break;
  case 8:  
    Serial.println("--------------|----------");
    break;
  case 9:    
    Serial.println("--------------|----------------");
    break;
  case 10:   
    Serial.println("--------------|-------------------");
    break;
  case 11:   
    Serial.println("--------------|-----------------------");
    break;
  
  } 
}

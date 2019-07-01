

import processing.serial.*;
PFont font;
PFont portsFont;
Scrollbar scaleBar;

Serial port;

int Sensor;      // arduino sensöründen gelen veriyi saklayan değişken
int IBI;         // kalp atış zamanını arduinodan çeken değişken
int BPM;         // bpm i çekecek değişken
int[] RawY;      // y eksenindeki dalga boyutunu tutacak değişken
int[] ScaledY;   // kalp atış dalga ölceğini kullanmak için
int[] rate;      // bpm dalga ölçeğini kulanmak için
float zoom;      
float offset;    // değişen Pulse'ları göstermek için kullanılan değişkenler
color eggshell = color(255, 253, 248);
int heart = 0;   // Ana değişkenimiz 
//  açılacan pencerelerin boyutları
int PulseWindowWidth = 490;
int PulseWindowHeight = 512;
int BPMWindowWidth = 180;
int BPMWindowHeight = 340;
boolean beat = false;   

//Dogru portu bulma ve atama islemi
String serialPort;
String[] serialPorts = new String[Serial.list().length];
boolean serialPortFound = false;
Radio[] button = new Radio[Serial.list().length];


void setup() {
  size(700, 600);  // program boyutu
  frameRate(100);
  font = loadFont("Arial-BoldMT-24.vlw");
  textFont(font);
  textAlign(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);

  scaleBar = new Scrollbar (400, 575, 180, 12, 0.5, 1.0);  // parametreler set ediliyor
  RawY = new int[PulseWindowWidth];          // dalga dizilerini başlatıyor
  ScaledY = new int[PulseWindowWidth];       // pulse dalga ölceğini başlatıyor
  rate = new int [BPMWindowWidth];           // bpm dalga dizi ölceğini başlatıyor
  zoom = 0.75;                               // kalp atış penceresini zoomluyor

 for (int i=0; i<rate.length; i++){
    rate[i] = 555;      
   }
 for (int i=0; i<RawY.length; i++){
    RawY[i] = height/2; 
 }

 background(0);
 noStroke();

 drawDataWindows();
 drawHeart();

// arduinoya bağlansın diyoruz
  fill(eggshell);
  text("Baglı olan portu seçiniz",245,30);
  listAvailablePorts();

}

void draw() {
if(serialPortFound){
  // port bağlı olunca görüntüleyici açıyor
  background(0);
  noStroke();
  drawDataWindows();
  drawPulseWaveform();
  drawBPMwaveform();
  drawHeart();
// veri ve değişkelerin değerleri yazılıyor
  fill(eggshell);                                       // text e dökülüyor
  text("Pulse Sensor Amper Goruntuleyici",245,30);     // yazılan başlık gösteriliyor
  text("IBI " + IBI + "mS",600,585);                    // kalp atışı zaman ms cinsinden gösteriliyor
  text(BPM + " BPM",600,200);                           // beats per minute(bpm) gösteriliyor
  text("Pulse Genlik Olcegi " + nf(zoom,1,2), 150, 585); // pulse genlik ölceği istege bağlı degişebiliyor 

  scaleBar.update (mouseX, mouseY);
  scaleBar.display();

} else { 

  for(int i=0; i<button.length; i++){
    button[i].overRadio(mouseX,mouseY);
    button[i].displayRadio();
  }

}

}  


void drawDataWindows(){
    // dikdörtgen pencereler olusturuluyor
    fill(eggshell);  //pencere arka planı rengi
    rect(255,height/2,PulseWindowWidth,PulseWindowHeight);
    rect(600,385,BPMWindowWidth,BPMWindowHeight);
}

void drawPulseWaveform(){
  // 
  RawY[RawY.length-1] = (1023 - Sensor) - 212;   
  zoom = scaleBar.getPos();                      // en sonki dalga ölcegi değeri yazılıyor
  offset = map(zoom,0.5,1,150,0);                //offset ölceği hesaplanıyor
  for (int i = 0; i < RawY.length-1; i++) {      // dalga hareketleri başlatılıyor
    RawY[i] = RawY[i+1];                         // pixel kaymaları yapılıyor
    float dummy = RawY[i] * zoom + offset;      
    ScaledY[i] = constrain(int(dummy),44,556);  
  }
  stroke(250,0,0);                               // kırmızı rengi ayarlanıyor
  noFill();
  beginShape();                                  
  for (int x = 1; x < ScaledY.length-1; x++) {
    vertex(x+10, ScaledY[x]);                  
  }
  endShape();
}

void drawBPMwaveform(){
// bpm dalgalarını ciziyor
 if (beat == true){  
   beat = false;     
   for (int i=0; i<rate.length-1; i++){
     rate[i] = rate[i+1];                  // eğer bpm artarsa grafikten y eksenin arttıırıp grafik cizen yer
   }
// then limit and scale the BPM value
   BPM = min(BPM,200);                     // 200 bpm i geçmiyor 
   float dummy = map(BPM,0,200,555,215);   // oranlar ayarlanıyor
   rate[rate.length-1] = int(dummy);      
 }
 stroke(250,0,0);                          // grafik ciziliyor
 strokeWeight(2);                          // grafik ayarları icelik kalınlık vs.
 noFill();
 beginShape();
 for (int i=0; i < rate.length-1; i++){    // i değişkenine göre grafik ciziliyor
   vertex(i+510, rate[i]);                 // göruntu geçmişi siliniyor
 }
 endShape();
}

void drawHeart(){
  //şekildeki kalp ciziliyor
    fill(250,0,0);
    stroke(250,0,0);
    heart--;                    
    heart = max(heart,0);       
    if (heart > 0){             
      strokeWeight(8);          
    }
    smooth();   
    bezier(width-100,50, width-20,-20, width,140, width-100,150);
    bezier(width-100,50, width-190,-20, width-200,140, width-100,150);
    strokeWeight(1);          // reset the strokeWeight for next time
}

void listAvailablePorts(){
  println(Serial.list());    // uygun portlar sıralansın diyoruz
  serialPorts = Serial.list();
  fill(0);
  textFont(font,16);
  textAlign(LEFT);

  int yPos = 0;
  for(int i=serialPorts.length-1; i>=0; i--){
    button[i] = new Radio(35, 95+(yPos*20),12,color(180),color(80),color(255),i,button);
    text(serialPorts[i],50, 100+(yPos*20));
    yPos++;
  }
  textFont(font);
  textAlign(CENTER);
}

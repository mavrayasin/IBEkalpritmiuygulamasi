
//  Değişkenler
int pulsePin = 0;                 
int blinkPin = 13;                
int fadePin = 5;                
int fadeRate = 0;                 

// interruptlar için gelip geçici değişkenler
volatile int BPM;                   // A0 pinine bağlı bpm gösterecek değişken
volatile int Signal;                // gelecek olan raw verisini tutacak
volatile int IBI = 600;             // pulseler arası zaman aralıgını tutar, mecbur bişeye sabitlememiz gerekiyor
volatile boolean Pulse = false;     // canlı bi varlık oldugunda işlem yapsın diyeilk basta false 
volatile boolean QS = false;        // arduino pulse geldiğinde değişmesi için değişken


static boolean serialVisual = false;  


void setup(){
  pinMode(blinkPin,OUTPUT);         // blinkpin ataması
  pinMode(fadePin,OUTPUT);          // fadepin ataması
  Serial.begin(115200);             // biraz hızlı olması için
  interruptSetup();                 // Her 2mS'de Darbe Sensörü sinyalini okumak için ayarlana interrrupt
   //Eğer pinden analog değerler almak istersek pwm izlenir  ====> analogReference(EXTERNAL);  
}
void loop(){
    serialOutput() ;       
  if (QS == true){     // kalpatışı(pulse)geldi ise
                       // bpm ve ıbı yi ayarlansın
        digitalWrite(blinkPin,HIGH);     // led yanacak atış buldugu için
        fadeRate = 255;         // sönme pin ayarlamaları
                                // pulse ye göre yanacak sönecek
        serialOutputWhenBeatHappens();   //kalp atışını seri haberleşmeyle output verilecek   
        QS = false;            
  }
  ledFadeToBeat();                      // Sönecek
  delay(20);                             
}


void ledFadeToBeat(){
    fadeRate -= 15;                         //  sönen led değerleri
    fadeRate = constrain(fadeRate,0,255);   //  sönük bırakmak için negatif sayı verdik
    analogWrite(fadePin,fadeRate);          //  sönük led
  }

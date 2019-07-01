class Scrollbar{
 int x,y;               // x,y  koordinant
 float sw, sh;          // scrollbar genişligi uzunklugu
 float pos;             // başparmak posiszyonu
 float posMin, posMax;  // başparmak max ve min pozisyonlar 
 boolean rollover;      // mouse ile ayarlamak için 
 boolean locked;        // scrollbar aktif pasif ayarı
 float minVal, maxVal;  // min ve max basparmak degerleri

 Scrollbar (int xp, int yp, int w, int h, float miv, float mav){ // parametreleri gelen fonksiyon
  x = xp;
  y = yp;
  sw = w;
  sh = h;
  minVal = miv;
  maxVal = mav;
  pos = x - sh/2;
  posMin = x-sw/2;
  posMax = x + sw/2;  // - sh;
 }

 // başparmak basılı mı değilmi kontrolleri boolean şeklinde
 void update(int mx, int my) {
   if (over(mx, my) == true){
     rollover = true;            // scrollbar da mouse la hareket için
   } else {
     rollover = false;
   }
   if (locked == true){
    pos = constrain (mx, posMin, posMax);
   }
 }


 void press(int mx, int my){
   if (rollover == true){
    locked = true;            // bastığın zaman kitlenen bi yapı
   }else{
    locked = false;
   }
 }

 // scroll barı cıkarken resetlemek için
 void release(){
  locked = false;
 }

 // scrollbar da ki cursora göre genlik ölçeği değişimi
 boolean over(int mx, int my){
  if ((mx > x-sw/2) && (mx < x+sw/2) && (my > y-sh/2) && (my < y+sh/2)){
   return true;
  }else{
   return false;
  }
 }

 //scroll barı ekrana cizme kısmı
 void display (){

  noStroke();
  fill(255);
  rect(x, y, sw, sh);      // scroll bar yap
  fill (250,0,0);
  if ((rollover == true) || (locked == true)){
   stroke(250,0,0);
   strokeWeight(8);           
  }
  ellipse(pos, y, sh, sh);     
  strokeWeight(1);            
 }

 // o an ki başparmaktan alınan değerleri geri döndürüyor
 float getPos() {
  float scalar = sw / sw;  // (sw - sh/2);
  float ratio = (pos-(x-sw/2)) * scalar;
  float p = minVal + (ratio/sw * (maxVal - minVal));
  return p;
 }
 }

import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;



Minim minim;
AudioPlayer in;
AudioSample in2,in3,in4,in5,in6;

boolean upz, downz, rightz, leftz, spacez;
float startx,starty;
String[] Blocks;
String[] Usable;
Blok[] Bloklar;
PImage bg;
PImage menu;

int SKOR,level;

ArrayList nesneler;
ArrayList partic;

Kamera Cam = new Kamera();
ArrayList entity;

int pBLOCK = 0;
int pSKOR = 1;
int pOLUM = 2;
int pGOAL = 4;
int pKEY = 3;
int pDIKEN=5;

boolean levelkey;

/////////////*******************FONKSIYONLAR

float signum(float x)
{
  if (x < 0)
    return -1;
  if (x==0)
    return 0;
  if (x > 0)
    return 1; 

  return 0;
}

boolean InCam(float x, float y)
{
  if (x + 50 >= Cam.x && x - 50 <= Cam.x + Cam.w && y + 50 >= Cam.y && y - 50 <= Cam.y + Cam.w)
  {
    return true;
  }
  else
    return false;
}


PVector CollisionLine(float x1, float y1, float x2, float y2, int typ)
{
  PVector asd;
  float aci=atan2(y2-y1, x2-x1);
  float xt=x1;
  float yt=y1;
  float dis=sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));

  for (int i=0; i < int(dis); i++)
  {
    xt =x1 + i * cos(aci) ;
    yt =y1 + i * sin(aci);  

    if (IsCollided(xt, yt) == typ)
    {
      asd=new PVector( xt, yt);
      return asd;
    }
  }



  return null;
}

int IsCollided(float x, float y)
{ 
  for (int i=0; i < Bloklar.length; i++)
  {
    if (Bloklar[i] != null)
    {

    if (Bloklar[i].x < x && Bloklar[i].x + Bloklar[i].width > x && Bloklar[i].y < y && Bloklar[i].y + Bloklar[i].height > y)
    {
      Bloklar[i].img[Bloklar[i].curFrame].loadPixels();
      int X=int(x - Bloklar[i].x);
      int Y=int(y - Bloklar[i].y);
      int loc=X + Y*Bloklar[i].img[Bloklar[i].curFrame].width;

      //println(alpha(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));
      /*println(green(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));
       println(blue(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));*/
      if (alpha(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]) > 0)
        return Bloklar[i].type;
    }
    }
  }

  return -1;
}

int IsCollided(float x, float y, PImage img)
{ 
  for (int i=0; i < Bloklar.length; i++)
  {
    if (Bloklar[i] != null)
    {
    img.loadPixels();
    for (int X=0; X < img.width; X++)
    {
      for (int Y=0; Y < img.height; Y++)
      { 

        if (Bloklar[i].x < x + X && Bloklar[i].x + Bloklar[i].width > x + X && Bloklar[i].y < y + Y && Bloklar[i].y + Bloklar[i].height > y + Y)
        {

          Bloklar[i].img[Bloklar[i].curFrame].loadPixels();
          int nX=int(x + X - Bloklar[i].x);
          int nY=int(y + Y - Bloklar[i].y);
          int loc=nX + nY*Bloklar[i].img[Bloklar[i].curFrame].width;

          //println(alpha(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));
          /*println(green(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));
           println(blue(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));*/
          if (alpha(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]) > 0)
            return Bloklar[i].type;
        }
      }
    }
    }
  }

  return -1;
}

int CollisionObj(float x, float y, PImage img)
{ 
  for (int i=0; i < Bloklar.length; i++)
  {
    if (Bloklar[i] != null)
    {
    img.loadPixels();
    for (int X=0; X < img.width; X++)
    {
      for (int Y=0; Y < img.height; Y++)
      { 

        if (Bloklar[i].x < x + X && Bloklar[i].x + Bloklar[i].width > x + X && Bloklar[i].y < y + Y && Bloklar[i].y + Bloklar[i].height > y + Y)
        {

          Bloklar[i].img[Bloklar[i].curFrame].loadPixels();
          int nX=int(x + X - Bloklar[i].x);
          int nY=int(y + Y - Bloklar[i].y);
          int loc=nX + nY*Bloklar[i].img[Bloklar[i].curFrame].width;

          //println(alpha(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));
          /*println(green(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));
           println(blue(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]));*/
          if (alpha(Bloklar[i].img[Bloklar[i].curFrame].pixels[loc]) > 0)
            return Bloklar[i].id;
        }
      }
    }
    }
  }

  return -1;
}

void loadgame(int level)
{
  
  
  Blocks=loadStrings("blok"+level+".txt");
  Bloklar = new Blok[Blocks.length - 1];
  String[] settings=split(Blocks[0], TAB);
  for (int i=0; i < Blocks.length-1; i++)
  {
    String[] parca = split(Blocks[i+1], TAB);
    if (parca.length == 6)
    {
      Bloklar[i] = new Blok(parca, i);
    }
  }
  resetstate();
  levelkey=false;
  startx=float(settings[1]);
  starty=float(settings[2]);
  ((Karakter)entity.get(0)).x = float(settings[1]);
  ((Karakter)entity.get(0)).y = float(settings[2]);
  bg=loadImage(settings[0]);
}

void resetstate()
{
 ((Karakter)entity.get(0)).swing=false;
 ((Karakter)entity.get(0)).iparray.clear();
 ((Karakter)entity.get(0)).sx=0;
((Karakter)entity.get(0)).sy=0;
 ((Karakter)entity.get(0)).w=0;
  ((Karakter)entity.get(0)).aci=PI/3;
  
}

void CreateParticle(float X, float Y, int num)
{
 for(int i=0; i < num; i++)
{
  float randdeg,r;
  randdeg=radians(-180 + random(180));
  r=2+(random(8));
  partic.add(new Particle(X,Y,cos(randdeg)*r, sin(randdeg)*r, "coin.png"));
 
} 
}


void CreateParticle(float X, float Y, int num, String file)
{
 for(int i=0; i < num; i++)
{
  float randdeg,r;
  randdeg=radians(-180 + random(180));
  r=2+(random(8));
  partic.add(new Particle(X,Y,cos(randdeg)*r, sin(randdeg)*r, file));
 
} 
}

/////////*****************CLASSLAR****************\\\\\\\\\\\\\\\\\\

class Kamera
{
  float x, y, w, h, sx, sy;
  Kamera() { 
    x=0; 
    y=0; 
    w=800; 
    h=600;
  }
  void update()
  {
    sx=(((Karakter)entity.get(0)).x - x - 380)/12;
    sy=(((Karakter)entity.get(0)).y - y - 280)/12;
    x += sx;
    y += sy;
    /*x = ((Karakter)entity.get(0)).x - 380;
     y = ((Karakter)entity.get(0)).y - 280; */

    x=max(0, x);
    y=max(0, y);
  }
}

class Nesne
{
  float x, y, sx, sy, w, gravity, aci, wa, r, ox, oy, centx, centy, width, height;
  PImage[] img;
  String fileDir;
  int curFrame;
  int framec,id;
  float fps;
  int Sayac;
  int type;

  void FrameControl() { 
    Sayac += 1;
    //print(int(frameRate*fps));
    if (Sayac > int((60 * fps)))
    {
      curFrame += 1;
      if (curFrame >= framec)
        curFrame=0;

      Sayac = 0;
    }
  }
  void Draw() {
  }
}

class Particle
{
 float x,y,lifespan,sx,sy;
 PImage[] img; 
 boolean dead;
 
 Particle(float X, float Y, float SX, float SY, String file)
 {
  sx=SX;
 sy=SY;
x=X;
y=Y;
dead=false;
img=new PImage[1];
img[0]=loadImage(file);
 }
 
 void update()
 {
  sy += 0.5;
  x+=sx;
  y+=sy;
  
  
  if (!InCam(x,y))
  dead=true;
  tint(random(255),random(255),random(255),100+random(100));
  
  image(img[0],x - Cam.x,y - Cam.y);
  
  tint(255);
   
 }
}

class Blok extends Nesne
{
  float degree;
  Blok(String[] cons, int ID)
  {
    degree=0;
    Sayac=0;
    id = ID;
    curFrame=0;
    framec=int(cons[3]);
    img=new PImage[framec];
    fps=float(cons[4]);
    type=int(cons[5]);
    x=float(cons[0]);
    y=float(cons[1]);
    fileDir=cons[2];
    

    for (int i=0; i < framec; i++)
      img[i]=loadImage(cons[2] + i + ".png");

    //  print(fps);

    width=img[0].width;
    height=img[0].height;
  }

  void Draw()
  {
    FrameControl();
    pushMatrix();
    translate(x, y);
    rotate(radians(0));
    image(img[curFrame], - Cam.x, - Cam.y); 
    popMatrix();
  }
}

class Karakter extends Nesne
{

  float ipx, ipy, ipsx, ipsy;
  boolean swing;
  ArrayList iparray;



  void update()
  {
    //iparray.clear();
    if (swing)
    {
      //iparray.add(new PVector(ox,oy));
    }
    
    if (IsCollided(x,y,img[curFrame]) == pSKOR) // skor
    {
      SKOR += 100;
      in4.trigger();
      CreateParticle(x,y,2, "gold0.png");
      Bloklar[CollisionObj(x,y,img[curFrame])] = null;
      
      
    }
    
    if (IsCollided(x,y,img[curFrame]) == pKEY) // level atla
    {
      levelkey=true;
      SKOR += 500;
      in4.trigger();
      Bloklar[CollisionObj(x,y,img[curFrame])] = null;
      
    }
    
    if (IsCollided(x,y,img[curFrame]) == pGOAL && levelkey) // level atla
    {
      SKOR += 100;
      //in4.trigger();
      //Bloklar[CollisionObj(x,y,img[curFrame])] = null;
      in6.trigger();
      delay(1500);
      loadgame(++level);
      
    }
    
    if (IsCollided(x,y,img[curFrame])==pOLUM) // ölüm
    {
      SKOR -= 500;
     x=startx;
     y=starty;
     CreateParticle(x,y,2, "skull.png");
     resetstate();
     delay(1000); 
    }


    if (r < 5)
    {
      swing=false;
    }

    if (swing)
    {
      wa=(-1 *  gravity/(r*4)) * sin(aci);
      w += wa;
      w *= 0.990;
      aci += w;
      
      if (abs(w) > 0.04 && frameCount % 5 == 0)
      CreateParticle(x,y,1, "karakter.png");

      x=r*sin(aci);
      y=r*cos(aci);

      x += ((PVector)iparray.get(iparray.size()-1)).x;
      y += ((PVector)iparray.get(iparray.size()-1)).y;



      if (IsCollided(x, y, img[curFrame])==0)
      {
        if (abs(w) > 0.01)
        {
         CreateParticle(x,y,2);
        in5.trigger();
        }
        aci -= w;
        w *= -0.9;
      }

      /*PVector zxc;
      
       float xcc = ((PVector)iparray.get(iparray.size()-1)).x;
       float ycc = ((PVector)iparray.get(iparray.size()-1)).y;
       if ((zxc=CollisionLine(x, y, xcc, ycc,0)) != null) 
       {
       if (sqrt((zxc.x-xcc)*(zxc.x-xcc) + (zxc.y-ycc)*(zxc.y-ycc)) > 15)
       iparray.add(zxc);
       }
       
       if (iparray.size() > 1)
       {
       float xc = ((PVector)iparray.get(iparray.size()-2)).x;
       float yc = ((PVector)iparray.get(iparray.size()-2)).y;
       
       if ((zxc=CollisionLine(x, y, xc, yc,0)) != null) 
       { 
       println(xcc + " " + ycc);
       println(xc + " " + yc);
       
       if (sqrt((zxc.x-xc)*(zxc.x-xc) + (zxc.y-yc)*(zxc.y-yc)) < 15)
       {
       
       
       iparray.remove(iparray.size()-1);
       }
       }
       }*/



        float xcc = ((PVector)iparray.get(iparray.size()-1)).x;
        float ycc = ((PVector)iparray.get(iparray.size()-1)).y;

      r=sqrt((xcc-x)*(xcc-x) + (ycc-y)*(ycc-y));
      //  println(r);
    }
    else
    {


      if (IsCollided(x + sx, y - 2, img[curFrame])==0)
      {
        //x -= sx;
        sx *= -0.5;
      }

      if (IsCollided(x, y+ sy, img[curFrame])==0)
      {

        sy *= -0.2;
        sx *= 0.8;
      }
      else
      {
        sy += 0.2;
      }

      if (abs(sx) <= 0.01)
        sx = 0;

      if (abs(sy) <= 0.1)
        sy=0;
        
       //if ((abs(sx) > 11) || (abs(sy) > 11))
       //CreateParticle(x,y,1);


      x+=sx;
      y+=sy;
    }

    if (!swing)
    {
      ipx += ipsx;
      ipy += ipsy;
      ox = x + ipx + 10;
      oy = y + ipy + 5;

      if (sqrt((ox - x)*(ox - x) + (oy - y)*(oy - y)) > 650)
      {
        ipsx=0;
        ipsy=0;
        ipx=0;
        ipy=0;
        ox=x + 10;
        oy=y + 5;
      }
      PVector asd;

      if ((asd=CollisionLine(x, y, ox, oy, pBLOCK)) != null && (ox != x && oy != y))
      {
        ox=asd.x;
        oy=asd.y;
        iparray.add(new PVector(ox, oy));
        r=sqrt((x-asd.x)*(x-asd.x) + (y-asd.y)*(y-asd.y));
        aci=PI-atan2(asd.y-y, asd.x-x) + PI/2;
        swing=true;
        w +=(sx *  gravity/(r*4)) * abs(sin(aci));
        //CreateParticle(x,y,10);
        in2.trigger();
      }
      
      if ((asd=CollisionLine(x, y, ox, oy, pDIKEN)) != null && (ox != x && oy != y))
      {
        ipsx=0;
        ipsy=0;
        ipx=0;
        ipy=0;
        ox=x + 10;
        oy=y + 5;
        in2.trigger();
      }
    }
    if (mousePressed == true)
    {
      if (!spacez)
      {
        spacez=true;
        if (!swing)
        {
          float acisal;
          acisal=atan2(mouseY - (y-Cam.y), mouseX - (x-Cam.x));
          ipsx=50* cos(acisal);
          ipsy=50* sin(acisal);
        }
    }
    
    }

    if (keyPressed == true)
    {
      if (key == ' ' && !spacez)
      {
        spacez=true;
        if (!swing)
        {
          float acisal;
          acisal=PI - aci;  
          ipsx=50* min(sin(degrees(90 + signum(sin(acisal))*45)), sin(acisal));
          in3.trigger();
          ipsy=-50* abs(cos(acisal));
        }
        else
        {
          iparray.clear();
          sx=min(w*r, 20)*cos(aci);
          sy=min(20, w*r)*-sin(aci);
          swing=false;
          ipsx=0;
          ipsy=0;
          ox=x;
          oy=y;
          ipx=0;
          ipy=0;
        }
      }
    }

    if (leftz)
    {
      if (swing)
        w -= 0.150 / r;
      else
      {
        //if (IsCollided(x, y + 2, img[curFrame])==0)
        //{
          if (sx > -6)
            sx -= 0.3;
          //else
            //sx = -6;
        //}
      }
    }

    if (rightz)
    {
      if (swing)
        w += 0.150 / r;
      else
      {
        //if (IsCollided(x, y + 2, img[curFrame])==0)
        //{
          if (sx < 6)
            sx += 0.3;
          //else
          //  sx = 6;
        //}
      }
    }

    if (upz)
    {
      if (swing  && r > 25 && IsCollided(x - 5*sin(aci), y - 5*cos(aci), img[curFrame]) != 0)
        r -= 5;
      else
        if (!swing && IsCollided(x, y+2, img[curFrame])==0)
        {
          CreateParticle(x,y,10, "bullet_up.png");
          sy -= 7.0;
        }
    }

    if (downz &&  r < 350 && IsCollided(x + 5*sin(aci), y + 5*cos(aci), img[curFrame]) != 0)
      r += 5;
      
    





    Draw();
  }

  void Draw()
  {


    if (InCam(x, y))
    {
      FrameControl();
      pushMatrix();
      //rotate(radians(45));
      stroke(155, 155, 155);


      if (swing)
      {
        for (int i=0; i < iparray.size(); i++)
        {
          float xc = ((PVector)iparray.get(i)).x;
          float yc = ((PVector)iparray.get(i)).y;
          float hx= x; 
          float hy= y; 

          if (i != iparray.size() - 1)
          {
            hx= ((PVector)iparray.get(i + 1)).x; 
            hy= ((PVector)iparray.get(i + 1)).y;
          }


          line(xc  - Cam.x, yc  - Cam.y, hx  - Cam.x + 15, hy  - Cam.y +10);
        }
      }
      else
      {
        if ((ipsx) != 0 || (ipsy) != 0)
          line(ox  - Cam.x, oy  - Cam.y, x  - Cam.x + 15, y  - Cam.y + 10 );
      }


      fill(155, 155, 155);
      image(img[curFrame], x - Cam.x, y-Cam.y);
      //ellipse(x - Cam.x, y  - Cam.y, 15, 15);

      popMatrix();
    }
  }



  Karakter()
  {

    gravity=2.0;
    r=150;
    aci=PI/3;
    x=100 + r * sin(aci);
    y=100 + r * cos(aci);
    w=0;

    swing=false;     
    ox=505;
    oy=105;
    img = new PImage[1];
    img[0] = loadImage("karakter.png");
    fps=1.0;
    framec=1;
    iparray=new ArrayList();
    //iparray.add(new PVector(ox,oy));
    //iparray.add(new PVector(700,300));
  }
}



//////////////*************************olaylar



void setup()
{

  size(800, 600);
  entity=new ArrayList();
  entity.add(new Karakter());
  minim=new Minim(this);
  in=(AudioPlayer)minim.loadFile("mus.mp3");
  in.setVolume(5);
  in.play();
  in2=minim.loadSample("boomshot.wav");
  in3=minim.loadSample("swin.wav");
  in4=minim.loadSample("curious_up.wav");
  in5=minim.loadSample("gun7.wav");
  in6=minim.loadSample("win3.wav");
  menu=loadImage("menu.PNG");
  partic=new ArrayList();
  //in5=minim.loadSample("swin.wav");

  /*Blocks=loadStrings("blok.txt");
  Bloklar = new Blok[Blocks.length - 1];
  for (int i=0; i < Blocks.length-1; i++)
  {
    String[] parca = split(Blocks[i+1], TAB);
    if (parca.length == 6)
    {
      Bloklar[i] = new Blok(parca);
    }
  }*/
  level=-1;
  //loadgame(level);
}





void keyPressed() {
  if (keyCode == UP || key == 'w')
    upz=true;

  if (keyCode == DOWN || key == 's')
    downz=true;

  if (keyCode == LEFT || key == 'a')
    leftz=true;

  if (keyCode == RIGHT || key == 'd')
    rightz=true;

  //if (key == ' ')
  //spacez=true;
}

void keyReleased() {
  if (key == 'r')
  {
    ((Karakter)entity.get(0)).x=startx;
    ((Karakter)entity.get(0)).y=starty;
    ((Karakter)entity.get(0)).swing=false;
     //x=startx;
     //y=starty;
     //swing=false;
     SKOR -= 500;
     delay(1000);  
  }
  
  if (keyCode == UP || key == 'w')
    upz=false;

  if (keyCode == DOWN || key == 's')
    downz=false;

  if (keyCode == LEFT || key == 'a')
    leftz=false;

  if (keyCode == RIGHT || key == 'd')
    rightz=false;

  if (key == ' ')
    spacez=false;
}


void draw()
{
  background(0);
  /*PFont metaBold;
  
  metaBold = loadFont("LBRITED.TTF");
  textFont(metaBold, 44); */
  if (level == -1)
  {
    image(menu,0,0);
    if (keyCode == ENTER)
    loadgame(++level);
    
  }
  else
  {

  for (int i=0; i <= 800 / bg.width; i += 1)
  {
    for (int a=0; a <= 600 / bg.height; a += 1)
    {
      image(bg, i * bg.width, a * bg.height);
    }
  }

  Cam.update();
  


  for (int i=0; i < Bloklar.length; i++)
    if (Bloklar[i] != null)
      Bloklar[i].Draw();
      
     text("SKOR : "+SKOR,10,40);
     ((Karakter)entity.get(0)).update();
     
     if (partic.size() > 0)
     {
      for (int c=0; c < partic.size(); c++)
     {
      if (((Particle)partic.get(c)).dead)
      partic.remove(c);
      else
      ((Particle)partic.get(c)).update();
     } 
     }
  }
}

void mouseReleased() {
spacez=false;
}




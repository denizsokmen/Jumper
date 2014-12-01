boolean upz, downz, rightz, leftz, spacez;

String[] Blocks;
String[] Usable;
Blok[] Bloklar;



Kamera Cam = new Kamera();
ArrayList entity;
ArrayList tipler;
int curtip;

int pBLOCK = 0;
int pSKOR = 1;
int pOLUM = 2;
int pGOAL = 4;
int pKEY = 3;
int pDIKEN=5;


void setup()
{

  size(800, 600);
  entity=new ArrayList();
  tipler=new ArrayList();
  
  curtip=1;
  
  tipler.add(new Blok(0,"blok",1.0,2,pBLOCK));
  tipler.add(new Blok(1,"blo",1.0,1,pBLOCK));
  tipler.add(new Blok(2,"gold",1.0,1,pSKOR));
  tipler.add(new Blok(3,"water",1.0,1,pOLUM));
  tipler.add(new Blok(4,"key",1.0,1,pKEY));
  tipler.add(new Blok(5,"diamond",1.0,1,pSKOR));
  tipler.add(new Blok(6,"doors",1.0,1,pGOAL));
  tipler.add(new Blok(7,"skull",1.0,1,pOLUM));
  tipler.add(new Blok(8,"spk",1.0,1,pDIKEN));
  tipler.add(new Blok(9,"blo",1.5,2,pBLOCK));
  tipler.add(new Blok(10,"troblo",1.5,1,pBLOCK));

  /*Blocks=loadStrings("blok.txt");
  Bloklar = new Blok[Blocks.length];
  for (int i=0; i < Blocks.length; i++)
  {
    String[] parca = split(Blocks[i], TAB);
    if (parca.length == 5)
    {
      Bloklar[i] = new Blok(parca);
    }
  }*/
  
}


/////////*****************CLASSLAR****************\\\\\\\\\\\\\\\\\\

class Kamera
{
  float x, y, w, h;
  Kamera() { 
    x=0; 
    y=0; 
    w=800; 
    h=600;
  }
  void update()
  {
    //x = ((Karakter)entity.get(0)).x - 380;
    //y = ((Karakter)entity.get(0)).y - 280; 

    x=max(0, x);
    y=max(0,y);
  }
}

class Nesne
{
  float x, y, sx, sy, w, gravity, aci, wa, r, ox, oy, centx, centy, width, height;
  PImage[] img;
  String fileDir;
  int curFrame;
  int framec;
  int TYP;
  float fps;
  int Sayac;

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

class Blok extends Nesne
{
  float degree;
  int type;
  Blok(String[] cons)
  {
    degree=0;
    Sayac=0;
    curFrame=0;
    framec=int(cons[3]);
    img=new PImage[framec];
    fps=float(cons[4]);
    x=float(cons[0]);
    y=float(cons[1]);

    for (int i=0; i < framec; i++)
      img[i]=loadImage(cons[2] + i + ".png");

    width=img[0].width;
    height=img[0].height;
  }
  
  Blok(int typ, String dir, float FPS, int frmc, int tip2)
  {
    degree=0;
    Sayac=0;
    curFrame=0;
    framec=frmc;
    type=typ;
    img=new PImage[framec];
    fps=FPS;
    x=0;
    y=0;
    fileDir=dir;
    TYP=tip2;

    for (int i=0; i < framec; i++)
      img[i]=loadImage(dir + i + ".png");

    width=img[0].width;
    height=img[0].height;
  }
  
  Blok(float IKS, float YE,String dir, float FPS, int frmc, int typ, int tip2)
  {
    degree=0;
    Sayac=0;
    curFrame=0;
    framec=frmc;
    type=typ;
    img=new PImage[framec];
    fps=FPS;
    x=IKS;
    y=YE;
    fileDir=dir;
    TYP=tip2;

    for (int i=0; i < framec; i++)
      img[i]=loadImage(dir + i + ".png");

    width=img[0].width;
    height=img[0].height;
  }
  
  Blok(float iks, float ye)
  {
    degree=0;
    Sayac=0;
    curFrame=0;
    framec=1;
    img=new PImage[framec];
    fps=1.0;
    x=iks;
    y=ye;

    //for (int i=0; i < framec; i++)
      img[0]=loadImage("blok0.png");

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







void keyPressed() {
  if (keyCode == UP)
    upz=true;

  if (keyCode == DOWN)
    downz=true;

  if (keyCode == LEFT)
    leftz=true;

  if (keyCode == RIGHT)
    rightz=true;

  //if (key == ' ')
  //spacez=true;
  
  if (key == ' ')
  {
   curtip += 1;
   if (curtip >= tipler.size())
  curtip=0; 
  }
  
  if (key == ENTER)
{
 String[] olay= new String[entity.size()];
 for (int i=0; i < entity.size(); i++)
 {
  olay[i]=int(((Blok)entity.get(i)).x) + "\t" + int(((Blok)entity.get(i)).y) + "\t" + ((Blok)entity.get(i)).fileDir + "\t"+((Blok)entity.get(i)).framec +"\t"+((Blok)entity.get(i)).fps+"\t"+((Blok)entity.get(i)).TYP;
   
 }
 saveStrings("blok.txt",olay);
 
} 
  
}

void keyReleased() {

  if (keyCode == UP)
    upz=false;

  if (keyCode == DOWN)
    downz=false;

  if (keyCode == LEFT)
    leftz=false;

  if (keyCode == RIGHT)
    rightz=false;

  if (key == ' ')
    spacez=false;
}


void draw()
{
  
  background(50);
  Cam.update();
  //((Karakter)entity.get(0)).update();
  if (leftz)
  Cam.x -= 5;
  
  if (rightz)
  Cam.x += 5;
  
  if (upz)
  Cam.y -=5;
  
  if (downz)
  Cam.y += 5;
  stroke(255);
  
  for(int k=0; k < 600; k++)
  {
      line(k*((Blok)tipler.get(curtip)).width - Cam.x, 0, k*((Blok)tipler.get(curtip)).width - Cam.x, 600);
  }
  
  for(int j=0; j < 600; j++)
  {
      line(0,j*((Blok)tipler.get(curtip)).height - Cam.y, 800, j*((Blok)tipler.get(curtip)).height - Cam.y);
  }
  
  if (mousePressed)
  {
    if (mouseButton == LEFT)
    {
   float wd=((Blok)tipler.get(curtip)).width;
   float he=((Blok)tipler.get(curtip)).height;
   
   float asd =  (int((Cam.x + mouseX)/wd) * wd);
   float asd2 =  (int((Cam.y  + mouseY)/he) * he);
   for(int i=0; i < entity.size(); i++)
   {
    if (((Blok)entity.get(i)).x == asd && ((Blok)entity.get(i)).y == asd2 && ((Blok)entity.get(i)).type == curtip)
    return;
   }
   entity.add(new Blok(asd,asd2,((Blok)tipler.get(curtip)).fileDir,((Blok)tipler.get(curtip)).fps,((Blok)tipler.get(curtip)).framec,curtip, ((Blok)tipler.get(curtip)).TYP));
    }
    else
    {
      float wd=((Blok)tipler.get(curtip)).width;
   float he=((Blok)tipler.get(curtip)).height;
   
   float asd =  (int((Cam.x + mouseX)/wd) * wd);
   float asd2 =  (int((Cam.y  + mouseY)/he) * he);
   for(int i=0; i < entity.size(); i++)
   {
    if (((Blok)entity.get(i)).x == asd && ((Blok)entity.get(i)).y == asd2 && ((Blok)entity.get(i)).type == curtip)
    entity.remove(i);
   }
    }
  }
  
  if (entity.size() > 0)
  {
  for (int i=0; i < entity.size(); i++)
    ((Blok)entity.get(i)).Draw();
    
  }
  
  image(((Blok)tipler.get(curtip)).img[0],10,10);
}



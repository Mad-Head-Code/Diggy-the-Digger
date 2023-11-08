import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim m = new Minim(this);

AudioPlayer theme, pick, loose, win, dig;
boolean arr[][] = new boolean[20][30];
PFont font;
int Level = 1;
int score = 0;
int health = 100;
int fuel = 70;
int playerx=280;
int playery=180;
int ryx=0;
int ryy = 0;
int rubyx=0;
int rubyy=0;
int goldXY[][] = new int[8][2];
int oilXY[][] = new int[8][2];
String tarr[] = {
  "Use arrow keys...", 
  "Take Ruby for health", 
  "Diggy must dig...", 
  "Diggy wants oil!", 
  "Diggy diggy dig!", 
  "Diggy wants cookie...", 
  "Where's gold?", 
  "What are there?", 
  "Processing is the best!", 
  "Javascript is scary...", 
  "Scratch is for toddlers!", 
  "Links, rechts, gerade aus..", 
  "Let's begin the beginning!", 
  "Look, what's there!?", 
  "Open your I-Phone!", 
};
int num = 0;
int message = 360;
int letstalk = 0;
boolean next;
void setup() {
  size(600, 600);
  surface.setTitle("Diggy the Digger");
  surface.setIcon(loadImage("icon.png"));
  noStroke();
  font = createFont("big-shot.ttf", 20);
  textFont(font);
  textSize(30);
  noSmooth();
  pushOil();
  pushGold();
  pushRuby();
  pick = m.loadFile("pick.mp3");
  dig= m.loadFile("dig.mp3");
  theme = m.loadFile("theme.mp3");
  win = m.loadFile("win.mp3");
  loose = m.loadFile("loose.mp3");
  theme.play();
  theme.loop();
}

void draw() {
  if (keyPressed) {
    if (Level<=5) {
      playerControl();
    }
  }
  back();
  digged();
  player();
  if (Level<=5) {
    drawOil();
    drawGold();
    drawRuby();
  }
  logic();
}

void pushGold() {
  for (int i = 0; i < Level+3; i++) {
    goldXY[i][0] = (int(random(1, 28))*20);
    goldXY[i][1] = 200+(int(random(1, 18))*20);
  }
}

void pushOil() {
  for (int i = 0; i < 8-Level; i++) {
    oilXY[i][0] = (int(random(1, 28))*20);
    oilXY[i][1] = 200+(int(random(1, 18))*20);
  }
}


void drawGold() {
  for (int i = 0; i < Level+3; i++) {
    golddraw(goldXY[i][0], goldXY[i][1]);
    if (dist(playerx+10, playery+10, goldXY[i][0]+10, goldXY[i][1]+10)<15) {
      pick.rewind();
      pick.play();
      goldXY[i][0]=-20;
      goldXY[i][1]=-20;
      score+=20;
    }
  }
}

void drawOil() {
  for (int i = 0; i < 8-Level; i++) {
    oildraw(oilXY[i][0], oilXY[i][1]);
    if (dist(playerx+10, playery+10, oilXY[i][0]+10, oilXY[i][1]+10)<15) {
      pick.rewind();
      pick.play();
      oilXY[i][0]=-20;
      oilXY[i][1]=-20;
      fuel+=20;
      if (fuel>70)
      {
        fuel=70;
      }
    }
  }
}


void keyReleased() {
  playerPositioning();
}

void logic() {
  if (score/20==Level+3 && Level<5) {
    Level++;
    score=0;
    pushOil();
    pushGold();
    pushRuby();
    fuel=70;
    playerx = 280;
    playery = 180;
    for (int x = 0; x < 30; x++) {
      for (int y = 0; y < 20; y++) {
        arr[y][x]=false;
      }
    }
  }
  if (score/20==Level+3 && Level==5) {
    Level++;
  }
  if (health<0) {
    background(0);
    fill(255);
    textAlign(CENTER);
    text("GAME OVER", 300, 310);
    if (!loose.isPlaying()) {
      theme.pause();
      loose.play();
    }
  }
  if (Level>5) {
    pushStyle();
    textSize(40);
    textAlign(CENTER);
    fill(255);
    text("YOU WIN", 300, 400);
    popStyle();
    if (!win.isPlaying()) {
      theme.pause();
      win.play();
    }
  }
}

void player() {
  if (frameCount%300==0) {
    ryx=round(random(0, 8));
    ryy=round(random(0, 6));
  }
  pushMatrix();
  translate(playerx, playery-5+(frameCount/20)%3);
  fill(100);
  rect(0, 0, 20, 20);
  fill(255);
  rect(4, 4, 12, 12);
  fill(0);
  rect(4+ryx, 6+ryy, 4, 4);
  fill(50);
  if (frameCount%600<20) {
    rect(4, 4, 12, 12);
  } else {
    rect(4, 4, 12, 4);
  }
  if (letstalk+message > frameCount && letstalk<frameCount) {
    pushStyle();
    fill(255);
    rect(22, -4, 2, 2);
    rect(22, -6, 4, 2);
    rect(22, -8, 6, 2);
    rect(-4, -12, 100, -60);
    rect(0, -8, 92, -68);
    fill(0);
    textSize(14);
    text(tarr[num], 0, -72, 100, 64);
    popStyle();
    next = true;
  } else {
    if (next) {
      letstalk+=int(random(15*60, 12*60));
      num = ceil(random(14));
      next=false;
    }
  }
  popMatrix();
}

void playerControl() {
  if (keyCode == UP && playery>=180) {
    playery-=2;
    if (playery>190) {
      if (!arr[(playery+9-200)/20][(playerx+9)/20]) {
        fuel-=3;
      }
    }
  } else if (keyCode == DOWN && playery<=575) {
    playery+=2;
    if (playery>190) {
      if (!arr[(playery+9-200)/20][(playerx+9)/20]) {
        fuel-=3;
      }
    }
  } else if (keyCode == LEFT && playerx>=5) {
    playerx-=2;
    if (playery>190) {
      if (!arr[(playery+9-200)/20][(playerx+9)/20]) {
        fuel-=3;
      }
    }
  } else if (keyCode == RIGHT && playery<=575) {
    playerx+=2;
    if (playery>190) {
      if (!arr[(playery+9-200)/20][(playerx+9)/20]) {
        fuel-=3;
      }
    }
  }
  if (fuel<0) {
    fuel=0;
    health-=4;
  }
  if (playery>190) {
    if (!dig.isPlaying() && !arr[(playery+9-200)/20][(playerx+9)/20]) {
      dig.rewind();
      dig.play();
    }
    arr[(playery+9-200)/20][(playerx+9)/20]=true;
  }
}

void playerPositioning() {
  playerx = playerx/10*10;
  playery = (playery-200)/10*10+200;
}

void digged() {
  for (int x = 0; x < 30; x++) {
    for (int y = 0; y < 20; y++) {
      if (arr[y][x]) {
        fill(0);
        rect(x*20-5, y*20+200-5, 30, 30);
      }
    }
  }
}

void back() {
  background(#27D6C0);
  fill(#FAD53F);
  rect(0, 195, 600, 405);
  fill(#E88A31);
  rect(0, 300, 600, 300);
  fill(#A55B16);
  rect(0, 400, 600, 200);
  fill(100);
  rect(0, 500, 600, 100);
  fill(255);
  textAlign(CENTER);
  text("Level: "+Level, 300, 30);
  textAlign(LEFT);
  fill(255);
  text("Health:", 10, 60);
  fill(#00ff00);
  rect(140, 40, health, 20);
  fill(255);
  text("Fuel:", 10, 90);
  fill(#FAA235);
  rect(100, 70, fuel*2, 20);
  fill(255);
  text("Score: "+score, 400, 60);
}

void oildraw(int x, int y) {
  pushMatrix();
  translate(x, y);
  fill(0);
  rect(2, 2, 16, 16);
  rect(0, 4, 20, 12);
  rect(4, 0, 12, 20);
  fill(255);
  rect(4, 4, 4, 4);
  popMatrix();
}

void golddraw(int x, int y) {
  pushMatrix();
  translate(x, y);
  fill(#EDFF03);
  rect(2, 2, 16, 16);
  rect(0, 4, 20, 12);
  rect(4, 0, 12, 20);
  fill(255);
  rect(4, 4, 4, 4);
  popMatrix();
}



void pushRuby() {
  rubyx=int(random(1, 28))*20;
  rubyy=int(random(1, 18))*20+200;
}

void drawRuby() {
  rubydraw(rubyx, rubyy);
  if (dist(rubyx+10, rubyy+10, playerx+10, playery+10)<15) {
    pick.rewind();
    pick.play();
    rubyx=rubyy=-20;
    health+=20;
    if (health>100) {
      health=100;
    }
  }
}

void rubydraw(int x, int y) {
  pushMatrix();
  translate(x, y);
  fill(#ff0000);
  rect(4, 0, 12, 4);
  rect(0, 4, 20, 4);
  rect(4, 8, 12, 4);
  rect(8, 12, 4, 4);
  fill(255);
  rect(4, 4, 4, 4);
  popMatrix();
}

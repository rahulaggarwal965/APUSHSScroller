Platform platform;
Enemy enemyclass;
Boss boss1;
import java.util.Random;
import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

class Stage {
  Platform[] parray;
  Platform[] parray1;
  Enemy[] earray;
  int enumber;
  int platnumber;
  int c = 1;
  List<Bullet> bullets = new ArrayList<Bullet>();
  ListIterator<Bullet> bulletIterator = null;
  
  Random rnd = new Random();
  
  Stage(int platnumber, int enumber) {
    this.platnumber = platnumber;
    parray = new Platform[platnumber];
    for(int i=0; i<platnumber; i++){
      parray[i] = new Platform("ssplatforms", rnd.nextInt(12500), rnd.nextInt(300)+120);
    }  
    this.enumber = enumber;
    earray = new Enemy[enumber];
    for(int i=0; i<enumber; i++){
      earray[i] = new Enemy(rnd.nextInt(12500), rnd.nextInt(300)+150);
    }  
    parray1 = new Platform [6];
    for(int i=0; i<6; i++){
      parray1[i]= new Platform("ssplatforms", 400*c-250, 150*((i+1)%3)+50);
      if(i==2){
        c=2;
      }
    }  
    boss1 = new Boss();
  }
  
  void updateBullets() {
    bulletIterator = bullets.listIterator();
    while(bulletIterator.hasNext()) {
      Bullet bullet = bulletIterator.next();
      bullet.update();
      bullet.render();
      if(bullet.isOffScreen(900, 500)) {
        bulletIterator.remove();
      }
    }
  }
  
  void checkBECollisions(Player player) {
    bulletIterator = bullets.listIterator();
    while(bulletIterator.hasNext()) {
      Bullet bullet = bulletIterator.next();
      for (int j = 0; j < this.earray.length; j++) {
        if(bullet.x >= earray[j].x - player.xshift && bullet.x <= earray[j].x - player.xshift + earray[j].width && bullet.y <= earray[j].y && bullet.y >= earray[j].y - earray[j].height) {
          earray[j].health -= bullet.damage;
          if (bullet.type == 0 || bullet.type == 1) {
            bulletIterator.remove();
          }
        }
      }
    }
  }
  
  int checkPCollision(Player player, Platform[] parray0){
    int maxY = 455;
    for(int a=0; a<parray0.length; a++){
      if(player.y <= parray0[a].y && player.x >= parray0[a].x-player.xshift-player.width && player.x <= parray0[a].x-player.xshift+parray0[a].width){
        maxY = (parray0[a].y < maxY) ? parray0[a].y : maxY;
      }  
    }
    return(maxY);
  }  
  
  int checkECollision(Enemy enemy){
    int maxY = 455;
    for(int a=0; a<platnumber; a++){
      if(enemy.y <= parray[a].y && enemy.x >= parray[a].x && enemy.x <= parray[a].x+parray[a].width){
        maxY = (parray[a].y < maxY) ? parray[a].y : maxY;
      }  
    }
    return(maxY);
  }  
  
  
  
  void render(int x, int y, int xshift, Background background, Player player) {
    background.display(x, y, xshift, player);
    if(background.gstate==0){
      
    player.bottom = this.checkPCollision(player,parray);
    for(int j=0; j<platnumber; j++){
      parray[j].display(player.xshift);
    }
    for(int i=0; i<enumber; i++){
      earray[i].bottom = this.checkECollision(earray[i]);
      for(int j=0; j<enumber; j++){
        if(earray[i].checkCollisionOther(earray[j],player)==true && !(i==j)){
          earray[i].col=true;
        }
      }
      earray[i].update(player);
      earray[i].render();
    }
    }
    else{
      player.xshift=0;
      player.bottom =this.checkPCollision(player,parray1);
      boss1.update(player, this);
      boss1.render(player);
      for(int i=0; i<6; i++){
        parray1[i].display(0);
      }
      boss1.healthbar.render(boss1.health, boss1.x + boss1.width/2, boss1.y);
    }
  }
  
}

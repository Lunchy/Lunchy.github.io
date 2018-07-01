import '../view/GameView.dart';
import '../model/Level.dart';
import '../model/gameObjects/GameObject.dart';
import '../model/gameObjects/moveableGameObjects/MoveableGameObject.dart';
import '../model/gameObjects/moveableGameObjects/Enemy.dart';
import '../model/gameObjects/PowerUpBlock.dart';
import '../model/behaviors/jump/HighJump.dart';
import 'dart:async';
import 'dart:html';
import 'dart:math';
import '../model/behaviors/jump/SimpleJump.dart';
import '../model/behaviors/move/FastMove.dart';
import '../model/behaviors/move/SimpleMove.dart';
import '../model/behaviors/PowerUp.dart';
import '../model/behaviors/attack/ProjectileAttack.dart';
import '../model/gameObjects/moveableGameObjects/Projectile.dart';

/*
Regelt den Spielablauf
 */
class GameController {
  GameView view;      // Zum darstellen des Spieles
  Level level;        // Die aktuelle Spielwelt
  Timer updateTimer;  // Intervall zum Bewegen der Objekte und Updaten der View
  int updateCnt = 0;  // Zähler zum ermittlen, was geschehen muss
  bool paused = false;// Gibt an, ob dsa Spiel Pausiert wurde

  StreamSubscription powerUpSubscription; // Observer für berührungen mit dem Power-up-Block

  // Der Konstruktor lässt das GameField in der View initialisieren, und startet den Timer für den Spielablauf
  GameController(this.view, this.level){
    view.initGameField();

    //Mobile Steuerung
    view.jumpButton.onClick.listen((MouseEvent ev) {
      if(level == null || level.gameOver) return;
      level.player.jump();
    });

    if(updateTimer != null){
      updateTimer.cancel();
    }

    updateTimer = new Timer.periodic(const Duration(milliseconds: 1), (_) => update());
  }

  // Überprüft ob Objekte bewegt werden müssen und deligiert dies, wenn das Spiel nicht Pausiert ist
  // Zusätzlich wird hier das aktualisieren der Anzeige ausgelöst
  void update(){
    if(paused) return;

    updateCnt++;

    for(Projectile projectile in level.projectiles){
      if(updateCnt % projectile.movementSpeed == 0){
        if(!level.gameOver){
          moveObject(projectile);
        }
      }
    }

    if(updateCnt % level.player.movementSpeed == 0){
      if(!level.gameOver){
        moveObject(level.player);
      }
    }

    for(Enemy enemy in level.enemys){
      if(updateCnt % enemy.movementSpeed == 0){
        if(!level.gameOver){
          moveObject(enemy);
        }
      }
    }

    if(!level.gameOver){
      view.updateGamefield(level, level.player);
    }
  }

  // Überprüft, ob die Spielfigur mit einem Power-up-Block kollidiert ist
  bool checkPowerUp (MoveableGameObject mgo) {
    if(mgo.tag != "player") {
      return false;
    }
    for(PowerUpBlock powerUpBlock in level.powerUps){
      if(powerUpBlock.positionX == mgo.positionX && powerUpBlock.positionY == mgo.positionY) {
        if (level.player.powerUp == PowerUp.noPowerUp) {
          setPowerUp();
          return true;
        }
        return false;
      }
    }
    return false;
  }

  // Aktiviert auf wunsch des Spielers das aktuell ausgerüstete Power-up
  void activatePowerUp (MouseEvent event, PowerUp powerUp) {
    switch (powerUp) {
      case PowerUp.higherJump: //Higher Jump
        powerUpSubscription.cancel();
        view.activatePowerUp(powerUp);
        level.player.jumpBehavior = new HighJump();
        new Timer(const Duration(milliseconds: 2500), () => removePowerUp(powerUp));
        break;
      case PowerUp.speed: //Speed
        powerUpSubscription.cancel();
        view.activatePowerUp(powerUp);
        level.player.moveBehavior = new FastMove();
        new Timer(const Duration(milliseconds: 2500), () => removePowerUp(powerUp));
        break;
      case PowerUp.fire: //Fire
        powerUpSubscription.cancel();
        level.player.attackBehavior = new ProjectileAttack();
        level.player.attack();
        level.player.attackBehavior = null;
        removePowerUp(powerUp);
        break;
      case PowerUp.secondLife: //Fire
        break;
      case PowerUp.noPowerUp:
        break;
    }
  }

  // Rüstet den Spieler mit einem Power-up aus
  void setPowerUp () {
    PowerUp powerUp;
    switch (new Random().nextInt(4)) {
      case 0:
        powerUp = PowerUp.higherJump;
        break;
      case 1:
        powerUp = PowerUp.speed;
        break;
      case 2:
        powerUp = PowerUp.fire;
        break;
      case 3:
        powerUp = PowerUp.secondLife;
        break;
    }
    switch (powerUp) {
      case PowerUp.higherJump: //Higher Jump
        view.setPowerUp(PowerUp.higherJump);
        level.player.powerUp = PowerUp.higherJump;
        powerUpSubscription = view.powerUpButton.onClick.listen((MouseEvent event) => activatePowerUp(event, PowerUp.higherJump));
        break;
      case PowerUp.speed: //Speed
        view.setPowerUp(PowerUp.speed);
        level.player.powerUp = PowerUp.speed;
        powerUpSubscription = view.powerUpButton.onClick.listen((MouseEvent event) => activatePowerUp(event, PowerUp.speed));
        break;
      case PowerUp.fire: //Fire
        view.setPowerUp(PowerUp.fire);
        level.player.powerUp = PowerUp.fire;
        powerUpSubscription = view.powerUpButton.onClick.listen((MouseEvent event) => activatePowerUp(event, PowerUp.fire));
        break;
      case PowerUp.secondLife: //Second Life
        view.setPowerUp(PowerUp.secondLife);
        level.player.powerUp = PowerUp.secondLife;
        level.player.secondLife = true;
        break;
      case PowerUp.noPowerUp:
        break;
    }
  }

  // Entfernt das aktuell ausgerüstete Power-up der Spielfigur
  void removePowerUp (PowerUp powerUp) {
    view.setPowerUp(PowerUp.noPowerUp);
    level.player.powerUp = PowerUp.noPowerUp;
    switch (powerUp) {
      case PowerUp.higherJump: //Higher Jump
        level.player.jumpBehavior = new SimpleJump();
        break;
      case PowerUp.speed: //Speed
        level.player.moveBehavior = new SimpleMove();
        break;
      case PowerUp.fire: //Fire
        break;
      case PowerUp.secondLife: //Second Life
        level.player.secondLife = false;
        break;
      case PowerUp.noPowerUp:
        break;
    }
  }

  // Bewegt das übergebene 'MoveableGameObject' und lässt diese Bewegung überprüfen und ausführen
  void moveObject(MoveableGameObject mgo){
    if(paused) return;
    if(mgo.isDestroyed) return;

    mgo.move();
    handleY(mgo);
    handleX(mgo);
  }

  // Regelt die vertikale Bewegung des Übergebenen Objektes
  handleY(MoveableGameObject mgo){
    final desiredY = mgo.desiredY;
    final oldY = mgo.positionY;

    //Fallen, wenn die gewünschte höhe nicht verändert wurde
    if(mgo.positionY == desiredY && mgo.hasGravity) {
      mgo.positionY++;
      traps(mgo);
      if(checkLost(mgo)) return;
      if(checkWin(mgo)) return;
      checkPowerUp(mgo);
      if(!level.field[mgo.positionY][mgo.positionX].isPassable){
        mgo.positionY--;
      }
    }

    //Springen, wenn die gewünschte höhe verändert wurde
    else {
      for(int y = oldY - 1; y >= desiredY; y--){
        mgo.positionY = y;
        if(checkLost(mgo)) return;
        if(checkWin(mgo)) return;
        checkPowerUp(mgo);
        if(!level.field[y][mgo.positionX].isPassable){
          mgo.positionY++;
          break;
        }
      }
    }

    mgo.desiredY = mgo.positionY;

    if(mgo.positionY != oldY){
      GameObject o = level.field[mgo.positionY][mgo.positionX];
      level.field[mgo.positionY][mgo.positionX] = mgo;
      level.field[oldY][mgo.positionX] = mgo.currentStaticObject;
      mgo.currentStaticObject = o;
    }
  }

  // Regelt die horizontale Bewegung des Übergebenen Objektes
  handleX(MoveableGameObject mgo) {
    final desiredX = mgo.desiredX;
    final oldX = mgo.positionX;

    if(mgo.direction > 0){
      for(int x = oldX + 1; x <= desiredX; x++){
        mgo.positionX = x;
        if(checkLost(mgo)) return;
        if(checkWin(mgo)) return;
        checkPowerUp(mgo);
        if(!level.field[mgo.positionY][x].isPassable){
          mgo.positionX--;
          break;
        }
      }
    }

    if(mgo.direction < 0){
      for(int x = oldX - 1; x >= desiredX; x--){
        mgo.positionX = x;
        if(checkLost(mgo)) return;
        if(checkWin(mgo)) {
          return;
        }
        checkPowerUp(mgo);
        if(!level.field[mgo.positionY][x].isPassable){
          mgo.positionX++;
          break;
        }
      }
    }

    mgo.desiredX = mgo.positionX;

    if(mgo.positionX != oldX){
      GameObject o = level.field[mgo.positionY][mgo.positionX];
      level.field[mgo.positionY][mgo.positionX] = mgo;
      level.field[mgo.positionY][oldX] = mgo.currentStaticObject;
      mgo.currentStaticObject = o;
    }
  }

  // Regelt die Zustände, wenn der Spieler gescheitert ist
  void setLost(){
    level.gameOver = true;
    view.setPowerUp(PowerUp.noPowerUp);
    view.showLost();
    updateTimer.cancel();
  }

  // Überprüft, ob die Spielfigur einem Gegner auf den Kopf gesprungen ist
  void traps(MoveableGameObject mgo){
    if(mgo.tag != 'player') return;
    Enemy enemy = Enemy.getEnemyByPosition(level, mgo.positionY, mgo.positionX);
    enemy?.destroy();
  }

  // Regelt die Zustände, wenn der Spieler das Ziel erreicht hat.
  void setWin() {
    level.gameOver = true;
    view.setPowerUp(PowerUp.noPowerUp);
    view.showWon();
    updateTimer.cancel();
  }

  // Überprüft, ob der Spieler gescheitert ist
  bool checkLost(MoveableGameObject mgo){
    //GameOver Bedingungen
    if((level.field.length <= mgo.positionY
    || mgo.positionY < 0
    || level.field[0].length <= mgo.positionX
    || mgo.positionX < 0)){
      if(mgo.tag == 'player'){
        setLost();
        return true;
      }
      else {
        mgo.destroy();
      }
    }
      if (level.field[mgo.positionY][mgo.positionX].isDeathly) {
        if (mgo.tag == 'player') {
          if (level.player.secondLife == false) {
            setLost();
            return true;
          } else {
            traps(mgo);
            removePowerUp(PowerUp.secondLife);
          }
        } else {
          mgo.destroy();
          return false;
        }
      } else if (level.field[mgo.positionY][mgo.positionX].tag == 'player') {
        if (level.player.secondLife == false) {
          setLost();
          return true;
        } else {
          mgo.destroy();
          removePowerUp(PowerUp.secondLife);
        }
      }
    return false;
  }

  // Überprüft, ob die SPielfigur das Ziel erreicht hat.
  bool checkWin(MoveableGameObject mgo) {
    if(mgo.tag != "player") {
      return false;
    }
    if(level.field[mgo.positionY][mgo.positionX].isGoal){
      setWin();
      return true;
    }
    return false;
  }

  // Pausiert die aktuelle Spielwelt
  void pause(){
    paused = true;
  }

  // Führt das Spiel fort, wenn dies zuvor Pausiert wurde
  void resume(){
    paused = false;
  }
}

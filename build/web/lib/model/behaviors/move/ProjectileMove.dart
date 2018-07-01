import 'IMoveBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';
import '../../gameObjects/moveableGameObjects/Enemy.dart';

// Stellt ein konkretes Bewegungsverhalten dar, das Bewegte Objekte zerstört und beim aufprall selbst zerstört wird
class ProjectileMove extends IMoveBehavior {

  // Bewegt das MoveableGameObject und zersötrt Gegner auf seinem Weg. Wird allerdings auch selbstzerstört, wenn auf ein undurchdringliches Objekt getroffen wird.
  move(MoveableGameObject mgo) {
    mgo.desiredX += mgo.direction;

    Enemy enemy = Enemy.getEnemyByPosition(mgo.level, mgo.desiredY, mgo.desiredX);
    if(enemy != null) {
      enemy.destroy();
      mgo.destroy();
      mgo.desiredX = mgo.positionX;
      mgo.desiredY = mgo.positionY;
    }
    else if(!mgo.level.field[mgo.desiredY][mgo.desiredX].isPassable){
      mgo.destroy();
      mgo.desiredX = mgo.positionX;
      mgo.desiredY = mgo.positionY;
    }
  }
}
import 'IMoveBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Ein konkretes Bewegungsverhalten, welches beim kollidieren mit einem unpassierbaren Objekt die richtung ändert
class EnemyMove extends IMoveBehavior {

  // Bewegt das MoveableGameObjekt in die aktuelle richtung, sollte der Block vor ihm unpassierbar sein, wird die richtung gedreht.
  move(MoveableGameObject mgo){
    if(mgo.level.field[mgo.positionY][mgo.positionX + mgo.direction].isPassable){
      mgo.desiredX += mgo.direction;
    }
    else {
      mgo.direction *= -1;
    }
  }
}
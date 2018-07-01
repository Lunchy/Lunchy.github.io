import 'IJumpBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Ein konkretes Sprungverhalten, mit hoher Sprungkraft
class HighJump extends IJumpBehavior {

  // Lässt das MoveableGameObjekt hoch springen
  @override
  jump(MoveableGameObject mgo){
    if(mgo.level.field.length == mgo.positionY) return;
    if(mgo.level.field[mgo.positionY + 1][mgo.positionX].isPassable) return;
    mgo.desiredY -= 4;
  }
}
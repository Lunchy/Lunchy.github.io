import 'IMoveBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Ein konkretes Bewegungsverhalten, welches beim Bewegen Springt
class JumpMove extends IMoveBehavior {

  // Statt das MoveableGameObjekt horitontal zu bewegen, wird vertikal bewegt
  @override
  move(MoveableGameObject mgo) {
    if(!mgo.level.field[mgo.desiredY + 1][mgo.positionX].isPassable){
      mgo.desiredY -= 5;
    }
  }
}
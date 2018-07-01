import 'IJumpBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// ein konretes Sprungverhalten mit geöhnlicher Sprungkraft
class SimpleJump extends IJumpBehavior {

  // Lässt das übergebene MoveableGameObject gewöhnlich hoch springen
  @override
  jump(MoveableGameObject mgo) {
    if (mgo.level.field.length == mgo.positionY) return;
    if (mgo.level.field[mgo.desiredY + 1][mgo.positionX].isPassable) return;
    mgo.desiredY -= 2;
  }
}
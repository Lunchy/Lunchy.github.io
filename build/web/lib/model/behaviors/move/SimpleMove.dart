import 'IMoveBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Stellt ein geweöhnliches Bewegungsverhalten dar
class SimpleMove extends IMoveBehavior {
  move(MoveableGameObject mgo){
    mgo.desiredX += mgo.direction;
  }
}
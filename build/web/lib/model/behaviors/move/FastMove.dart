import 'IMoveBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Ein konkretes schnelles Bewegungsverhalten
class FastMove extends IMoveBehavior {
  // Lässt das MoveableGameObjekt sich schnell weiter Bewegen
  move(MoveableGameObject mgo){
    mgo.desiredX += mgo.direction * 2;
  }
}
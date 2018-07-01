import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Eine Schnittstelle für MoveableGameObjekts um ein Sprungverhalten zu implementieren
abstract class IJumpBehavior {
  // Zum abrufen dieses Sprungverhaltens
  jump(MoveableGameObject mgo);
}
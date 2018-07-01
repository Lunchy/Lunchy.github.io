import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Stellt die Schnittstelle für Bewegungsverhalten dar
abstract class IMoveBehavior {
  // Zum abrufen des Bewegungsverhaltens
  move(MoveableGameObject mgo);
}
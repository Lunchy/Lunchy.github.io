import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';

// Stellt eine Schnittstelle dar, um Objekte ein Angriffsverhalten zu verleihen
abstract class IAttackBehavior {
  // Zum abrufen des Kampfverhaltens
  attack(MoveableGameObject mgo);
}
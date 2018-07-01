import 'IAttackBehavior.dart';
import '../../gameObjects/moveableGameObjects/MoveableGameObject.dart';
import '../../gameObjects/moveableGameObjects/Projectile.dart';

// Ein konkretes Angriffsverhalten, das abgerufen werden kann
class ProjectileAttack extends IAttackBehavior {

  // Schießt ein Projektile in die eigene richtung, mit doppelter Bewegungsgeschwindigkeit
  @override
  attack(MoveableGameObject mgo) {
    new Projectile(mgo.level, mgo.positionX + mgo.direction, mgo.positionY, mgo.direction, mgo.movementSpeed ~/ 2);
  }

}
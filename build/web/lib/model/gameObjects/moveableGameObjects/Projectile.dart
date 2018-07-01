import '../../Level.dart';
import 'MoveableGameObject.dart';
import '../../behaviors/move/ProjectileMove.dart';

// Ein Projektil ist teil eines Angriffes
class Projectile extends MoveableGameObject {

  // Erstellt ein neues Projektil
  Projectile(Level Level, int positionX, int positionY, int direction, int moveSpeed)
      : super(Level, positionX, positionY, false, true, false, new ProjectileMove(), null, null, moveSpeed, direction, 'projectile'){
    level.addProjectile(this);
  }



}
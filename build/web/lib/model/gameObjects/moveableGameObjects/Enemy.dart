import '../../behaviors/attack/IAttackBehavior.dart';
import '../../behaviors/jump/IJumpBehavior.dart';
import '../../behaviors/move/IMoveBehavior.dart';
import '../../Level.dart';
import 'MoveableGameObject.dart';

// Stellt den Abstrakten Gegnertyp dar
abstract class Enemy extends MoveableGameObject {
  // erstellt ein MoveableGameObject und teilt der Spielwelt mit, dass ein Gegner hinzugefügt wurde
  Enemy(Level Level, int PositionX, int PositionY, bool IsPassable, bool IsDeathly, bool hasGravity, IMoveBehavior moveBehavior, IJumpBehavior jumpBehavior, IAttackBehavior attackBehavior, int movementSpeed, int direction, String tag)
      : super(Level, PositionX, PositionY, IsPassable, IsDeathly, hasGravity, moveBehavior, jumpBehavior, attackBehavior, movementSpeed, direction, tag){
    level.addEnemy(this);
  }

  // Eine statische Mehtode, um Gegner mittels ihrer Position zu finden
  static Enemy getEnemyByPosition(Level level, int y, int x) {
    var enemy;
    for(Enemy enemy in level.enemys){
      if(enemy.positionX == x && enemy.positionY == y) {
        return enemy;
      }
    }
    return enemy;
  }
}
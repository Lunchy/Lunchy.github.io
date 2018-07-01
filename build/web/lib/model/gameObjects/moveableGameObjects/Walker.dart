import 'Enemy.dart';
import '../../Level.dart';
import '../../behaviors/move/EnemyMove.dart';

// Ein Gegnertyp der sich horizontal in der Spielwelt bewegt
class Walker extends Enemy {
  // Erstellt einen Gegner vom Typ "Walker"
  Walker(Level Level, int positionX, int positionY, int moveSpeed)
      : super(Level, positionX, positionY, false, true, true, new EnemyMove(), null, null, moveSpeed, -1, "walker");

}
import 'Enemy.dart';
import '../../behaviors/move/JumpMove.dart';
import '../../Level.dart';

// Ein Gegnertyp der an einer bestimmten Stelle sich auf und ab bewegt
class Jumper extends Enemy {

  // Erstellt den konkreten Gegnertyp "Jumper"
  Jumper(Level Level, int positionX, int positionY, int moveSpeed)
      : super(Level, positionX, positionY, false, true, true, new JumpMove(), null, null, moveSpeed, 0, "jumper");
}
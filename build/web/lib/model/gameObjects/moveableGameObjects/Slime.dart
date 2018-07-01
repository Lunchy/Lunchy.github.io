import 'Enemy.dart';
import '../../Level.dart';

// Ein Gegnertyp, der unbeweglich ist
class Slime extends Enemy {
  // Erstellt einen Gegner vom Typ "Slime"
  Slime(Level Level, int PositionX, int PositionY)
      : super(Level, PositionX, PositionY, false, true, false, null, null, null, 0, 0, "slime");
}
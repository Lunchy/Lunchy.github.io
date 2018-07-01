import 'MoveableGameObject.dart';
import '../../behaviors/move/SimpleMove.dart';
import '../../behaviors/jump/SimpleJump.dart';
import '../../Level.dart';
import '../../behaviors/PowerUp.dart';

// Die Spielfigur, welche vom Spieler manövriert wird
class Player extends MoveableGameObject {
  bool secondLife = false;              // Gibt an, ob der Spieler ein extra-Leben besitzt
  PowerUp powerUp = PowerUp.noPowerUp;  // Gibt die aktuelle verbesserung der Spielfigur an

  // Erstellt eine neue Spielfigur in der mitgegebenen Spielwelt
  Player(Level level, int positionX, int positionY, int moveSpeed)
      : super(level, positionX, positionY, true, false, true, new SimpleMove(), new SimpleJump(), null, moveSpeed, 1, 'player'){
    level.addPlayer(this);
  }

}
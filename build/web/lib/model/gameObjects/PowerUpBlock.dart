import 'GameObject.dart';
import '../Level.dart';

// Ein Block, der der Spielfigur verbesserte Fähigkeiten verleiht
class PowerUpBlock extends GameObject {
  // Ersellt einen Power-up Block in der Spielwelt
  PowerUpBlock(Level Level, int positionX, int positionY) : super(Level, positionX, positionY, true, false, false, 'powerUpBlock'){
    level.addPowerUp(this);
  }
}
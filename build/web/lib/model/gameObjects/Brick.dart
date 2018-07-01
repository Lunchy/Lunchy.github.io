import 'GameObject.dart';
import '../Level.dart';

// Ein unbewegtes, undurchdringliches, untötliches Objekt in der Spielwelt
class Brick extends GameObject {

  // Erstellt ein GameObjekt vom Typ "Block"
  Brick(Level Level, int positionX, int positionY) : super(Level, positionX, positionY, false, false, false, 'brick');
}
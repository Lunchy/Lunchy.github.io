import 'GameObject.dart';
import '../Level.dart';

// Ein unbewegtes, durchdringliches, untötliches Objekt in der Spielwelt
class Air extends GameObject {

  // Erstellt ein Objekt vom Typ "Luft"
  Air(Level Level, int positionX, int positionY) : super(Level, positionX, positionY, true, false, false, "air");
}
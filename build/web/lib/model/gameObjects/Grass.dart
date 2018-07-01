import 'GameObject.dart';
import '../Level.dart';

// Üblicherweise ein teil des Bodens einer Spielwelt
class Grass extends GameObject {
  // Erstellt ein neuen Grass-Block
  Grass(Level Level, int positionX, int positionY) : super(Level, positionX, positionY, false, false, false, 'grass');
}
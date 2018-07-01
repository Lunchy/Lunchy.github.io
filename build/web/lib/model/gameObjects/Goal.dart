import 'GameObject.dart';
import '../Level.dart';

// Stellt ein Ziel einer Spielwelt dar
class Goal extends GameObject {
  // Erstellt ein neues Ziel in der Spielwelt
  Goal(Level Level, int positionX, int positionY) : super(Level, positionX, positionY, false, false, true, 'goal');
}
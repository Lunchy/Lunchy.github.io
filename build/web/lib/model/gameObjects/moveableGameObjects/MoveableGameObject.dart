import '../GameObject.dart';
import '../../behaviors/move/IMoveBehavior.dart';
import '../../behaviors/jump/IJumpBehavior.dart';
import '../../behaviors/attack/IAttackBehavior.dart';
import '../../Level.dart';
import '../Air.dart';

// Ist ein "verbestertes" GameObject, welches sich bewegen, springen und angreifen kann.
// Außerdem kann es zerstört werden.
abstract class MoveableGameObject extends GameObject {
  int movementSpeed;          // Die Bewegungsgeschwindigkeit

  bool _isDestroyed = false;  // Ein Wert, der angiebt, ob das Objekt zerstört wurde
  bool get isDestroyed => _isDestroyed;

  bool hasGravity;    // Ein Wert, der angiebt, ob das Objekt der Schwerkraft ausgesetzt ist

  GameObject currentStaticObject; // Wird benötigt, um ein GameObject an die aktuelle Stelle zu setzten, wenn dieses die Position verlässt.

  IMoveBehavior moveBehavior;     // Stellt das Bewegungsverhalten dar
  IJumpBehavior jumpBehavior;     // Stellt das Sprungverhalten dar
  IAttackBehavior attackBehavior; // Stellt das Angriffsverhalten dar

  // Die gewünschten Postitionen, werden im GameController überprüft und anschließend gesetzt
  int desiredX; // Gibt die gewünschte X-Position an.
  int desiredY; // Gibt die gewünschte Y-Position an.

  // Die aktuelle richtung des Objektes
  int direction;

  // Erstellt ein Bewegliches Objekt. Wenn sich das Objekt bewegt, wird diese Position inital durch "Luft" ersetzt
  MoveableGameObject(Level Level, int PositionX, int PositionY, bool IsPassable, bool IsDeathly, this.hasGravity, this.moveBehavior, this.jumpBehavior, this.attackBehavior, this.movementSpeed, this.direction, String tag) :
        super(Level, PositionX, PositionY, IsPassable, IsDeathly, false, tag){
    desiredY = PositionY;
    desiredX = PositionX;

    currentStaticObject = new Air(null, positionX, positionY);
  }

  // Führt das aktuelle Bewegungsverhalten aus
  move(){
    moveBehavior?.move(this);
  }

  // Führt das aktuelle Sprungverhalten aus
  jump(){
    jumpBehavior?.jump(this);
  }

  // Führt das aktuelle Angriffsverhalten aus
  attack(){
    attackBehavior?.attack(this);
  }

  // Zerstört das Bewegliche Objekt
  destroy() {
    _isDestroyed = true;
    level.field[positionY][positionX] = currentStaticObject;
  }
}
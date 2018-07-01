import '../Level.dart';

// Ein GameObjekt befindet sich an einer bestimmten Stelle in der Spielwelt, und besitzt besondere Eigenschaften
abstract class GameObject{
  Level level;      // Die Spielwelt, in der sich dieses Objekt befindet
  int positionX;    // Die aktuelle X-Position
  int positionY;    // Die aktuelle Y-Position
  bool isPassable;  // Gibt an, ob das Objekt für andere durchringlich ist
  bool isDeathly;   // Gibt an, ob das Objekt für andere tötlich ist
  bool isGoal;      // Gibt an, ob das Objekt ein Ziel ist
  String tag;       // Stellt einen Identifizierer für ein bestimmten Objekt-Typ dar

  GameObject(this.level, this.positionX, this.positionY, this.isPassable, this.isDeathly, this.isGoal, this.tag){
    if(level != null){
      level.field[positionY][positionX] = this;
    }
  }
}
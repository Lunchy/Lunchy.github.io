import 'dart:async';
import 'dart:html';
import 'dart:convert';

import '../model/Level.dart';
import '../model/gameObjects/GameObject.dart';
import '../model/gameObjects/moveableGameObjects/Walker.dart';
import '../model/gameObjects/Brick.dart';
import '../model/gameObjects/Grass.dart';
import '../model/gameObjects/Air.dart';
import '../model/gameObjects/moveableGameObjects/Player.dart';
import "../model/gameObjects/Goal.dart";
import "../model/gameObjects/moveableGameObjects/Slime.dart";
import '../model/gameObjects/moveableGameObjects/Jumper.dart';
import '../model/gameObjects/PowerUpBlock.dart';
import '../view/GameView.dart';

// Liest die definition einer Spielwelt aus einer JSON-Datei aus und kann diese erstellen
class LevelCreator {
  int width = 100;  // Die Breite der Spielwelt
  int height = 20;  // Die Höhe der Spielwelt

  GameView view;    // Das Anzeigeelement (wird zum setzten des Hintergrunds benötigt)

  LevelCreator(this.view);

  // Liest eine JSON-Datei ein, wenn dies fertig ist wird das Level gebaut und einer übergebenen Methode weitergegeben
  Future load(final int levelNr, void callbackFunction(Level level)) {
    return HttpRequest
        .getString("../../levels/level_$levelNr.json")
        .then((lvlJson) {
      callbackFunction(levelFromMap(JSON.decode(lvlJson)));
    });
  }

  // Setzt die Höhe und Breite der Spielwelt
  void setHeightAndWidth(var h, var w) {
    height = int.parse(h);
    width = int.parse(w);
  }

  // Wandelt die Map, die aus der JSON-Datei ausgelesen wurde, in eine Spielwelt um
  // initial wird die Spielwelt mit Luft gefüllt
  Level levelFromMap(Map data) {
    view.setLevelBackground(data['background']['image'] == null
        ? "grasslands"
        : data['background']['image']);

    if (data['size'] != null) {
      data['size'].forEach((k, v) => setHeightAndWidth(k, v));
    }

    Level level = new Level();
    List<List<GameObject>> field = new List<List<GameObject>>(height);
    for (int row = 0; row < height; row++) {
      field[row] = new List<GameObject>(width);
    }
    level.field = field;

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        new Air(level, col, row);
      }
    }

    if (data['grass'] != null) {
      data['grass'].forEach((k, v) => v == "all"
          ? fillWithGrass(level, k)
          : setGrass(level, k, v.toString().split(',')));
    }

    if (data['brick'] != null) {
      data['brick'].forEach((k, v) => v == "all"
          ? fillWithBricks(level, k)
          : setBricks(level, k, v.toString().split(',')));
    }

    if (data['goal'] != null) {
      data['goal'].forEach((k, v) => setGoal(level, k, v.toString().split(',')));
    }

    if (data['powerUp'] != null) {
      data['powerUp']
          .forEach((k, v) => setPowerUp(level, k, v.toString().split(',')));
    }

    if (data['walker'] != null) {
      data['walker'].forEach((k, v) => k != 'speed'
          ? setWalker(level, k, v.toString().split(','))
          : "");
    }

    if (data['jumper'] != null) {
      data['jumper'].forEach((k, v) => k != 'speed'
          ? setJumper(level, k, v.toString().split(','))
          : "");
    }

    if (data['slime'] != null) {
      data['slime']
          .forEach((k, v) => setSlime(level, k, v.toString().split(',')));
    }

    if (data['player'] != null) {
      data['player'].forEach((k, v) => k != 'speed'
          ? setPlayer(level, k, v.toString().split(','))
          : "");
    }

    if (data['air'] != null) {
      data['air'].forEach((k, v) => setAir(level, k, v.toString().split(',')));
    }

    return level;
  }

  // Setzt Luft an die übergebenen Y- und X-Positionen
  void setAir(Level level, String y, var x) {
    for (var v in x) {
      new Air(level, int.parse(v), int.parse(y));
    }
  }

  // Setzt Power-ups an die übergebenen Y- und X-Positionen
  void setPowerUp(Level level, String y, var x) {
    for (var v in x) {
      new PowerUpBlock(level, int.parse(v), int.parse(y));
    }
  }

  // Füllt eine komplette Zeile mit Bricks
  void fillWithBricks(Level level, String y) {
    for (int i = 0; i < width; i++) {
      new Brick(level, i, int.parse(y));
    }
  }

  // Setzt Bricks an die übergebenen Y- und X-Positionen
  void setBricks(Level level, String y, var x) {
    for (var v in x) {
      new Brick(level, int.parse(v), int.parse(y));
    }
  }

  // Füllt eine komplette Zeile mit Grass
  void fillWithGrass(Level level, String y) {
    for (int i = 0; i < width; i++) {
      new Grass(level, i, int.parse(y));
    }
  }

  // Setzt Grass an die übergebenen Y- und X-Positionen
  void setGrass(Level level, String y, var x) {
    for (var v in x) {
      new Grass(level, int.parse(v), int.parse(y));
    }
  }

  // Setzt Ziele an die übergebenen Y- und X-Positionen
  void setGoal(Level level, String y, var x) {
    for (var v in x) {
      new Goal(level, int.parse(v), int.parse(y));
    }
  }

  // Setzt Gegner vom Typ Walker an die übergebenen Y- und X-Positionen, mit angegebener geschwindigkeit
  void setWalker(Level level, String y, var x) {
    for (var v in x) {
      if (y.toString() != "speed") {
        var z = v.toString().split(';');
        if(z.length < 2){
          new Walker(level, int.parse(z[0]), int.parse(y), 200);
        }
        else
        {
          new Walker(level, int.parse(z[0]), int.parse(y), int.parse(z[1]));
        }
      }
    }
  }

  // Setzt Gegner vom Typ Jumper an die übergebenen Y- und X-Positionen, mit angegebener geschwindigkeit
  void setJumper(Level level, String y, var x) {
    for (var v in x) {
      var z = v.toString().split(';');
      if(z.length < 2){
        new Jumper(level, int.parse(z[0]), int.parse(y), 200);
      }
      else
      {
        new Jumper(level, int.parse(z[0]), int.parse(y), int.parse(z[1]));
      }
    }
  }

  // Setzt Gegner vom Typ Slime an die übergebenen Y- und X-Positionen
  void setSlime(Level level, String y, var x) {
    for (var v in x) {
      new Slime(level, int.parse(v), int.parse(y));
    }
  }

  // Setzt den Spieler an eine bestimmte Position, mit bestimmter Geschwindigkeit
  void setPlayer(Level level, String y, var x) {
    for (var v in x) {
      var z = v.toString().split(';');
      if(z.length < 2){
        new Player(level, int.parse(z[0]), int.parse(y), 100);
      }
      else
      {
        new Player(level, int.parse(z[0]), int.parse(y), int.parse(z[1]));
      }
    }
  }
}

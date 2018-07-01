import 'dart:html';
import '../controller/MenuController.dart';
import '../controller/GameController.dart';
import '../model/Level.dart';
import '../model/gameObjects/moveableGameObjects/Player.dart';
import '../model/behaviors/PowerUp.dart';

class GameView {
  DivElement levelSelectDiv = querySelector("#levelSelectDiv"); // Hauptmenü Anzeige
  DivElement successScreen = querySelector("#SuccessScreen");   // Level Geschafft Anzeige
  DivElement failureScreen = querySelector("#FailureScreen");   // Level Gescheitert Anzeige
  TableElement gameField = querySelector("#GameField");         // Spielfeld
  DivElement pauseScreen = querySelector("#PauseScreen");       // Pause Anzeige
  DivElement powerUpLabel = querySelector("#powerUpLabel");     // Power-up Anzeige (ingame)
  DivElement creditsScreen = querySelector("#CreditsScreen");   // Credits Anzeige

  List<ButtonElement> levelSelectButtons = new List<ButtonElement>(); // Liste von Level-Knöpfen

  ButtonElement backToMenuFromSuccess = querySelector("#backToLevelSelect");          // Knopf für "zurück zum Hauptmenü" nach einem bestandenem Level
  ButtonElement backToMenuFromFailure = querySelector("#backToLevelSelect_Failure");  // Knopf für "zurück zum Hauptmenü" nach einem gescheitertem Level
  ButtonElement nextLevel = querySelector("#nextLevel");                              // Knopf für "nächstes Level" nach bestandenem Level
  ButtonElement retryLevel = querySelector("#retryLevel");                            // Knopf für "neuer Versuch" nach gescheitertem Level
  ButtonElement btnCreditsScreen = querySelector("#btnCreditsScreen");                   // Knopf für das einblenden des SuccessScreen
  ButtonElement backToMenuFromCredis = querySelector("#backToLevelSelect_Credits");   // Knopf für "zurück zum Hauptmenü" nach den Credits

  ButtonElement jumpButton = querySelector("#jumpButton");        // Knopf zum Springen
  ButtonElement powerUpButton = querySelector("#powerUpButton");  // Knopf zum aktivieren des Power-ups

  MenuController menuController;  // Der zugeortnete Menü Controller
  GameController gameController;  // Der zugeortnete Game Controller

  // Zum überprüfen, ob sich das Seitenverhältnis geändert hat
  int iWidth;   // Die zuletzt festgestellte innere breite des Anzeigeelementes
  int iHeight;  // Die zuletzt festgestellte innere höhe des Anzeigeelementes

  // Felder des Anzeigeelementes
  int width;        // Felder in der Breite (wird in "reload" berechnet)
  int height = 10;  // Felder in der Höhe (feste anzahl)

  List<List<HtmlElement>> fields; // Eine Liste mit den HTML-Elementen zum ändern des DOM-Tree
  bool isGameActive = false;      // Gibt an, ob das Spiel nicht im Pause-Modus ist

  // Speichert das aktuelle Seitenverhältnis und fügt allen Menü-Relevanten Knöpfen Klick-Events zu
  GameView(this.menuController) {
    reload();

    backToMenuFromSuccess.onClick.listen(menuController.triggerBackToMenuFromSuccess);
    nextLevel.onClick.listen(menuController.triggerNextLevel);
    backToMenuFromFailure.onClick.listen(menuController.triggerBackToMenuFromFailure);
    retryLevel.onClick.listen(menuController.triggerRetryLevel);
    btnCreditsScreen.onClick.listen(menuController.triggerShowCredits);
    backToMenuFromCredis.onClick.listen(menuController.triggerBackToMenuFromCredits);

    for (int i = 1; i <= 15; i++) {
      ButtonElement button = querySelector("#button$i");
      levelSelectButtons.add(button);
      button.style.backgroundImage = "url(../../img/LevelButtons/lvl$i.png)";
      button.onClick.listen((MouseEvent event) => menuController.selectLevel(event, i));
    }
  }

  // Setzt das Hintergrundbild der Spielwelt
  void setLevelBackground (String background) {
      gameField.style.background = "url(../../img/LevelBackgrounds/$background.png)";
      gameField.style.backgroundSize = "cover";
  }

  // Setzt die Power-up Anzeige auf das "aktiv"
  void activatePowerUp (PowerUp powerUp) {
    switch (powerUp) {
      case PowerUp.higherJump: //Higher Jump
        powerUpLabel.style.backgroundImage = "url(../../img/PowerUps/higherJumpActivatedPowerUp.png)";
        break;
      case PowerUp.speed: //Speed
        powerUpLabel.style.backgroundImage = "url(../../img/PowerUps/speedActivatedPowerUp.png)";
        break;
      case PowerUp.fire: //Fire
        break;
      case PowerUp.secondLife: //Second Life
        break;
      case PowerUp.noPowerUp: //Kein PowerUp
        break;
    }
  }

  // Setzt die Power-up Anzeige auf das aktuell ausgerüstete Power-up
  void setPowerUp (PowerUp powerUp) {
    switch (powerUp) {
      case PowerUp.higherJump: //Higher Jump
        powerUpLabel.style.backgroundImage = "url(../../img/PowerUps/higherJumpPowerUp.png)";
        break;
      case PowerUp.speed: //Speed
        powerUpLabel.style.backgroundImage = "url(../../img/PowerUps/speedPowerUp.png)";
        break;
      case PowerUp.fire: //Fire
        powerUpLabel.style.backgroundImage = "url(../../img/PowerUps/fireActivatedPowerUp.png)";
        break;
      case PowerUp.secondLife: //Second Life
        powerUpLabel.style.backgroundImage = "url(../../img/PowerUps/secondLifePowerUp.png)";
        break;
      case PowerUp.noPowerUp: //Kein PowerUp
        powerUpLabel.style.backgroundImage = "url(../../img/PowerUps/noPowerUp.png)";
        break;
    }
  }

  // Speichert das aktuelle Seitenverhältnis und berechnet die Felder, die in die Breite angezeigt werden
  void reload(){
    iWidth = window.innerWidth;
    iHeight = window.innerHeight;
    width = ((iWidth / iHeight) * height).round();
    initGameField();
  }

  // Baut das GameField mittels DOM-Tree Manipulation in der index.html
  // speichert zusätzlich die einzelnen Zellen in einem 2D-Array
  void initGameField(){
    String table = "";
    for (int row = 0; row < height; row++) {
      table += "<tr>";
      for (int col = 0; col < width; col++) {
        table += "<td  id='field_${col}_${row}'></td>";
      }
      table += "</tr>";
    }
    gameField.innerHtml = table;

    fields = new List<List<HtmlElement>>(height);
    for (int row = 0; row < height; row++) {
      fields[row] = [];
      for (int col = 0; col < width; col++) {
        fields[row].add(gameField.querySelector("#field_${col}_${row}"));
      }
    }
  }

  // Berechnet die relative Position der Splate im Spielfeld, abhängig von der Spielfigur
  int calcColStart(int playerX, int levelWidth){
    int retVal;
    if(playerX - (width ~/ 2) < 0) {
      retVal = 0;
    }
    else {
      if(playerX + (width ~/ 2) > levelWidth) {
        retVal = levelWidth - width;
      }
      else {
        retVal = playerX - (width ~/ 2);
      }
    }
    return retVal;
  }
  // Berechnet die relative Position der Zeile im Spielfeld, abhängig von der Spielfigur
  int calcRowStart(int playerY, int levelHeight){
    int retVal;
    if(playerY + (height ~/ 2) > levelHeight) {
      retVal = levelHeight - height;
    }
    else {
      if(playerY - (height ~/ 2) < 0) {
        retVal = 0;
      }
      else {
        retVal = playerY - (height ~/ 2);
      }
    }
    return retVal;
  }

  // Zeichnet den Anzeigebereich neu
  // Prüft das Seitenverhältnis und zieht daraus schlüsse
  void updateGamefield(Level level, Player player) {
    final field = level?.field;
    final fieldHeight = field?.length;
    final fieldWidth = field[0]?.length;
    final playerX = player?.positionX;
    final playerY = player?.positionY;

    if(window.innerWidth < window.innerHeight){
      showPause();
      return;
    }
    else {
      if(!isGameActive){
        showGame();
      }
    }

    if(iWidth != window.innerWidth || iHeight != window.innerHeight){
      reload();
    }

    int rowStart = 0;
    int rowEnd = height;

    int colStart = 0;
    int colEnd = width;

    if(field == null) return;

    if(fieldHeight == height){
      rowStart = 0;
    }

    else if (fieldHeight > height) {
      rowStart = calcRowStart(playerY, fieldHeight);
    }
    else {
      rowStart = (fieldHeight ~/ 2) - (height ~/ 2);
    }

    rowEnd = rowStart + height;

    colStart = calcColStart(playerX, field[0].length);
    colEnd = colStart + width;

    for (int col = colStart; col < colEnd; col++) {
      for (int row = rowStart; row < rowEnd; row++) {
        final td = fields[row - rowStart][col - colStart];
        if(td.className == null || td.className != field[row][col].tag){
          td.classes.clear();
          if (td != null) {
            if (row < 0 || row > fieldHeight - 1 || col < 0 ||
                col > fieldWidth - 1 || field[row][col] == null) {
              td.classes.add("noneClass");
            }
            else {
              td.classes.add(field[row][col].tag);
            }
          }
        }
      }
    }
  }

  // Zeigt einen "Gewonnen"-Bildschirm.
  // Aus diesem kann zurück ins Hauptmenü gewechselt werden
  // oder mit dem nächsten Level fortgefahren werden
  void showWon(){
    isGameActive = false;
    gameField.style.zIndex = "1";
    levelSelectDiv.style.zIndex = "0";
    successScreen.style.zIndex = "2";
    failureScreen.style.zIndex = "0";
    pauseScreen.style.zIndex = "0";

    gameField.style.visibility = "visible";
    levelSelectDiv.style.visibility = "hidden";
    successScreen.style.visibility = "visible";
    failureScreen.style.visibility = "hidden";
    pauseScreen.style.visibility = "hidden";
  }

  // Zeigt einen "Verloren"-Bildschirm
  // Aus diesem kann zurück ins Hauptmenü gewechselt werden
  // oder das Level neu Versucht werden
  void showLost() {
    isGameActive = false;
    gameField.style.zIndex = "1";
    levelSelectDiv.style.zIndex = "0";
    successScreen.style.zIndex = "0";
    failureScreen.style.zIndex = "2";
    pauseScreen.style.zIndex = "0";

    gameField.style.visibility = "visible";
    levelSelectDiv.style.visibility = "hidden";
    successScreen.style.visibility = "hidden";
    failureScreen.style.visibility = "visible";
    pauseScreen.style.visibility = "hidden";
  }

  // Blendet die aktuelle Spielwelt ein
  void showGame(){
    isGameActive = true;
    gameController?.resume();
    gameField.style.zIndex = "1";
    levelSelectDiv.style.zIndex = "0";
    successScreen.style.zIndex = "0";
    failureScreen.style.zIndex = "0";
    pauseScreen.style.zIndex = "0";
    powerUpLabel.style.zIndex = "2";
    creditsScreen.style.zIndex = "0";

    creditsScreen.style.visibility = "hidden";
    powerUpLabel.style.visibility = "visible";
    gameField.style.visibility = "visible";
    levelSelectDiv.style.visibility = "hidden";
    successScreen.style.visibility = "hidden";
    failureScreen.style.visibility = "hidden";
    pauseScreen.style.visibility = "hidden";
  }

  // Blendet das Menü ein
  void showMenu () {
    isGameActive = false;
    gameField.style.zIndex = "0";
    levelSelectDiv.style.zIndex = "1";
    successScreen.style.zIndex = "0";
    failureScreen.style.zIndex = "0";
    pauseScreen.style.zIndex = "0";
    creditsScreen.style.zIndex = "0";
    powerUpLabel.style.zIndex = "0";

    powerUpLabel.style.visibility = "hidden";
    gameField.style.visibility = "hidden";
    levelSelectDiv.style.visibility = "visible";
    successScreen.style.visibility = "hidden";
    failureScreen.style.visibility = "hidden";
    pauseScreen.style.visibility = "hidden";
    creditsScreen.style.visibility = "hidden";
  }

  // Blendet die Credits ein
  void showCredits() {
    isGameActive = false;
    gameField.style.zIndex = "0";
    levelSelectDiv.style.zIndex = "0";
    successScreen.style.zIndex = "0";
    failureScreen.style.zIndex = "0";
    pauseScreen.style.zIndex = "0";
    creditsScreen.style.zIndex = "1";
    powerUpLabel.style.zIndex = "0";

    gameField.style.visibility = "hidden";
    levelSelectDiv.style.visibility = "hidden";
    successScreen.style.visibility = "hidden";
    failureScreen.style.visibility = "hidden";
    pauseScreen.style.visibility = "hidden";
    creditsScreen.style.visibility = "visible";
    powerUpLabel.style.visibility = "hidden";
  }

  // Blendet einen "Pause"-Bildschirm ein
  // und Pausiert die Spielwelt
  void showPause(){
    isGameActive = false;
    gameController?.pause();
    pauseScreen.style.zIndex = "2";
    successScreen.style.zIndex = "0";
    failureScreen.style.zIndex = "0";
    levelSelectDiv.style.zIndex = "0";
    gameField.style.zIndex = "1";

    gameField.style.visibility = "hidden";
    levelSelectDiv.style.visibility = "hidden";
    successScreen.style.visibility = "hidden";
    failureScreen.style.visibility = "hidden";
    powerUpLabel.style.visibility = "hidden";
    pauseScreen.style.visibility = "visible";
  }

}
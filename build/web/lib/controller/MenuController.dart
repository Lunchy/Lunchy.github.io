import "dart:html";
import "../view/GameView.dart";
import '../util/LevelCreator.dart';
import '../model/Level.dart';
import "GameController.dart";

//Regelt die nutzer eingaben, die außerhalb des Spielgeschehen relevanz haben
class MenuController {
  GameView view;                  // Die Anzeige, die die verschiedenen Zustände darstellen kann
  GameController gameController;  // Der Spielcontroller (wird erzeugt, wenn eine Spielwelt ausgewählt wurde)
  int selectedLevel;              // Der Index der ausgewählten Spielwelt

  // Wird von den Spielwelt-Knöpfen im Hauptmenü aufgerufen, um eine bestimmte Spielwelt zu laden
  void selectLevel(MouseEvent event, int selectedLevel) {
    this.selectedLevel = selectedLevel;
    new LevelCreator(view).load(selectedLevel, loadLevel);
  }

  // Wird vom LevelCreator nach dem Laden der Spielwelt aufgerufen
  void loadLevel(Level level){
    gameController = new GameController(view, level);
    view.showGame();
  }

  // Wird ausgelöst, wenn der Spieler nach einer erfolgreich bestrittenen Spielwelt zurück zum Hauptmenü kehren möchte
  void triggerBackToMenuFromSuccess (MouseEvent event) {
    view.showMenu();
  }

  // Wird ausgelöst, wenn der Spieler nach dem scheitern einer Spielwelt zurück zum Hauptmenü kehren möchte
  void triggerBackToMenuFromFailure (MouseEvent event) {
    view.showMenu();
  }

  // Lässt die Credits-Anzeige einblenden
  void triggerShowCredits(MouseEvent event) {
    view.showCredits();
  }

  // Lässt das Hauptmenü einblenden
  void triggerBackToMenuFromCredits(MouseEvent event) {
    view.showMenu();
  }

  // Wird ausgelöst, wenn der Spieler eine Spielwelt erfolgreich abgeschlossen hat und in die nächste Spielwelt kehren möchte
  void triggerNextLevel (MouseEvent event) {
    selectedLevel++;
    selectLevel(event, selectedLevel);
    view.showGame();
  }

  // Wird ausgelöst, wenn der Spieler in einer Spielwelt gescheitert ist und diese erneut versuchen möchte
  void triggerRetryLevel (MouseEvent event) {
    selectLevel(event, selectedLevel);
    view.showGame();
  }
}


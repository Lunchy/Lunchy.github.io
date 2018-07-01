import 'gameObjects/moveableGameObjects/Player.dart';
import 'gameObjects/moveableGameObjects/Enemy.dart';
import 'gameObjects/GameObject.dart';
import 'gameObjects/PowerUpBlock.dart';
import 'gameObjects/moveableGameObjects/Projectile.dart';

// Stellt eine Spielwelt dar
class Level {
  List<List<GameObject>> field;   // Das zweidiemensionale Raster, welches das Spielfeld ist
  Player player;                  // Die Spielfigur in der Spielwelt

  List<Projectile> projectiles = new List<Projectile>();  // Eine Liste mit allen Projektilen, die sich in der Spielwelt befinden
  List<Enemy> enemys = new List<Enemy>();                 // Eine Liste mit allen Gegnern, die sich in der Spielwelt befinden
  List<PowerUpBlock> powerUps = new List<PowerUpBlock>(); // Eine Liste mit allen Power-up-Blöcken, die sich in der Spielwelt befinden

  bool gameOver = false;  // Gibt an, ob das level beendet wurde (positiv und negativ)

  // Fügt eine Spielfigur der Spielwelt hinzu
  void addPlayer(Player player) => this.player = player;

  // Fügt einen Gegner der Spielwelt hinzu
  void addEnemy(Enemy enemy) => enemys.add(enemy);

  // Fügt ein Geschoss der Spielwelt hinzu
  void addProjectile(Projectile projectile) => projectiles.add(projectile);

  // Fügt ein Power-up-Block der Spielwelt hinzu
  void addPowerUp(PowerUpBlock powerUpBlock) => powerUps.add(powerUpBlock);
}
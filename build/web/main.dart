import 'lib/controller/MenuController.dart';
import 'lib/view/GameView.dart';

void main() {
  var mc = new MenuController();
  mc.view = new GameView(mc);
}



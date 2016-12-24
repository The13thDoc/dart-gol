import 'package:dart_gol/rules.dart';

class Cell {
  String id; // RxC
  int r, c;
  bool alive = false;
  List<Cell> neighbors;
  bool nextState = false;

  Cell(this.id, this.alive) {
    neighbors = [];
    r = int.parse(id.split('x').first);
    c = int.parse(id.split('x').last);
  }

  /// Prepare the next state (dead or alive).
  bool getNextState() {
    switch (rule) {
      case Rule.TwoThree_Three:
        if (alive && neighbors.length == 2 || neighbors.length == 3) {
          return true; // alive
        }
        if (!alive && neighbors.length == 3) {
          return true; // reborn
        }
        return false;
        break;

      case Rule.Twothree_Three_Six:
        if (alive && neighbors.length == 2 || neighbors.length == 3) {
          return true; // alive
        }
        if (!alive && neighbors.length == 3 || neighbors.length == 6) {
          return true; // reborn
        }
        return false;
        break;
    }
    return false;
  }

  // Check for living neighbors.
  void check() {
    nextState = getNextState();
  }

  /// Advance to the next state.
  bool grow() {
    alive = nextState;
    return alive;
  }
}

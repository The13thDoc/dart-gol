import 'package:dart_gol/rules.dart';

class Cell {
  String id; // RxC
  int r, c;
  bool alive = false;
  Map<String, Cell> neighbors;
  bool nextState = false;

  Cell(this.id, this.alive) {
    neighbors = {};
    r = int.parse(id.split('x').first);
    c = int.parse(id.split('x').last);
  }

  /// Make friends with the neighbor, if not done yet.
  /// Both neighbors with include each other in their list.
  void addNeighbor(Cell neighbor) {
    if (!neighbors.containsKey(neighbor.id)) {
      neighbors.putIfAbsent(neighbor.id, () => neighbor);
      neighbor.addNeighbor(this);
    }
  }

  /// Prepare the next state (dead or alive).
  bool getNextState() {
    int living = 0;
    for (Cell cell in neighbors.values) {
      if (cell.alive) living++;
    }
    // TODO: Move this into rules.dart
    switch (rule) {
      case Rule.TwoThree_Three:
        if (alive && (living == 2 || living == 3)) {
          return true; // alive
        }
        if (!alive && living == 3) {
          return true; // reborn
        }
        return false;
        break;

      case Rule.Twothree_ThreeSix:
        if (alive && (living == 2 || living == 3)) {
          return true; // alive
        }
        if (!alive && (living == 3 || living == 6)) {
          return true; // reborn
        }
        return false;
        break;
    }
    return false;
  }

  /// Check for living neighbors.
  /// Return - true if changing
  bool check() {
    nextState = getNextState();
    return (nextState != alive);
  }

    /// Initial check for living neighbors.
    /// Not actually set to change.
    /// Return - true if changing
    bool falseCheck() {
      return (getNextState() != alive);
    }

  /// Advance to the next state.
  bool grow() {
    alive = nextState;
    return alive;
  }
}

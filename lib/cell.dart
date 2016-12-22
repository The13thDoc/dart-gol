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
    if (alive && neighbors.length == 2 || neighbors.length == 3) {
      return true; // alive
    }
    if (!alive && neighbors.length == 3) {
      return true; // reborn
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

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
    if (alive) {
      if (neighbors.length == 2 || neighbors.length == 3) {
        return true; // alive
      }
    } else {
      if (neighbors.length == 3) {
        return true; // reborn
      }
    }
    return false;
  }

  // Check for living neighbors.
  void check() {
    nextState = getNextState();
    if (nextState) {
      print("${id}(${alive}): ${neighbors.length}, Will be: ${nextState}");
    }
  }

  /// Advance to the next state.
  void grow() {
    alive = nextState;
  }
}

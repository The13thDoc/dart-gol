import 'dart:math';
import 'package:dart_gol/cell.dart';
import 'package:dart_gol/forms.dart' as Forms;

/// Currently selected state of initialization,
Init gridState;

enum Init { randomBool, random8, allDead, allAlive, glider, rPentomino }

/// Initialize a grid of cells with the given state.
Cell initState(String id, Init init, int gridSize) {
  switch (init) {
    case Init.randomBool:
      bool alive = new Random().nextBool();
      if (alive) return getAlive(id);
      break;

    case Init.random8:
      int alive = new Random().nextInt(8);
      if (alive == 2 || alive == 3) return getAlive(id);
      break;

    case Init.allAlive:
      return getAlive(id);
      break;

    case Init.allDead:
      return getDead(id);
      break;

    case Init.glider:
      return centerForm(id, gridSize, Forms.glider());
      // if (Forms.glider()[id]) return getAlive(id);
      break;

    case Init.rPentomino:
      return centerForm(id, gridSize, Forms.rPentomino());
      // if (Forms.rPentomino()[id]) return getAlive(id);
      break;
  }
  return getDead(id);
}

/// Get a Cell initialized as alive.
Cell getAlive(String id) => new Cell(id, true);

/// Get a Cell initialized as dead.
Cell getDead(String id) => new Cell(id, false);

/// Return a live Cell with the centered ID.
Cell centerForm(String id, int gridSize, Map form) {
  for (String eachID in form.keys) {
    if (id == centeredId(eachID, gridSize) && form[eachID]) {
      return getAlive(id);
    }
  }
  return getDead(id);
}

String centeredId(String id, int gridSize) {
  int middle = (gridSize / 2).floor();
  // print(middle);
  return "${int.parse(id.split('x').first) + middle}x${int.parse(id.split('x').last) + middle}";
}

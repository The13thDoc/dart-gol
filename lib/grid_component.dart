import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

import 'dart:async';
import 'cell.dart';

@Component(
  selector: 'grid-component',
  templateUrl: 'grid_component.html',
  styleUrls: const ['grid_component.css'],
  directives: const [NgClass],
)
class GridComponent {
  @Input()
  String gridDimension = "10";

  int generationsPast = 1;
  int generationsToRun = 0;
  int secondsPerGeneration = 0;
  bool go = false;

  List columnsList;
  Map<String, Cell> lookupCells = {};
  String cellDimension = "20";
  String cellDimensionPx;
  int livingCells = 0;

  GridComponent() {
    cellDimensionPx = "${cellDimension}px";
    generateList();
  }

  Future<Null> generateList() async {
    List<List> initGlider = [
      [0, 1, 0],
      [0, 0, 1],
      [1, 1, 1]
    ];
    List<List> initBlock = [
      [0, 0, 0, 0, 0],
      [0, 0, 1, 1, 0],
      [0, 0, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ];
    List<List> initBlinker = [
      [0, 0, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0],
    ];
    // top to bottom
    // left to right
    columnsList = [];
    for (int c = 0; c < int.parse(gridDimension); c++) {
      List<Cell> cellsList = [];
      for (int r = 0; r < int.parse(gridDimension); r++) {
        // incrememt r and c by 1, for base 1 instead of 0.
        String id = "${r + 1}x${c + 1}";
        Cell cell = getDead(id);
        cellsList.add(cell);
        lookupCells.addAll({id: cell});
      }
      columnsList.add(cellsList);
    }
  }

  Cell getAlive(String id) {
    return new Cell(id, true);
  }

  Cell getDead(String id) {
    return new Cell(id, false);
  }

  void stepForward() {
    verifyNeighbors();
    grow();
  }

  /// Check surroundings for living neighbors.
  void verifyNeighbors() {
    for (List col in columnsList) {
      for (Cell cell in col) {
        findNeighbors(cell);
        cell.check();
      }
    }
  }

  /// Iterate throw the grid, advancing each cell's state.
  void grow() {
    for (List col in columnsList) {
      for (Cell cell in col) {
        if (cell.alive != cell.nextState) {
          updateLiveCount(cell.grow());
        }
      }
    }
    generationsPast++;
  }

  void findNeighbors(Cell cell) {
    // Remember, indexes are set at base 1. Bring them back to base zero.
    // int r = cell.r - 1, c = cell.c - 1;
    int r = cell.r, c = cell.c;
    Map rotation = {
      0: {"r": r, "c": c + 1},
      0.25: {"r": r - 1, "c": c + 1},
      0.5: {"r": r - 1, "c": c},
      0.75: {"r": r - 1, "c": c - 1},
      1: {"r": r, "c": c - 1},
      1.25: {"r": r + 1, "c": c - 1},
      1.5: {"r": r + 1, "c": c},
      1.75: {"r": r + 1, "c": c + 1},
    };
    num angle = 0;
    cell.neighbors.clear(); // IMPORTANT!
    while (angle <= 1.75) {
      Cell neighbor;
      int row = rotation[angle]["r"];
      int col = rotation[angle]["c"];

      if (lookupCells.containsKey("${row}x${col}")) {
        neighbor = lookupCells["${row}x${col}"];
        if (neighbor.alive) {
          cell.neighbors.add(neighbor);
        }
      }
      angle += 0.25;
    }
  }

  void buttonRun() {
    go = true;
    stepForward();
  }

  void buttonStop() {
    go = false;
  }

  /// Toggle the state (true/false) of the given cell.
  bool toggleState(bool state, String id) {
    lookupCells[id].alive = !state;
    updateLiveCount(!state);
    return !state;
  }

  void updateGridSize() {
    generateList();
  }

  void updateCellSize() {
    cellDimensionPx = "${cellDimension}px";
  }

  void updateLiveCount(bool state) {
    if (state) {
      livingCells++;
    } else {
      livingCells--;
    }
  }
}

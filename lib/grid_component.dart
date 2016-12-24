import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

import 'dart:async';
import 'package:dart_gol/cell.dart';
import 'package:dart_gol/init_forms.dart';

@Component(
  selector: 'grid-component',
  templateUrl: 'grid_component.html',
  styleUrls: const ['grid_component.css', 'header_component.css'],
  directives: const [NgClass],
)
class GridComponent implements OnInit {
  String gridDimension = "25";
  String generationsToRun = "1000";
  String secondsPerGeneration = ".1";
  int generationsPast = 1;
  bool go = false;

  String cellDimension = "15";
  String cellDimensionPx;
  int livingCells = 0;

  List columnsList;
  Map<String, Cell> lookupCells = {};


  GridComponent() {
    updateCellSize();
    generateList(Init.rPentomino);
  }

  Future<Null> generateList(Init state) async {
    // This reset all cells to dead currently
    livingCells = 0;

    // top to bottom
    // left to right
    columnsList = [];
    for (int c = 1; c <= int.parse(gridDimension); c++) {
      List<Cell> cellsList = [];
      for (int r = 1; r <= int.parse(gridDimension); r++) {
        // incrememt r and c by 1, for base 1 instead of 0.
        String id = "${r}x${c}";
        Cell cell = initState(id, state, int.parse(gridDimension));

        if (cell.alive) updateLiveCount(cell.alive);
        gridState = state;

        cellsList.add(cell);
        lookupCells.addAll({id: cell});
      }
      columnsList.add(cellsList);
    }
  }

  void stepForward() {
    verifyNeighbors();
    if (go) grow();
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

  /// Check surroundings for living neighbors.
  void verifyNeighbors() {
    for (List col in columnsList) {
      for (Cell cell in col) {
        findNeighbors(cell);
        cell.check();
      }
    }
  }

  void findNeighbors(Cell cell) {
    // Remember, indexes are set at base 1. Bring them back to base zero.
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

  /// Toggle the state (true/false) of the given cell.
  bool toggleState(bool state, String id) {
    lookupCells[id].alive = !state;
    updateLiveCount(!state);
    return !state;
  }

  Future<Null> ngOnInit() async {}

  void buttonStep() {
    go = true;
    stepForward();
    buttonStop();
  }

  void buttonStop() {
    go = false;
  }

  Future<Null> buttonRun() async {
    go = true;
    while (go) {
      // print("while(go) executed");
      await loop();
    }
  }

  Future<Null> loop() async {
    if (go) {
      if (generationsPast < int.parse(generationsToRun)) {
        return (await new Future.delayed(
            new Duration(seconds: num.parse(secondsPerGeneration)),
            stepForward));
      } else {
        go = false;
      }
    }
  }

  void updateGridSize() {
    generateList(gridState);
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

  void buttonRandom() {
    generateList(Init.randomBool);
    generationsPast = 0;
  }

  void buttonAllDead() {
    generateList(Init.allDead);
    generationsPast = 0;
  }

  void buttonAllAlive() {
    generateList(Init.allAlive);
    generationsPast = 0;
  }

  void buttonRandom8() {
    generateList(Init.random8);
    generationsPast = 0;
  }
}

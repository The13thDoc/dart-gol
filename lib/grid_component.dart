import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

import 'dart:async';
import 'package:dart_gol/cell.dart';
import 'package:dart_gol/rules.dart';
import 'package:dart_gol/init_forms.dart';

@Component(
  selector: 'grid-component',
  templateUrl: 'grid_component.html',
  styleUrls: const ['grid_component.css', 'header_component.css'],
  directives: const [NgClass],
)
class GridComponent {
  String color;
  String gridDimension = "30";
  String generationsToRun = "10000";
  String secondsPerGeneration = ".1";
  int generationsPast = 1;
  bool go = false;
  String ruleString;

  String cellDimension = "15";
  String cellDimensionPx;
  int livingCells = 0;

  List columnsList;
  Map<String, Cell> lookupCells;
  List<Cell> changingCells;

  GridComponent() {
    ruleString = getRuleString();
    updateCellSize();
    generateList(Init.glider);
  }

  Future<Null> generateList(Init state) async {
    generationsPast = 0;
    // This reset all cells to dead currently
    livingCells = 0;

    // top to bottom
    // left to right
    columnsList = [];
    lookupCells = {};
    for (int c = 1; c <= int.parse(gridDimension); c++) {
      List<Cell> cellsList = [];
      for (int r = 1; r <= int.parse(gridDimension); r++) {
        // incrememt r and c by 1, for base 1 instead of 0.
        String id = "${r}x${c}";
        Cell cell = initState(id, state, int.parse(gridDimension));

        if (cell.alive) updateLiveCount(cell.alive);
        gridState = state;

        cellsList.add(cell);
        lookupCells.putIfAbsent(id, () => cell);
        findNeighbors(cell);
      }
      columnsList.add(cellsList);
    }
    tempForm = [];
  }

  void stepForward() {
    verifyNeighbors();
    if (go) grow();
  }

  /// Check each cell for living neighbors and its next state.
  void verifyNeighbors() {
    changingCells = [];
    for (Cell cell in lookupCells.values) {
      if (cell.check()) changingCells.add(cell);
    }
  }

  /// Iterate throw the grid, advancing each cell's state.
  void grow() {
    for (Cell cell in changingCells) {
        updateLiveCount(cell.grow());
    }
    generationsPast++;
  }

  Future<Null> findNeighbors(Cell cell) async {
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
    while (angle <= 1.75) {
      int row = rotation[angle]["r"];
      int col = rotation[angle]["c"];

      if (lookupCells.containsKey("${row}x${col}")) {
        Cell neighbor = lookupCells["${row}x${col}"];
        cell.addNeighbor(neighbor);
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

  updateGridSize() => generateList(gridState);

  updateCellSize() => cellDimensionPx = "${cellDimension}px";

  void updateLiveCount(bool state) {
    if (state) {
      livingCells++;
    } else {
      livingCells--;
    }
  }

  buttonRandom() => generateList(Init.randomBool);

  buttonAllDead() => generateList(Init.allDead);

  buttonAllAlive() => generateList(Init.allAlive);

  buttonRandom8() => generateList(Init.random8);

  buttonGlider() => generateList(Init.glider);

  buttonRPentomino() => generateList(Init.rPentomino);

  String getRuleString() {
    switch (rule) {
      case Rule.TwoThree_Three:
        return "23/3";
        break;

      case Rule.Twothree_Three_Six:
        return "23/36";
        break;
    }
    return "";
  }

  buttonRule23_3() {
    rule = Rule.TwoThree_Three;
    ruleString = getRuleString();
  }

  buttonRule23_36() {
    rule = Rule.Twothree_Three_Six;
    ruleString = getRuleString();
  }
}

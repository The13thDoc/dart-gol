import 'package:angular2/core.dart';
import 'package:angular2/common.dart';

import 'dart:async';
import 'package:dart_gol/cell.dart';
import 'package:dart_gol/init_forms.dart';
import 'package:dart_gol/header_component.dart';
import 'package:dart_gol/forms_menu.dart';

@Component(
  selector: 'grid-component',
  templateUrl: 'grid_component.html',
  styleUrls: const ['grid_component.css', 'style.css'],
  directives: const [NgClass, FormsMenu],
  providers: const [],
)
class GridComponent {
  bool go = false;

  List columnsList;
  Map<String, Cell> lookupCells;
  List<Cell> changingCells;

  final HeaderComponent header;

  static final Map<HeaderComponent, GridComponent> _cache =
      <HeaderComponent, GridComponent>{};

  factory GridComponent(HeaderComponent header) {
    if (_cache.containsKey(header)) {
      return _cache[header];
    } else {
      final grid = new GridComponent._internal(header);
      _cache[header] = grid;
      return grid;
    }
  }

  GridComponent._internal(this.header);
  //
  // GridComponent(this.header) {
  //   print("GridComponent generated.");
  //   generateList(Init.rPentomino);
  // }

  Future<Null> generateListDefault() async {
    generateList(Init.glider);
  }

  Future<Null> generateList(Init state) async {
    print("generating grid: ${header.gridDimension}");
    gridState = state;
    header.generationsPast = 0;
    // This resets all cells to dead
    header.livingCells = 0;

    // top to bottom
    // left to right
    columnsList = [];
    lookupCells = {};
    for (int c = 1; c <= int.parse(header.gridDimension); c++) {
      List<Cell> cellsList = [];
      for (int r = 1; r <= int.parse(header.gridDimension); r++) {
        // incrememt r and c by 1, for base 1 instead of 0.
        String id = "${r}x${c}";
        Cell cell = initState(id, state, int.parse(header.gridDimension));

        if (cell.alive) header.updateLiveCount(cell.alive);

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
      header.updateLiveCount(cell.grow());
    }
    header.generationsPast++;
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
    header.updateLiveCount(!state);
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
      if (header.generationsPast < int.parse(header.generationsToRun)) {
        return (await new Future.delayed(
            new Duration(seconds: num.parse(header.secondsPerGeneration)),
            stepForward));
      } else {
        go = false;
      }
    }
  }

  buttonRandom() => generateList(Init.randomBool);

  buttonAllDead() => generateList(Init.allDead);

  buttonAllAlive() => generateList(Init.allAlive);

  buttonRandom8() => generateList(Init.random8);

  buttonGlider() => generateList(Init.glider);

  buttonRPentomino() => generateList(Init.rPentomino);
}

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

  List<List> columnsList;
  String cellDimension = "20";
  String cellDimensionPx;

  GridComponent() {
    cellDimensionPx = "${cellDimension}px";
    generateList();
  }

  Future<Null> generateList() async {
    // List<List> initGlider = [
    //   [0, 1, 0],
    //   [0, 0, 1],
    //   [1, 1, 1]
    // ];
    // top to bottom
    // left to right
    columnsList = [];
    int square = int.parse(gridDimension);
    for (int c = 0; c < square; c++) {
      List<Cell> cellsList = [];
      for (int r = 0; r < square; r++) {
        // incrememt r and c by 1, for base 1 instead of 0.
        String id = "${r+1}x${c+1}";
        cellsList.add(getDead(id));
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

  Future<Null> loop() async {
    // while (generationsPast <= generationsToRun && go) {
    run();
    // new Future.delayed(const Duration(seconds: 1), run);
    // }
  }

  void run() {
    for (List col in columnsList) {
      for (Cell cell in col) {
        findNeighbors(cell);
        cell.check();
      }
    }
    grow();
  }

  /// Iterate throw the grid, advancing each cell's state.
  void grow() {
    for (List col in columnsList) {
      for (Cell cell in col) {
        cell.grow();
      }
    }
    generationsPast++;
  }

  void findNeighbors(Cell cell) {
    // Remember, indexes are set at base 1. Bring them back to base zero.
    int r = cell.r - 1, c = cell.c - 1;
    Map rotation = {
      0: {'r': r, 'c': c + 1},
      0.25: {'r': r - 1, 'c': c + 1},
      0.5: {'r': r - 1, 'c': c},
      0.75: {'r': r - 1, 'c': c - 1},
      1: {'r': r, 'c': c - 1},
      1.25: {'r': r + 1, 'c': c - 1},
      1.5: {'r': r + 1, 'c': c},
      1.75: {'r': r + 1, 'c': c + 1},
    };
    num rotate = 0;
    while (rotate <= 1.75) {
      Cell neighbor;
      int row = rotation[rotate]['r'];
      int col = rotation[rotate]['c'];

      if (row >= 0 && col >= 0) {
        try {
          neighbor = columnsList[col][row];
        } catch (RangeError) {}
        if (neighbor != null) {
          if (neighbor.alive) {
            cell.neighbors.add(neighbor);
          }
        }
      }
      rotate += 0.25;
    }
  }

  void buttonRun() {
    go = true;
    run();
  }

  void buttonStop() {
    go = false;
  }

  /// Toggle the state (true/false) of the given cell.
  bool toggleState(bool state) {
    return !state;
  }

  void updateGridSize() {
    generateList();
  }

  void updateCellSize() {
    cellDimensionPx = "${cellDimension}px";
  }
}

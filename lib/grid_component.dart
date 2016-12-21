import 'package:angular2/core.dart';

import 'package:angular2/common.dart';

@Component(
  selector: 'grid-component',
  templateUrl: 'grid_component.html',
  styleUrls: const ['grid_component.css'],
  directives: const [NgClass],
)
class GridComponent {
  @Input()
  String gridDimension = "10";

  List<List> rowsList;

  @HostBinding('[class.cell]')
  String cellDimension = "20";
  String cellDimensionPx;

  GridComponent() {
    cellDimensionPx = "${cellDimension}px";;
    generateList();
  }

  void generateList() {
    List<List> initGlider = [
      [0, 1, 0],
      [0, 0, 1],
      [1, 1, 1]
    ];
    // top to bottom
    // left to right
    rowsList = [];
    int square = int.parse(gridDimension);
    for (int c = 0; c < square; c++) {
      List<List> cellsList = [];
      for (int r = 0; r < square; r++) {
        // incrememt r and c by 1, for base 1 instead of 0.
        String id = "${r+1}x${c+1}";
        try {
          if (initGlider[r][c] == 1) {
            cellsList.add(getAlive(id));
          } else {
            cellsList.add(getDead(id));
          }
        } catch (e) {
          cellsList.add(getDead(id));
        }
      }
      rowsList.add(cellsList);
    }
  }

  List getAlive(String id) {
    // alive = true;
    return [
      {'id': id, 'state': true}
    ];
  }

  List getDead(String id) {
    // alive = false;
    return [
      {'id': id, 'state': false}
    ];
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

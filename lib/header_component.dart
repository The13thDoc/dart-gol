import 'package:angular2/core.dart';
import 'package:dart_gol/rules.dart';
import 'package:dart_gol/init_forms.dart';
import 'package:angular2/common.dart';
import 'package:dart_gol/grid_component.dart';

@Component(
  selector: 'header-component',
  templateUrl: 'header_component.html',
  styleUrls: const ['header_component.css', 'style.css'],
  directives: const [NgModel, GridComponent],
  // providers: const [GridComponent],
)
class HeaderComponent {
  String gridDimension = "30";
  String generationsToRun = "10000";
  String secondsPerGeneration = ".1";
  int generationsPast = 1;
  int livingCells = 0;
  String cellDimension = "8";
  String cellDimensionPx;
  String ruleString;

  GridComponent grid;

  HeaderComponent() {
    print("HeaderComponent generated.");
    grid = new GridComponent(this);
    updateCellSize();
    getDefaultRule();
    grid.generateListDefault();
  }

  updateGridSize() {
    // print("Grid state: $gridState");
    grid.generateList(gridState);
  }

  updateCellSize() => cellDimensionPx = "${cellDimension}px";

  void updateLiveCount(bool state) {
    if (state) {
      livingCells++;
    } else {
      livingCells--;
    }
  }

  // TODO: Move this into rules.dart
  String getRuleString() {
    switch (rule) {
      case Rule.TwoThree_Three:
        return "23/3";
        break;

      case Rule.Twothree_ThreeSix:
        return "23/36";
        break;
    }
    return "";
  }

  getDefaultRule() => ruleString = getRuleString();

  buttonRule23_3() {
    rule = Rule.TwoThree_Three;
    ruleString = getRuleString();
  }

  buttonRule23_36() {
    rule = Rule.Twothree_ThreeSix;
    ruleString = getRuleString();
  }
}

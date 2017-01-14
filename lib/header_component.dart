library Header;

import 'package:angular2/core.dart';
import 'package:dart_gol/rules.dart';
import 'package:dart_gol/init_forms.dart';
import 'package:dart_gol/grid_component.dart';

@Component(
  selector: 'header-component',
  templateUrl: 'header_component.html',
  styleUrls: const ['header_component.css'],
  directives: const [],
  providers: const [],
)
class HeaderComponent {
  String gridDimension = "30";
  String generationsToRun = "10000";
  String secondsPerGeneration = ".1";
  int generationsPast = 1;
  int livingCells = 0;
  String cellDimension = "15";
  String cellDimensionPx;
  String ruleString;

  GridComponent grid;

  HeaderComponent() {
    grid = new GridComponent(this);
    updateCellSize();
    // grid.generateList(Init.glider);
  }

  updateGridSize() {
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

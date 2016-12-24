import 'package:angular2/core.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/angular2.dart';

import 'package:dart_gol/grid_component.dart';

@Component(
  selector: 'app-component',
  templateUrl: 'app_component.html',
  directives: const [GridComponent],
  styleUrls: const [],
)
class AppComponent {
  String conway = "Conway's";
  String title = "Game of Life";

  AppCmp(Location location) {
    location.go('/web');
  }
}

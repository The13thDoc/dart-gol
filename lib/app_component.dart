import 'package:angular2/core.dart';

import 'package:dart_gol/grid_component.dart';
import 'package:dart_gol/header_component.dart';

@Component(
  selector: 'app-component',
  templateUrl: 'app_component.html',
  directives: const [HeaderComponent, GridComponent],
  styleUrls: const [],
  providers: const [HeaderComponent],
)
class AppComponent {
  String conway = "Conway's";
  String title = "Game of Life";
}

import 'package:angular2/core.dart';

import 'package:dart_gol/header_component.dart';

@Component(
  selector: 'app-component',
  templateUrl: 'app_component.html',
  directives: const [HeaderComponent],
  styleUrls: const [],
)
class AppComponent {
  String conway = "Conway's";
  String title = "Game of Life";
}

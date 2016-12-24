import 'package:angular2/platform/browser.dart';
import 'package:angular2/platform/common.dart';
import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'package:dart_gol/app_component.dart';

class AppCmp {
  constructor(Location location) {
    location.go('/dart-gol/web/index.hml');
  }
}

void main() {
  bootstrap(AppComponent, [
    ROUTER_PROVIDERS,
    const Provider(LocationStrategy, useClass: HashLocationStrategy)
  ]);
}

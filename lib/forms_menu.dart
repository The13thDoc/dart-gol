import 'package:angular2/core.dart';

import 'package:dart_gol/init_forms.dart';

@Component(
  selector: 'forms-menu',
  templateUrl: 'forms_menu.html',
  styleUrls: const ['forms_menu.css'],
)
class FormsMenu {

List<Init> forms = Init.values;

bool isVisible = false;

void click(Init form) {
  print(form);
}

}

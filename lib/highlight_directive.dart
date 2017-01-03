library attribute_directives.highlight_directive;

import 'package:angular2/core.dart';

@Directive(selector: '[myHighlight]')
class HighlightDirective {
  final dynamic _el;

  HighlightDirective(ElementRef elRef) : _el = elRef.nativeElement;

  @Input('myHighlight')
  String highlightColor = 'orange';

  @HostListener('mouseenter')
  void onMouseEnter() => _highlight(highlightColor);

  @HostListener('mouseleave')
  void onMouseLeave() {
    _highlight();
  }

  void _highlight([String color]) {
    if (_el != null) _el.style.backgroundColor = color;
  }
}

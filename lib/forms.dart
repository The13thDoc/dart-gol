/// forms.dart is soley for the formations.

List initCell() {
  return [
      {'x': 1, 'y': 1, 'name': 'One cell'},
      {'state': 1, 'previous': 0, 'next': 0, 'neighbors': 0,},
    ];
}

List initGlider() {
  return [
    {'x': 3, 'y': 3, 'name': 'glider'},
    // row 1
    {'id': '0x1', 'state': 0, 'previous': 0, 'next': 0, 'neighbors': 0,},
    {'id': '0x2', 'state': 1, 'previous': 0, 'next': 0, 'neighbors': 0,},
    {'id': '0x3', 'state': 0, 'previous': 0, 'next': 0, 'neighbors': 0,},

    // row 2
    {'id': '1x1', 'state': 0, 'previous': 0, 'next': 0, 'neighbors': 0,},
    {'id': '1x2', 'state': 0, 'previous': 0, 'next': 0, 'neighbors': 0,},
    {'id': '1x3', 'state': 1, 'previous': 0, 'next': 0, 'neighbors': 0,},

    // row 3
    {'id': '3x1', 'state': 1, 'previous': 0, 'next': 0, 'neighbors': 0,},
    {'id': '3x2', 'state': 1, 'previous': 0, 'next': 0, 'neighbors': 0,},
    {'id': '3x3', 'state': 1, 'previous': 0, 'next': 0, 'neighbors': 0,},
  ];
}

List gliderForm() {
  return [
    [0,1,0],
    [0,0,1],
    [1,1,1]
  ];
}

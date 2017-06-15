/*
 * Rules to govern the life and death of a cell.
 *
 * The numerator states the integers that allow rebirth:
 *   [23]/3 => 2 and 3 neighbors bring a dead cell to life.
 *
 * The denominator states the integers that cause death:
 *   23/[3] => 3 neighbors kill a living cell.
 *
 * Standard: 23/3
 * High Life: 23/36
 *
 */
enum Rule {
  TwoThree_Three,
  Twothree_ThreeSix,
}

Rule rule = Rule.TwoThree_Three;

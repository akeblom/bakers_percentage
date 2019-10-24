import 'package:bakers_percentage/bread_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //setup

  var bread = BreadViewModel();
  bread.flour = 500;
  bread.hydrationPercentage = .82;
  bread.saltPercentage = .02;
  bread.levainPercentage = .3;
  test('Bakers percentage', () {
    // Build our app and trigger a frame.

    expect(bread.saltWeight, 12);
    expect(bread.levainWeight, 150);
    expect(bread.waterInAutolys, 397);
    expect(bread.waterInLevainGram, 75);
  });
}

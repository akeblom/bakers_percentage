class BreadViewModel {
  BreadViewModel()
      : hydrationPercentage = 0.5,
        flour = 350,
        waterPercentage = 0,
        saltPercentage = 0,
        levainPercentage = 0;

  double hydrationPercentage;
  double flour;
  double waterPercentage;
  double saltPercentage;
  double levainPercentage;

  double get totalFlourInclAutoly => (flour + flourInLevain);
  int get flourInLevain => ((flour * levainPercentage) / 2).round();
  int get waterInLevainGram => ((flour * levainPercentage) / 2).round();
  int get waterInAutolys =>
      ((totalFlourInclAutoly * hydrationPercentage) - waterInLevainGram)
          .round();
  int get saltWeight => (totalFlourInclAutoly * saltPercentage).round();
  int get levainWeight => (flour * levainPercentage).round();
}

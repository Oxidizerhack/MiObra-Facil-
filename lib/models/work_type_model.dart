class WorkType {
  final String id;
  final String description;
  final String unit;
  final Map<String, double> prices;

  WorkType({
    required this.id,
    required this.description,
    required this.unit,
    required this.prices,
  });
}

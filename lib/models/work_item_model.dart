import 'work_type_model.dart';

class WorkItem {
  final String category;
  final List<WorkType> items;

  WorkItem({
    required this.category,
    required this.items,
  });

  WorkItem copyWith({
    String? category,
    List<WorkType>? items,
  }) {
    return WorkItem(
      category: category ?? this.category,
      items: items ?? this.items,
    );
  }
}

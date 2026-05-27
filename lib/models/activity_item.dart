
/// Activity feed item for the timeline screen.
enum ActivityType {
  paymentSynced,
  logReconciled,
  paymentEntryCreated,
  customerAdded,
}

class ActivityItem {
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;

  const ActivityItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

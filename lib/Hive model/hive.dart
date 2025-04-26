import 'package:hive/hive.dart';

part 'hive.g.dart'; // This part is important for Hive to generate the necessary code for the model

@HiveType(typeId: 0)
class DailyPostureStat extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final Duration slouchTime;

  @HiveField(2)
  final double slouchPercentage;

  DailyPostureStat({
    required this.date,
    required this.slouchTime,
    required this.slouchPercentage,
  });
}

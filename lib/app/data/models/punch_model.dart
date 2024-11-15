import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'punch_model.g.dart';

@HiveType(typeId: 1)
class PunchModel extends HiveObject {

  @HiveField(0)
  String? id;  // Unique ID field
  

  @HiveField(1)
  String? imagePath;

  @HiveField(2)
  double? latitude;

  @HiveField(3)
  double? longitude;

  @HiveField(4)
  String? dateTime;

  @HiveField(5)
  bool? isSync ;

  @HiveField(6)
  bool isLoading;

  @HiveField(7)
  String? error;

  @HiveField(8)
  int? user_id;

  PunchModel({
   this.id,
   this.imagePath,
   this.latitude,
   this.longitude,
   this.dateTime,
   this.isSync,
   this.isLoading=false,
   this.error,
   this.user_id
  });

  // Factory method to create a new PunchModel with a unique ID
  factory PunchModel.create({
    String? imagePath,
    double? latitude,
    double? longitude,
    String? dateTime,
    bool? isSync,
    bool isLoading=false,
    String? error,
    int? user_id
  }) {
    return PunchModel(
      id: Uuid().v4(),  // Generates a unique ID
      imagePath: imagePath,
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
      isSync: isSync,
      isLoading: isLoading,
      error: error,
      user_id: user_id
    );
  }

}

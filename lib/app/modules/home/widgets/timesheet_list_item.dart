// modules/home/widgets/timesheet_list_item.dart
import 'package:flutter/material.dart';
import 'package:hrm_app/app/theme/app_colors.dart';

class TimesheetListItem extends StatelessWidget {
  final String date;
  final String duration;
  final String inOut;
  final bool sync;
  final bool isLoading;

  const TimesheetListItem(
      {required this.date,
      required this.duration,
      required this.inOut,
      required this.sync,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1),
        border: Border.all(
          color: Colors.grey, // Border color
          width: 1.0, // Border width
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date.substring(0, 9), style: AppColors.labelTextStyle),
              SizedBox(height: 4),
              Text(date.substring(11, 19), style: AppColors.subheadingStyle),
            ],
          ),
          isLoading
              ? CircularProgressIndicator()
              : CircleAvatar(
                  backgroundColor: sync ? Colors.green[300] : Colors.red[300],
                  radius: 10,
                ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/data/models/punch_model.dart';
import 'package:hrm_app/app/modules/punch/punch_controller.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/PunchAsyncData.dart';

class PunchList extends StatefulWidget {
  Key? key;
  final bool isLoadUnsync;

  PunchList({this.key, required this.isLoadUnsync}) : super(key: key);

  @override
  _PunchList createState() => _PunchList();
}
class _PunchList extends State<PunchList> with WidgetsBindingObserver {
  List asyncData = [];
  late Worker _punchListWorker;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    final PunchController punchController = Get.find<PunchController>();
    punchController.loadPunchData();

    // Manually update asyncData on initial load
    _updateAsyncData(punchController);

    // Observe changes to punchList
    _punchListWorker = ever(punchController.punchList, (_) {
      if (mounted) {
        _updateAsyncData(punchController);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _punchListWorker.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final PunchController punchController = Get.find<PunchController>();
      _updateAsyncData(punchController); // Refresh data on resume
    }
  }

  void _updateAsyncData(PunchController punchController) {
    setState(() {
      if (widget.isLoadUnsync) {
        asyncData = punchController.punchList
            .where((punch) => punch.isSync == false)
            .toList();
      } else {
        asyncData = punchController.punchList.toList();
      }
      print("Updated asyncData: $asyncData");
    });
  }

  @override
  Widget build(BuildContext context) {
    print("list --------- ${asyncData}");

    return Card(
      color: AppColors.secondary,
      shadowColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isLoadUnsync ? "Recents" : "Timesheet",
                  style: AppColors.subheadingStyle,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    BackgroundWorkDispatcher.SubmitPunchData();
                  },
                  icon: Icon(Icons.sync),
                  label: const Text("Sync"),
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(130, 30),
                    minimumSize: const Size(130, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(fontSize: 14),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (asyncData.isEmpty) Text("No unsync punches recorded."),
            Column(
              children: List.generate(
                widget.isLoadUnsync
                    ? asyncData.length > 5
                        ? 5
                        : asyncData.length
                    : asyncData.length,
                (i) => CardDetails(
                  details: asyncData[i],
                  index: i,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (widget.isLoadUnsync)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/punch-screen');
                      },
                      child: const Text(
                        "View all",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

class CardDetails extends StatelessWidget {
  final PunchModel details;
  final int index;

  CardDetails({required this.details, required this.index});

  @override
  Widget build(BuildContext context) {
    final PunchController punchController = Get.find<PunchController>();

    return Obx(() {
      bool isExpanded = punchController.expandedCardIndex.value == index;
      return GestureDetector(
        onTap: () {
          punchController.toggleCardExpansion(index);
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            details.dateTime!.substring(11, 19),
                            style: const TextStyle(
                              fontSize: kDefaultFontSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            details.dateTime!.substring(0, 10),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      if (details.error != null)
                        Text(
                          details.error ?? "",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  ),
                  Row(
                    children: [
                    details.isPunchin! ? 
                    Text("Punch-in",style: AppColors.linkTextStyle.copyWith(color: AppColors.green),)
                    :
                    Text("Punch-out",style: AppColors.linkTextStyle.copyWith(color: AppColors.red)),
                      
                      SizedBox(width: 5,),
                      details.isLoading
                          ? CircularProgressIndicator()
                          : CircleAvatar(
                              backgroundColor: details.isSync == true
                                  ? Colors.green[300]
                                  : Colors.red[300],
                              radius: 10,
                            ),
                      SizedBox(width: 10),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (isExpanded)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (details.imagePath != null)
                      Image.file(
                        File(details.imagePath!),
                        width: 80,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Latitude: ${details.latitude}",
                          style: const TextStyle(
                            fontSize: kDefaultFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Longitude: ${details.longitude}",
                          style: const TextStyle(
                            fontSize: kDefaultFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}

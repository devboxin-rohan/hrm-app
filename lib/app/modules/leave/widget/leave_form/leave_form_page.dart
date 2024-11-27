import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrm_app/app/modules/auth/auth_controller.dart';
import 'package:hrm_app/app/modules/leave/widget/leave_form/leave_form_controller.dart';
import 'package:hrm_app/app/theme/app_colors.dart';
import 'package:hrm_app/app/utils/notifications.dart';
import 'package:hrm_app/app/utils/widgets/AppBar.dart';
import 'package:hrm_app/app/utils/widgets/BottomNavigationBar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class LeaveFormPage extends StatefulWidget {
  @override
  _LeaveFormPage createState() => _LeaveFormPage();
}

class _LeaveFormPage extends State<LeaveFormPage> {
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();
  final TextEditingController leaveCategory = TextEditingController();
  final TextEditingController reason = TextEditingController();
   bool isHalfDay=false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> availableDates = [];
  List<String> selectedHalfDayDates = [];

  final List<Map<String, dynamic>> leaveCategoryOptions = [
    {"value": 0, "label": "Casual"},
    {"value": 1, "label": "Sick"},
    {"value": 2, "label": "Annual"}
  ];

  generatePayload()async{
    AuthController controller = Get.find<AuthController>();
     var response = await controller.getUserData();
    return { "leave_category_id": leaveCategory.text,
                "is_halfday": isHalfDay,
                "from_date": fromDate.text,
                "to_date": toDate.text,
                "status": "Pending",
                "reason": reason.text,
                "emp_id": response!.empId};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      appBar: CustomAppBar(),
      backgroundColor: AppColors.primary,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
          color: AppColors.secondary,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Attach Form Key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text("Request Time Off", style: AppColors.subheadingStyle),
                const SizedBox(height: 20),
                datePicker("From Date", fromDate),
                const SizedBox(height: 20),
                datePicker("To Date", toDate),
                const SizedBox(height: 20),
                HalfDayCheckbox(),
                const SizedBox(height: 20,),
                if(isHalfDay)
                multiSelectDropdown(),
                if(isHalfDay)
                const SizedBox(height: 20),
                DropdownComponent(context, "Leave Category",
                    leaveCategoryOptions, leaveCategory),
                const SizedBox(height: 20),
                CustomTextField("Reason", reason, 40),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      LeaveFormController controller = Get.find<LeaveFormController>();
                      controller.SubmitLeave(await generatePayload());
                    }
                  },
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  HalfDayCheckbox(){
    return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: Checkbox(
                  value: isHalfDay,
                  onChanged: (bool? value) {
                    setState(() {
                      isHalfDay = value ?? false;
                    });
                  },
                ),
              ),
              const Text(
                  'Is half days',
                  style: AppColors.labelTextStyle,
                ),
            ],
          );
  }

  CustomTextField(String label, TextEditingController controller, height) {
    return TextFormField(
      readOnly: false,
      decoration: InputDecoration(
        fillColor: AppColors.secondary,
        labelText: label,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        errorBorder: const OutlineInputBorder(
          // Add this
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          // Add this
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        counterText: "",
      ),
      controller: controller,
      onChanged: (text){controller.text=text; _formKey.currentState!.validate(); },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  datePicker(String label, TextEditingController controller) {
    return TextFormField(
      readOnly: false,
      decoration: InputDecoration(
        fillColor: AppColors.secondary,
        labelText: label,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        errorBorder: const OutlineInputBorder(
          // Add this
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          // Add this
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        counterText: "",
      ),
      controller: controller,
      onChanged: (text){_formKey.currentState!.validate(); },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          builder: (BuildContext context, Widget? child) {
            return buildTheme(context, child);
          },
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
        selectedHalfDayDates.clear();
        generateAvailableDates();
      },
    );
  }

  DropdownComponent(context, label, List options, controller) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: AppColors.secondary,
        labelText: label,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        errorBorder: const OutlineInputBorder(
          // Add this
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          // Add this
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        counterText: "",
      ),
      hint: Text(
        label,
        style: TextStyle(fontSize: 14),
      ),
      items: options
          .map((item) => DropdownMenuItem<String>(
                value: item["value"].toString(),
                child: Text(
                  item["label"],
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return "Please select $label";
        }
        return null;
      },
      onChanged: (value) {
        controller.text = value ?? "";
        _formKey.currentState!.validate();
      },
      value: controller.text.isNotEmpty ? controller.text : null,
    );
  }

  void generateAvailableDates() {
    if (fromDate.text.isEmpty || toDate.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select both From Date and To Date")),
      );
      return;
    }

    DateTime startDate = DateFormat('yyyy-MM-dd').parse(fromDate.text);
    DateTime endDate = DateFormat('yyyy-MM-dd').parse(toDate.text);

    if (startDate.isAfter(endDate)) {
      AlertNotification.error("Input Error", "Can't allow to select FromDate before ToDate");
      return;
    }

    availableDates.clear();
    for (DateTime date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      availableDates.add(DateFormat('yyyy-MM-dd').format(date));
    }

    setState(() {});
  }

  Widget multiSelectDropdown() {
    return GestureDetector(
      onTap: () => showMultiSelect(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          selectedHalfDayDates.isNotEmpty
              ? "Half-Day: ${selectedHalfDayDates.join(', ')}"
              : "Select Half-Day Leave Dates",
          style: TextStyle(
            color: selectedHalfDayDates.isNotEmpty ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  void showMultiSelect() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select Half-Day Leave Dates",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: availableDates.length,
                      itemBuilder: (BuildContext context, int index) {
                        String date = availableDates[index];
                        bool isSelected = selectedHalfDayDates.contains(date);
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (bool? checked) {
                            setModalState(() {
                              if (checked == true) {
                                selectedHalfDayDates.add(date);
                              } else {
                                selectedHalfDayDates.remove(date);
                              }
                            });
                            setState(() {});
                          },
                          title: Text(date),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Theme buildTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      child: child!,
    );
  }
}

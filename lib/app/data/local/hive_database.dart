import 'package:hive/hive.dart';
import 'package:hrm_app/app/data/models/punch_model.dart';
import 'package:hrm_app/app/data/models/user_model.dart';

class HiveDatabase {
  static const String employeeBoxName = "employeeBox";
    static const String userBoxName = "userBox";
    static const String punchBoxName="punchBox";


  // Open a box
  static Future<void> init() async {
    try {
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(PunchModelAdapter());

    await Hive.openBox<PunchModel>(punchBoxName);
    await Hive.openBox<UserModel>(userBoxName);
  } catch (e) {
    print("Error initializing Hive: ------------------ ${e}");
  }

  }

  // static Box<Employee> get employeeBox => Hive.box<Employee>(employeeBoxName);

  // // Add an employee
  // static Future<void> addEmployee(Employee employee) async {
  //   await employeeBox.add(employee);
  // }

  // // Fetch all employees
  // static List<Employee> getEmployees() {
  //   return employeeBox.values.toList();
  // }
}

import 'package:get/get.dart';
import '/controllers/diet_controller.dart';
import '/controllers/trainee_controller.dart';

import 'controllers/coach_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/workout_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class CoachBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<CoachController>(CoachController());
  }
}

class TraineeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TraineeController());
    Get.lazyPut(() => DietController());
    Get.lazyPut(() => WorkoutController());
  }
}

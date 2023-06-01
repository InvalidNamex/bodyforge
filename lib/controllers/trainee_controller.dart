import 'package:get/get.dart';
import '/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trainee_model.dart';

class TraineeController extends GetxController {
  static TraineeController instance = Get.find();
  final supabase = Supabase.instance.client;
  RxBool traineeLoaded = false.obs;
  TraineeModel? trainee;
  bool isCoach = false;

  Future getTrainee() async {
    final param = Get.parameters['client'];
    final _x =
        await supabase.from('trainee').select().eq('id', int.parse(param!));
    trainee = TraineeModel.fromJson(_x[0]);
    await coachController.getCoachByID(trainee!.coachID);
    await dietController.populateMealsList();
    await workoutController.populateWorkoutsList();
    traineeLoaded(true);
  }

  Future initiateClientScreen() async {
    final param = Get.parameters['client'];
    await supabase
        .from('trainee')
        .select()
        .eq('id', int.parse(param!))
        .then((_x) => trainee = TraineeModel.fromJson(_x[0]));
    await coachController.getCoachByID(trainee!.coachID);
    traineeLoaded(true);
  }
}

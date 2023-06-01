import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../models/exercise_model.dart';
import '../models/trainee_model.dart';
import '../models/workout_model.dart';

class WorkoutController extends GetxController {
  static WorkoutController instance = Get.find();
  final supabase = Supabase.instance.client;
  final addWorkoutKey = GlobalKey<FormState>();
  final editWorkoutKey = GlobalKey<FormState>();
  final workoutTitle = TextEditingController();
  final workoutDesc = TextEditingController();
  final workoutUrl = TextEditingController();
  final TraineeModel? trainee = traineeController.trainee;
  RxList<WorkoutModel> workoutsList = RxList<WorkoutModel>([]);
  RxList<ExerciseModel> exercisesList = RxList<ExerciseModel>([]);
  Future addWorkout({
    required int day,
    required String title,
    required String desc,
    required String url,
    required int trainee,
    required int order,
  }) async {
    final workout = WorkoutModel(
            coach: coachController.coach!.coachID,
            day: day,
            exerciseOrder: order,
            title: title,
            desc: desc,
            trainee: trainee,
            url: url)
        .toJson();
    await supabase.from('workout').insert(workout);
    await populateWorkoutsList();
  }

  Future populateWorkoutsList() async {
    workoutsList.clear();
    List _x = await supabase
        .from('workout')
        .select()
        .filter('trainee', 'eq', trainee!.traineeID)
        .order('exerciseOrder', ascending: true);
    for (var workout in _x) {
      workoutsList.add(WorkoutModel.fromJson(workout));
    }
  }

  Future<void> deleteExercise(int id) async {
    await supabase.from('workout').delete().eq('id', id);
    workoutsList.clear();
    await populateWorkoutsList();
  }

  Future<void> updateWorkout({
    required int id,
    required int day,
    required int exerciseOrder,
    required String title,
    required String desc,
    required String url,
  }) async {
    Map<String, dynamic> _workout = WorkoutModel(
      coach: trainee!.coachID,
      trainee: trainee!.traineeID!,
      day: day,
      exerciseOrder: exerciseOrder,
      title: title,
      desc: desc,
      url: url,
    ).toJson();
    await supabase.from('workout').update(_workout).eq('id', id);
    workoutsList.clear();
    await populateWorkoutsList();
  }

  Future<void> deleteWorkoutPlan() async {
    await supabase.from('workout').delete().eq('trainee', trainee!.traineeID);
    workoutsList.clear();
    await populateWorkoutsList();
  }

  Future<void> getExercisesByMuscleGroup(String? muscleGroup) async {
    exercisesList.clear();
    List _x =
        await supabase.from('exercises').select().eq('category', muscleGroup);
    for (var exercise in _x) {
      exercisesList.add(ExerciseModel.fromJson(exercise));
    }
  }
}

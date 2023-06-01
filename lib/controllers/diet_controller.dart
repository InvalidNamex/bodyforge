import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../models/diet_model.dart';
import '../models/trainee_model.dart';

class DietController extends GetxController {
  static DietController instance = Get.find();
  final supabase = Supabase.instance.client;
  final addMealKey = GlobalKey<FormState>();
  final editMealKey = GlobalKey<FormState>();
  final mealTitle = TextEditingController();
  final mealDesc = TextEditingController();
  final TraineeModel? trainee = traineeController.trainee;
  RxList<DietModel> mealsList = RxList<DietModel>([]);
  Future addMeal(
      {required int day,
      required String title,
      required String desc,
      required int trainee,
      required int order}) async {
    final meal = DietModel(
            coach: coachController.coach!.coachID,
            day: day,
            mealOrder: order,
            title: title,
            desc: desc,
            trainee: trainee)
        .toJson();
    await supabase.from('diet').insert(meal);
    await populateMealsList();
  }

  Future populateMealsList() async {
    String? id = Get.parameters['client'];
    mealsList.clear();
    List _x = await supabase
        .from('diet')
        .select()
        .filter('trainee', 'eq', trainee!.traineeID ?? int.parse(id!))
        .order('mealOrder', ascending: true);
    for (var meal in _x) {
      mealsList.add(DietModel.fromJson(meal));
    }
  }

  Future<void> deleteMeal(int id) async {
    await supabase.from('diet').delete().eq('id', id);
    mealsList.clear();
    await populateMealsList();
  }

  Future<void> updateMeal(
      {required int id,
      required int day,
      required int mealOrder,
      required String title,
      required String desc}) async {
    Map<String, dynamic> _meal = DietModel(
            coach: trainee!.coachID,
            trainee: trainee!.traineeID!,
            day: day,
            mealOrder: mealOrder,
            title: title,
            desc: desc)
        .toJson();
    await supabase.from('diet').update(_meal).eq('id', id);
    mealsList.clear();
    await populateMealsList();
  }

  Future<void> deleteDiet() async {
    await supabase.from('diet').delete().eq('trainee', trainee!.traineeID);
    mealsList.clear();
    await populateMealsList();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifit/models/pricing_model.dart';
import 'package:ifit/models/transformation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/coach_model.dart';
import '../models/trainee_model.dart';

class CoachController extends GetxController {
  static CoachController instance = Get.find();
  final supabase = Supabase.instance.client;
  RxList<TraineeModel> traineeList = RxList<TraineeModel>([]);
  final RxBool isLoading = true.obs;
  CoachModel? coach;
  TextEditingController coachPassword = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController clientGoal = TextEditingController();
  TextEditingController clientJoinDate = TextEditingController();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  RxList<CoachModel> coachesList = RxList<CoachModel>([]);
  RxList<TransformationModel> transList = RxList<TransformationModel>([]);
  RxList<PricingModel> pricingList = RxList<PricingModel>([]);
  final newClientFormKey = GlobalKey<FormState>();
  final changePasswordFormKey = GlobalKey<FormState>();
  // plan
  final addPlanFormKey = GlobalKey<FormState>();
  final addTransformationFormKey = GlobalKey<FormState>();
  TextEditingController planName = TextEditingController();
  TextEditingController planTitle = TextEditingController();
  TextEditingController planText = TextEditingController();
  TextEditingController planPrice = TextEditingController();
  TextEditingController planImage = TextEditingController();
  // trans
  TextEditingController transName = TextEditingController();
  TextEditingController transBefore = TextEditingController();
  TextEditingController transAfter = TextEditingController();

  Rx<DateTime> joinDate = DateTime.now().obs;

  Future getTransformations(int id) async {
    transList.clear();
    final data =
        await supabase.from('transformation').select().eq('coach-id', id);
    for (var trans in data) {
      transList.add(TransformationModel.fromJson(trans));
    }
  }

  Future getPricePlans(int id) async {
    pricingList.clear();
    final data = await supabase.from('price-plans').select().eq('coach-id', id);
    for (var plan in data) {
      pricingList.add(PricingModel.fromJson(plan));
    }
  }

  Future getTrainees() async {
    traineeList.clear();
    final data =
        await supabase.from('trainee').select().eq('coach', coach!.coachID);
    for (var trainee in data) {
      traineeList.add(TraineeModel.fromJson(trainee));
    }
  }

  Future getCoaches() async {
    coachesList.clear();
    final data =
        await supabase.from('coaches').select().eq('coach_isVisible', true);
    for (Map<String, dynamic> coach in data) {
      coachesList.add(CoachModel.fromJson(coach));
    }
  }

  Future getCoachByID(int? id) async {
    final _x = await supabase.from('coaches').select().eq('id', id);
    coach = CoachModel.fromJson(_x.first);
    await getTrainees().whenComplete(() => isLoading(false));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: joinDate.value,
        firstDate: DateTime(2010),
        lastDate: DateTime.now());
    if (picked != null && picked != joinDate.value) {
      joinDate.value = picked;
    }
  }

  void validatePassword() async {
    isLoading(true);
    String? _id = Get.parameters['id'];
    if (_id != null) {
      final List _x = await supabase
          .from('coaches')
          .select()
          .eq('coach_password', coachPassword.text)
          .eq('id', int.parse(_id));
      if (_x.isNotEmpty) {
        coach = CoachModel.fromJson(_x[0]);
        final SharedPreferences pref = await prefs;
        await pref.setInt('id', int.parse(_id));
        await getTrainees();
        isLoading(false);
        Get.toNamed('/coach-zone');
      } else {
        isLoading(false);
        Get.defaultDialog(
            backgroundColor: Colors.red,
            title: 'incorrect password',
            content: Text(
              'Check the password you entered and try again',
              style: GoogleFonts.aclonica(),
            ));
        return;
      }
    }
  }

  Future addTrainee(
      String traineeName, String traineeGoal, String traineeJoinDate) async {
    final trainee = TraineeModel(
            coachID: coach!.coachID,
            traineeName: traineeName,
            traineeGoal: traineeGoal,
            traineeJoinDate: traineeJoinDate)
        .toJson();
    await supabase
        .from('trainee')
        .insert(trainee)
        .whenComplete(() async => await getTrainees());
  }

  Future getCoach() async {
    final param = Get.parameters['id'] ?? '';
    if (param != '') {
      isLoading(true);
      final _x =
          await supabase.from('coaches').select().eq('id', int.parse(param));
      coach = CoachModel.fromJson(_x.first);
    }
    isLoading(false);
  }

  Future populateCoach() async {
    final SharedPreferences pref = await prefs;
    final int? id = pref.getInt('id');
    if (id != null) {
      await getCoachByID(id);
      await getPricePlans(id);
      await getTransformations(id);
    } else {
      Get.offNamed('/');
    }
  }

  Future checkCoach() async {
    await getCoach();
    final SharedPreferences pref = await prefs;
    final int? id = pref.getInt('id');
    if (id != null) {
      await getCoachByID(id);
      Get.offNamed('/coach-zone');
    }
  }

  Future<void> addPlan(planName, planTitle, planText, planPrice) async {
    await supabase.from('price-plans').insert(PricingModel(
        coachID: coach!.coachID,
        planName: planName,
        planTitle: planTitle,
        planText: planText,
        planPrice: planPrice));
  }

  Future<void> deletePlan(int id) async {
    await supabase.from('price-plans').delete().eq('id', id);
    pricingList.clear();
    await getPricePlans(coach!.coachID);
  }

  Future<void> deleteTrans(int id) async {
    await supabase.from('transformation').delete().eq('id', id);
    transList.clear();
    await getTransformations(coach!.coachID);
  }
}

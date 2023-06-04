import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/coach_image_picker.dart';
import '/controllers/coach_controller.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class CoachCPanel extends GetView<CoachController> {
  const CoachCPanel({super.key});

  @override
  Widget build(BuildContext context) {
    controller.populateCoach();
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/coach-zone');
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: SpinKitPumpingHeart(
                    color: Colors.red,
                  ),
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth > pageWidth) {
                      return Center(
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: pageWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: buildContent(context, controller),
                        ),
                      );
                    } else {
                      return buildContent(context, controller);
                    }
                  },
                ),
        ),
      ),
    );
  }
}

Widget buildContent(context, CoachController controller) => Container(
      alignment: Alignment.topCenter,
      constraints: BoxConstraints(maxWidth: pageWidth),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(controller.coach!.coachImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.black.withOpacity(0.8),
            title: Text('Control Panel',
                style: GoogleFonts.aclonica(color: Colors.white)),
            centerTitle: true,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red),
                      color: Colors.black.withOpacity(0.9)),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Change Picture',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: imagePicker(
                      url: controller.coach!.coachImage,
                      buttonText: 'Choose Image',
                      imageBucket: 'coach_image',
                      dataTable: 'coaches',
                      column: 'id',
                      value: controller.coach!.coachID.toString(),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red),
                      color: Colors.black.withOpacity(0.9)),
                  child: ListTile(
                    leading: const Icon(
                      Icons.password,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Change Password',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Get.defaultDialog(
                          backgroundColor: Colors.black.withOpacity(0.9),
                          title: 'Change Password',
                          titleStyle: const TextStyle(color: Colors.white),
                          content: Form(
                            key: controller.changePasswordFormKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  autofocus: true,
                                  onEditingComplete: () =>
                                      controller.validatePassword(),
                                  obscureText: true,
                                  controller: controller.coachPassword,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                    ),
                                    hintText: 'Enter password',
                                    hintStyle: TextStyle(color: Colors.white),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.red)),
                                  onPressed: () async {
                                    final supabase = Supabase.instance.client;
                                    await supabase.from('coaches').update({
                                      'coach_password':
                                          controller.coachPassword.text
                                    }).eq('id', controller.coach!.coachID);
                                    Get.back();
                                  },
                                  child: const Text('Save Password'),
                                )
                              ],
                            ),
                          ));
                    },
                  ),
                ),
                managePlans(controller, context),
                manageTransformations(controller, context)
              ],
            ),
          ),
        ],
      ),
    );

Widget managePlans(CoachController controller, context) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red),
        color: Colors.black.withOpacity(0.9)),
    child: ExpansionTile(
      iconColor: Colors.red,
      collapsedIconColor: Colors.white,
      collapsedTextColor: Colors.white,
      leading: IconButton(
          onPressed: () => Get.toNamed('/add-plan'),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      title: Text(
        'Plans & Offers',
        style: GoogleFonts.aclonica(color: Colors.white),
      ),
      children: <Widget>[
        Obx(
          () => controller.pricingList.isEmpty
              ? const SpinKitPumpingHeart(
                  color: Colors.red,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.pricingList
                      .where((item) => item.planName != null)
                      .toList()
                      .length,
                  itemBuilder: (context, index) => ListTile(
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await controller.deletePlan(controller.pricingList
                            .where((item) => item.planName != null)
                            .toList()[index]
                            .planID!);
                      },
                    ),
                    title: Text(
                      controller.pricingList
                          .where((item) => item.planName != null)
                          .toList()[index]
                          .planName!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.pricingList.where((item) => item.planName != null).toList()[index].planTitle}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            'Price: ${controller.pricingList.where((item) => item.planName != null).toList()[index].planPrice}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}

Widget manageTransformations(CoachController controller, context) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red),
        color: Colors.black.withOpacity(0.9)),
    child: ExpansionTile(
      iconColor: Colors.red,
      collapsedIconColor: Colors.white,
      collapsedTextColor: Colors.white,
      leading: IconButton(
          onPressed: () => Get.toNamed('/add-transformation'),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      title: Text(
        'Transformations',
        style: GoogleFonts.aclonica(color: Colors.white),
      ),
      children: <Widget>[
        Obx(
          () => controller.transList.isEmpty
              ? const SpinKitPumpingHeart(
                  color: Colors.red,
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.transList.length,
                  itemBuilder: (context, index) => ListTile(
                    trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await controller.deleteTrans(
                              controller.transList[index].transformationID);
                        }),
                    title: Text(
                      '${controller.transList[index].name}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}

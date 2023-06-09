import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/screens/coach_screens/coach_login.dart';
import '/screens/coach_screens/coach_signup.dart';
import '/screens/splash_screen.dart';
import '/screens/pricing.dart';
import '/widgets/add_transformation.dart';
import '/screens/coach_screens/coach_cpanel_screen.dart';
import '/widgets/add_price_plan.dart';
import '/screens/coach_screens/coach_landing_screen.dart';
import '/screens/coach_screens/coaches_screen.dart';
import '/screens/trainee_screens/trainee_screen.dart';
import '/screens/coach_screens/coach_home.dart';
import '/screens/not_found.dart';
import '/screens/trainee_screens/workout_screen.dart';
import 'constants.dart';
import 'screens/trainee_screens/diet_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '/screens/coach_screens/coach_login_with_user.dart';
import '/screens/home_screen.dart';
import 'bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANNON_KEY']!);
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BodyForge',
      initialRoute: '/',
      enableLog: true,
      unknownRoute: GetPage(name: '/404', page: () => const NotFound()),
      logWriterCallback: (text, {isError = false}) {
        if (isError) {
          Get.defaultDialog(
              backgroundColor: darkColor,
              titleStyle: TextStyle(color: accentColor),
              title: 'Error',
              content: Text(
                text,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: lightColor),
              ));
        } else {}
      },
      fallbackLocale: const Locale('en', 'US'),
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => const NotFound(),
        );
      },
      getPages: [
        GetPage(
          name: '/404',
          page: () => const NotFound(),
        ),
        GetPage(
            name: '/',
            page: () => const SplashScreen(),
            binding: HomeBinding(),
            transition: Transition.zoom,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/index',
            page: () => const HomeScreen(),
            binding: HomeBinding(),
            transition: Transition.leftToRight,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/pricing',
            page: () => const PricingScreen(),
            binding: PaymentBinding(),
            transition: Transition.leftToRight,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/coach',
            page: () => const CoachLandingScreen(),
            binding: CoachBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/coach-cpanel',
            page: () => const CoachCPanel(),
            binding: CoachBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/coaches',
            page: () => const CoachesScreen(),
            binding: CoachBinding(),
            transition: Transition.leftToRight,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/coach-login',
            page: () => const CoachLogin(),
            binding: CoachBinding(),
            transition: Transition.upToDown,
            preventDuplicates: true,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/coach-login/:id',
            page: () => const CoachLoginWithUser(),
            binding: CoachBinding(),
            transition: Transition.upToDown,
            preventDuplicates: true,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/coach-signup',
            page: () => const CoachSignUp(),
            binding: CoachAuthBinding(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/coach-zone',
            page: () => const CoachHome(),
            binding: CoachBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/add-plan',
            page: () => const PricePlan(),
            binding: CoachBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/add-transformation',
            page: () => const TransformationManagement(),
            binding: CoachBinding(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/client',
            page: () => const ClientScreen(),
            binding: TraineeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/diet',
            page: () => const DietScreen(),
            binding: TraineeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/workout',
            page: () => const WorkoutScreen(),
            binding: TraineeBinding(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 200)),
      ],
    );
  }
}

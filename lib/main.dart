import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:ifit/widgets/add_transformation.dart';
import '/screens/coach_screens/coach_cpanel_screen.dart';
import '/widgets/add_price_plan.dart';
import '/screens/coach_screens/coach_landing_screen.dart';
import '/screens/coach_screens/coaches_screen.dart';
import '/screens/trainee_screens/trainee_screen.dart';
import '/screens/coach_screens/coach_home.dart';
import '/screens/not_found.dart';
import '/screens/trainee_screens/workout_screen.dart';
import 'screens/trainee_screens/diet_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import '/screens/coach_screens/coach_login.dart';
import '/screens/home_screen.dart';
import 'bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANNON_KEY']!);
  usePathUrlStrategy();
  runApp(MyApp());
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
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BodyForge',
      initialRoute: '/',
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
            name: '/',
            page: () => const HomeScreen(),
            binding: HomeBinding(),
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

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mypocket/app/Utils/app_preferences.dart';
import 'package:mypocket/app/Utils/firebase_options.dart';
import 'package:mypocket/app/routes/app_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.initPref();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(boldText: false, textScaler: const TextScaler.linear(1)),
      child: GetMaterialApp(
        title: 'My Pocket',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        initialRoute: AppRoutes.splashScreen,
        getPages: AppRoutes.routes,
      ),
    );
  }
}

class NameController extends GetxController {
  List<String> namesList = [
    "India",
    "Pakistan",
    "USA",
    "Canada",
    "Australia",
  ];

  List<IconData> iconList = [
    Icons.home,
    Icons.local_activity,
    Icons.face,
    Icons.media_bluetooth_off,
    Icons.real_estate_agent_outlined
  ];

  String displayedName = "";
  int index = 0;
  int currentIndex = 0;
  bool isRemoving = false;
  bool showCursor = false;
  Timer? timer1;
  Timer? timer2;
  updateCursor(value) {
    showCursor = value;
  }

  updateIndex() {
    if (namesList.length == index + 1) {
      index = 0;
    } else {
      index = index + 1;
    }
    update();
    startAnimation();
  }

  void startAnimation() {
    timer1 = Timer.periodic(
      const Duration(milliseconds: 100),
          (timer) async {
        if (!isRemoving) {
          updateCursor(true);
          if (currentIndex < namesList[index].length) {
            displayedName += namesList[index][currentIndex];
            currentIndex++;
            update();
          } else {
            timer.cancel();
            await Future.delayed(const Duration(milliseconds: 500)).then(
                  (value) {
                updateCursor(false);
                isRemoving = true;
                startRemoving();
              },
            );
          }
        }
      },
    );
  }

  void startRemoving() {
    updateCursor(true);
    timer2 = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      if (currentIndex > 0) {
        displayedName = displayedName.substring(0, displayedName.length - 1);
        currentIndex--;
        update();
      } else {
        timer.cancel();
        updateCursor(false);
        isRemoving = false;
        timer1!.cancel();
        timer2!.cancel();
        updateIndex();
        update();
      }
    });
  }
}

class NameAnimationScreen extends StatefulWidget {
  const NameAnimationScreen({super.key});

  @override
  State<NameAnimationScreen> createState() => _NameAnimationScreenState();
}

class _NameAnimationScreenState extends State<NameAnimationScreen> {
  NameController nameController = Get.put(NameController());
  @override
  void initState() {
    super.initState();
    nameController.startAnimation();
  }

  @override
  void dispose() {
    nameController.timer1?.cancel();
    nameController.timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NameController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Name Animation'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 5,
                      child: Icon(controller.iconList[controller.index],
                          color: Colors.red, size: 75)),
                  Expanded(
                    flex: 8,
                    child: Row(
                      children: [
                        Text(
                          controller.displayedName,
                          style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        if (controller.showCursor)
                          Container(
                            height: 70,
                            width: 1,
                            color: Colors.red,
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

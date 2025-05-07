import 'package:booknest/Views/Pages/Home/user_not_login_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'Views/common widget/common_method.dart';


//main function entryu point
void main() async {
  Widget initialScreen;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    initialScreen = await Check_Jwt_Token_Start_Screen();
  } catch (obj) {
    print("Exception caught in main.dart while checking jwttoken");
    print(obj.toString());
    await clearUserData();
    print("Deleteing temporary directory success.");
    initialScreen = UserNotLoginHomeScreen();
  }
  //initial screen
  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: initialScreen,
    );
  }
}

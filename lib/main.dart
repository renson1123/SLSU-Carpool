import 'package:capstone_project_carpool/appinfo/app_info.dart';
import 'package:capstone_project_carpool/authentication/login_screen.dart';
import 'package:capstone_project_carpool/authentication/signup_screen.dart';
import 'package:capstone_project_carpool/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission)
  {
    if(valueOfPermission )
      {
        Permission.locationWhenInUse.request();
      }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'TRAMP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : HomePage(),
      ),
    );
  }
}

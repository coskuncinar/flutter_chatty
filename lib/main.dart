import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import 'viewmodel/cubit/user_view_cubit.dart';
import 'firebase_options.dart';
import 'locator.dart';
import 'pages/landing_page.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserViewCubit>(
      lazy: false,
      create: (_) => UserViewCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Chatty",
        theme: ThemeData(
          //colorScheme: defaultColorScheme,
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          //brightness: Brightness.dark,
        ),
        home: const LandingPage(),
      ),
    );
  }
}

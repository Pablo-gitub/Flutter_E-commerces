import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:store_app/controllers/category_controller.dart';
import 'package:store_app/views/screens/authentication_screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'your apikey web',
            appId: 'your appid web',
            messagingSenderId: 'your messagingSenderId',
            projectId: 'your projectId',
            storageBucket: 'your storageBucket',
          ),
        )
      : await Firebase.initializeApp();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: [
      'en',
      'it',
      'zh',
    ],
  );

  runApp(
    LocalizedApp(delegate, const ProviderScope(child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        localizationDelegate
      ],
      supportedLocales: localizationDelegate.supportedLocales,
      locale: localizationDelegate.currentLocale,
      home: LoginScreen(),
      initialBinding: BindingsBuilder(
        () {
          Get.put<CategoryController>(CategoryController());
        },
      ),
    );
  }
}

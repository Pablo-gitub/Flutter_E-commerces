import 'package:base_ecommerce/provider/cart_provider.dart';
import 'package:base_ecommerce/provider/product_provider.dart';
import 'package:base_ecommerce/views/buyers/auth/login_screen.dart';
// import 'package:base_ecommerce/vendor/views/auth/vendor_auth_screen.dart';
// import 'package:base_ecommerce/vendor/views/screens/main_vendor_screen.dart';
// import 'package:base_ecommerce/views/buyers/auth/login_screen.dart';
// import 'package:base_ecommerce/views/buyers/auth/register_screen.dart';
import 'package:base_ecommerce/views/buyers/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
//import 'package:base_ecommerce/views/buyers/main_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) {
      return ProductProvider();
    }),
    ChangeNotifierProvider(create: (_) {
      return CartProvider();
    })
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Brand-Bold',
      ),
      home: LoginScreen(),
      builder: EasyLoading.init(),
    );
  }
}

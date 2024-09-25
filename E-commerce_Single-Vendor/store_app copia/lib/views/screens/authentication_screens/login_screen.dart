import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/controllers/auth_controller.dart';
import 'package:store_app/views/screens/authentication_screens/register_screen.dart';
import 'package:store_app/views/screens/main_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  bool _isLoading = false;
  bool _isObscure = true;

  late String email;
  late String password;

  loginUser() async {
    BuildContext localContext = context;
    setState(() {
      _isLoading = true;
    });
    String res = await _authController.loginUser(email, password);
    if (res == 'success') {
      Future.delayed(Duration.zero, () {
        Navigator.push(localContext, MaterialPageRoute(builder: (context) {
          return const MainScreen();
        }));
        //we want to show a message to the user to tell them they have logged in
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(translate('Logged in'))));
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row for language selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/uk_flag.png',
                          width: 30,
                          height: 20,
                          fit: BoxFit.cover,
                          semanticLabel: translate('en'),
                        ),
                        onPressed: () => changeLocale(context, 'en'),
                        tooltip: translate('en'),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/it_flag.png',
                          width: 30,
                          height: 20,
                          fit: BoxFit.cover,
                          semanticLabel: translate('it'),
                        ),
                        onPressed: () => changeLocale(context, 'it'),
                        tooltip: translate('it'),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/cn_flag.png',
                          width: 30,
                          height: 20,
                          fit: BoxFit.cover,
                          semanticLabel: translate('zh'),
                        ),
                        onPressed: () => changeLocale(context, 'zh'),
                        tooltip: translate('zh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    translate("Login Your Account"),
                    style: GoogleFonts.getFont(
                      'Lato',
                      color: const Color(0xFF0d120E),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                      fontSize: 23,
                    ),
                  ),
                  Text(
                    translate("To Explore The World Exclusives"),
                    style: GoogleFonts.getFont(
                      'Lato',
                      color: const Color(0xFF0d120E),
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                  ExcludeSemantics(
                    child: Image.asset(
                      'assets/images/Illustration.png',
                      width: 200,
                      height: 200,
                      semanticLabel: translate("Login illustration"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      translate('Email'),
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Semantics(
                    label: translate('Email'),
                    child: TextFormField(
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return translate('enter your email');
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                        ),
                        enabledBorder: InputBorder.none,
                        labelText: translate('enter your email'),
                        labelStyle: GoogleFonts.getFont(
                          "Nunito Sans",
                          fontSize: 14,
                          letterSpacing: 0.1,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/icons/email.png',
                            width: 20,
                            height: 20,
                            semanticLabel: translate("Email icon"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      translate('Password'),
                      style: GoogleFonts.getFont(
                        'Nunito Sans',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Semantics(
                    label: translate('Password'),
                    child: TextFormField(
                      obscureText: _isObscure,
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return translate('enter your password');
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        labelText: translate('enter your password'),
                        labelStyle: GoogleFonts.getFont(
                          "Nunito Sans",
                          fontSize: 14,
                          letterSpacing: 0.1,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/icons/password.png',
                            width: 20,
                            height: 20,
                            semanticLabel: translate("Password icon"),
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            semanticLabel: _isObscure
                                ? translate('Show password')
                                : translate('Hide password'),
                          ),
                          tooltip: _isObscure
                              ? translate('Show password')
                              : translate('Hide password'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      } else {
                        print('failed');
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 319,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF102DE1),
                            Color(0xCC0D6EFF),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 278,
                            top: 19,
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                width: 60,
                                height: 60,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 12,
                                    color: const Color(0xFF103DE5),
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -20,
                            top: -18,
                            child: Opacity(
                              opacity: 0.5,
                              child: Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 12,
                                    color: const Color.fromARGB(
                                        255, 145, 162, 223),
                                  ),
                                  color: const Color(0xFF103DE5),
                                  borderRadius: BorderRadius.circular(400),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 311,
                            top: 36,
                            child: Opacity(
                              opacity: 0.3,
                              child: Container(
                                width: 5,
                                height: 5,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 281,
                            top: -10,
                            child: Opacity(
                              opacity: 0.3,
                              child: Container(
                                width: 20,
                                height: 20,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    translate('Sign in'),
                                    style: GoogleFonts.getFont(
                                      'Lato',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        translate('Need an Account? '),
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return RegisterScreen();
                            }),
                          );
                        },
                        child: Text(
                          translate('Sign up'),
                          style: GoogleFonts.roboto(
                            color: const Color(0xFF103DE5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

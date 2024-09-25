import 'package:base_ecommerce/controllers/auth_controller.dart';
import 'package:base_ecommerce/utils/show_snackBar.dart';
import 'package:base_ecommerce/vendor/views/auth/vendor_auth_screen.dart';
import 'package:base_ecommerce/views/buyers/auth/register_screen.dart';
import 'package:base_ecommerce/views/buyers/main_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;

  late String password;

  bool _isLoading = false;

  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      String res = await _authController.loginUser(email, password);
      if (res == 'success') {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MainScreen();
        }));
      } else {
        return showSnack(context, res);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return showSnack(context, 'Please fields must not be empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Customer"s Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Email field must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: ((value) {
                    email = value;
                  }),
                  decoration: InputDecoration(
                    labelText: 'Enter Email Adress',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Password must not be empty';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _loginUsers();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.yellow.shade900,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              letterSpacing: 5,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Need An Account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return BuyerRegisterScreen();
                            }));
                          },
                          child: Text(
                            'Register',
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('Do you want to switch to vendor app?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return VendorAuthScreen();
                          }));
                        },
                        child: Text(
                          'Vendor Login',
                        ),
                      ),
                    ]),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

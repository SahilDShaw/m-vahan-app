import 'dart:math';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'download_pdf.screen.dart';
import 'qr_scanner.screen.dart';
import '../helpers/device_id/platform_device_id.dart';
import '../models/card_info.model.dart';
import 'list.screen.dart';
// import 'package:flutter_number_captcha/number_captcha_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const routeName = '/signin-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? _errorMessage;
  late Future<String?> deviceIdFuture;
  late String _captchaStr;
  late int _captchaValue;

  // form key
  final _formKey = GlobalKey<FormState>();

  // text edting controllers
  TextEditingController? _userIdController;
  TextEditingController? _passwordController;
  TextEditingController? _captchaController;

  // form field keys
  final GlobalKey<FormFieldState> _userIdKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _captchaKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    deviceIdFuture = PlatformDeviceId.getDeviceId;
    _userIdController = TextEditingController();
    _passwordController = TextEditingController();
    _captchaController = TextEditingController();

    // captcha string
    Random random = Random();
    int num1 = 1 + random.nextInt(22);
    int num2 = 1 + random.nextInt(22);
    int op = random.nextInt(2); // 0 -> '+', 1 -> '-'
    // num1 should be larger of the 2 numbers
    if (num1 < num2) {
      int temp = num1;
      num1 = num2;
      num2 = temp;
    }

    _captchaStr = '$num1 ${(op == 0) ? '+' : '-'} $num2';
    _captchaValue = (op == 0) ? (num1 + num2) : (num1 - num2);
  }

  @override
  void dispose() {
    _userIdController?.dispose();
    _passwordController?.dispose();
    _captchaController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final h = mediaQuery.height;
    final w = mediaQuery.width;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 245, 244, 244),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: (h * 0.05),
              ),
              // girl svg
              SvgPicture.asset(
                "assets/images/auth-girl-1.svg",
                height: 120,
                semanticsLabel: 'Girl 1',
              ),
              const SizedBox(
                height: 10,
              ),
              // car icon
              const Icon(
                Icons.directions_car,
                size: 50,
                color: Colors.black,
              ),
              // sign in text
              const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 0,
                ),
                child: Text(
                  'SIGN IN',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // v(s) text
              const Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Text(
                  'v(s) 1.3.8',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              // user id field
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: TextFormField(
                  key: _userIdKey,
                  controller: _userIdController,
                  autofocus: true,
                  obscureText: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter user id.';
                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return 'Enter a valid user id.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (String? val) {
                    _userIdKey.currentState!.validate();
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    label: Text('User Id'),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    hintText: 'User Id',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // password text field
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: TextFormField(
                  key: _passwordKey,
                  controller: _passwordController,
                  autofocus: true,
                  obscureText: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter password.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (String? val) {
                    _passwordKey.currentState!.validate();
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    label: Text('Password'),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // captcha section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // captcha numbers
                    Container(
                      height: 50,
                      width: (w - 70) / 2,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 0, 218, 252),
                            Colors.yellow,
                            Color.fromARGB(255, 0, 218, 252),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 143, 0, 252),
                                Color.fromARGB(255, 232, 59, 255),
                              ],
                            ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                            ),
                            child: Text(
                              _captchaStr,
                              style: const TextStyle(
                                fontSize: 25,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // captcha text field
                    SizedBox(
                      width: (w - 70) / 2,
                      child: TextFormField(
                        key: _captchaKey,
                        controller: _captchaController,
                        autofocus: true,
                        obscureText: false,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter captcha.';
                          }
                          if (int.parse(value) != _captchaValue) {
                            return 'Captcha is wrong.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (String? val) {
                          _captchaKey.currentState!.validate();
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          label: Text('Captcha'),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          hintText: 'Captcha',
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _errorMessage.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              // submit button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                    ),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 18),
                    ),
                  ),
                  onPressed: () async {
                    // TODO: add API call
                    if (_formKey.currentState!.validate()) {
                      dev.log('API Call');
                    }
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // device id
              FutureBuilder(
                future: deviceIdFuture,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    String? deviceId = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                        bottom: 0,
                      ),
                      child: Text(
                        'Android Id: ${deviceId.toString()}',
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                },
              ),
              // registration button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // not registered yet text
                  const Text(
                    'Not Registered yet?',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // click here button
                  TextButton(
                    onPressed: () {
                      dev.log('goes to registration screen');
                    },
                    child: const Text(
                      'Click Here',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ListScreen(
                  cardList: [
                    // qr scanner
                    CardInfo(
                      image: const Icon(
                        Icons.qr_code_scanner,
                        size: 50,
                        color: Colors.black,
                      ),
                      title: 'Scan QR',
                      routeName: QRScannerScreen.routeName,
                    ),
                    // download pdf
                    CardInfo(
                      image: const Icon(
                        Icons.download,
                        size: 50,
                        color: Colors.black,
                      ),
                      title: 'Download PDF',
                      routeName: DownloadPdfScreen.routeName,
                    ),
                  ],
                ),
              ),
            );
          },
          child: const Icon(
            Icons.arrow_forward,
          ),
        ),
      ),
    );
  }
}

import 'package:chatify/Pages/Home.dart';
import 'package:chatify/Pages/registerPage.dart';
import 'package:chatify/UiHelper.dart';
import 'package:chatify/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  String email = "", password = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passWordContorller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  static String loginKey = "unknown";

  @override
  void initState() {
    super.initState();

    checkUser();
  }

  userLogin() async {
    dialog.showProgressBar(context);
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String? error = e.message;
      // ignore: use_build_context_synchronously
      ToastContext().init(context);
      Toast.show("$error", gravity: Toast.top, duration: 3);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: _deviceHeight * 0.8,
          width: _deviceWidth,
          //color: Colors.amber,
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: _loginPageUi(),
        ),
      ),
    );
  }

  Widget _loginPageUi() {
    return Container(
      height: _deviceHeight * 0.8,
      //color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Heading1(
            Heading: 'Welcome Back !',
            SubHeading: 'Please login to your account. ',
          ),
          SizedBox(
            height: 25,
          ),
          _inputForm(),
          SizedBox(
            height: 30,
          ),
          InkWell(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    email = _emailController.text;
                    password = _passWordContorller.text;
                  });
                  userLogin();
                  var pref = await SharedPreferences.getInstance();
                  pref.setString(loginKey, "known");
                }
              },
              child: textButton(
                  buttonText: 'LOGIN',
                  backgroundColor: Colors.blue,
                  textColor: Colors.white)),
          SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "Don't have Account ? ",
              style: TextStyle(color: Colors.white60),
            ),
            WidgetSpan(
                child: InkWell(
              child: Text(' Register',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterPage())),
            ))
          ])),
        ],
      ),
    );
  }

  Widget _inputForm() {
    return Form(
      key: _formKey,
      onChanged: () {},
      child: Column(
        children: <Widget>[
          formField(
              hintText: 'Email Address',
              obsecureText: false,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter the Email';
                }
                return null;
              },
              controller: _emailController),
          formField(
              hintText: 'Password',
              obsecureText: true,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter the Password';
                }
                return null;
              },
              controller: _passWordContorller),
        ],
      ),
    );
  }

  void checkUser() async {
    var pref = await SharedPreferences.getInstance();
    var check = pref.getString(loginKey);

    if (check != null) {
      if (check == "known") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
  }
}

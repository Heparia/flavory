// import 'package:flavory/pages/dashboard.dart';
import 'package:flavory/pages/dashboard.dart';
import 'package:flavory/pages/details.dart';
import 'package:flavory/pages/forgot_password.dart';
import 'package:flavory/pages/profile.dart';
import 'package:flavory/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavory/auth.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool isHoveringAdmin = false;
  bool isHoveringSignUp = false;
  bool _obscurePassword = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
              (Route<dynamic> route) => false, 
            );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return const Center(
      child: Column(
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Text('Masuk untuk melanjutkan'),
        ],
      ),
    );
  }

  Widget _sizedBoxHeight(double height) {
    return SizedBox(height: height);
  }

  Widget _entryField(String title, TextEditingController controller, bool password) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
        ),
        const SizedBox(height: 5.0),
        TextField(
          obscureText: password,
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Ketikkan $title...',
          ),
        )
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, Function(bool) toggleVisibility, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal, // Remove bold
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent, // Transparent background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                color: Colors.black, // Border color
                width: 1.0, // Border width
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintText: placeholder, // Placeholder text
            hintStyle: const TextStyle(color: Colors.black),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () => toggleVisibility(!obscureText),
            ),
          ),
        ),
      ],
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity, 
      child: ElevatedButton(
        onPressed: () {
          if (isLogin) {
            signInWithEmailAndPassword();
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => isHoveringAdmin = true),
      onExit: (_) => setState(() => isHoveringAdmin = false),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegisterPage()),
            ),
        child: Text(
          'Sign Up!',
          style: TextStyle(
            color: Colors.black,
            decoration: isHoveringAdmin ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );    
  }

  Widget _helpMeAdmin() {
    return MouseRegion(
      onEnter: (_) => setState(() => isHoveringSignUp = true),
      onExit: (_) => setState(() => isHoveringSignUp = false),
      child: GestureDetector(
        onTap: _openGmail,
        child: Text(
          'Help me Admin!',
          style: TextStyle(
            color: Colors.black,
            decoration: isHoveringSignUp ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }

  void _openGmail() async {
    // final Uri emailUri = Uri(
    //   scheme: 'mailto',
    //   path: 'flavory_recipe@outlook.com',
    //   query: 'subject=Hello&body=help Me Admin Flavory',
    // );
    // if (await canLaunchUrl(emailUri)) {
    //   await launchUrl(emailUri);
    // } else {
    //   throw 'Tidak dapat membuka aplikasi email.';
    // }
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'flavory_recipe@outlook.com',
      query: Uri.encodeFull('I need help with the registration process!'),
    );
    await launchUrl(emailLaunchUri);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    resizeToAvoidBottomInset: true, // Ensure UI resizes when keyboard appears
    body: SingleChildScrollView( // Wrap content with SingleChildScrollView
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height, // Full height of the screen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg-2.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center, // Vertically center the content
          children: <Widget>[
            _title(),
            _sizedBoxHeight(20.0),
            _entryField('email', _controllerEmail, false),
            _sizedBoxHeight(20.0),
            _buildPasswordField('Password', _controllerPassword, _obscurePassword, (value) {
              setState(() {
                _obscurePassword = value;
              });
            }, 'Ketikkan Password...'),
            _sizedBoxHeight(20.0),
            _errorMessage(),
            _submitButton(),
            _sizedBoxHeight(20.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForgotPasswordPage(),
                  ),
                );
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.black),
              ),
            ),
            _sizedBoxHeight(16.0),
            _helpMeAdmin(),
            _sizedBoxHeight(16.0),
            _signUpButton(),
          ],
        ),
      ),
    ),
  );
}

}
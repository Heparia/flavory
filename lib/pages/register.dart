import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavory/pages/dashboard.dart';
import 'package:flavory/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart'; // Add url_launcher package


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  String? errorMessage = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isHoveringSignUp = false;
  bool isHoveringAdmin = false;


  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Password dan konfirmasi password tidak cocok!';
      });
      return;
    }


    try {
      // Create user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );


      // Get UID and save user data to Firestore
      String uid = userCredential.user!.uid;
      await _firestore.collection('akun').doc(uid).set({
        'uid': uid,
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'telepon': _phoneController.text.trim(),
      });
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


  Future<void> _helpAdmin() async {
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg-2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: const [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold, // Remove bold
                        letterSpacing: 1.5, // Add spacing for uppercase effect
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Buat Akunmu Sekarang!',
                      // style: TextStyle(
                      //   fontSize: 25,
                      //   color: Colors.black,
                      //   fontWeight: FontWeight.normal, // Remove bold
                      // ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField('Username', _usernameController, 'Ketikkan username...'),
              const SizedBox(height: 25),
              _buildTextField('Email', _emailController, 'Ketikkan email...'),
              const SizedBox(height: 25),
              _buildTextField('Telepon', _phoneController, 'Ketikkan telepon...'),
              const SizedBox(height: 25),
              _buildPasswordField('Password', _passwordController, _obscurePassword, (value) {
                setState(() {
                  _obscurePassword = value;
                });
              }, 'Ketikkan Password...'),
              const SizedBox(height: 25),
              _buildPasswordField('Konfirmasi Password', _confirmPasswordController, _obscureConfirmPassword, (value) {
                setState(() {
                  _obscureConfirmPassword = value;
                });
              }, 'Konfirmasi Password...'),
              const SizedBox(height: 20),
              if (errorMessage != null && errorMessage!.isNotEmpty)
                Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: MouseRegion(
                  onEnter: (_) => setState(() => isHoveringAdmin = true),
                  onExit: (_) => setState(() => isHoveringAdmin = false),
                  child: GestureDetector(
                    onTap: _helpAdmin,
                    child: Text(
                      'Help me Admin!',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: isHoveringAdmin ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: MouseRegion(
                  onEnter: (_) => setState(() => isHoveringSignUp = true),
                  onExit: (_) => setState(() => isHoveringSignUp = false),
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        ),
                    child: Text(
                      'Login!',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: isHoveringSignUp ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, String placeholder) {
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
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent, // Transparent background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.black, // Border color
                width: 1.0, // Border width
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintText: placeholder, // Placeholder text
            hintStyle: const TextStyle(color: Colors.black),
          ),
        ),
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
              borderSide: BorderSide(
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
}



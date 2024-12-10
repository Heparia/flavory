import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditProfilePage extends StatefulWidget {
  final String userId;


  const EditProfilePage({Key? key, required this.userId}) : super(key: key);


  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}


class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();


  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('akun').doc(widget.userId).get();
      if (doc.exists) {
        setState(() {
          _usernameController.text = doc['username'] ?? '';
          _phoneController.text = doc['telepon'] ?? '';
          _emailController.text = doc['email'] ?? '';
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pengguna tidak ditemukan.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }


  Future<void> _updateUserData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await FirebaseFirestore.instance.collection('akun').doc(widget.userId).update({
        'username': _usernameController.text.trim(),
        'telepon': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui.')),
      );


      // Go back to profile page after saving
      Navigator.pop(context, true);  // Passing `true` indicates successful update
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Identitas'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg-2.png'), // Background image
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
                      'Edit Identitas',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Perbarui akun Anda. Anda tidak bisa mengedit email.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildTextField('Email', _emailController, 'Ketikkan email...', disabled: true),
              const SizedBox(height: 25),
              _buildTextField('Username', _usernameController, 'Ketikkan username...'),
              const SizedBox(height: 25),
              _buildTextField('Telepon', _phoneController, 'Ketikkan telepon...'),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildTextField(String label, TextEditingController controller, String placeholder, {bool disabled = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal, // Removed bold
        ),
      ),
      const SizedBox(height: 5),
      TextField(
        controller: controller,
        enabled: !disabled, // If disabled is true, the TextField will be non-editable
        decoration: InputDecoration(
          filled: true,
          fillColor: disabled ? Colors.grey[100] : Colors.transparent, // Grey background if disabled
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: disabled ? Colors.grey[600]! : Colors.black, // Darker border when disabled
              width: 1.0, // Border width
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.black),
          suffixIcon: disabled ? Icon(Icons.lock, color: Colors.black) : null, // Add a lock icon when disabled
        ),
      ),
    ],
  );
}
}
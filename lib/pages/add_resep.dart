import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddResepPage extends StatefulWidget {
  const AddResepPage({Key? key}) : super(key: key);


  @override
  State<AddResepPage> createState() => _AddResepPageState();
}


class _AddResepPageState extends State<AddResepPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _urlGambarController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final List<TextEditingController> _bahanControllers = [TextEditingController()];
  final List<TextEditingController> _langkahControllers = [TextEditingController()];
  final String _defaultImageUrl = 'images/default-image.png';


  String _currentImageUrl = '';


  void _addBahanField() {
    setState(() {
      _bahanControllers.add(TextEditingController());
    });
  }


  void _addLangkahField() {
    setState(() {
      _langkahControllers.add(TextEditingController());
    });
  }


  void _showInvalidImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("URL Gambar Tidak Valid"),
          content: const Text(
              "URL gambar yang Anda masukkan tidak dapat dimuat atau terkena masalah CORS. Apakah Anda ingin menggunakan gambar default?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentImageUrl = _defaultImageUrl;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Gunakan Gambar Default"),
            ),
          ],
        );
      },
    );
  }


void _saveData() async {
  final String nama = _namaController.text;
  final String deskripsi = _deskripsiController.text;
  final List<String> bahan = _bahanControllers.map((c) => c.text).toList();
  final List<String> langkah = _langkahControllers.map((c) => c.text).toList();


  if (nama.isEmpty || deskripsi.isEmpty || bahan.isEmpty || langkah.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Harap isi semua field kecuali URL gambar!')),
    );
    return;
  }


  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User tidak terdeteksi!')),
    );
    return;
  }
  String userId = user.uid;


  Timestamp timestamp = Timestamp.fromDate(DateTime.now());


  FirebaseFirestore.instance.collection('resep').add({
    'nama': nama,
    'url_gambar': _currentImageUrl.isNotEmpty ? _currentImageUrl : _defaultImageUrl,
    'deskripsi': deskripsi,
    'bahan': bahan,
    'langkah_langkah': langkah,
    'id_user': userId,
    'publish': timestamp,
  }).then((value) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resep berhasil disimpan!')),
    );


    _namaController.clear();
    _urlGambarController.clear();
    _deskripsiController.clear();
    _bahanControllers.forEach((controller) => controller.clear());
    _langkahControllers.forEach((controller) => controller.clear());


    setState(() {
      _currentImageUrl = '';
    });


    _bahanControllers.clear();
    _langkahControllers.clear();
    _bahanControllers.add(TextEditingController());
    _langkahControllers.add(TextEditingController());
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menyimpan resep: $error')),
    );
  });
}




   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Resep',
          // style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
        // centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg-2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('URL GAMBAR(OPSIONAL)', style: TextStyle(fontSize: 13.0)),
              const SizedBox(height: 5),
              TextField(
                controller: _urlGambarController,
                decoration: InputDecoration(
                  hintText: 'Masukkan URL gambar',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    _currentImageUrl = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _currentImageUrl.isNotEmpty
                  ? Image.network(
                      _currentImageUrl,
                      errorBuilder: (context, error, stackTrace) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _showInvalidImageDialog();
                        });
                        return const Text(
                          'Gambar akan menggunakan mode default.',
                          style: TextStyle(color: Colors.red),  
                        );
                      },
                    )
                  : SizedBox(),
              const SizedBox(height: 20),
              const Text('JUDUL MASAKAN', style: TextStyle(fontSize: 13.0)),
              const SizedBox(height: 5),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Masukkan judul masakan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
              const SizedBox(height: 20),
              const Text('DESKRIPSI', style: TextStyle(fontSize: 13.0)),
              const SizedBox(height: 5),
              TextField(
                controller: _deskripsiController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                ),
              ),
              const SizedBox(height: 20),
              const Text('BAHAN - BAHAN', style: TextStyle(fontSize: 13.0)),
              ..._bahanControllers.map(
                (controller) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    controller: controller,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Masukkan nama bahan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 15,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addBahanField,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('LANGKAH - LANGKAH', style: TextStyle(fontSize: 13.0)),
              ..._langkahControllers.map(
                (controller) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    controller: controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Masukkan langkah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Colors.black, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 15,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addLangkahField,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: double.infinity, 
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Simpan', style: TextStyle(fontSize: 18),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

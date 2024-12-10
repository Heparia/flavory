import 'package:flavory/pages/edit_resep.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavory/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final String idResep;
  final User? user = Auth().currentUser;
  final bool edit;

  DetailsPage({Key? key, required this.idResep, this.edit = false}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  Widget _sizedBoxHeight(double height) {
    return SizedBox(height: height);
  }

  Widget _byNameDate(String name, Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return Text(
      'Oleh $name ($formattedDate)',
      style: const TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w100,
      ),
    );
  }

  Widget _tryCatchImage(imageUrl, fallbackAsset, height) {
    double heightValue = height is int ? height.toDouble() : height;

    // If the imageUrl is '/images/default-image.png', set it to an empty string
    if (imageUrl == '/images/default-image.png') {
      imageUrl = '';  // Set to empty string to use the fallback
    }

    return Container(
      height: heightValue,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: imageUrl.isEmpty
            ? Image.asset( // If imageUrl is empty, load fallback image from assets
                fallbackAsset,
                fit: BoxFit.cover,
              )
            : Image.network( // If imageUrl is not empty, load it as a network image
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset( // On error, fallback to asset image
                    fallbackAsset,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }

  Widget _list(String judul, List<dynamic> data, bool isNumbered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color:Color.fromARGB(100, 143, 142, 142),
          ),
          child: Center(
            child: Text(
              judul,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5), 
        ...data.asMap().entries.map((entry) {
          int index = entry.key;
          String ingredient = entry.value; 
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              isNumbered 
                  ? '${index + 1}. $ingredient'
                  : '• $ingredient',          
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('resep').doc(widget.idResep).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            final data = snapshot.data!.data() as Map<String, dynamic>;

            final idUser = data['id_user'] ?? '';
            final name = data['nama'] ?? 'Details Page';
            final publish = data['publish'] ?? 'Not Available';
            final deskripsi = data['deskripsi'] ?? 'Not Available';
            final bahan = data['bahan'] ?? 'Not Available';
            final langkah = data['langkah_langkah'] ?? 'Not Available';
            final imageUrl = data['url_gambar'] ?? 'images/default-image.png';

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('akun').doc(idUser).get(),
              builder: (context, penulisSnapshot) {
                if (penulisSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final penulisName = penulisSnapshot.hasData && penulisSnapshot.data != null
                    ? (penulisSnapshot.data!.data() as Map<String, dynamic>)['username'] ?? 'Unknown'
                    : 'Unknown';

                return Scaffold(
                  appBar: AppBar(
                    title: Text(name),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
                  body: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/bg-2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _tryCatchImage(imageUrl, 'images/default-image.png', 300.0),
                        _sizedBoxHeight(16.0),
                        _byNameDate(penulisName, publish), // Masukkan nama penulis
                        _sizedBoxHeight(10.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(deskripsi),
                                _sizedBoxHeight(16),
                                _list('Bahan-bahan', bahan, false),
                                _sizedBoxHeight(16),
                                _list('Langkah-langkah', langkah, true),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // floatingActionButton: widget.edit
                  //     ? FloatingActionButton(
                  //         onPressed: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => EditResepPage(idItem: widget.idResep), // Meneruskan id item
                  //             ),
                  //           );
                  //         },
                  //         backgroundColor: Colors.black, // Warna latar belakang tombol
                  //         child: const Icon(
                  //           Icons.edit, // Ikon edit
                  //           color: Colors.white, // Warna ikon
                  //         ),
                  //       )
                  //     : null, 
                );
              },
            );
          }

          return const Center(child: Text('Data tidak ditemukan'));
        },
      ),
    );
  }
}

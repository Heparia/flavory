import 'package:flavory/pages/details.dart';
import 'package:flutter/material.dart';
import 'package:flavory/pages/add_resep.dart';
import 'package:flavory/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flavory/auth.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);
  final User? user = Auth().currentUser;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    return dateFormat.format(dateTime);
  }

  Future<String> _fetchUsername(String uid) async {
    try {
      final doc = await _firestore.collection('akun').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['username'] ?? 'Anonim';
      }
    } catch (e) {
      print('Error fetching username: $e');
    }
    return 'Anonim';
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Temukan berdasarkan judul...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        ),
      ),
    );
  }

  Widget _listData() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('resep').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Belum ada resep tersedia.'));
        }

        // Filter data berdasarkan pencarian
        final resepList = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final nama = data['nama']?.toLowerCase() ?? '';
          return nama.contains(_searchQuery);
        }).toList();

        if (resepList.isEmpty) {
          return const Center(child: Text('Tidak ada resep yang cocok.'));
        }

        return Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            itemCount: resepList.length,
            itemBuilder: (context, index) {
              final resepData = resepList[index].data() as Map<String, dynamic>;
              final idResep = resepList[index].id;
              final nama = resepData['nama'] ?? 'Resep Tanpa Nama';
              final deskripsi = resepData['deskripsi'] ?? '';
              final imageUrl = resepData['url_gambar'] ?? 'images/default-image.png';
              final idUser = resepData['id_user'] ?? '';
              final Timestamp publishTimestamp = resepData['publish'];
              final tanggal = _formatTimestamp(publishTimestamp);

              return FutureBuilder<String>(
                future: _fetchUsername(idUser),
                builder: (context, snapshot) {
                  final penulis = snapshot.data ?? 'Anonim';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(idResep: idResep),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.white,
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                imageUrl,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'images/default-image.png',
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Oleh $penulis ($tanggal)',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  deskripsi,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg-2.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black, // Warna latar belakang hitam
                      radius: 17, 
                      child: IconButton(
                        icon: const Icon(
                          Icons.person_rounded,
                          color: Colors.white, // Warna ikon putih agar terlihat di atas hitam
                          size: 17,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    StreamBuilder<DocumentSnapshot>(
                      stream: _firestore.collection('akun').doc(widget.user?.uid).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Text(
                            'Loading...',
                            style: TextStyle(color: Colors.black),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data?.data() == null) {
                          return const Text(
                            'Guest',
                            style: TextStyle(color: Colors.black),
                          );
                        }
                        final data = snapshot.data?.data() as Map<String, dynamic>;
                        final username = data['username'] ?? 'Guest';
                        return Text(
                          username,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 15,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddResepPage()),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Flavory',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _searchField(),
            _listData(),
          ],
        ),
      ),
    );
  }
}

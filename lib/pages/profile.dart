import 'package:flavory/pages/edit_profile.dart';
import 'package:flavory/pages/edit_resep.dart';
import 'package:flavory/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'details.dart'; // Import halaman detail
// import 'logout.dart'; // Import halaman logout


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>{
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference akunCollection =
      FirebaseFirestore.instance.collection('akun');
  final CollectionReference resepCollection =
      FirebaseFirestore.instance.collection('resep');

  Map<String, dynamic>? userData;
  bool _isLoading=true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }


  Future<void> _fetchUserData() async {
    if (user != null) {
      try {
        final doc = await akunCollection.doc(user!.uid).get();
        if (doc.exists) {
          setState(() {
            userData = doc.data() as Map<String, dynamic>?;
            _isLoading = false;
          });
        } else {
          setState(() {
            userData = null;
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference akunCollection =
        FirebaseFirestore.instance.collection('akun');
    final CollectionReference resepCollection =
        FirebaseFirestore.instance.collection('resep');


    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg-2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: akunCollection.doc(user?.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Terjadi kesalahan'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Data tidak ditemukan'));
              }


              final userData = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          // const CircleAvatar(
                          //   radius: 24,
                          //   backgroundColor: Color.fromARGB(255, 97, 139, 173),
                          //   child: Icon(Icons.person, size: 30, color: Colors.white),
                          // ),
                          // const SizedBox(width: 8),
                          Text(
                            "Identitas",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: const Color.fromARGB(255, 3, 2, 2),
                                    fontWeight: FontWeight.bold, fontSize: 30.0),
                          ),
                          IconButton(
                            onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfilePage(userId: user!.uid),
                                      ),
                                    ).then((_) => _fetchUserData());
                                    }, 
                            icon: const Icon(Icons.edit, color: Colors.black),
                          ),
                      
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        // padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileField(
                                label: "Name", value: userData['username']),
                            const SizedBox(height: 10) ,
                            _buildProfileField(
                                label: "Email", value: userData['email']),
                            const SizedBox(height: 10),
                            _buildProfileField(
                                label: "No Handphone",
                                value: userData['telepon']),
                          ],
                        ),
                      ),
                      const SizedBox(height: 45),


                      // Add the "Resepku" title here
                      Text(
                        "Resepku", // This is the "Resepku" text
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold, fontSize: 30.0),
                      ),
                      const SizedBox(height: 16),
                      StreamBuilder<QuerySnapshot>(
                        stream: resepCollection
                            .where('id_user', isEqualTo: user?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(child: Text('Terjadi kesalahan'));
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('Tidak ada resep'));
                          }


                          final resepList = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: resepList.length,
                            itemBuilder: (context, index) {
                              final resepData = resepList[index];
                              return Card(
                                
                                margin: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(97, 240, 239, 239),
                                    borderRadius: BorderRadius.circular(12),
                                    
                                  ),
                                  child:  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsPage(idResep: resepData.id),
                                        ),
                                      );
                                    },
                                    child: Row(
                                    
                                  children: [
                                    ClipRRect(
                                      
                                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                                      child: Image.network(
                                        resepData['url_gambar'] ?? 'images/default-image.png',
                                        // 'https://cdn0-production-images-kly.akamaized.net/UeGWJAdf34jTuB8Io_vX_3y7f7E=/800x800/smart/filters:quality(75):strip_icc():format(webp)/kly-media-production/medias/4937391/original/9700_1725529203-DALL__E_2024-09-05_16.26.40_-_A_bowl_of_Seblak_Nyemek__an_Indonesian_dish__served_in_a_deep_bowl_with_a_thick__rich_broth._The_dish_contains_chewy_crackers__kerupuk__as_its_base__m.jpg',
                                        // 'https://drive.google.com/file/d/12Ig5nZw9RJGeINyuuWPla4YSPofsFp_D/view?usp=sharing',
                                        // 'https://asset.kompas.com/crops/h3xhEVOTJqGQokQ5woEag9pub4Q=/0x0:1000x667/1200x800/data/photo/2022/04/17/625be6a0e520b.jpg',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'images/default-image.png',
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded( 
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              resepData['nama'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              resepData['deskripsi'] ?? '',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: const Color.fromARGB(255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.black),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => EditResepPage(idItem: resepData.id),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.black),
                                            onPressed: () {
                                              // Menampilkan dialog konfirmasi
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Konfirmasi Hapus"),
                                                    content: const Text(
                                                        "Apakah Anda yakin ingin menghapus resep ini?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop(); // Menutup dialog
                                                        },
                                                        child: const Text("Tidak"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          // Menghapus resep dari database
                                                          await resepCollection
                                                              .doc(resepData.id)
                                                              .delete();
                                                          Navigator.of(context)
                                                              .pop(); // Menutup dialog setelah "Ya"
                                                        },
                                                        child: const Text("Ya"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                  )
                               )
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                     Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Menampilkan dialog konfirmasi
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Konfirmasi Logout"),
                                      content: const Text("Apakah Anda yakin ingin logout?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Menutup dialog jika "Tidak" dipilih
                                          },
                                          child: const Text("Tidak"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Melakukan logout dan mengarahkan ke halaman login
                                            await FirebaseAuth.instance.signOut();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LoginPage(), // Arahkan ke halaman login
                                              ),
                                            );
                                          },
                                          child: const Text("Ya"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 201, 51, 41), // Warna latar belakang
                                foregroundColor: Colors.white, // Warna teks
                                padding: const EdgeInsets.symmetric(vertical: 15), // Padding vertikal tetap
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Logout",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}


  Widget _buildProfileField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            // color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: Colors.black,
              width: 1,
              style: BorderStyle.solid,
            )
          ),
          child: Text(value),
        ),
      ],
    );
  }
}



import 'package:flutter/material.dart';
import 'pengaturan_akun.dart';
import 'pengaturan_umum.dart';
import 'privasi_keamanan.dart'; 
import 'welcome_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  String userName = "Zidan Fademyach";

  // Dialog untuk edit nama user
  void _showEditDialog() {
    final TextEditingController nameController =
        TextEditingController(text: userName);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Nama"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Masukkan nama baru"),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                setState(() {
                  userName = nameController.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.bottomSlide,
    title: 'Log Out',
    desc: 'Apakah Anda yakin ingin keluar?',
    btnCancelText: 'Batal',
    btnCancelOnPress: () {
      // Tutup dialog, tanpa aksi
    },
    btnOkText: 'Ya, Keluar',
    btnOkOnPress: () {
      // Setelah OK ditekan, tampilkan dialog sukses logout
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Log Out Berhasil',
        desc: 'Anda telah keluar dari akun.',
        btnOkOnPress: () {
          // Navigasi ke halaman WelcomePage dan hapus history
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WelcomePage()),
            (route) => false,
          );
        },
      ).show();
    },
  ).show();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Pengaturan", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _showEditDialog,
            tooltip: "Edit Nama",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kartu Profil User
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3))
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  _infoTile(Icons.phone, "+62 858 988 5173"),
                  _infoTile(Icons.email, "zidanfdevtech@gmail.com"),
                ],
              ),
            ),
            const SizedBox(height: 24),


// Menu Pengaturan Akun
            _settingCard(
              icon: Icons.person_outline,
              title: "Pengaturan Akun",
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const PengaturanAkunPage(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
            const SizedBox(height: 12),

// Menu Pengaturan Umum
            _settingCard(
              icon: Icons.settings,
              title: "Pengaturan Umum",
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const PengaturanUmumPage(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
            const SizedBox(height: 12),

// Menu Privasi & Keamanan
            _settingCard(
              icon: Icons.privacy_tip_outlined,
              title: "Privasi & Keamanan",
              onTap: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const PrivasiKeamananPage(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Tombol Logout
            OutlinedButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                "LOG OUT",
                style: TextStyle(color: Colors.redAccent),
              ),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF3B2F6B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 3,
        onTap: (index) {
        
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[700], size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _settingCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.deepPurple.withOpacity(0.1),
        highlightColor: Colors.deepPurple.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: Colors.deepPurple, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Color.fromARGB(255, 227, 227, 227)),
            ],
          ),
        ),
      ),
    );
  }
}

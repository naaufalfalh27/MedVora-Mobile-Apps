import 'package:flutter/material.dart';
import 'pengaturan_akun.dart';
import 'pengaturan_umum.dart';

class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  void _showEditDialog() {
    final TextEditingController nameController =
        TextEditingController(text: "Zidan Fademyach");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Nama"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Masukkan nama baru"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          )
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Apakah anda ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Tambahkan proses log out di sini
            },
            child: const Text("Ya, keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8E6CEF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Zidan Fademyach",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  _infoTile(Icons.phone, "+62 858 988 5173"),
                  _infoTile(Icons.email, "zidanfdevtech@gmail.com"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _settingButton(
              icon: Icons.person_outline,
              title: "Pengaturan Akun",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PengaturanAkunPage()),
              ),
            ),
            _settingButton(
              icon: Icons.settings,
              title: "Pengaturan Umum",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PengaturanUmumPage()),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: _showLogoutDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text("LOG OUT"),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF3B2F6B),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: 3,
        onTap: (index) {
          // Navigasi berdasarkan index
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
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _settingButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

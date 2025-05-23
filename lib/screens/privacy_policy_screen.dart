import 'package:flutter/material.dart';
import 'permission_notifications_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ketentuan dan Kebijakan Privasi Kami',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2C5C), // Warna teks seperti di gambar
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Kami berkomitmen untuk melindungi privasi Anda dengan mengumpulkan hanya informasi yang diperlukan untuk memberikan layanan terbaik. Informasi yang kami kumpulkan meliputi:\n\n'
                  '1. Informasi Pribadi\n'
                  'seperti nama, alamat email, nomor telepon, dan detail lainnya yang Anda berikan saat mendaftar atau menggunakan layanan kami.\n\n'
                  '2. Data Aktivitas Pengguna\n'
                  'meliputi data penggunaan aplikasi/mobile, termasuk halaman yang Anda kunjungi, waktu akses, dan interaksi Anda dengan fitur tertentu.\n\n'
                  '3. Informasi Teknis\n'
                  'seperti alamat IP, jenis perangkat, sistem operasi, dan data lainnya yang secara otomatis dikumpulkan untuk memastikan kinerja layanan yang optimal.\n\n'
                  'Kami memastikan bahwa seluruh informasi yang dikumpulkan hanya digunakan sesuai dengan kebijakan ini dan tidak akan dibagikan tanpa persetujuan Anda, kecuali diwajibkan oleh hukum.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PermissionNotificationsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5E4BC7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Setuju',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

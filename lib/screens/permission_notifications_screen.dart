import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_phone_screen.dart';

class PermissionNotificationsScreen extends StatelessWidget {
  const PermissionNotificationsScreen({super.key});

  Future<void> _requestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      // Jika izin diberikan, lanjut ke screen berikutnya
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PermissionPhoneScreen(),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      // Jika ditolak permanen, arahkan ke pengaturan
      await openAppSettings();
    } else {
      // Jika ditolak sementara, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Izin notifikasi diperlukan untuk melanjutkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/images/notification.png', height: 120),
            const SizedBox(height: 24),
            const Text(
              'Izinkan Akses Notifikasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Medvora membutuhkan akses notifikasi untuk memberi Anda informasi penting dan pemberitahuan layanan secara langsung.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _requestNotificationPermission(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E4BC7),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Izinkan Notifikasi",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PermissionPhoneScreen(),
                  ),
                );
              },
              child: const Text(
                "Nanti Saja",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

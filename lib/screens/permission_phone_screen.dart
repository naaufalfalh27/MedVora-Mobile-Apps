import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_location_screen.dart';

class PermissionPhoneScreen extends StatelessWidget {
  const PermissionPhoneScreen({super.key});

  Future<void> _requestPhonePermission(BuildContext context) async {
    final status = await Permission.phone.request();

    if (status.isGranted) {
      // Jika izin diberikan, lanjut ke screen lokasi
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PermissionLocationScreen(),
        ),
      );
    } else if (status.isPermanentlyDenied) {
      // Jika ditolak permanen, arahkan ke pengaturan aplikasi
      await openAppSettings();
    } else {
      // Jika ditolak sementara, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Izin telepon diperlukan untuk melanjutkan')),
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
            Image.asset('assets/images/phone.png', height: 120),
            const SizedBox(height: 24),
            const Text(
              'Izinkan Akses Telepon',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Medvora memerlukan izin ini agar dapat memudahkan Anda dalam menghubungi fasilitas kesehatan secara langsung.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _requestPhonePermission(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E4BC7),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Izinkan Telepon",
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PermissionLocationScreen(),
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
